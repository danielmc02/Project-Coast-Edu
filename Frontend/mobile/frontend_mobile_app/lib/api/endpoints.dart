
class Endpoints
{

 // static const String ENDPOINT = "192.168.2.129";
  static const String ENDPOINT = "localhost";

  
  static final registerUserUri = Uri.parse('http://${ENDPOINT}:80/register_user');


  
  static final logInUri = Uri.parse('http://${ENDPOINT}:80/log_in');

  static final sendVerificationEmailUri = Uri.parse('http://${ENDPOINT}:80/send_verification_email');


  static final updateUserPreferencesUri = Uri.parse('http://${ENDPOINT}:80/update_user_preferences');


  static final getPublicUserInfo = Uri.parse('http://${ENDPOINT}:80/get_public_user_information');

 static Uri defaultUriConcatanate (String uriPath) =>  Uri.parse('http://${ENDPOINT}:80${uriPath}');




}