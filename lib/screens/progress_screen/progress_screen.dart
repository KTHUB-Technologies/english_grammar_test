import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/scale_transition.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/commons/slide_transition.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
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
          height: getScreenHeight(context)/Dimens.intValue4,
        ),
        Container(
          height: getScreenHeight(context)/Dimens.intValue4,
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
                    text: '${getLevel(widget.level)}',
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
                    return WidgetAnimatorSlideTransition(
                      CategoryCard(
                        totalQuestion: totalQuestion,
                        index: e,
                        level: widget.level,
                        category: e,
                        testCompleted: Rx<int>(getTestCompleted(e) ?? Dimens.initialValue0),
                        score: Rx<double>((getScoreOfCate(e) ?? Dimens.initialValue0)),
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
              border: Border.all(width: Dimens.borderWidth0, color: Colors.transparent),
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(Dimens.border70))),
          child: Center(
            child: AppText(
              text: FlutterLocalizations.of(context).getString(
                  context, 'coming_soon'),
            ),
          ),
        );
      default:
        return Container(
          height: getScreenHeight(context),
          width: getScreenWidth(context),
          decoration: BoxDecoration(
              border: Border.all(width: Dimens.borderWidth0, color: Colors.transparent),
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(Dimens.border70))),
          child: Center(
            child: AppText(
              text: FlutterLocalizations.of(context).getString(
                  context, 'something_wrong'),
            ),
          ),
        );
    }
  }

  _buildSectionTitle() {
    return ToggleButtons(
      children: mainController.sections
          .map((e) => Padding(
        padding: const EdgeInsets.all(Dimens.padding10),
        child: AppText(
          text: getSection(e),
          color: AppColors.white,
        ),
      ))
          .toList(),
      borderRadius: BorderRadius.circular(Dimens.border15),
      onPressed: (int index) {
        for (int buttonIndex = Dimens.initialValue0;
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
    double score = Dimens.doubleValue0;
    Map scoreCate = new Map();
    if (mainController.scoreOfCate
        .containsKey('${widget.level}_$index')) {
      if (mainController.scoreOfCate['${widget.level}_$index'] != null ||
          mainController.scoreOfCate['${widget.level}_$index'] == '0_0') {
        scoreCate
            .addAll(mainController.scoreOfCate['${widget.level}_$index']);
        scoreCate.forEach((key, value) {
          List<String> split = value.toString().split('_');
          score += double.tryParse(split[0]);
        });
      }
    }
    return score;
  }

  getTestCompleted(int index) {
    int countTest = Dimens.initialValue0;
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

  _buildProgress() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: Dimens.formPadding, vertical: Dimens.padding15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  text: FlutterLocalizations.of(context).getString(
                      context, 'delete_this_level'),
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
                  showConfirmDialog(context,title: FlutterLocalizations.of(context).getString(
                      context, 'waring'),
                    content:
                    FlutterLocalizations.of(context).getString(
                        context, 'ask_reset_level'), cancel: () {
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
