
class Endpoints
{

    static const String endpoint = "192.168.2.195";
  //static const String endpoint = "localhost";

  static final registerUserUri = Uri.parse('http://$endpoint:80/register_user');

  static final checkAndUpdateJwt = Uri.parse('http://$endpoint:80/check_and_update_jwt');
  
  static final logInUri = Uri.parse('http://$endpoint:80/log_in');

  static final sendVerificationEmailUri = Uri.parse('http://$endpoint:80/send_verification_email');


  static final updateUserPreferencesUri = Uri.parse('http://$endpoint:80/update_user_preferences');


  static final getPublicUserInfo = Uri.parse('http://$endpoint:80/get_public_user_information');

 static Uri defaultUriConcatanate (String uriPath) =>  Uri.parse('http://$endpoint:80$uriPath');




}