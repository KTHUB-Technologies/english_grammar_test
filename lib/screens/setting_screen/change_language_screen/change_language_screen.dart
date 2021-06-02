import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  final AppController appController=Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
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
            _buildVietnameseLanguage(),
            _buildAmericanLanguage(),
          ],
        ),
      ),
    );
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
          text: FlutterLocalizations.of(context)
              .getString(context, 'change_language'),
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.white,
        ),
      ),
    );
  }

  _buildVietnameseLanguage() {
    return Card(
      child: ListTile(
        title: AppText(
            text: FlutterLocalizations.of(context)
                .getString(context, 'vietnamese')),
        trailing: SizedBox(
            width: getScreenWidth(context) / 15,
            child: Image.asset(Images.vn_flag)),
        onTap: () {
          _handleClickMe(Constants.VIETNAMESE);
        },
      ),
    );
  }

  _buildAmericanLanguage() {
    return Card(
      child: ListTile(
        title: AppText(
            text: FlutterLocalizations.of(context).getString(context, 'english')),
        trailing: SizedBox(
            width: getScreenWidth(context) / 15,
            child: Image.asset(Images.us_flag)),
        onTap: () {
          _handleClickMe(Constants.ENGLISH);
        },
      ),
    );
  }

  void _changeLanguage(String languageCode) async {
    switch (languageCode) {
      case Constants.VIETNAMESE:
        appController.switchToVietnameseLanguage();
        break;
      case Constants.ENGLISH:
        appController.switchToEnglishLanguage();
        break;
      default:
        appController.switchToVietnameseLanguage();
        break;
    }
  }

  _handleClickMe(String languageCode) async {
    showConfirmDialog(context,
        title: FlutterLocalizations.of(context)
            .getString(context, 'change_language'),
        content: FlutterLocalizations.of(context)
            .getString(context, 'change_language_confirm'),
        cancel: () => Navigator.pop(context),
        confirm: () {
          _changeLanguage(languageCode);
        });
  }
}
