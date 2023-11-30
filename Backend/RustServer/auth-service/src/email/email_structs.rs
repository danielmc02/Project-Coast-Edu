pub mod email_structs {
    use serde::{Deserialize, Serialize};

    #[derive(Deserialize, Serialize)]
    pub struct VerifyEmailPayload {
        pub jwt: String,
        pub email: String,
        pub code: String,
    }
}
