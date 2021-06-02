import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
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
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => LoadingContainer(
          child: Scaffold(
            body: Column(
              children: <Widget>[
                // buildDarkModeSetting(),
                Container(
                  height: Dimens.container30,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: AppColors.gradientColorPrimary)),
                ),
                _buildHeader(),
                _buildSoundSetting(),
                _buildLanguageSetting(),
                _buildButtonSignInOut(context),
              ],
            ),
          ),
          isLoading: userController.isShowLoading.value,
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
          text: FlutterLocalizations.of(context).getString(context, 'setting'),
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

  _buildButtonSignInOut(BuildContext context) {
    return Obx(() => Card(
          child: ListTile(
            leading: Container(
              child: Icon(Icons.email),
              padding: EdgeInsets.symmetric(horizontal: Dimens.padding17),
            ),
            title: AppText(
              text: userController.user.value == null
                  ? FlutterLocalizations.of(context).getString(context, 'sign_in_with_social')
                  : userController.user.value.displayName ?? FlutterLocalizations.of(context).getString(context, 'unknown_name'),
            ),
            onTap: () async {
              userController.user.value == null
                  ? Get.offAll(MainScreen())
                  : showConfirmDialog(context,
                      title: FlutterLocalizations.of(context).getString(context, 'waring'),
                      content: FlutterLocalizations.of(context).getString(context, 'ask_log_out'), confirm: () async {
                      await userController.logout();
                    }, cancel: () {
                      Get.back();
                    });
            },
          ),
        ));
  }

  _buildSoundSetting() {
    return Obx(() {
      return Card(
        child: ListTile(
          leading: Switch(
              value: appController.sound.value,
              onChanged: (bool value) async {
                final openBox = await Hive.openBox(Constants.SOUND_BOX_NAME);
                appController.sound.value = value;
                await openBox.put(Constants.SOUND_KEY_NAME, appController.sound.value);
                openBox.close();
              }),
          title: AppText(
            text: FlutterLocalizations.of(context).getString(context, 'sound'),
            color: AppColors.blue,
          ),
        ),
      );
    });
  }

  _buildLanguageSetting() {
    return Card(
      child: ListTile(
        leading: Container(
          child: Icon(Icons.language),
          padding: EdgeInsets.symmetric(horizontal: Dimens.padding17),
        ),
        title: AppText(
          text: FlutterLocalizations.of(context).getString(context, 'language'),
        ),
        onTap: () {
          Get.to(ChangeLanguageScreen());
        },
      ),
    );
  }
}
