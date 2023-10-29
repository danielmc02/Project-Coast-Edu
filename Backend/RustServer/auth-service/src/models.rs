

pub mod global_structs {
    use sqlx::{Pool, Postgres};


    pub struct AppData {
        pub db_pool: Pool<Postgres>,
    }


}
