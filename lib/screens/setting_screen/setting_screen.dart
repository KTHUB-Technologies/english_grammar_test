import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/helper/config_microsoft.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/screens/login_screen/login_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'SETTINGS',
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          buildDarkModeSetting(),
          Dimens.height30,
          buildSignOutButton(context),
        ],
      ),
    );
  }

  Widget buildDarkModeSetting() {
    return Obx(() {
      return Card(
        child: ListTile(
          title: AppText(
            text: 'Dark Mode',
            color: AppColors.blue,
          ),
          trailing: Switch(
              value: appController.isDark.value,
              onChanged: (bool value) async {
                final openBox = await Hive.openBox('Dark_Mode');
                appController.isDark.value = value;
                await openBox.put('isDark', appController.isDark.value);
                openBox.close();
              }),
        ),
      );
    });
  }

  Widget buildSignOutButton(BuildContext context) {
    return AppButton(
      // ignore: deprecated_member_use
      appController.accessToken.value.isNullOrBlank ? 'Sign In' : 'Sign Out',
      widthButton: getScreenWidth(context) / 3,
      // ignore: deprecated_member_use
      onTap: appController.accessToken.isNullOrBlank
          ? () {
        Get.offAll(LoginScreen());
      }
          : () async {
        await ConfigMicrosoft.oauth.logout();
        appController.accessToken.value=null;
        Get.offAll(LoginScreen());
      },
    );
  }
}
