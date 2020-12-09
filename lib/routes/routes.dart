import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tocviet_customer/constants/constants.dart';
import 'package:tocviet_customer/screen/home_page/home_page.dart';
import 'package:tocviet_customer/screen/login_screen/collect_customer_information.dart';
import 'package:tocviet_customer/screen/login_screen/login_screen.dart';
import 'package:tocviet_customer/screen/login_screen/verify_phone_number_screen.dart';
import 'package:tocviet_customer/screen/main_screen/main_screen.dart';
import 'package:tocviet_customer/screen/no_connection.dart';
import 'package:tocviet_customer/screen/splash/splash_screen.dart';

class Routes {

  static String root = '/';
  static String loginScreen = '/LoginScreen';
  static String verifyPhoneNumberScreen = '/VerifyPhoneNumberScreen';
  static String splashScreenNew = '/SplashScreenNew';
  static String mainScreen = '/MainScreen';
  static String collectCustomerInformationScreen = '/CollectCustomerInformationScreen';
  static String homePage = '/HomePage';
  static String noConnection='/NoConnection';

  static final route=[
    GetPage(name: loginScreen,page: ()=>LoginScreen(),transition: Transition.rightToLeft,transitionDuration: Duration(milliseconds: 500)),
    GetPage(name: verifyPhoneNumberScreen,page: ()=>VerifyPhoneNumberScreen(),transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 500)),
    GetPage(name: splashScreenNew,page: ()=>SplashScreen()),
    GetPage(name: mainScreen,page: ()=>MainScreen(),transition: Transition.rightToLeft,transitionDuration: Duration(milliseconds: 500)),
    // GetPage(name: collectCustomerInformationScreen,page: ()=>CollectCustomerInformationScreen()),
    GetPage(name: homePage,page: ()=>HomePage()),
    GetPage(name: noConnection,page: ()=>NoConnectionScreen()),
  ];
  //
  // static void configureRoutes(router) {
  //   router.notFoundHandler = fluro.Handler(
  //       // ignore: missing_return
  //       handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  //     print(
  //         '------> ROUTE WAS NOT FOUND !!! Go to routes.dart and route_handlers.dart and add your screen there <-------');
  //   });
  //
  //   router.define(splashScreenNew, handler: splashScreenHandler);
  //   router.define(loginScreen, handler: loginScreenHandler);
  //   router.define(verifyPhoneNumberScreen, handler: verifyPhoneNumberScreenHandler);
  //   router.define(mainScreen, handler: mainScreenHandler);
  //   router.define(collectCustomerInformationScreen, handler: collectCustomerInformationScreenHandler);
  // }
}
