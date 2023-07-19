use actix_web::{ post, web, App, HttpResponse, HttpServer};
use serde::Deserialize;
use sqlx::{postgres::PgPoolOptions, Pool, Postgres};


#[derive(Deserialize)]
struct SignUpJsonForm {
    email: String,
    password: String,
}

struct AppState {
    db_pool: Pool<Postgres>,
}

#[post("/register_user")]
async fn register_user(
    sign_up_form: web::Json<SignUpJsonForm>,
    app_state: web::Data<AppState>,
) -> HttpResponse {
    // let pool: &Pool<Postgres> = &data;

    let formated_query: String = format!(
        r#"INSERT INTO users(email,password)
    VALUES ('{}', '{}');"#,
        sign_up_form.email, sign_up_form.password
    );
    let res = sqlx::query(&formated_query)
        .execute(&app_state.db_pool)
        .await;

    match res {
        Ok(res) => println!("No error, {:?}", res),
        Err(_e) => {
            println!("ERROR");
            return HttpResponse::Conflict().body("User already exists dumb ass");
        }
    }

    println!("DB WAS TRIGGERED");
    println!(
        "GOT IN HERE {} {}",
        sign_up_form.email, sign_up_form.password
    );

    HttpResponse::Ok().body("woop woop")
}
#[post("/sign_in_user")]
async fn sign_in_user(
    _sign_up_form: web::Json<SignUpJsonForm>,
    _app_state: web::Data<AppState>,
) -> HttpResponse {
    HttpResponse::Ok().body("SIGNED IN")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenvy::dotenv().expect("ERROR loading .env file");

    println!("START");

    let pool = PgPoolOptions::new()
        .max_connections(2)
        .connect("postgres://postgres:123123@localhost:5432/users")
        .await
        .expect("Failed to establish db connection");

    sqlx::query_file!("queries/two.sql")
        .execute(&pool)
        .await
        .expect("Something went wrong with droping user table");

    sqlx::query_file!("queries/temp_init.sql")
        .execute(&pool)
        .await
        .expect("Something went wrong with creating creating user table");
    println!("DONE With Db stuff");

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(AppState {
                db_pool: pool.clone(),
            }))
            .service(register_user)
            .service(sign_in_user)
    })
    .bind(("0.0.0.0", 8084))?
    .run()
    .await

    //  Ok(())
}
