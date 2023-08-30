pub mod auth_structs {

    use serde::{Deserialize, Serialize};
    use sqlx::{FromRow, Pool, Postgres};

    #[derive(Deserialize)]
    pub struct UserForm {
        pub email: String,
        pub password: String,
    }

    pub struct AppData {
        pub db_pool: Pool<Postgres>,
    }

    #[derive(FromRow)]
    pub struct PayLoad {
        pub password_hash: String,
    }

    #[derive(Debug, Serialize, Deserialize)]
    pub struct Claims {
        pub exp: usize,
        pub sub: String,
    }

    #[derive(Serialize, Deserialize)]
   pub struct JsonCallBack {
      pub  short_life_jwt: String,
     pub   public_key: String,

      pub  email: String,
    }
}
