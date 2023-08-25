


pub mod Auth {
    
  

    use std::future::Future;

    use actix_web::{get, post, web, web::Json, HttpResponse};
   // use jsonwebtoken::{encode, EncodingKey, Header};
    use serde::{Deserialize, Serialize};
    use sqlx::{ FromRow, Pool, Postgres};

    #[derive(Deserialize)]
    pub struct UserForm {
        pub email: String,
        pub password: String,
    }

    pub struct AppData {
        pub db_pool: Pool<Postgres>,
    }
    
    #[derive(FromRow)]
    struct PasswordCred {
        password_hash: String,
    }

    #[derive(Debug, Serialize, Deserialize)]
    struct Claims {
        exp: usize,
        aud: String,
    }


    #[post("/register_user")]
    pub async fn register_user(
        user_form: Json<UserForm>,
        data: web::Data<AppData>,
    ) -> HttpResponse {
        println!("{}",user_form.password);
        let formated_query = format!(
            "INSERT INTO Users(email,password_hash) VALUES('{}','{}');",
            user_form.email, user_form.password,
        );
        let result = sqlx::query(&formated_query).execute(&data.db_pool).await;

        match result {
            Ok(
                _
            ) => {
            
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

    pub async fn shared_login_logic(user_form: Json<UserForm>, data: web::Data<AppData>) -> HttpResponse {
        // Run a query that checks the db with the email
        println!("STEP 1");
        let formated_query = format!(
            r"SELECT password_hash FROM users WHERE email = '{}'",
            user_form.email
        );
        println!("STEP 2");

        let result =
            sqlx::query_as::<_, PasswordCred>(&formated_query as &str) /* .bind(&user_form.email)*/
                .fetch_one(&data.db_pool)
                .await;
            println!("STEP 3");

        //  println!("Hash: {}",result.password_hash );
        match result {
            Ok(res) => {
                println!("{} VSSSS {}",&user_form.password, &res.password_hash);
              let rez = bcrypt::verify(&user_form.password, &res.password_hash).unwrap();
              if rez == true
              {
                return HttpResponse::Ok().body("SUCESFULLY SIGNED IN")
              }
              else 
              {
                return HttpResponse::Conflict().body("Incorect password");

              }
           //     println!("{rez}");
            //    println!("{}\n{} .", res.password_hash, rez);
            }
            Err(err) => {
                return HttpResponse::Conflict().body("ERROR");

            }
        }


    }

}
