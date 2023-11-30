pub mod email {

    use actix_web::{post, web::Json, HttpResponse};
    use lettre::message::header::ContentType;
    use lettre::transport::smtp::authentication::Credentials;
    use lettre::{Message, SmtpTransport, Transport};

    use super::super::email_structs::email_structs::*;

    #[post("/send_verification_email")]
    pub async fn send_verification_email(data: Json<VerifyEmailPayload>) -> HttpResponse {

        let message = format!("Hello\nYour verification code is {}", data.code);
        let email = Message::builder()
            .from("coastlinkedu@gmail.com".parse().unwrap())
            .to(data.email.parse().unwrap())
            .subject("Your verification Code")
            .header(ContentType::TEXT_PLAIN)
            .body(message)
            .unwrap();

        let creds: Credentials = Credentials::new(
            "coastlinkedu@gmail.com".to_owned(),
            "fvja xyfg veiw jqlw".to_owned(),
        );

        // Open a remote connection to gmail
        let mailer = SmtpTransport::relay("smtp.gmail.com")
            .unwrap()
            .credentials(creds)
            .build();

        // Send the email
        match mailer.send(&email) {
            Ok(_) => HttpResponse::Ok().body(""),
            Err(E) => HttpResponse::Conflict().body(format!("ERROR : {}", E)),
        }
    }
}
