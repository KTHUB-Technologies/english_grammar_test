import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/config_microsoft.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AppController appController=Get.find();

  @override
  void initState() {
    super.initState();
    checkFirst();
  }

  checkFirst() async {
    final openBox = await Hive.openBox('First_Load');
    await openBox.put('isFirst', 'checked');
    openBox.close();
  }

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
                  await ConfigMicrosoft.oauth.login();
                  appController.accessToken.value = await ConfigMicrosoft.oauth.getAccessToken();
                  print('Logged in successfully, your access token: ${appController.accessToken.value}');

                  final response = await http.get(ConfigMicrosoft.userProfileBaseUrl,headers: {ConfigMicrosoft.authorization: ConfigMicrosoft.bearer + appController.accessToken.value});
                  print(response.body);

                  Map profile=jsonDecode(response.body);
                  print(profile['mail']);

                  Get.offAll(MainScreen());
                } catch (e) {
                  print("-----------------> $e");
                }
              },
            ),
            Dimens.height30,
            AppButton(
              'Continue with out Sign In',
              onTap: () {
                Get.offAll(MainScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
