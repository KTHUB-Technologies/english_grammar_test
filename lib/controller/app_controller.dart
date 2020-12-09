
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tocviet_customer/helper/shared_preferences_helper.dart';

class AppStoreController extends GetxController{

  int value = 0;

  bool isEnglish = false;

  Rx<Locale> locale=Rx<Locale>();

  void reset() {
    value = 0;
  }

  void increment() {
    value++;
  }

  void decrement() {
    value--;
  }

  getDefaultLanguage() async {
    String languageCode =
    await SharedPreferencesHelper.getStringValue('languageCode');
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
}