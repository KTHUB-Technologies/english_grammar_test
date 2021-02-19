import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/animted_list.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/ios_dialog.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/category_card.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
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
    mainController.scoreOfCate.value.clear();
    mainController.allQuestionsFromFS.value.clear();
    if (userController.user.value != null) {
      Map data =
          await userController.getDataScore(userController.user.value.uid);
      Map question =
          await userController.getDataQuestion(userController.user.value.uid);

      await userController.getDataFavorite(userController.user.value.uid);

      if (data.isNotEmpty) {
        if (data['${widget.level}'] != null)
          mainController.scoreOfCate.value = data['${widget.level}'];
        else
          mainController.scoreOfCate.value = {};
      }

      if (question.isNotEmpty) {
        if (question['${widget.level}'] != null)
          mainController.allQuestionsFromFS.value =
              HashMap.from(question['${widget.level}']);
        else
          mainController.allQuestionsFromFS.value = {};
      }
    } else {
      final openBox = await Hive.openBox('Table_Score_${widget.level}');
      mainController.scoreOfCate.value = openBox.toMap();
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
                        border: Border.all(width: 0, color: Colors.transparent),
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
          height: getScreenHeight(context) / 4,
        ),
        Container(
          height: getScreenHeight(context) / 4,
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.transparent),
              gradient: LinearGradient(colors: AppColors.gradientColorPrimary),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70))),
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
                      elevation: 20,
                      icon: Icon(Icons.menu,color: AppColors.white,),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onSelected: choiceAction,
                      itemBuilder: (context) {
                        return Constants.choices.map((e) {
                          return PopupMenuItem(
                            value: e,
                            child: ListTile(
                              title: AppText(
                                text: e,
                                color: AppColors.orangeAccent,
                              ),
                            ),
                          );
                        }).toList();
                      }),
                ),
                _buildSectionTitle()
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildSectionTitle() {
    return ToggleButtons(
      children: mainController.sections
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppText(
                  text: getSection(e),
                  color: AppColors.white,
                ),
              ))
          .toList(),
      borderRadius: BorderRadius.circular(15),
      onPressed: (int index) {
        for (int buttonIndex = 0;
            buttonIndex < mainController.selected.length;
            buttonIndex++) {
          if (buttonIndex == index) {
            mainController.selected[buttonIndex] = true;
          } else {
            mainController.selected[buttonIndex] = false;
          }
        }
        mainController.sectionSelected.value = index;
      },
      isSelected: mainController.selected,
    );
  }

  _buildCategoryContent(int sectionSelected) {
    switch (sectionSelected) {
      case 0:
        return Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.transparent),
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(70))),
          child: Column(
            children: [
              SizedBox(
                child: _buildProgress(),
                height: 54,
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
                    return WidgetAnimator(
                      CategoryCard(
                        totalQuestion: totalQuestion,
                        index: e,
                        level: widget.level,
                        category: e,
                        onTap: () async {
                                await mainController
                                    .loadQuestionFromLevelAndCategory(
                                        widget.level, e);

                                modalBottomSheet(
                                    getCategory(e), widget.level, e);
                              },
                        testCompleted: Rx<int>(getTestCompleted(e) ?? 0),
                        score: Rx<double>((getScoreOfCate(e) ?? 0)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      case 1:
        return Container(
          height: getScreenHeight(context),
          width: getScreenWidth(context),
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.transparent),
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(70))),
          child: Center(
            child: AppText(
              text: "COMING SOON",
            ),
          ),
        );
      default:
        return Container(
          height: getScreenHeight(context),
          width: getScreenWidth(context),
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.transparent),
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(70))),
          child: Center(
            child: AppText(
              text: "Something wrong",
            ),
          ),
        );
    }
  }

  _buildProgress() {
    return Container(
            margin: EdgeInsets.symmetric(
                horizontal: Dimens.formPadding, vertical: 15),
            child: AppText(
              text: '#The Enest Language Center',
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

  getScoreOfCate(int index) {
    double score = 0;
    Map scoreCate = new Map();
    if (mainController.scoreOfCate.value
        .containsKey('${widget.level}_$index')) {
      if (mainController.scoreOfCate.value['${widget.level}_$index'] != null ||
          mainController.scoreOfCate.value['${widget.level}_$index'] == '0_0') {
        scoreCate
            .addAll(mainController.scoreOfCate.value['${widget.level}_$index']);
        scoreCate.forEach((key, value) {
          List<String> split = value.toString().split('_');
          score += double.tryParse(split[0]);
        });
      }
    }
    return score;
  }

  getTestCompleted(int index) {
    int countTest = 0;
    Map scoreCate = new Map();
    if (mainController.scoreOfCate.value
        .containsKey('${widget.level}_$index')) {
      if (mainController.scoreOfCate.value['${widget.level}_$index'] != null ||
          mainController.scoreOfCate.value['${widget.level}_$index'] == '0_0') {
        scoreCate
            .addAll(mainController.scoreOfCate.value['${widget.level}_$index']);
        scoreCate.forEach((key, value) {
          if (value != '0_0') countTest++;
        });
      }
    }
    return countTest;
  }

  modalBottomSheet(String cateName, int level, int categoryId) async {
    mainController.score.value.clear();
    if (userController.user.value != null) {
      if (mainController.scoreOfCate.value
          .containsKey('$level' '_' '$categoryId')) {
        if (mainController.scoreOfCate.value['$level' '_' '$categoryId'] !=
            null) {
          mainController.score.value.addAll(
              mainController.scoreOfCate.value['$level' '_' '$categoryId']);
        } else {
          mainController.score.value.clear();
        }
      } else {
        mainController.score.value.clear();
      }
    } else {
      final openBox = await Hive.openBox('Table_Score_${widget.level}');
      if (openBox.containsKey('$level' '_' '$categoryId')) {
        if (openBox.get('$level' '_' '$categoryId') != null) {
          mainController.score.value
              .addAll(openBox.get('$level' '_' '$categoryId'));
        } else {
          mainController.score.value.clear();
        }
      } else {
        mainController.score.value.clear();
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

  choiceAction(String choice) async {
    switch (choice) {
      case 'Favorite':
        if (userController.user.value != null) {
          List<dynamic> favorite=await userController.getDataFavorite(userController.user.value.uid);
          if(favorite.isNotEmpty){
            mainController.questionsHiveFavorite=  RxList<Question>(favorite.map((e) => Question.fromJson(e)).toList());
          }
        } else {
          bool exist = await HiveHelper.isExists(boxName: 'Table_Favorite');
          if (exist) {
            print('-----------------------------------------');
            mainController.questionsHiveFavorite =
                RxList<Question>(await HiveHelper.getBoxes('Table_Favorite'));
          }
        }
        Get.to(
            QuestionScreen(
              question: mainController.questionsHiveFavorite,
              isFavorite: true,
            ),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 500));
        return;
      case 'Progress':
          Get.to(
              ProgressScreen(
                level: widget.level,
              ),
              transition: Transition.rightToLeftWithFade,
              duration: Duration(milliseconds: 500));
        return;
      case 'Settings':
        Get.to(SettingScreen(),
            transition: Transition.rightToLeftWithFade,
            duration: Duration(milliseconds: 500));
        return;
    }
  }
}
