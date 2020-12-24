import 'dart:ffi';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/assets/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/screens/question_screen/question_screen.dart';
import 'package:the_enest_english_grammar_test/screens/splash/splash_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class LevelScreen extends StatefulWidget {
  final int level;

  const LevelScreen({Key key, this.level}) : super(key: key);
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final LevelController levelController = Get.find();
  final player = AudioCache();

  @override
  void initState() {
    loadScore();
    super.initState();
  }

  loadScore() async{
    final openBox=await Hive.openBox('Table_Score');
    int length = openBox.length;
    for (int i = 0; i < length; i++) {
      levelController.score.value.addAll(openBox.getAt(i));
    }
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
          text: getLevel(widget.level),
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
                      child: ListView(
                        children: levelController.distinctCategory.map((e) {
                          return buildListCategories(
                            context,
                            e,
                            '',
                            () async {
                              await levelController
                                  .loadQuestionFromLevelAndCategory(
                                      widget.level, e);
                              modalBottomSheet(getCategory(e), widget.level, e);
                            },
                          );
                        }).toList(),
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

  Widget buildListCategories(
      BuildContext context, int index, String nameCategory, Function onTap) {
    return GestureDetector(
      child: Card(
        child: Container(
          height: getScreenHeight(context) / 15,
          child: Row(
            children: <Widget>[
              Dimens.width20,
              AppText(
                text: getCategory(index),
                color: AppColors.clickableText,
              ),
              Dimens.width20,
              AppText(
                text: nameCategory,
                color: AppColors.clickableText,
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

  modalBottomSheet(String cateName, int level, int categoryId) async {
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
  Box<dynamic> openBox;

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
              children: levelController.listChunkQuestions
                  .map((e) {
                    String score ='${levelController.score.value['${widget.level}_${widget.categoryId}_${levelController.listChunkQuestions.indexOf(e) + 1}']??''}';
                    List<String> splitScore=score.split('_');
                    print(splitScore);
                    return GestureDetector(
                      child: Card(
                        child: ListTile(
                          title: AppText(
                            text:
                            'Test ${levelController.listChunkQuestions.indexOf(e) + 1}',
                          ),
                          trailing: AppText(text: 'Score: ${levelController.score.value['${widget.level}_${widget.categoryId}_${levelController.listChunkQuestions.indexOf(e) + 1}']??0}'),
                        ),
                      ),
                      onTap: () async {
                        Get.back();
                        levelController.questionsHiveFavorite =
                            RxList<Question>(
                                await HiveHelper.getBoxes('Table_Favorite'));
                        await checkExistTable(
                            levelController.listChunkQuestions.indexOf(e) +
                                1);
                        Get.to(QuestionScreen(
                          level: widget.level,
                          categoryId: widget.categoryId,
                          question:
                          levelController.questionsFromHive.isNullOrBlank
                              ? RxList<Question>(e)
                              : levelController.questionsFromHive,
                          testNumber:
                          levelController.listChunkQuestions.indexOf(e) +
                              1,
                          isFavorite: false,
                          questionTemp: RxList<Question>(e),
                        ));
                      },
                    );
              })
                  .toList(),
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
