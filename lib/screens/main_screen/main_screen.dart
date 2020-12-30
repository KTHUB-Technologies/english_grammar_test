import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/assets/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
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
    levelController.categories = [];
    levelController.distinctCategory = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = getScreenWidth(context) / 2;
    return Obx((){
      return LoadingContainer(child: Scaffold(
        body: Container(
          color: AppColors.white,
          width: getScreenWidth(context),
          padding: EdgeInsets.only(top: Dimens.getLogoSize(context)),
          child: Column(
            children: <Widget>[
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
                  children: levelController.distinctLevel.map((e) {
                    return Container(
                      padding: EdgeInsets.only(bottom: Dimens.formPadding),
                      child: buildAppButtonLevel(e, () async {
                        await levelController.loadQuestionFromLevel(e);
                        levelController.categories = levelController.questions
                            .map((e) => e.categoryId)
                            .toList();
                        levelController.distinctCategory =
                            levelController.categories.toSet().toList();
                        levelController.distinctCategory.sort();

                        Get.to(LevelScreen(
                          level: e,
                          isProgress: false,
                        ));
                      }),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),isLoading: levelController.isShowLoading.value, isShowIndicator: true,);
    });
  }

  AppButton buildAppButtonLevel(int level, Function onTap) {
    return AppButton(
      getLevel(level),
      onTap: () {
        player.play(Sounds.touch);
        onTap();
      },
    );
  }
}
