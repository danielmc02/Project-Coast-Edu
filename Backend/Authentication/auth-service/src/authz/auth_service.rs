


pub mod Auth {
    
    use crate::models::GlobalStructs::{AppData, UserForm};

    use actix_web::{get, post, web, web::Json, HttpResponse};
    use bcrypt::{hash, verify, DEFAULT_COST};
    use jsonwebtoken::{encode, EncodingKey, Header};
    use rand::{rngs::OsRng, RngCore};
    use serde::{Deserialize, Serialize};
    use sqlx::{postgres::PgPoolOptions, FromRow, Pool, Postgres};
    use std::{
        fmt::format,
        time::{SystemTime, UNIX_EPOCH},
    };

    fn create_salt() -> [u8; 16] {
        let mut salt = [0u8; 16];
        OsRng.fill_bytes(&mut salt);
        salt
    }

    #[post("/register_user")]
    pub async fn register_user(
        user_form: Json<UserForm>,
        data: web::Data<AppData>,
    ) -> HttpResponse {
        // let salt = create_salt();
        //     let serialized_salt = salt.iter().map(|byte| format!("{:02x}", byte))
        // .collect::<String>();
        //  println!("SERIALIZED SALT IS: {}",serialized_salt);
        let hashed_password = bcrypt::hash(&user_form.password, bcrypt::DEFAULT_COST).unwrap();
        println!("FRESH :{}", hashed_password);
        let formated_query = format!(
            "INSERT INTO Users(email,password_hash) VALUES('{}','{:?}');",
            user_form.email, hashed_password,
        );
        let result = sqlx::query(&formated_query).execute(&data.db_pool).await;

        match result {
            Ok(res) => {
                /*
                Registering to db was sucessful, now sign in and return the jwt
                */

                return HttpResponse::Ok().body("REGISTER SUCESFUL");
                // return log_in(user_form, data).await;
            }
            Err(error) => {
                println!("{}", error);
                return HttpResponse::Conflict()
                    .body("The user may already exist. Try signing in.");
            }
            _ => {
                return HttpResponse::BadRequest().body("SOMETHING WENT WRONG");
            }
        }
    }

    #[derive(FromRow)]
    struct PasswordCred {
        password_hash: String,
    }
    #[post("/log_in")]
    async fn log_in(user_form: Json<UserForm>, data: web::Data<AppData>) -> HttpResponse {
        // Run a query that checks the db with the email
        let formated_query = format!(
            r"SELECT password_hash FROM users WHERE email = '{}'",
            user_form.email
        );
        let result =
            sqlx::query_as::<_, PasswordCred>(&formated_query as &str) /* .bind(&user_form.email)*/
                .fetch_one(&data.db_pool)
                .await;
        //  println!("Hash: {}",result.password_hash );
        match result {
            Ok(res) => {
                let rez = bcrypt::verify(&user_form.password, &res.password_hash).unwrap();
                println!("{rez}");
                println!("{}\n{} .", res.password_hash, rez);
            }
            Err(err) => {}
        }

        /*
        match result {
            Ok(cred) => {
                // Email found, now you have access to cred.password_hash and cred.password_salt
                println!("Password hash: {}, Salt: {}", cred.password_hash, cred.password_salt);
                return HttpResponse::Ok().body("Sign in successful");
            },
            Err(err) => {
                println!("Error: {:?}", err);
                return HttpResponse::Conflict().body("Sign in not successful");
            },
        }
        */
        HttpResponse::Ok().body("woop")
    }
}
