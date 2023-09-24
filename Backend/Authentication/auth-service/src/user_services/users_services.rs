pub mod user_services {
    use std::fmt::format;

    use crate::email;

    use super::super::super::AppData;
    //use super::super::user_structs::user_structs::DefaultPreferences;
    use actix_web::{post, web, web::Json, HttpResponse, put};
    use serde_json;
    use sqlx::query_as;
  /*   #[post("/update_user_preferences")]
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
*/


  use super::super::user_structs::user_structs::DefaultUserRequestFormat;


    #[put("/update_user_name")]
    async fn update_user_name(req: Json<DefaultUserRequestFormat>,data: web::Data<AppData>) -> HttpResponse
    {
 //       println!("WOOP WOOP {}\n{}\n{}\n", req.jwt,req.id,req.data);
        
       let result =  sqlx::query("UPDATE public_users SET name = $1 WHERE id = $2::uuid")
       .bind(&req.data)
       .bind(&req.id)
       .execute(&data.db_pool).await;
    match result {
        Ok(_)=> {
            return HttpResponse::Ok().body("");
        }
        Err(e)=> {
            return HttpResponse::Conflict().body(e.to_string());
        }
    }
        
    }

    #[put("/update_user_interests")]
    async fn update_user_interests(req: Json<DefaultUserRequestFormat>,data: web::Data<AppData>) -> HttpResponse
    {
        println!("Updating user interests \n{}\n{}\n" ,req.id,req.data);

        

       let result =  sqlx::query("UPDATE public_users SET interests = $1::json WHERE id = $2::uuid")
       .bind(&req.data)
       .bind(&req.id)
       .execute(&data.db_pool).await;
    match result {
        Ok(_)=> {
            println!("YESSIR");
            return HttpResponse::Ok().body("");
        }
        Err(e)=> {
            return HttpResponse::Conflict().body(e.to_string());
        }
    }
        
    }

    #[put("/update_verified_student_status")]
    async fn update_verified_student_status(req: Json<DefaultUserRequestFormat>,data: web::Data<AppData>) -> HttpResponse
    {
        println!("Updating student status \n{}\n{}\n" ,req.id,req.data);

        

       let result =  sqlx::query("UPDATE public_users SET verified_student = $1::BOOL WHERE id = $2::uuid")
       .bind(&req.data)
       .bind(&req.id)
       .execute(&data.db_pool).await;
    match result {
        Ok(_)=> {
            println!("YESSIR");
            return HttpResponse::Ok().body("");
        }
        Err(e)=> {
            return HttpResponse::Conflict().body(e.to_string());
        }
    }
        
    }
}
