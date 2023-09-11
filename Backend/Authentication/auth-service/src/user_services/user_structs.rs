pub mod user_structs
{
    use serde::{Deserialize,Serialize};

    #[derive(Deserialize,Serialize)]
     pub struct DefaultPreferences
    {
       pub name: String,
       pub interests : String,
       pub school : String,
       pub verified: bool
    }

}