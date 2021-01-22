import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';

class ConfigMicrosoft{

  static const userProfileBaseUrl = 'https://graph.microsoft.com/v1.0/me';
  static const authorization = 'Authorization';
  static const bearer = 'Bearer ';

  static Config config = new Config(
      tenant: "4ae3f938-bb88-48f4-aa29-8153f2660c5d",
      clientId: "3838ee20-f117-4010-8f07-c33d5a9e46cf",
      scope: "https://graph.microsoft.com/user.read",
      redirectUri: "msal3838ee20-f117-4010-8f07-c33d5a9e46cf://auth"
  );

  static final AadOAuth oauth = new AadOAuth(config);
}