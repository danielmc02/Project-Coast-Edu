pub mod auth {

    use super::super::auth_structs::auth_structs::*;
    use std::time::{Duration, SystemTime, UNIX_EPOCH};

    use actix_web::{get, post, web, web::Json, HttpResponse};
    use argon2::{
        password_hash::{
            rand_core::OsRng, PasswordHash, PasswordHasher, PasswordVerifier, Salt, SaltString,
        },
        Argon2,
    };
    use jsonwebtoken::{encode, Algorithm, EncodingKey, Header};
    use serde_json::json;
    // use sqlx::types::Json as sqlx;
    #[post("/register_user")]
    pub async fn register_user(req: Json<UserForm>, data: web::Data<AppData>) -> HttpResponse {
        //query database for email first instead of using compute power to hash!!!
        let res = sqlx::query("SELECT * FROM users WHERE email = $1")
            .bind(&req.email)
            .fetch_one(&data.db_pool)
            .await;
        match res {
            //if the query suceeds than the email belongs to an account
            Ok(k) => {

                println!("IN HERE:");
                return HttpResponse::Conflict()
                    .body("The user may already exist. Try signing in.2");
            }
            //if the email dosen't exist than continue with registering the new email
            Err(_) => {
                let argon2 = Argon2::default();
                // A generated salt string
                let salt = SaltString::generate(&mut OsRng);

                let password_hash = argon2
                    .hash_password(&req.password.as_bytes(), &salt)
                    .unwrap()
                    .to_string();
                println!("PASSWORD HASH: {:?}\n\n", password_hash);

                let ps = PasswordHash::new(&password_hash).expect("msg");

                let result =
                    sqlx::query("INSERT INTO users(email,password_hash,salt) VALUES($1, $2, $3);")
                        .bind(&req.email)
                        .bind(&password_hash)
                        .bind(salt.to_string())
                        .execute(&data.db_pool)
                        .await;

                match result {
                    Ok(_) => {
                        return shared_login_logic(req, data).await;
                        //return shared_login_logic(req, data).await;
                    }
                    Err(error) => {
                        println!("{}", error);
                        return HttpResponse::Conflict()
                            .body("Something went wrong, please try again later");
                    }
                }
            }
        }
    }

    #[post("/log_in")]
    pub async fn log_in(user_form: Json<UserForm>, data: web::Data<AppData>) -> HttpResponse {
        // Run a query that checks the db with the email

        shared_login_logic(user_form, data).await
    }

    pub async fn shared_login_logic(
        user_form: Json<UserForm>,
        data: web::Data<AppData>,
    ) -> HttpResponse {
        let result = sqlx::query_as::<_, User>(
            "SELECT id::text, email, password_hash, salt FROM users WHERE email = $1",
        ) /* .bind(&user_form.email)*/
        .bind(&user_form.email)
        .fetch_one(&data.db_pool)
        .await;

        match result {
            //an account exists, time to verify the password
            Ok(res) => {
                
                //set up argon2 configuration 
                let argon2 = Argon2::default();
                let bool = argon2
                    .verify_password(
                        &user_form.password.as_bytes(),
                        &PasswordHash::new(&res.password_hash).unwrap(),
                    )
                    .is_ok();
                {
                  if  bool == false {
                        return HttpResponse::Conflict().body("Password incorect");
                    }
                }

            let rez =sqlx::query_as::<_,SignInResponce>(
            "SELECT id::text, name, interests, verified_student,friends FROM public_users WHERE id = '3fb0479e-9f61-4a6c-a8de-07886e571ee9'"
                ).bind(res.id).fetch_one(&data.db_pool).await.unwrap();
                println!("\n\nVALUE: {:?}\n\n",rez);
              //  let response = SignInResponce{};
                // RSA JWT
           let json_string = serde_json::to_value(&rez).unwrap(); // serde_json::to_string(&rez).unwrap();

           let mut modified_json_object = json_string.as_object().unwrap().clone();
           let jwt: serde_json::Value= json!(create_jwt_token());
modified_json_object.insert("jwt".to_string(), jwt);
println!("THE pack IS {:?}\n\n\n",modified_json_object);

       return HttpResponse::Ok().json(modified_json_object);
            }
            Err(er) => {
                println!("NOT SUCESFUL SIGN IN {}", er);

                return HttpResponse::Conflict().body("This account may not exist");
            }
        }
    }

    #[get("/test")]
    async fn test() -> HttpResponse {
        HttpResponse::Ok().body("SUCESFULLY RETRIEVED TEST")
    }

    fn create_jwt_token() -> String {
        let current_time_duration = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("Error fetching time");

        let expiration_time_duration = current_time_duration + Duration::new(1800, 0);

        let expiration_time_unix_timestamp = expiration_time_duration.as_secs() as usize;

        let user_claims: Claims = Claims {
            exp: expiration_time_unix_timestamp,
            sub: "user".to_string(),
        };
        let jwt_res = encode(
            &Header::new(Algorithm::RS256),
            &user_claims,
            &EncodingKey::from_rsa_pem(include_bytes!("keys/privkey.pem")).unwrap(),
        )
        .expect("ERROR CREATING JWT");
        return jwt_res;
    }
}
