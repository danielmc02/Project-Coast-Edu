
use actix_web::{get, post, web::Json, App, HttpResponse, HttpServer, Responder,web::Data};
use awc::Client;
use bcrypt::{hash, hash_with_salt, verify, DEFAULT_COST};
use serde::Deserialize;



struct AppState {
    auth_client_access: Client,
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
    .service(hello)
    .service(register_user))
        .bind(("0.0.0.0",8083))?
        .run()
        .await
}
