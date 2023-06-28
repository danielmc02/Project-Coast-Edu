use actix_web::{HttpServer,App, Responder,get,HttpResponse};



#[get("/")]
async fn hello() -> impl Responder
{
    HttpResponse::Ok().body("Welcome")
}

#[actix_web::main]
async fn main() -> std::io::Result<()>
{

    HttpServer::new(||
    {
        App::new().service(hello)

    }).bind(("0.0.0.0", 8083))?.run().await

}