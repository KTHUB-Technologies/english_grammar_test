
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_enest_english_grammar_test/helper/config_microsoft.dart';
import 'package:the_enest_english_grammar_test/helper/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;

class AppController extends GetxController{

  int value = 0;

  bool isEnglish = false;

  Rx<Locale> locale=Rx<Locale>();

  Rx<String> idUserMicrosoft=Rx<String>(null);

  Rx<bool> isShowLoading=Rx<bool>(false);

  void reset() {
    value = 0;
  }

  void increment() {
    value++;
  }

  void decrement() {
    value--;
  }

  Rx<bool> isDark=Rx<bool>(false);

  getDefaultLanguage() async {
    String languageCode =
    await SharedPreferencesHelper.getStringValue(SharedPreferencesHelper.LANGUAGE_CODE);
    if(languageCode.isNotEmpty){
      switch (languageCode){
        case "vi":
          locale.value = Locale("vi", 'VN');
          break;
        case "en":
          locale.value = Locale("en", 'US');
          break;
        default:
      }
    }
  }

  switchToVietnameseLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', "vi");
    locale.value = Locale("vi", 'VN');
  }

  switchToEnglishLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', "en");
    locale.value = Locale("en", 'US');
  }

  loginWithMicrosoft() async{
    isShowLoading.value=true;

    await ConfigMicrosoft.oauth.login();
    var accessToken = await ConfigMicrosoft.oauth.getAccessToken();
    print('Logged in successfully, your access token: $accessToken');

    final response = await http.get(ConfigMicrosoft.userProfileBaseUrl,headers: {ConfigMicrosoft.authorization: ConfigMicrosoft.bearer + accessToken});
    print(response.body);

    Map profile=jsonDecode(response.body);
    print(profile['id']);

    idUserMicrosoft.value=profile['id'];
    print(idUserMicrosoft.value);

    isShowLoading.value=false;
  }
}