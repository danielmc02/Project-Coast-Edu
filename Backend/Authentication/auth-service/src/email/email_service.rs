pub mod email {
    
    use actix_web::{post, HttpResponse,web::Json};
    use lettre::message::header::ContentType;
    use lettre::transport::smtp::authentication::Credentials;
    use lettre::{Message, SmtpTransport, Transport};

   use super::super::email_structs::email_structs::*;

    #[post("/send_verification_email")]
 pub   async fn send_verification_email(data: Json<VerifyEmailPayload>) -> HttpResponse {
/* 
    let public_key_path = "src/authentication/keys/publickey.pem";

    let mut public_key_file = File::open(public_key_path).expect("ERROR OPENING");
    let mut public_key_contents = Vec::new();
    public_key_file.read_to_end(&mut public_key_contents).expect("ERROR READING OUTPUT");
    let valid = Validation::new(jsonwebtoken::Algorithm::RS256);

    let result = decode::<serde_json::Value>(&data.jwt,  &DecodingKey::from_rsa_pem(&public_key_contents).unwrap(), &valid).expect("msg");
    print!("{:?}",result);
    */
        let message = format!("Hello\nYour verification code is {}",data.code);
        let email = Message::builder()
            .from("coastlinkedu@gmail.com".parse().unwrap())
            .to(data.email.parse().unwrap())
            .subject("Your verification Code")
            .header(ContentType::TEXT_PLAIN)
            .body(message)
            .unwrap();

        let creds: Credentials = Credentials::new(
            "coastlinkedu@gmail.com".to_owned(),
            "jcdjcpfjhphxrmmp".to_owned(),
        );

        // Open a remote connection to gmail
        let mailer = SmtpTransport::relay("smtp.gmail.com")
            .unwrap()
            .credentials(creds)
            .build();

        // Send the email
        match mailer.send(&email) {
            Ok(_) => HttpResponse::Ok().body(""),
            Err(_) => HttpResponse::Conflict().body(""),
        }
        
         
    }
}
