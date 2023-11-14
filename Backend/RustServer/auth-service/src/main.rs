mod authentication;
use authentication::auth_service::auth::{log_in, register_user};
use authentication::auth_structs::auth_structs::AppData;

mod email;
use email::email_service::email::send_verification_email;

mod user_services;
use user_services::users_services::user_services::{update_user_name,update_user_interests,update_verified_student_status,get_public_user_information};

use actix_web::{  web, App, HttpResponse, HttpServer,get };


use sqlx::{postgres::PgPoolOptions, Pool};



#[get("/test")]
async fn test(app_data: web::Data<AppData>) -> HttpResponse {

   println!("TEST SCOPED");
    actix_web::HttpResponse::Ok().body("TEST TEST TEST")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    
    std::env::set_var("RUST_LOG", "debug");
    env_logger::init();

    let _postgress_pool: Pool<sqlx::Postgres> = PgPoolOptions::new()
        .max_connections(2)
   //  .connect("postgresql://postgres:123@localhost:5432/users")
 .connect("postgresql://postgres:123@database:5432/users")
        .await
        .expect("Error connecting to db");

    println!("LETS GOz");
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new({
                AppData {
                    db_pool: _postgress_pool.clone(),
                }
            }))
            .service(register_user)
            .service(log_in)
            .service(test)
           .service(send_verification_email)
           .service(update_user_interests)
           .service(update_user_name)
            .service(update_verified_student_status)
            .service(get_public_user_information)
    })
    .bind(("0.0.0.0", 80))?
    .run()
    .await
}
