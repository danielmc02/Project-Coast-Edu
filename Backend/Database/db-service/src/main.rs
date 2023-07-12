use actix_web::{App, HttpServer,HttpResponse,Responder,get};
use sqlx::postgres::PgPoolOptions;

#[get("/process_new_user")]
async fn process_new_user() -> impl Responder
{
    println!("DB WAS TRIGGERED");
    HttpResponse::Ok()
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // Create a connection pool
    //  for MySQL, use MySqlPoolOptions::new()
    //  for SQLite, use SqlitePoolOptions::new()
    //  etc.
    let pool = PgPoolOptions::new()
        .max_connections(2)
        .connect("postgres://postgres:123123@localhost:5432/users")
        .await.expect("Failed to establish db connection");

    sqlx::query(
        "CREATE TABLE users (
            id SERIAL PRIMARY KEY,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            email VARCHAR(255) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL
          );",
    )
    .execute(&pool)
    .await.expect("Failed to query default user template!\nThis could be because the server dosent exist or the table already exists");

    println!("DONE With Db stuff");

    HttpServer::new(|| App::new(
        
    ).service(process_new_user))
        .bind(("0.0.0.0", 8084))?
        .run()
        .await

    //  Ok(())
}
