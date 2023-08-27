pub mod Auth {

    use std::time::{Duration, SystemTime, UNIX_EPOCH};

    use actix_web::{get, post, rt::System, web, web::Json, HttpResponse};
    use jsonwebtoken::{encode, Algorithm, EncodingKey, Header};
    use serde::{Deserialize, Serialize};
    use sqlx::{FromRow, Pool, Postgres};


    #[derive(Deserialize)]
    pub struct UserForm {
        pub email: String,
        pub password: String,
    }

    pub struct AppData {
        pub db_pool: Pool<Postgres>,
    }

    #[derive(FromRow)]
    struct PayLoad {

        password_hash: String,
    }

    #[derive(Debug, Serialize, Deserialize)]
    struct Claims {
        exp: usize,
        sub: String,
    }


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
            _ => {
                return HttpResponse::BadRequest().body("SOMETHING WENT WRONG");
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
            r"SELECT password_hash FROM users WHERE email = '{}'",
            user_form.email
        );
        println!("STEP 2");

        let result =
            sqlx::query_as::<_, PayLoad>(&formated_query as &str) /* .bind(&user_form.email)*/
                .fetch_one(&data.db_pool)
                .await;
        println!("STEP 3");


        //  println!("Hash: {}",result.password_hash );
        match result {
            Ok(res) => {

                // RSA JWT
                let current_time_duration = SystemTime::now()
                    .duration_since(UNIX_EPOCH)
                    .expect("Error fetching time");

                let expiration_time_duration = current_time_duration + Duration::new(1800, 0);

                let expiration_time_unix_timestamp = expiration_time_duration.as_secs() as usize;

                let user_claims: Claims = Claims {
                    exp: expiration_time_unix_timestamp,
                    sub: "user".to_string(),
                };
                let private_key_path = "./privkey.pem";
                let jwt_res = encode(
                    &Header::new(Algorithm::RS256),
                    &user_claims,
                    &EncodingKey::from_rsa_pem(include_bytes!("privkey.pem")).unwrap(),
                )
                .expect("ERROR CREATING JWT");
                println!("JJJWWWTTT: {}", jwt_res);
                if res.password_hash == user_form.password {
                    println!("SUCESFUL");
                    let data = JsonCallBack{shortLifeJwt: "TEST".to_string() ,publicKey:jwt_res,email: "NIG".to_string()};
                    return HttpResponse::Ok().json(data);
                } else {
                    println!("NOT SUCESFUL SIGN IN");
                    return HttpResponse::Conflict().body("Incorect password");
                }
                //     println!("{rez}");
                //    println!("{}\n{} .", res.password_hash, rez);
            }
            Err(err) => {
                println!("NOT SUCESFUL SIGN IN");

                return HttpResponse::Conflict().body("ERROR");
            }
        }
    }

#[derive(Serialize,Deserialize)]
    struct JsonCallBack
    {
        shortLifeJwt: String,
        publicKey: String,

        email: String
    }

}
