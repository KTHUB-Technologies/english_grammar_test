import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/fade_container.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeContainer(
          child: Image.asset(
            Images.logo,
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
        _navigateToMainScreen();
    });
  }

  _loadUserData() async {

  }
  _navigateToMainScreen() {
    Get.offNamedUntil('/MainScreen', (route) => false);
  }
}
