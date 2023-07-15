
use actix_web::{post, web::Data, web, App, HttpResponse, HttpServer, Responder};
use serde::Deserialize;
use sqlx::{postgres::PgPoolOptions, Pool, Postgres};

#[derive(Deserialize)]
struct SignUpJsonForm {
    email: String,
    password: String,
}

/*
struct AppState {
    postgres_pool: Pool<Postgres>,
}
*/
#[post("/register_user")]
async fn register_user(
  sign_up_form: web::Json<SignUpJsonForm>,
    //  data: Data<Pool<Postgres>>
) -> impl Responder {
    let pool = PgPoolOptions::new()
    .max_connections(2)
    .connect("postgres://postgres:123123@localhost:5432/users")
    .await
    .expect("Failed to establish db connection");
    println!("WH");
   // let pool: &Pool<Postgres> = &data;
    let formated_query = format!(
        "INSERT INTO users (email, password)
    VALUES ('{}','{}');",
        sign_up_form.email, sign_up_form.password
    );
    sqlx::query(&formated_query)
        .execute(&pool)
        .await
        .expect("SOMETHING WENT WRONG");
    println!("DB WAS TRIGGERED");
    println!("GOT IN HERE {} {}", sign_up_form.email,sign_up_form.password);

    HttpResponse::Ok()
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("START");
    // Create a connection pool
    //  for MySQL, use MySqlPoolOptions::new()
    //  for SQLite, use SqlitePoolOptions::new()
    //  etc.
/* 
    let pool = PgPoolOptions::new()
        .max_connections(2)
        .connect("postgres://postgres:123123@localhost:5432/users")
        .await
        .expect("Failed to establish db connection");

    sqlx::query(
        "CREATE TABLE users (
            
          
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          );",
    )
    .execute(&pool)
    .await.expect("Failed to query default user template!\nThis could be because the server dosent exist or the table already exists");
*/
    println!("DONE With Db stuff");

    HttpServer::new(move || App::new()
   //.app_data(pool.clone())
    .service(register_user))
        .bind(("0.0.0.0", 8084))?
        .run()
        .await

    //  Ok(())
}
