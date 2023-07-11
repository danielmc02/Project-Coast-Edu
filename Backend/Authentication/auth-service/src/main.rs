use std::fmt::format;

use actix_web::{get, post, web::Json, App, HttpResponse, HttpServer, Responder};
use bcrypt::{hash, hash_with_salt, verify, DEFAULT_COST};
use serde::Deserialize;

#[derive(Deserialize)]
struct RegistrationInfo {
    email: String,
    password: String,
}

#[get("/")]
async fn hello() -> impl Responder {
    println!("SCOPED");
    HttpResponse::Ok().body("Welcome")
}

#[post("/register_user")]
async fn register_user(info: Json<RegistrationInfo>) -> HttpResponse {
    println!("SCOPED");
    let salt: [u8; 16] = [1; 16];
    let email = &info.email;
    let password = &info.password;
    println!("SALT: {:?}", salt);
    println!("Email: {}\nPassword: {}", email, password);
    /*
    Register user logic here
    */
    // let hashed_password: Result<String, bcrypt::BcryptError> = hash(password, DEFAULT_COST);
    let hashed_password = hash_with_salt(password, DEFAULT_COST, salt);
    //  println!("Hashed Password: {:?}",hashed_password.unwrap()["hash"]);
    //verify(hashed_password, hash);

    HttpResponse::Ok().body("User registered successfully")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().service(hello).service(register_user))
        .bind(("0.0.0.0", 8083))?
        .run()
        .await
}
