import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AppController appController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text:'SETTINGS',
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.white,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Obx((){
            return Card(
              child: ListTile(
                title: AppText(text: 'Dark Mode',color: AppColors.blue,),
                trailing: Switch(value: appController.isDark.value, onChanged: (bool value){
                  appController.isDark.value=value;
                }),
              ),
            );
          })
        ],
      ),
    );
  }
}
