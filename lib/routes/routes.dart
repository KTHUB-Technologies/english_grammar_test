import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/screens/splash/splash_screen.dart';

class Routes {
  static String root = '/';
  static String loginScreen = '/LoginScreen';
  static String verifyPhoneNumberScreen = '/VerifyPhoneNumberScreen';
  static String splashScreenNew = '/SplashScreenNew';
  static String mainScreen = '/MainScreen';
  static String collectCustomerInformationScreen =
      '/CollectCustomerInformationScreen';
  static String homePage = '/HomePage';
  static String noConnection = '/NoConnection';

  static final route = [
    GetPage(name: splashScreenNew, page: () => SplashScreen()),
    GetPage(
        name: mainScreen,
        page: () => MainScreen(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 500)),
  ];

}
