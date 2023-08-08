use actix_web::{ post, web, App, HttpResponse, HttpServer};
use serde::Deserialize;
use sqlx::{postgres::{PgPoolOptions, PgQueryResult}, Pool, Postgres};


#[derive(Deserialize)]
struct SignUpJsonForm {
    email: String,
    password: String,
}

struct AppState {
    db_pool: Pool<Postgres>,
}
#[derive(Deserialize)]
struct UserCredForm
{
    email : String,
    password : String
}

#[post("/create_user")]
async fn create_user(appstate: web::Data<AppState>, json : web::Json<UserCredForm>) -> HttpResponse
{
   let result = sqlx::query(r"INSERT INTO users (email, password);
   VALUES (email, password);
   ").execute(&appstate.db_pool).await;

   match result {
    Ok(PgQueryResult) =>{
       return HttpResponse::Ok().body("User has been registered sucesffuly");
    },
    Err(Error) => {
        return HttpResponse::Conflict().body("The user may already exist. Try signing in.");
    },
    _ => {
        return HttpResponse::InternalServerError().body("Something went wrong, please try again later");
    }
       
   }

   HttpResponse::Ok().body("body")
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
            .service(create_user)

    })
    .bind(("0.0.0.0", 8084))?
    .run()
    .await

    //  Ok(())
}
