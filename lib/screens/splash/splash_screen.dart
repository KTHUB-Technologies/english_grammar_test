import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tocviet_customer/auth/auth_helper.dart';
import 'package:tocviet_customer/controller/home_store_controller.dart';
import 'package:tocviet_customer/controller/user_store_controller.dart';
import 'package:tocviet_customer/helper/shared_preferences_helper.dart';
import 'package:tocviet_customer/localization/flutter_localizations.dart';
import 'package:tocviet_customer/model/user.dart';
import 'package:tocviet_customer/res/images/images.dart';
import 'package:tocviet_customer/screen/login_screen/collect_customer_information.dart';
import 'package:tocviet_customer/theme/colors.dart';
import 'package:tocviet_customer/utils/utils.dart';
import 'package:tocviet_customer/widget/fade_container.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  final UserStoreController userStore = Get.find();
  final HomeStoreController homeStore = Get.find();
  Timer timer;

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           OVERRIDE METHODS           ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  @override
  void initState() {
    super.initState();
    checkConnect();
    onWidgetBuildDone(onBuildDone);
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = getScreenWidth(context) / 2;
    homeStore.getNews();
    homeStore.getHotStyleInMonth();
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: FadeContainer(
          child: Image.asset(
            Images.logo2,
            width: logoSize,
            height: logoSize,
          ),
        ),
      ),
    );
  }

  checkConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Get.offNamedUntil('/NoConnectionScreen', (route) => false);
    }
  }

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           BUILD METHODS              ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///             OTHER METHODS            ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  onBuildDone() async {
    /// Delay 3 seconds, then navigate to Login screen

    timer=Timer.periodic(Duration(seconds: 2), (timer) async {
      await _loadUserData();
      if (userStore.user.value==null) {
        _navigateToLoginScreen();
      } else {
        _navigateToMainScreen();
      }
    });
  }

  _loadUserData() async {
    var user = await SharedPreferencesHelper.getStringValue(
        SharedPreferencesHelper.USER);
    if (user.isNotEmpty) {
      userStore.user.value = UserTocViet.fromJson(jsonDecode(user));
    }
  }

  _navigateToLoginScreen() {
    Get.offNamedUntil('/LoginScreen', (route) => false);
  }

  _navigateToMainScreen() {
    Get.offNamedUntil('/MainScreen', (route) => false);
  }
}
