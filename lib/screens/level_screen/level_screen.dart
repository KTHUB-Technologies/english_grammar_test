import 'dart:ffi';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/assets/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/ios_dialog.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/screens/progress_screen/progress_screen.dart';
import 'package:the_enest_english_grammar_test/screens/question_screen/question_screen.dart';
import 'package:the_enest_english_grammar_test/screens/splash/splash_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class LevelScreen extends StatefulWidget {
  final int level;
  final bool isProgress;
  const LevelScreen({Key key, this.level, this.isProgress}) : super(key: key);
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final LevelController levelController = Get.find();
  final player = AudioCache();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text:
              widget.isProgress == false ? getLevel(widget.level) : 'PROGRESS',
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.white,
        ),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: choiceAction,
              itemBuilder: (context) {
                return Constants.choices.map((e) {
                  return PopupMenuItem(
                    value: e,
                    child: ListTile(
                      title: AppText(
                        text: e,
                      ),
                    ),
                  );
                }).toList();
              }),
        ],
      ),
      body: Obx(() {
        return LoadingContainer(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                TabBar(
                  labelColor: AppColors.black,
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 3.0, color: AppColors.blue),
                    ),
                  ),
                  tabs: [
                    Tab(
                      text: 'TOPIC',
                    ),
                    Tab(
                      text: 'MIXED',
                    ),
                  ],
                ),
                Dimens.height10,
                Expanded(
                  child: TabBarView(children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          widget.isProgress == false
                              ? SizedBox()
                              : AppText(text: getLevel(widget.level)),
                          Expanded(
                            child: ListView(
                              children:
                                  levelController.distinctCategory.map((e) {
                                return FutureBuilder(
                                    future: getScoreOfCate(e),
                                    builder: (context, snapshot) {
                                      return buildListCategories(context, e,
                                          () async {
                                        await levelController
                                            .loadQuestionFromLevelAndCategory(
                                                widget.level, e);
                                        modalBottomSheet(
                                            getCategory(e), widget.level, e);
                                      }, snapshot.data);
                                    });
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppText(text: 'Test'),
                  ]),
                ),
              ],
            ),
          ),
          isLoading: levelController.isShowLoading.value,
        );
      }),
    );
  }

  Widget buildListCategories(BuildContext context, int index, Function onTap, double score) {
    return GestureDetector(
      child: Card(
        child: Container(
          height: getScreenHeight(context) / 15,
          padding: EdgeInsets.symmetric(horizontal: Dimens.formPadding),
          child: Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  text: getCategory(index),
                  color: AppColors.clickableText,
                ),
              ),
              Dimens.width20,
              AppText(
                text:
                    'Score: ${score == null || score.toString() == 'NaN' ? 0 : score.round()}%',
                color: AppColors.clickableText,
              ),
              Dimens.width20,
              widget.isProgress == false
                  ? SizedBox()
                  : GestureDetector(
                      child: Icon(Icons.rotate_left),
                      onTap: () {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return IOSDialog(
                                title: 'WARNING',
                                content: "Do you want to restart ${widget.level}_$index?",
                                cancel: () {
                                  Get.back();
                                },
                                confirm: () async {
                                  // final openBox= await Hive.openBox('Table_${widget.level}_${widget.categoryId}_${widget.testNumber}');
                                },
                              );
                            });
                      },
                    ),
            ],
          ),
        ),
      ),
      onTap: () async {
        player.play(Sounds.touch);
        onTap();
      },
    );
  }

  getScoreOfCate(int index) async {
    double score = 0;
    Map scoreCate = new Map();
    final openBox = await Hive.openBox('Table_Score');
    if (openBox.get('${widget.level}_$index') != null) {
      scoreCate.addAll(openBox.get('${widget.level}_$index'));
      scoreCate.forEach((key, value) {
        List<String> split = value.toString().split('_');
        score += (double.tryParse(split[0]) / double.tryParse(split[1])) * 100;
      });
      return score / scoreCate.length;
    }
  }

  modalBottomSheet(String cateName, int level, int categoryId) async {
    levelController.score.value.clear();
    final openBox = await Hive.openBox('Table_Score');
    if (openBox.containsKey('$level' '_' '$categoryId')) {
      levelController.score.value
          .addAll(openBox.get('$level' '_' '$categoryId'));
    } else {
      levelController.score.value.clear();
    }
    showModalBottomSheet(
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
    if (choice == 'Favorite') {
      bool exist = await HiveHelper.isExists(boxName: 'Table_Favorite');
      if (exist) {
        print('-----------------------------------------');
        levelController.questionsHiveFavorite =
            RxList<Question>(await HiveHelper.getBoxes('Table_Favorite'));
      }
      Get.to(QuestionScreen(
        question: levelController.questionsHiveFavorite,
        isFavorite: true,
      ));
    } else if (choice == 'Progress') {
      Get.back();
      Get.to(LevelScreen(
        level: widget.level,
        isProgress: true,
      ));
    }
  }
}

class ModalBottomSheet extends StatefulWidget {
  final int level;
  final int categoryId;
  final String categoryName;

  const ModalBottomSheet(
      {Key key, this.level, this.categoryId, this.categoryName})
      : super(key: key);
  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final LevelController levelController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppText(
              text: widget.categoryName,
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
              textSize: Dimens.paragraphHeaderTextSize,
            ),
            Dimens.height10,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: levelController.listChunkQuestions.map((e) {
                double scorePercent;
                if (levelController.score.value[
                        '${levelController.listChunkQuestions.indexOf(e) + 1}'] !=
                    null) {
                  List<String> splitScore =
                      '${levelController.score.value['${levelController.listChunkQuestions.indexOf(e) + 1}']}'
                          .split('_');
                  scorePercent = (double.tryParse(splitScore[0]) /
                          double.tryParse(splitScore[1])) *
                      100;
                }
                return GestureDetector(
                  child: Card(
                    child: ListTile(
                      title: AppText(
                        text:
                            'Test ${levelController.listChunkQuestions.indexOf(e) + 1}',
                      ),
                      trailing: AppText(
                          text:
                              'Score: ${scorePercent == null || scorePercent.isNaN ? 0 : scorePercent.round()} %'),
                    ),
                  ),
                  onTap: () async {
                    Get.back();
                    levelController.questionsHiveFavorite = RxList<Question>(
                        await HiveHelper.getBoxes('Table_Favorite'));
                    await checkExistTable(
                        levelController.listChunkQuestions.indexOf(e) + 1);
                    Get.to(QuestionScreen(
                      level: widget.level,
                      categoryId: widget.categoryId,
                      question: levelController.questionsFromHive.isNullOrBlank
                          ? RxList<Question>(e)
                          : levelController.questionsFromHive,
                      testNumber:
                          levelController.listChunkQuestions.indexOf(e) + 1,
                      isFavorite: false,
                      questionTemp: RxList<Question>(e),
                    ));
                  },
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  checkExistTable(int testNumber) async {
    bool exist = await HiveHelper.isExists(
        boxName: 'Table_${widget.level}_${widget.categoryId}_$testNumber');
    if (exist) {
      print('-----------------------------------------');
      levelController.questionsFromHive = RxList<Question>(
          await HiveHelper.getBoxes(
              'Table_${widget.level}_${widget.categoryId}_$testNumber'));
    } else {
      levelController.questionsFromHive.clear();
    }
  }
}
