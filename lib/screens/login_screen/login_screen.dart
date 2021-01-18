
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  static final Config config = new Config(
      tenant: "f8cdef31-a31e-4b4a-93e4-5f571e91255a",
      clientId: "7d031982-91e9-4080-86f6-49f1cf7e57c7",
      scope: "https://graph.microsoft.com/offline_access",
      redirectUri: "msauth.com.example.theEnestEnglishGrammarTest://auth"
  );

  final AadOAuth oauth = new AadOAuth(config);

  @override
  Widget build(BuildContext context) {
    final logoSize = getScreenWidth(context) / 2;
    return Scaffold(
      body: Container(
        width: getScreenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              Images.logo,
              width: logoSize,
              height: logoSize,
            ),
            Dimens.quarterHeight(context),
            AppButton(
              'Sign I with MICROSOFT account',
              onTap: ()async{
                try {
                  await oauth.login();
                  var accessToken = await oauth.getAccessToken();
                  print('Logged in successfully, your access token: $accessToken');
                } catch (e) {
                  print("-----------------> $e");
                }
              },
            ),
            Dimens.height30,
            AppButton(
              'Continue with out Sign In',
              onTap: () async{
                await oauth.logout();
                await FirebaseAuth.instance.signOut();
                // Get.offAll(MainScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
