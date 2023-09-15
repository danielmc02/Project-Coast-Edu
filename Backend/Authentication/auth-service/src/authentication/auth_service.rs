pub mod auth {

    use super::super::auth_structs::auth_structs::*;
    use std::time::{Duration, SystemTime, UNIX_EPOCH};

    use actix_web::{get, post, web, web::Json, HttpResponse};
    use jsonwebtoken::{encode, Algorithm, EncodingKey, Header};
    use argon2::{password_hash::{rand_core::OsRng,PasswordHash,PasswordHasher,PasswordVerifier,SaltString, Salt},Argon2};
   // use sqlx::types::Json as sqlx;
    #[post("/register_user")]
    pub async fn register_user(
        req: Json<UserForm>,
        data: web::Data<AppData>,
    ) -> HttpResponse {
        println!("{}", req.password);
        let argon2 = Argon2::default();
        // A generated salt string
        let salt = SaltString::generate(&mut OsRng);
        println!("{}",salt);

        let password_hash = argon2.hash_password(&req.password.as_bytes(), &salt).unwrap().to_string();
        println!("PASSWORD HASH: {:?}\n\n",password_hash);

let ps = PasswordHash::new(&password_hash).expect("msg");

println!("{}",ps);

        let result = sqlx::query(
            "INSERT INTO users(email,password_hash,salt) VALUES($1, $2, $3);"
        ).bind(&req.email)
        .bind(&password_hash)
        .bind(salt.to_string())
        .execute(&data.db_pool).await;

        match result {
            Ok(_) => {
               return HttpResponse::Ok().body("body");
                //return shared_login_logic(req, data).await;
            }
            Err(error) => {
                println!("{}", error);
                return HttpResponse::Conflict()
                    .body("The user may already exist. Try signing in.");
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

        let result =
            sqlx::query_as::<_, User>( "SELECT id::text, email, password_hash, salt FROM users WHERE email = $1") /* .bind(&user_form.email)*/
                .bind(&user_form.email)
                .fetch_one(&data.db_pool)
                .await;
     
        
        match result {
            Ok(res) => {
                println!("{:?}",res);
                let argon2 = Argon2::default();

             let bool =   argon2.verify_password(&user_form.password.as_bytes(), &PasswordHash::new(&res.password_hash).unwrap()).is_ok();
                // RSA JWT
                println!("BOOL IS {}",bool);
                let jwt_res: String = create_jwt_token();
                println!("JJJWWWTTT: {}", jwt_res);
                if res.password_hash == user_form.password {
                    println!("SUCESFUL");
                    /*
                    On a user signin, pass jwt, id
                     */

                    /* 
                    let data = SignInPackage {

                        short_life_jwt: jwt_res,
                        email: user_form.email.to_string(),
                        name: res.name,
                        id: res.id as String,
                        interests: res.interests ,
                        verified_student: res.verified_student,
                    
                    };
                    */
                    return HttpResponse::Ok().body("data");
                } else {
                    println!("NOT SUCESFUL SIGN IN");
                    return HttpResponse::Conflict().body("Incorect password");
                }
                //     println!("{rez}");
                //    println!("{}\n{} .", res.password_hash, rez);
            }
            Err(er) => {
                println!("NOT SUCESFUL SIGN IN {}",er);

                return HttpResponse::Conflict().body("ERROR");
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
