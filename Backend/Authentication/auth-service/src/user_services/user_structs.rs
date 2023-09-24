pub mod user_structs
{
    use std::vec::Vec;
    use serde::{Deserialize,Serialize};
    use sqlx::types::Json;

    /* 
    #[derive(Deserialize,Serialize)]
    pub struct DefaultPreferences {
        pub email: String,
        pub name: String,
        pub interests: String, 
        pub verified: bool,
    }
    */
    #[derive(Serialize, Deserialize)]
    pub struct DefaultUserRequestFormat
    {
       pub jwt : String,
       pub id : String,
       pub data : String
    }
}