pub mod user_services {
    use std::fmt::format;

    use crate::email;

    use super::super::super::AppData;
    use super::super::user_structs::user_structs::DefaultPreferences;
    use actix_web::{post, web, web::Json, HttpResponse};
    use serde_json;
    use sqlx::query_as;
    #[post("/update_user_preferences")]
    pub async fn update_user_preferences(
        req: Json<DefaultPreferences>,
        data: web::Data<AppData>,
    ) -> HttpResponse {
        println!("IF YOU SEE THIS: {}",&req.name);

        let result = sqlx::query(
            "UPDATE users set name = $1, interests = $2, verified_student = $3 WHERE email = $4", // &formated_query
        )
        .bind(&req.name)
        .bind(&req.interests)
        .bind(&req.verified)
        .bind(&req.email)
        //        interests = '$2'::json,    .bind(&req.interests)
        // .bind(&req.verified as &bool)
        .execute(&data.db_pool)
        .await;
        match result {
            Ok(row) => { 
            
                return HttpResponse::Ok().json(req);},
            Err(e) => {
                println!("{}", e);
                return HttpResponse::Conflict().body("ERROR");
            }
        }
    }
}
