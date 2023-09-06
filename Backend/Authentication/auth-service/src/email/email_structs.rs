pub mod email_structs
{
    use serde::{Serialize,Deserialize};


    #[derive(Deserialize,Serialize)]
    pub struct VerifyEmailPayload
    {
      pub  jwt: String,
      pub  email: String,
      pub  code: String
    }


}