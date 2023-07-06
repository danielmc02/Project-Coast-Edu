
use sqlx::postgres::PgPoolOptions;

#[tokio::main]
async fn main() -> Result<(), sqlx::Error> 
{
let pool = PgPoolOptions::new()
.max_connections(5)
.connect("postgres://postgres:123123@localhost:5432/database").await?;
let row: (i64,) = sqlx::query_as("SELECT $1")
.bind(150_i64)
.fetch_one(&pool).await?;

assert_eq!(row.0, 150);

Ok(())
}