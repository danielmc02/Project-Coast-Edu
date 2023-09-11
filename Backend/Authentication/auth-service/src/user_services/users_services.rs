pub mod user_services
{
    use actix_web::{post, HttpResponse,web::Json,web};
    use super::super::user_structs::user_structs::DefaultPreferences;
     
    use super::super::super::AppData;
    
    #[post("/update_user_preferences")]
    pub async fn update_user_preferences(req: Json<DefaultPreferences>, data: web::Data<AppData>,) -> HttpResponse
    {
        println!("{}\n{}\n{}\n{}\n",req.name,req.interests,req.school,req.verified);
        HttpResponse::Ok().body("body")
    }
    




}