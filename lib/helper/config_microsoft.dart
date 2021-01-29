import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';

class ConfigMicrosoft{

  static const userProfileBaseUrl = 'https://graph.microsoft.com/v1.0/me';
  static const authorization = 'Authorization';
  static const bearer = 'Bearer ';

  static Config config =  Config(
      tenant: "351983a7-160f-4e5b-8100-6518447a1937",
      clientId: "0900e203-5228-495b-8b46-772bcd81d2bf",
      scope: "https://graph.microsoft.com/user.read",
      redirectUri: "msal0900e203-5228-495b-8b46-772bcd81d2bf://auth",
  );

  static final AadOAuth oauth =  AadOAuth(config);

}