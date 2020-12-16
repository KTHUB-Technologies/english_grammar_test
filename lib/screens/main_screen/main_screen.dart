import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/assets/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/level_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

import '../../helper/utils.dart';
import '../../res/images/images.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final LevelController levelController = Get.find();
  final player = AudioCache();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = getScreenWidth(context) / 2;
    return Scaffold(
      body: Container(
        color: AppColors.white,
        width: getScreenWidth(context),
        padding: EdgeInsets.only(top: Dimens.getLogoSize(context)),
        child: Column(
          children: <Widget>[
            Dimens.height30,
            Image.asset(
              Images.logo,
              width: logoSize,
              height: logoSize,
            ),
            AppText(
              text: 'English Grammar Test',
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
              textSize: Dimens.paragraphHeaderTextSize,
            ),
            Dimens.quarterHeight(context),
            Expanded(
              child: Column(
                children: <Widget>[
                  buildAppButtonLevel(1, () {
                    Get.to(LevelScreen(
                      level: 1,
                    ));
                  }),
                  Dimens.height30,
                  buildAppButtonLevel(2, () {
                    Get.to(LevelScreen(
                      level: 2,
                    ));
                  }),
                  Dimens.height30,
                  buildAppButtonLevel(3, () {
                    Get.to(LevelScreen(
                      level: 3,
                    ));
                  }),
                  Dimens.height30,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppButton buildAppButtonLevel(int level, Function onTap) {
    return AppButton(
      '$level',
      onTap: () {
        player.play(Sounds.touch);
        onTap();
      },
    );
  }
}
