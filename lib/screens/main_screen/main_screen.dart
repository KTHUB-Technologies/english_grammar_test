import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_logo.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/level_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final LevelController levelController = Get.find();
  final AppController appController = Get.find();

  @override
  void initState() {
    levelController.categories = [];
    levelController.distinctCategory = [];
    super.initState();
    checkFirst();
  }

  checkFirst() async {
    final openBox = await Hive.openBox('First_Load');
    await openBox.put('isFirst', 'checked');
    openBox.close();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingContainer(
        child: Scaffold(
          body: Container(
            child: Row(
              children: [
                _buildLevelNavigationRail(),
                Expanded(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: AppColors.gradientColorPrimary)),
                            height: getScreenHeight(context) / 2,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(70))),
                              height: getScreenHeight(context) / 2,
                              child: Center(
                                child: AppLogo(),
                              )),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            color: AppColors.white,
                            height: getScreenHeight(context) / 2,
                          ),
                          Container(
                            height: getScreenHeight(context) / 2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: AppColors.gradientColorPrimary),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(70))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: AppText(
                                    text: getLevelDescription(
                                        levelController.levelSelected.value +
                                            1),
                                    textAlign: TextAlign.center,
                                    color: AppColors.white,
                                  ),
                                ),
                                Dimens.height10,
                                Container(
                                  child: Center(
                                      child: _buildSelectedContent(
                                          levelController.levelSelected.value +
                                              1)),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        isLoading: levelController.isShowLoading.value,
        isShowIndicator: true,
      );
    });
  }

  _buildLevelNavigationRail() {
    return NavigationRail(
        backgroundColor: AppColors.white,
        minWidth: 55.0,
        groupAlignment: 0.0,
        selectedLabelTextStyle: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 14,
          letterSpacing: 1,
          decorationThickness: 2.0,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 13,
          letterSpacing: 0.8,
        ),
        selectedIndex: levelController.levelSelected.value,
        onDestinationSelected: (int index) {
          levelController.levelSelected.value = index;
        },
        labelType: NavigationRailLabelType.all,
        destinations: levelController.distinctLevel
            .map(
              (e) => NavigationRailDestination(
                  icon: SizedBox.shrink(),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Text(getLevel(e)),
                    ),
                  )),
            )
            .toList());
  }

  _buildSelectedContent(int level) {
    return Column(
      children: [buildAppButtonLevel(level)],
    );
  }

  _buildBottomNavigationBar() {}

  AppButton buildAppButtonLevel(int level) {
    return AppButton(
      "Let's Start",
      onTap: () async {
        SoundsHelper.checkAudio(Sounds.touch);
        await levelController.loadQuestionFromLevel(level);
        levelController.categories =
            levelController.questions.map((e) => e.categoryId).toList();
        levelController.distinctCategory =
            levelController.categories.toSet().toList();
        levelController.distinctCategory.sort();

        Get.to(
            LevelScreen(
              level: level,
              isProgress: false,
            ),
            transition: Transition.rightToLeftWithFade,
            duration: Duration(milliseconds: 500));
      },
    );
  }
}
