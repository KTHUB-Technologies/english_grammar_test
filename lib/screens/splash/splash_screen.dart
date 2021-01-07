import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/fade_container.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/screens/about_screen/about_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  final LevelController levelController=Get.find();
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
    await levelController.loadJson();
    await SoundsHelper.load();
    /// Delay 3 seconds, then navigate to Login screen
    timer=Timer.periodic(Duration(seconds: 2), (timer) async {
      await _loadUserData();
      await checkFirstLoad();
    });
  }

  checkFirstLoad()async{
    final openBox=await Hive.openBox('First_Load');
    if(openBox.get('isFirst')!=null)
      _navigateToMainScreen();
    else
      Get.to(AboutScreen());
    openBox.close();
  }

  _loadUserData() async {

  }
  _navigateToMainScreen() {
    Get.offNamedUntil('/MainScreen', (route) => false);
  }
}
