use actix_web::{web, App, HttpServer,get};

mod authentication;
use authentication::auth_service::auth::{log_in, register_user};
use authentication::auth_structs::auth_structs::AppData;

use sqlx::{postgres::PgPoolOptions, Pool};

#[get("/test")]
async fn test() -> actix_web::HttpResponse
{println!("TEST SCOPED");
    actix_web::HttpResponse::Ok().body("TEST TEST TEST")
}


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    //std::thread::sleep(std::time::Duration::new(2, 0));


    let postgress_pool: Pool<sqlx::Postgres> = PgPoolOptions::new()
        .max_connections(2)
        .connect("postgres://postgres:123@localhost:5432/users")
        .await
        .expect("Error connecting to db");
    println!("LETS GO");
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new({
                AppData {
                    db_pool: postgress_pool.clone(),
                }
            }))
            .service(register_user)
            .service(log_in)
            .service(test)
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}