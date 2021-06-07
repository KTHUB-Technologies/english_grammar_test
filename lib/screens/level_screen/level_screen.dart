import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/scale_transition.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/category_card.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/normal_card.dart';
import 'package:the_enest_english_grammar_test/screens/progress_screen/progress_screen.dart';
import 'package:the_enest_english_grammar_test/screens/question_screen/question_screen.dart';
import 'package:the_enest_english_grammar_test/screens/setting_screen/setting_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class LevelScreen extends StatefulWidget {
  final int level;

  const LevelScreen({Key key, this.level}) : super(key: key);

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final MainController mainController = Get.find();
  final AppController appController = Get.put(AppController());
  final UserController userController = Get.find();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    loadAllScoreOfLevel();
  }

  loadAllScoreOfLevel() async {
    mainController.scoreOfCate.clear();
    mainController.allQuestionsFromFS.value.clear();
    if (userController.user.value != null) {
      Map data =
          await userController.getDataScore(userController.user.value.uid);
      Map question =
          await userController.getDataQuestion(userController.user.value.uid);

      await userController.getDataFavorite(userController.user.value.uid);

      if (data!=null) {
        if (data['${widget.level}'] != null)
          mainController.scoreOfCate.assignAll(data['${widget.level}']);
        else
          mainController.scoreOfCate.clear();
      }

      if (question!=null) {
        if (question['${widget.level}'] != null)
          mainController.allQuestionsFromFS.value =
              HashMap.from(question['${widget.level}']);
        else
          mainController.allQuestionsFromFS.value = {};
      }
    } else {
      final openBox = await Hive.openBox('Table_Score_${widget.level}');
      mainController.scoreOfCate.assignAll(openBox.toMap());
      openBox.close();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return LoadingContainer(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: AppColors.gradientColorPrimary),
                        border: Border.all(width: Dimens.borderWidth0, color: AppColors.transparent),
                      ),
                    ),
                    _buildCategoryContent(mainController.sectionSelected.value)
                  ],
                ),
              )
            ],
          ),
          isLoading: mainController.isShowLoading.value,
        );
      }),
    );
  }

  _buildHeader() {
    return Stack(
      children: [
        Container(
          color: AppColors.white,
          height: getScreenHeight(context) / Dimens.intValue4,
        ),
        Container(
          height: getScreenHeight(context) / Dimens.intValue4,
          decoration: BoxDecoration(
              border: Border.all(width: Dimens.borderWidth0, color: AppColors.transparent),
              gradient: LinearGradient(colors: AppColors.gradientColorPrimary),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Dimens.border70))),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: Dimens.formPadding),
            child: Column(
              children: [
                Dimens.height10,
                ListTile(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                        Get.back();
                    },
                  ),
                  title: AppText(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    textSize: Dimens.paragraphHeaderTextSize,
                    text: getLevel(widget.level),
                  ),
                  trailing: PopupMenuButton(
                      elevation: Dimens.elevation20,
                      icon: Icon(Icons.menu,color: AppColors.white,),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.border15)),
                      onSelected: choiceAction,
                      itemBuilder: (context) {
                        return Constants.choices.map((e) {
                          return PopupMenuItem(
                            value: e,
                            child: ListTile(
                              title: AppText(
                                text: getStringChoice(e, context),
                                color: AppColors.orangeAccent,
                              ),
                            ),
                          );
                        }).toList();
                      }),
                ),
                // _buildSectionTitle()
              ],
            ),
          ),
        ),
      ],
    );
  }

  // _buildSectionTitle() {
  //   return ToggleButtons(
  //     children: mainController.sections
  //         .map((e) => Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: AppText(
  //                 text: getSection(e),
  //                 color: AppColors.white,
  //               ),
  //             ))
  //         .toList(),
  //     borderRadius: BorderRadius.circular(15),
  //     onPressed: (int index) {
  //       for (int buttonIndex = 0;
  //           buttonIndex < mainController.selected.length;
  //           buttonIndex++) {
  //         if (buttonIndex == index) {
  //           mainController.selected[buttonIndex] = true;
  //         } else {
  //           mainController.selected[buttonIndex] = false;
  //         }
  //       }
  //       mainController.sectionSelected.value = index;
  //     },
  //     isSelected: mainController.selected,
  //   );
  // }

  _buildCategoryContent(int sectionSelected) {
    // switch (sectionSelected) {
    //   case 0:
        return Container(
          decoration: BoxDecoration(
              border: Border.all(width: Dimens.borderWidth0, color: Colors.transparent),
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(Dimens.border70))),
          child: Column(
            children: [
              SizedBox(
                child: _buildProgress(),
                height: Dimens.height54,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: mainController.distinctCategory.map((e) {
                    int totalQuestion = RxList<Question>(mainController
                            .questions
                            .where((c) => c.categoryId == e)
                            .toList())
                        .length;
                    return WidgetAnimatorScaleTransition(
                      NormalCategoryCard(
                        index: e,
                        level: widget.level,
                        totalQuestion: totalQuestion,
                        trueQues: Rx<double>(getTrueScoreOfCate(e))??Dimens.doubleValue0,
                        wrongQues: Rx<double>(getWrongScoreOfCate(e))??Dimens.doubleValue0,
                        category: e,
                        onTap: () async {
                          await mainController
                              .loadQuestionFromLevelAndCategory(
                              widget.level, e);

                          modalBottomSheet(
                              getCategory(e), widget.level, e);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      // case 1:
      //   return Container(
      //     height: getScreenHeight(context),
      //     width: getScreenWidth(context),
      //     decoration: BoxDecoration(
      //         border: Border.all(width: 0, color: Colors.transparent),
      //         color: AppColors.white,
      //         borderRadius: BorderRadius.only(topRight: Radius.circular(70))),
      //     child: Center(
      //       child: AppText(
      //         text: "COMING SOON",
      //       ),
      //     ),
      //   );
      // default:
      //   return Container(
      //     height: getScreenHeight(context),
      //     width: getScreenWidth(context),
      //     decoration: BoxDecoration(
      //         border: Border.all(width: 0, color: Colors.transparent),
      //         color: AppColors.white,
      //         borderRadius: BorderRadius.only(topRight: Radius.circular(70))),
      //     child: Center(
      //       child: AppText(
      //         text: "Something wrong",
      //       ),
      //     ),
      //   );
    // }
  }

  _buildProgress() {
    return Container(
            margin: EdgeInsets.symmetric(
                horizontal: Dimens.formPadding, vertical: Dimens.padding15),
            child: AppText(
              text: FlutterLocalizations.of(context).getString(
                  context, 'the_enest'),
              fontWeight: FontWeight.bold,
              color: AppColors.blue,
              textSize: Dimens.paragraphHeaderTextSize,
            ));
  }

  restartLevel() async {
    if (userController.user.value != null) {
      var data = {'scores.${widget.level}': FieldValue.delete()};

      userController.deleteDataScore(userController.user.value.uid, data);

      var questions = {'questions.${widget.level}': FieldValue.delete()};

      userController.deleteDataQuestion(
          userController.user.value.uid, questions);
    } else {
      final openBox = await Hive.openBox('Table_${widget.level}');
      openBox.deleteFromDisk();
      openBox.close();

      final openBoxScore = await Hive.openBox('Table_Score_${widget.level}');
      openBoxScore.deleteFromDisk();
      openBoxScore.close();
    }
  }

  getTrueScoreOfCate(int index) {
    double scoreTrue = Dimens.doubleValue0;
    Map scoreCate = new Map();
    if (mainController.scoreOfCate
        .containsKey('${widget.level}_$index')) {
      if (mainController.scoreOfCate['${widget.level}_$index'] != null ||
          mainController.scoreOfCate['${widget.level}_$index'] == '0_0') {
        scoreCate
            .addAll(mainController.scoreOfCate['${widget.level}_$index']);
        scoreCate.forEach((key, value) {
          List<String> split = value.toString().split('_');
          scoreTrue += double.tryParse(split[0]);
        });
      }
    }
    return scoreTrue;
  }

  getWrongScoreOfCate(int index) {
    double scoreWrong = Dimens.doubleValue0;
    Map scoreCate = new Map();
    if (mainController.scoreOfCate
        .containsKey('${widget.level}_$index')) {
      if (mainController.scoreOfCate['${widget.level}_$index'] != null ||
          mainController.scoreOfCate['${widget.level}_$index'] == '0_0') {
        scoreCate
            .addAll(mainController.scoreOfCate['${widget.level}_$index']);
        scoreCate.forEach((key, value) {
          List<String> split = value.toString().split('_');
          scoreWrong += double.tryParse(split[1])-double.tryParse(split[0]);
        });
      }
    }
    return scoreWrong;
  }

  getTestCompleted(int index) {
    int countTest = Dimens.intValue1;
    Map scoreCate = new Map();
    if (mainController.scoreOfCate
        .containsKey('${widget.level}_$index')) {
      if (mainController.scoreOfCate['${widget.level}_$index'] != null ||
          mainController.scoreOfCate['${widget.level}_$index'] == '0_0') {
        scoreCate
            .addAll(mainController.scoreOfCate['${widget.level}_$index']);
        scoreCate.forEach((key, value) {
          if (value != '0_0') countTest++;
        });
      }
    }
    return countTest;
  }

  modalBottomSheet(String cateName, int level, int categoryId) async {
    mainController.isGoToCheck.value=false;
    mainController.score.clear();
    if (userController.user.value != null && mainController.scoreOfCate.containsKey('$level' '_' '$categoryId') && mainController.scoreOfCate['$level' '_' '$categoryId'] != null) {
      mainController.score.assignAll(
          mainController.scoreOfCate['$level' '_' '$categoryId']);
    } else {
      final openBox = await Hive.openBox('Table_Score_${widget.level}');
      if (openBox.containsKey('$level' '_' '$categoryId') && openBox.get('$level' '_' '$categoryId') != null) {
        mainController.score.assignAll(openBox.get('$level' '_' '$categoryId'));
        openBox.close();
      } else {
        mainController.score.clear();
      }
    }
    await showModalBottomSheet(
        backgroundColor: AppColors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ModalBottomSheet(
            categoryName: cateName,
            level: level,
            categoryId: categoryId,
          );
        });
  }

  choiceAction(int choice) async {
    switch (choice) {
      case 1:
        if (userController.user.value != null) {
          List<dynamic> favorite=await userController.getDataFavorite(userController.user.value.uid);
          if(favorite.isNotEmpty){
            mainController.questionsHiveFavorite=  RxList<Question>(favorite.map((e) => Question.fromJson(e)).toList());
          }
        } else {
          bool exist = await HiveHelper.isExists(boxName: Constants.TABLE_FAVORITE_BOX_NAME);
          if (exist) {
            print('-----------------------------------------');
            mainController.questionsHiveFavorite =
                RxList<Question>(await HiveHelper.getBoxes(Constants.TABLE_FAVORITE_BOX_NAME));
          }
        }
        mainController.isGoToCheck.value=false;
        Get.to(
            QuestionScreen(
              question: mainController.questionsHiveFavorite,
              isFavorite: true,
            ),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: Dimens.durationMilliseconds500));
        return;
      case 2:
        Get.to(SettingScreen(),
            transition: Transition.rightToLeftWithFade,
            duration: Duration(milliseconds: Dimens.durationMilliseconds500));
        return;
    }
  }
}
