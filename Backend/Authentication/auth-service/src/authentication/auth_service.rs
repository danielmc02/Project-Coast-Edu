pub mod auth {

    use super::super::auth_structs::auth_structs::*;
    use std::time::{Duration, SystemTime, UNIX_EPOCH};

    use actix_web::{get, post, web, web::Json, HttpResponse};
    use jsonwebtoken::{encode, Algorithm, EncodingKey, Header};
   // use sqlx::types::Json as sqlx;
    #[post("/register_user")]
    pub async fn register_user(
        user_form: Json<UserForm>,
        data: web::Data<AppData>,
    ) -> HttpResponse {
        println!("{}", user_form.password);

        let formated_query = format!(
            "INSERT INTO Users(email,password_hash) VALUES('{}','{}');",
            user_form.email, user_form.password,
        );
        let result = sqlx::query(&formated_query).execute(&data.db_pool).await;

        match result {
            Ok(_) => {
                return shared_login_logic(user_form, data).await;
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
        let formated_query = format!(
            r"SELECT id::text, email, name , password_hash, interests, verified_student FROM users WHERE email = '{}'",
            user_form.email
        );

        let result =
            sqlx::query_as::<_, UserField>(&formated_query as &str) /* .bind(&user_form.email)*/
                .fetch_one(&data.db_pool)
                .await;
     
        println!("{:?}",result);
        
        match result {
            Ok(res) => {
                // RSA JWT
                print!("OKAYY");
                let jwt_res: String = create_jwt_token();
                println!("JJJWWWTTT: {}", jwt_res);
                if res.password_hash == user_form.password {
                    println!("SUCESFUL");
                    /*
                    On a user signin, pass jwt, id
                     */
                    let data = SignInPackage {

                        short_life_jwt: jwt_res,
                        email: user_form.email.to_string(),
                        name: res.name,
                        id: res.id as String,
                        interests: res.interests ,
                        verified_student: res.verified_student,
                    
                    };
                    return HttpResponse::Ok().json(data);
                } else {
                    println!("NOT SUCESFUL SIGN IN");
                    return HttpResponse::Conflict().body("Incorect password");
                }
                //     println!("{rez}");
                //    println!("{}\n{} .", res.password_hash, rez);
            }
            Err(_) => {
                println!("NOT SUCESFUL SIGN IN");

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
