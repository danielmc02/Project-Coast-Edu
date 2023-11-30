pub mod auth_structs {
    use redis::{Client, RedisError};
    use serde::{Deserialize, Serialize};
    use sqlx::{FromRow, Pool, Postgres};
    #[derive(Deserialize, Serialize)]
    pub struct UserForm {
        pub email: String,
        pub password: String,
    }

    pub struct AppData {
        pub db_pool: Pool<Postgres>,
        //pub redis_connection: redis::Client
    }

    #[derive(FromRow, Debug)]
    pub struct User {
        pub id: String,
        pub email: String,
        //  pub name: Option<String>,
        pub password_hash: String,
        pub salt: String, //    pub interests: Option<serde_json::Value>,
                          //   pub verified_student: bool
    }

    #[derive(Debug, Serialize, Deserialize)]
    pub struct Claims {
        pub exp: usize,
        pub sub: String,
    }
    /*
     #[derive(Serialize)]
    pub struct SignInPackage {
     pub short_life_jwt: String,
     pub id:  String ,

     pub email: String,
     pub name: Option<String>,

    pub interests: Option<serde_json::Value>,
     pub verified_student: bool
     }
     */

    //Sent after signing in
    #[derive(Serialize, FromRow, Debug)]
    pub struct SignInResponce {
        //needs a jwt
        //needs their uid
        pub id: String,
        //needs their name
        pub name: Option<String>,
        //needs their interests
        pub interests: Option<serde_json::Value>,

        //needs verification status
        pub verified_student: bool,

        pub friends: Option<serde_json::Value>,
    }
}
