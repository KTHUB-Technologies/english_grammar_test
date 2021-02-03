import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/helper/config_microsoft.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/screens/setting_screen/change_language_screen/change_language_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => LoadingContainer(
          child: Scaffold(
            body: Column(
              children: <Widget>[
                // buildDarkModeSetting(),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: AppColors.gradientColorPrimary)),
                ),
                _buildHeader(),
                _buildSoundSetting(),
                _buildLanguageSetting(),
                // _buildButtonSignInOut(context),
              ],
            ),
          ),
          isLoading: appController.isShowLoading.value,
        ));
  }

  _buildHeader() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.gradientColorPrimary)),
      child: ListTile(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
            onPressed: () => Get.back()),
        title: AppText(
          text: 'SETTINGS',
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.white,
        ),
      ),
    );
  }

  // _buildDarkModeSetting() {
  //   return Obx(() {
  //     return Card(
  //       child: ListTile(
  //         title: AppText(
  //           text: 'Dark Mode',
  //           color: AppColors.blue,
  //         ),
  //         trailing: Switch(
  //             value: appController.isDark.value,
  //             onChanged: (bool value) async {
  //               final openBox = await Hive.openBox('Dark_Mode');
  //               appController.isDark.value = value;
  //               await openBox.put('isDark', appController.isDark.value);
  //               openBox.close();
  //             }),
  //       ),
  //     );
  //   });
  // }

  // _buildButtonSignInOut(BuildContext context) {
  //   return Obx(() => Card(
  //         child: ListTile(
  //           leading: Container(
  //             child: Icon(Icons.email),
  //             padding: EdgeInsets.symmetric(horizontal: 17),
  //           ),
  //           title: AppText(
  //             text: appController.user.value == null
  //                 ? 'Sign In With The ENEST Account'
  //                 : appController.user.value['mail'],
  //           ),
  //           onTap: () async {
  //             appController.user.value == null
  //                 ? appController.loginWithMicrosoft()
  //                 : appController.signOut();
  //           },
  //         ),
  //       ));
  //
  //   // AppButton(
  //   //   appController.user.value == null
  //   //       ? 'Sign In With The ENEST Account'
  //   //       : appController.user.value['mail'],
  //   //   widthButton: getScreenWidth(context) / 3,
  //   //   onTap: appController.user.value == null
  //   //       ? () {
  //   //           Get.offAll(MainScreen());
  //   //         }
  //   //       : () async {
  //   //           await ConfigMicrosoft.oauth.logout();
  //   //           appController.user.value = null;
  //   //           final openBox = await Hive.openBox('accessToken');
  //   //           await openBox.clear();
  //   //           openBox.close();
  //   //           Get.offAll(MainScreen());
  //   //         },
  //   // );
  // }

  _buildSoundSetting() {
    return Obx(() {
      return Card(
        child: ListTile(
          leading: Switch(
              value: appController.sound.value,
              onChanged: (bool value) async {
                final openBox = await Hive.openBox('Sound');
                appController.sound.value = value;
                await openBox.put('isSound', appController.isDark.value);
                openBox.close();
              }),
          title: AppText(
            text: 'Sounds',
            color: AppColors.blue,
          ),
        ),
      );
    });
  }

  _buildLanguageSetting(){
    return Card(
      child: ListTile(
        leading: Container(
          child: Icon(Icons.language),
          padding: EdgeInsets.symmetric(horizontal: 17),
        ),
        title: AppText(
          text: FlutterLocalizations.of(context)
              .getString(context, 'language'),
        ),
        onTap: (){
          Get.to(ChangeLanguageScreen());
        },
      ),
    );
  }
}
