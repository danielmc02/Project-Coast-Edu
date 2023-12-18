pub mod auth {

    use super::super::auth_structs::auth_structs::*;
    use actix_web::{get, post, web, web::Json, HttpResponse, HttpRequest};
    use argon2::{
        password_hash::{
            rand_core::OsRng, PasswordHash, PasswordHasher, PasswordVerifier, Salt, SaltString,
        },
        Argon2,
    };
    use jsonwebtoken::{encode, Algorithm, EncodingKey, Header,decode, DecodingKey, Validation, TokenData};
    use serde_json::json;
    use std::{
        time::{Duration, SystemTime, UNIX_EPOCH},
    };
    use super::super::auth_structs::auth_structs::Claims;


    #[post("/register_user")]
    pub async fn register_user(req: Json<UserForm>, data: web::Data<AppData>) -> HttpResponse {
        // a query to check if the account exists in the first place
        let res = sqlx::query("SELECT * FROM users WHERE email = $1")
            .bind(&req.email)
            .fetch_one(&data.db_pool)
            .await;

        match res {
            Ok(k) => {
                // Email already exists
                return HttpResponse::Conflict()
                    .body("The user may already exist. Try signing in.2");
            }
            Err(_) => {
                // Email wasn't found, continue to register the given credentials

                let salt = SaltString::generate(&mut OsRng);

                let password_hash = Argon2::default()
                    .hash_password(&req.password.as_bytes(), &salt)
                    .unwrap()
                    .to_string();

                let ps =
                    PasswordHash::new(&password_hash).expect("Failed to generate password hash");

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
        shared_login_logic(user_form, data).await
    }

    pub async fn shared_login_logic(
        user_form: Json<UserForm>,
        data: web::Data<AppData>,
    ) -> HttpResponse {
        // Fetch user information
        let result = sqlx::query_as::<_, User>(
            "SELECT id::text, email, password_hash, salt FROM users WHERE email = $1",
        )
        .bind(&user_form.email)
        .fetch_one(&data.db_pool)
        .await;

        match result {
            //an account exists, time to verify the password
            Ok(res) => {
                let bool = Argon2::default()
                    .verify_password(
                        &user_form.password.as_bytes(),
                        &PasswordHash::new(&res.password_hash).unwrap(),
                    )
                    .is_ok();
                {
                    if bool == false {
                        return HttpResponse::Conflict().body("Password incorect");
                    }
                }
                let formated_query = format!("SELECT id::text, name, interests, verified_student,friends FROM public_users WHERE id = '{}'",res.id);
                let rez = sqlx::query_as::<_, SignInResponce>(&formated_query)
                    .bind(res.id)
                    .fetch_one(&data.db_pool)
                    .await
                    .unwrap();

                //cast to json so you can insert jwt from what was once a struct
                let json_string = serde_json::to_value(&rez).unwrap();

                let mut modified_json_object = json_string.as_object().unwrap().clone();
                let jwt: serde_json::Value = json!(create_jwt_token());
                modified_json_object.insert("jwt".to_string(), jwt);

                return HttpResponse::Ok().json(modified_json_object);
            }
            Err(er) => {
                //No account exists
                return HttpResponse::Conflict().body("This account may not exist");
            }
        }
    }

    fn create_jwt_token() -> String {
        let current_time_duration = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("Error fetching time");
        // Expiration of 30 minutes
        let expiration_time_duration = current_time_duration + Duration::new(1800, 0); //1800 seconds = 30 mins

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
        // is_valid_jwt(&jwt_res);
        return jwt_res;
    }


    #[post("/check_and_update_jwt")]
    async fn check_and_update_jwt(request: HttpRequest) -> HttpResponse {
        //verify jwt
       // decode(token, key, validation)
        println!("{}", format!("{:?}",request));

        if let Some(jwt) = request.headers().get("Authorization")
        {
            println!("{:?}", jwt);
            let public_key = std::fs::read_to_string("src/authentication/keys/publickey.pem").expect("Couldn't find/access public key").as_bytes().to_owned();
            let result = decode::<Claims>(jwt.to_str().unwrap(), &DecodingKey::from_rsa_pem(&public_key).unwrap(), &Validation::new(Algorithm::RS256));
            println!("{:?}",result);
            return HttpResponse::Ok().body("")
        }
        else 
        {
            return HttpResponse::BadRequest().body("")
        }


    }
}
