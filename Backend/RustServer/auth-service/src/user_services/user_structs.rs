pub mod user_structs
{
    use std::vec::Vec;
    use serde::{Deserialize,Serialize, de};
    use sqlx::{types::Json, FromRow};

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

#[derive(FromRow, Serialize,Deserialize,Debug)]
    pub struct PublicUserInformation
    {
        pub name: String,
        pub interests: Option<serde_json::Value>,
        pub verified_student: bool
    }

    #[derive(Serialize,Deserialize)]
    pub struct ClientIdMaster
    {
        pub id: String
    }
}