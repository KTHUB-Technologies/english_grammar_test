import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_enest_english_grammar_test/helper/config_microsoft.dart';
import 'package:the_enest_english_grammar_test/helper/shared_preferences_helper.dart';

class AppController extends GetxController {
  int value = 0;

  bool isEnglish = false;

  Rx<Locale> locale = Rx<Locale>();

  Rx<bool> isShowLoading = Rx<bool>(false);

  void reset() {
    value = 0;
  }

  void increment() {
    value++;
  }

  void decrement() {
    value--;
  }

  Rx<bool> isDark = Rx<bool>(false);
  Rx<bool> sound=Rx<bool>(true);

  getDefaultLanguage() async {
    String languageCode = await SharedPreferencesHelper.getStringValue(
        SharedPreferencesHelper.LANGUAGE_CODE);
    if (languageCode.isNotEmpty) {
      switch (languageCode) {
        case "vi":
          locale.value = Locale("vi", 'VN');
          break;
        case "en":
          locale.value = Locale("en", 'US');
          break;
        default:
          locale.value = Locale("en", 'US');
          break;
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

  // loginWithMicrosoft() async {
  //   isShowLoading.value = true;
  //   try {
  //     await ConfigMicrosoft.oauth.login();
  //     var accessToken = await ConfigMicrosoft.oauth.getAccessToken();
  //     final response = await Dio().get(ConfigMicrosoft.userProfileBaseUrl,
  //         options: Options(headers: {
  //           ConfigMicrosoft.authorization: ConfigMicrosoft.bearer + accessToken
  //         }));
  //     Map profile = jsonDecode(response.toString());
  //     print(profile);
  //     user.value = profile;
  //     final openBox = await Hive.openBox('accessToken');
  //     await openBox.put('accessToken', accessToken);
  //     await openBox.put('id',profile['id']);
  //     openBox.close();
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   isShowLoading.value = false;
  // }

  // signOut()async {
  //   isShowLoading.value = true;
  //   try {
  //     await ConfigMicrosoft.oauth.logout();
  //     user.value = null;
  //     final openBox = await Hive.openBox('accessToken');
  //     await openBox.clear();
  //     openBox.close();
  //   } catch (e) {
  //     print(e);
  //   }
  //   isShowLoading.value = false;
  // }
}
