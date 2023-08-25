pub mod GlobalStructs {
    use serde::{Deserialize, Serialize};
    use sqlx::{Pool, Postgres};


    #[derive(Deserialize)]
    pub struct UserForm {
        pub email: String,
        pub password: String,
    }
/* 
    pub struct AppData {
        pub db_pool: Pool<Postgres>,
    }
    */

    #[derive(Debug, Serialize, Deserialize)]
    struct Claims {
        exp: usize,
        aud: String,
    }
}
