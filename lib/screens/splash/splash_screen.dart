import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/fade_container.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/helper/config_microsoft.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/screens/about_screen/about_screen.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  final MainController mainController=Get.find();
  final AppController appController=Get.find();
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
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   Get.offNamedUntil('/NoConnectionScreen', (route) => false);
    // }
  }

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///           BUILD METHODS              ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///

  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  ///             OTHER METHODS            ///
  ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~///
  onBuildDone() async {
    await mainController.getAllQuestions();
    await _loadUserData();
    await SoundsHelper.load();
    await checkDarkMode();
    /// Delay 3 seconds, then navigate to Login screen
    timer=Timer.periodic(Duration(seconds: 2), (timer) async {
      await _loadUserData();
      _navigateToMainScreen();
    //  await checkFirstLoad();
    });
  }

  checkDarkMode() async{
    final openBox=await Hive.openBox('Dark_Mode');
    if(openBox.get('isDark')!=null)
      appController.isDark.value=openBox.get('isDark');
    openBox.close();
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
    final openBox=await Hive.openBox('Token');
    try{
      if(openBox.get('accessToken')!=null){
        final response = await Dio().get(ConfigMicrosoft.userProfileBaseUrl,
            options: Options(headers: {
              ConfigMicrosoft.authorization: ConfigMicrosoft.bearer + openBox.get('accessToken')
            }));
        Map profile = jsonDecode(response.toString());
        print(profile);
        appController.user.value = profile;
      }
      openBox.close();
    }catch (error){
      print(error);
    }
  }
  _navigateToMainScreen() {
    Get.offAll(MainScreen());
  }
}
