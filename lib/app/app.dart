import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:tocviet_customer/controller/app_store_controller.dart';
import 'package:tocviet_customer/controller/booking_store_controller.dart';
import 'package:tocviet_customer/controller/cart_product_store_controller.dart';
import 'package:tocviet_customer/controller/cart_service_store_controller.dart';
import 'package:tocviet_customer/controller/history_store_controller.dart';
import 'package:tocviet_customer/controller/home_store_controller.dart';
import 'package:tocviet_customer/controller/main_store_controller.dart';
import 'package:tocviet_customer/controller/notification_store_controller.dart';
import 'package:tocviet_customer/controller/product_store_controller.dart';
import 'package:tocviet_customer/controller/service_store_controller.dart';
import 'package:tocviet_customer/controller/user_store_controller.dart';
import 'package:tocviet_customer/controller/wallet_store_controller.dart';
import 'package:tocviet_customer/localization/flutter_localizations_delegate.dart';
import 'package:tocviet_customer/router/routes.dart';
import 'package:tocviet_customer/screen/no_connection.dart';
import 'package:tocviet_customer/screen/splash/splash_screen.dart';
import 'package:tocviet_customer/theme/colors.dart';
import 'package:tocviet_customer/theme/fonts.dart';

class TocVietUserApp extends StatefulWidget {
  // static var router;
//
//   TocVietUserApp({Key key}) : super(key: key) {
//     final router =  fluro.Router();
//     Routes.configureRoutes(router);
//     TocVietUserApp.router = router;
//   }
//
  @override
  State<TocVietUserApp> createState() => _AppState();
}

class _AppState extends State<TocVietUserApp> {
  final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();

  final AppStoreController appStore= Get.put(AppStoreController());

  StreamSubscription connectivitySubscription;

  ConnectivityResult _previousResult;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        if (nav.currentState != null) {
          nav.currentState.pushReplacement(MaterialPageRoute(
              builder: (BuildContext _) => NoConnectionScreen()));
        }
      } else if (_previousResult == ConnectivityResult.none) {
        if (nav.currentState != null) {
          nav.currentState.pushReplacement(
              MaterialPageRoute(builder: (BuildContext _) => SplashScreen()));
        } else {
          if (nav.currentState != null) {
            nav.currentState.pushReplacement(
                MaterialPageRoute(builder: (BuildContext _) => SplashScreen()));
          }
        }
      }

      _previousResult = connectivityResult;
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    appStore.getDefaultLanguage();
    return Obx((){
        return GetMaterialApp(
            navigatorKey: nav,
            initialBinding: BindingsBuilder((){
              Get.put(BookingStoreController());
              Get.put(CartProductStoreController());
              Get.put(CartServiceStoreController());
              Get.put(HistoryStoreController());
              Get.put(HomeStoreController());
              Get.put(MainStoreController());
              Get.put(NotificationStoreController());
              Get.put(ProductStoreController());
              Get.put(ServiceStoreController());
              Get.put(UserStoreController());
              Get.put(WalletStoreController());
            }),
            getPages: Routes.route,
            color: AppColors.primary,
            debugShowCheckedModeBanner: false,
            title: '',
            supportedLocales: [
              Locale('vi', 'VN'),
              Locale('en', 'US'),
            ],
            locale: appStore.locale.value,
            localizationsDelegates: [
              FlutterLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
                primaryColor: AppColors.primary,
                accentColor: AppColors.primary,
                fontFamily: Fonts.Lato,
                primaryIconTheme: IconThemeData(color: Colors.white)),
            home: SplashScreen());
      },
    );
  }
}
