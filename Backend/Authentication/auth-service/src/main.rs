/*
    Daniel McCray
*/


mod models;
use models::global_structs::AppData;



use actix_web::{web, App, HttpServer};

//use auth_service::Auth::{log_in, register_user};
use sqlx::{postgres::PgPoolOptions, Pool};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // std::env::set_var("RUST_LOG", "debug");
    //  env_logger::init();

    let postgress_pool: Pool<sqlx::Postgres> = PgPoolOptions::new()
        .max_connections(2)
        .connect("postgres://postgres:123@localhost:5432/users")
        .await
        .expect("Error connecting to db");
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new({
                AppData {
                    db_pool: postgress_pool.clone(),
                }
            }))
        //    .service(register_user)
         //   .service(log_in)
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
