pub mod auth_structs {

    use serde::{Deserialize, Serialize};
    use sqlx::types::Uuid;


    use sqlx::{FromRow, Pool, Postgres};
    #[derive(Deserialize,Serialize)]
    pub struct UserForm {
        pub email: String,
        pub password: String,
    }

    pub struct AppData {
        pub db_pool: Pool<Postgres>,
    }

    #[derive(FromRow,Debug)]
    pub struct UserField {
        pub id: String,
        pub email: String,
        pub name: Option<String>,
        pub password_hash: String,
        pub interests: Option<serde_json::Value>,
        pub verified_student: bool

    }


    #[derive(Debug, Serialize, Deserialize)]
    pub struct Claims {
        pub exp: usize,
        pub sub: String,
    }

    #[derive(Serialize)]
   pub struct SignInPackage {
    pub short_life_jwt: String,
    pub id:  String ,

    pub email: String,
    pub name: Option<String>,

   pub interests: Option<serde_json::Value>,
    pub verified_student: bool
    }
}

