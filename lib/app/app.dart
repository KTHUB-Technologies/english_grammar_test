import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations_delegate.dart';
import 'package:the_enest_english_grammar_test/routes/routes.dart';
import 'package:the_enest_english_grammar_test/screens/splash/splash_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/fonts.dart';


class EnglishGrammarTestApp extends StatefulWidget {
  @override
  State<EnglishGrammarTestApp> createState() => _EnglishGrammarTestAppState();
}

class _EnglishGrammarTestAppState extends State<EnglishGrammarTestApp> {
  final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();
  final AppController appController= Get.put(AppController());
  StreamSubscription connectivitySubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    appController.getDefaultLanguage();
    return Obx((){
        return GetMaterialApp(
            navigatorKey: nav,
            getPages: Routes.route,
            initialBinding: BindingsBuilder((){
              Get.put(MainController());
              Get.put(UserController());
            }),
            debugShowCheckedModeBanner: false,
            title: '',
            supportedLocales: [
              Locale('vi', 'VN'),
              Locale('en', 'US'),
            ],
            locale: appController.locale.value,
            localizationsDelegates: [
              FlutterLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(brightness: Brightness.light, fontFamily: Fonts.Helvetica),
            // theme: ThemeData(
            //    // primaryColor: AppColors.primary,
            //  //   accentColor: AppColors.primary,
            //     primaryIconTheme: IconThemeData(color: Colors.white)),
            home: SplashScreen());
      },
    );
  }
}
