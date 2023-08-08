
use actix_web::{get, post, web::Json, App, HttpResponse, HttpServer,web::Data};
use awc::Client;
use bcrypt::{hash, hash_with_salt, verify, DEFAULT_COST};
use serde::Deserialize;





struct AppState {
    auth_client_access: Client,
}

#[post("/register_user")]
async fn register_user() -> HttpResponse
{
    //create a new user via db service and pass back a JWT
    HttpResponse::Ok().body("")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    //create client to communicate with other services

    HttpServer::new(  || App::new()
    .app_data(
        Data::new(AppState{
            auth_client_access: Client::default()
        })
    )
    .service(register_user))
        .bind(("0.0.0.0",8083))?
        .run()
        .await
}
