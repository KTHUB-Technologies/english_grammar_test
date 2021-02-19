import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/animted_list.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/category_card.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class ProgressScreen extends StatefulWidget {
  final int level;

  const ProgressScreen({Key key, this.level}) : super(key: key);
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final MainController mainController = Get.find();
  final UserController userController = Get.find();
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
                    text: '${getLevel(widget.level)} (Progress)',
                  ),
                ),
                _buildSectionTitle()
              ],
            ),
          ),
        ),
      ],
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
                        testCompleted: Rx<int>(getTestCompleted(e) ?? 0),
                        score: Rx<double>((getScoreOfCate(e) ?? 0)),
                        onTap: (){},
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

  _buildProgress() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: Dimens.formPadding, vertical: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  text: 'Delete All At This Level',
                  color: AppColors.red,
                  textSize: Dimens.paragraphHeaderTextSize,
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: AppColors.red,
                ),
                onTap: () {
                  showConfirmDialog(context,title: 'WARNING',
                    content:
                    "Do you want to reset all question in this level?", cancel: () {
                      Get.back();
                    },
                    confirm: () async {
                      Get.offAll(MainScreen());

                      await restartLevel();
                    },);
                },
              ),
            ],
          ),
        ),
      ],
    );
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
}
