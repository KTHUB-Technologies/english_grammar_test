import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
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
  final AppController appController = Get.find();

  @override
  void initState() {
    levelController.loadJson(appController.accessToken.value);
    levelController.categories = [];
    levelController.distinctCategory = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = getScreenWidth(context) / 2;
    return Obx(() {
      return LoadingContainer(
        child: Scaffold(
          body: Container(
            width: getScreenWidth(context),
            padding: EdgeInsets.only(top: Dimens.getLogoSize(context)),
            child: Column(
              children: <Widget>[
                Image.asset(
                  Images.logo,
                  width: logoSize,
                  height: logoSize,
                ),
                Text(
                  'English Grammar Test',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimens.paragraphHeaderTextSize,
                  ),
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

                          Get.to(
                              LevelScreen(
                                level: e,
                                isProgress: false,
                              ),
                              transition: Transition.rightToLeftWithFade,
                              duration: Duration(milliseconds: 500));
                        }),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        isLoading: levelController.isShowLoading.value,
        isShowIndicator: true,
      );
    });
  }

  Widget buildAppButtonLevel(int level, Function onTap) {
    return Stack(
      children: <Widget>[
        AppButton(
          getLevel(level),
          onTap: () async {
            SoundsHelper.checkAudio(Sounds.touch);
            onTap();
          },
        ),
        // ignore: deprecated_member_use
        appController.accessToken.value.isNullOrBlank
            ? level != 1
                ? Container(
                    height: getScreenWidth(context) / 8,
                    width: getScreenWidth(context) / 1.8,
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: AppColors.white,
                    ),
                  )
                : SizedBox()
            : SizedBox(),
      ],
    );
  }
}
