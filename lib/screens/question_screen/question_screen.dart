import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/ios_dialog.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/check_answer/check_answer_screen.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class QuestionScreen extends StatefulWidget {
  final int level;
  final int categoryId;
  final int testNumber;
  final RxList<Question> question;
  final bool isFavorite;
  final RxList<Question> questionTemp;

  const QuestionScreen(
      {Key key,
      this.level,
      this.categoryId,
      this.question,
      this.testNumber,
      this.isFavorite,
      this.questionTemp})
      : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final LevelController levelController = Get.find();
  Rx<int> countTrue = Rx<int>();

  List<Widget> get listQuestion => widget.question
      .map((question) => CardQuestion(
            question: question,
            countTrue: countTrue,
            listQuestions: widget.question,
            isFavorite: widget.isFavorite,
          ))
      .toList();

  @override
  void initState() {
    levelController.index.value = 0;
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
          text: widget.isFavorite == true
              ? "Favorite"
              : getCategory(widget.categoryId),
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: levelController.questionsFromHive.isNullOrBlank
              ? widget.isFavorite == false
                  ? () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return IOSDialog(
                              title: 'WARNING',
                              content:
                                  "If you exit now, your results will be cancel!!!",
                              cancel: () {
                                Get.back();
                              },
                              confirm: () {
                                Get.back();
                                Get.back();
                              },
                            );
                          });
                    }
                  : () {
                      Get.back();
                    }
              : () {
                  Get.back();
                },
        ),
        actions: <Widget>[
          levelController.questionsFromHive.isNotEmpty
              ? widget.isFavorite == false
                  ? IconButton(
                      icon: Icon(Icons.rotate_left),
                      onPressed: () async {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return IOSDialog(
                                title: 'WARNING',
                                content: "Do you want to restart your results?",
                                cancel: () {
                                  Get.back();
                                },
                                confirm: () async {
                                  Get.back();
                                  levelController.questionsFromHive.clear();
                                  final openBox = await Hive.openBox(
                                      'Table_${widget.level}');
                                  Map level =
                                      await openBox.get('${widget.categoryId}');
                                  level['${widget.testNumber}'] = null;
                                  await openBox.put(
                                      '${widget.categoryId}', level);

                                  Get.offAll(MainScreen());

                                  final openBoxScore = await Hive.openBox(
                                      'Table_Score_${widget.level}');
                                  Map score = openBoxScore.get(
                                      '${widget.level}_${widget.categoryId}');
                                  score['${widget.testNumber}'] = '0_0';
                                  await openBoxScore.put(
                                      '${widget.level}_${widget.categoryId}',
                                      score);
                                  levelController.score.value.clear();
                                  openBoxScore.close();
                                },
                              );
                            });
                      })
                  : SizedBox()
              : SizedBox(),
        ],
      ),
      body: Obx(() {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.question.length == levelController.index.value
                  ? widget.question.length != 0
                      ? widget.isFavorite == false
                          ? Center(
                              child: Column(
                                children: <Widget>[
                                  CircularPercentIndicator(
                                    radius: 120.0,
                                    lineWidth: 10.0,
                                    animation: true,
                                    animationDuration: 1200,
                                    percent: (countTrue.value /
                                        widget.question.length),
                                    header: AppText(
                                      text: 'Processing',
                                    ),
                                    center: Icon(
                                      Icons.person_pin,
                                      size: 50.0,
                                      color: Colors.blue,
                                    ),
                                    circularStrokeCap: CircularStrokeCap.butt,
                                    backgroundColor: Colors.grey,
                                    progressColor: Colors.green,
                                  ),
                                  AppText(
                                    text:
                                        'Score: ${countTrue.value}/${widget.question.length}',
                                  ),
                                  Dimens.height20,
                                  AppButton(
                                    'Check Answer',
                                    onTap: () async {
                                      SoundsHelper.checkAudio(Sounds.touch);
                                      Get.to(CheckAnswerScreen(
                                        question: widget.question,
                                      ));

                                      var listQuestions = widget.question
                                          .map((e) => e.toJson())
                                          .toList();
                                      final openBoxLevel = await Hive.openBox(
                                          'Table_${widget.level}');
                                      Map level = await openBoxLevel
                                          .get('${widget.categoryId}');
                                      if (level.isNullOrBlank) {
                                        level = {
                                          '${widget.testNumber}': listQuestions
                                        };
                                      } else {
                                        level['${widget.testNumber}'] =
                                            listQuestions;
                                      }
                                      await openBoxLevel.put(
                                          '${widget.categoryId}', level);
                                      openBoxLevel.close();

                                      final openBox = await Hive.openBox(
                                          'Table_Score_${widget.level}');
                                      Map score = await openBox.get(
                                          '${widget.level}_${widget.categoryId}');
                                      if (score.isNullOrBlank) {
                                        score = {
                                          '${widget.testNumber}':
                                              '${countTrue.value}_${widget.question.length}'
                                        };
                                      } else {
                                        score['${widget.testNumber}'] =
                                            '${countTrue.value}_${widget.question.length}';
                                      }
                                      await openBox.put(
                                          '${widget.level}_${widget.categoryId}',
                                          score);
                                      openBox.close();
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Center(
                            child: AppButton(
                                'PREVIOUS',
                                onTap: () async {
                                  SoundsHelper.checkAudio(Sounds.touch);
                                  levelController.index.value--;
                                },
                              ),
                          )
                      : Center(
                          child: AppText(
                            text: 'No Question...',
                          ),
                        )
                  : listQuestion[levelController.index.value],
            ],
          ),
        );
      }),
    );
  }
}

class CardQuestion extends StatefulWidget {
  const CardQuestion(
      {Key key,
      this.question,
      this.countTrue,
      this.listQuestions,
      this.isFavorite})
      : super(key: key);

  final Question question;
  final Rx<int> countTrue;
  final RxList<Question> listQuestions;
  final bool isFavorite;

  @override
  _CardQuestionState createState() => _CardQuestionState();
}

class _CardQuestionState extends State<CardQuestion> {
  final LevelController levelController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = [];
    RxList<Color> colorsI = RxList<Color>([]);
    RxList<Icon> iconsI = RxList<Icon>([]);
    options = widget.question.options.split('///');
    for (var i = 0; i < options.length; i++) {
      colorsI.add(AppColors.transparent);
      iconsI.add(Icon(null));
    }
    if (widget.isFavorite == true) {
      widget.question.currentChecked.value = widget.question.correctAnswer - 1;
      colorsI[widget.question.currentChecked.value] = AppColors.green;
      iconsI[widget.question.currentChecked.value] = Icon(
        Icons.check,
        color: AppColors.green,
      );
    } else {
      if (widget.question.currentChecked.value != null) {
        if (widget.question.currentChecked.value ==
            widget.question.correctAnswer - 1) {
          colorsI[widget.question.currentChecked.value] = AppColors.green;
          iconsI[widget.question.currentChecked.value] = Icon(
            Icons.check,
            color: AppColors.green,
          );
        } else {
          colorsI[widget.question.currentChecked.value] = AppColors.red;
          colorsI[widget.question.correctAnswer - 1] = AppColors.green;

          iconsI[widget.question.currentChecked.value] = Icon(
            Icons.clear,
            color: AppColors.red,
          );
          iconsI[widget.question.correctAnswer - 1] = Icon(
            Icons.check,
            color: AppColors.green,
          );
        }
      }
    }

    return Obx(() {
      levelController.containFromFavorite = RxList<Question>(levelController
          .questionsHiveFavorite
          .where((e) => e.id == widget.question.id)
          .toList());
      return Container(
        height: getScreenHeight(context) / 1.132,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AppText(
                            text:
                                '${levelController.index.value + 1}/${widget.listQuestions.length}'),
                        IconButton(icon: Obx(() {
                          return levelController.containFromFavorite.isNotEmpty
                              ? Icon(
                                  Icons.favorite,
                                  color: AppColors.red,
                                )
                              : Icon(Icons.favorite_border);
                        }), onPressed: () async {
                          if (levelController.containFromFavorite.isEmpty) {
                            List<Question> question = [];
                            question.add(widget.question);
                            var questions =
                                question.map((e) => e.toJson()).toList();
                            await HiveHelper.addBoxes(
                                questions, 'Table_Favorite');
                            levelController.questionsHiveFavorite
                                .add(widget.question);
                            levelController.containFromFavorite =
                                RxList<Question>(levelController
                                    .questionsHiveFavorite
                                    .where((e) => e.id == widget.question.id)
                                    .toList());
                          } else {
                            final openBox =
                                await Hive.openBox('Table_Favorite');
                            if (widget.isFavorite == true) {
                              openBox.deleteAt(widget.listQuestions
                                  .indexOf(widget.question));
                              widget.listQuestions.removeWhere((element) =>
                                  element.id == widget.question.id);
                            } else {
                              openBox.deleteAt(levelController
                                  .questionsHiveFavorite
                                  .indexWhere(
                                      (e) => e.id == widget.question.id));
                              levelController.questionsHiveFavorite.removeWhere(
                                  (e) => e.id == widget.question.id);
                              levelController.containFromFavorite =
                                  RxList<Question>(levelController
                                      .questionsHiveFavorite
                                      .where((e) => e.id == widget.question.id)
                                      .toList());
                            }
                          }
                        }),
                      ],
                    ),
                    AppText(
                      text: widget.question.task,
                      textSize: Dimens.paragraphHeaderTextSize,
                    ),
                    Dimens.height10,
                    Column(
                      children: options.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Obx(() {
                            return AbsorbPointer(
                              ignoringSemantics: true,
                              absorbing: widget.question.currentChecked.value
                                      .isNullOrBlank
                                  ? false
                                  : true,
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: colorsI[options.indexOf(e)],
                                    ),
                                  ),
                                  child: ListTile(
                                    title: AppText(
                                      text: e,
                                    ),
                                    trailing: iconsI[options.indexOf(e)],
                                  ),
                                ),
                                onTap: () async {
                                  widget.question.currentChecked.value =
                                      options.indexOf(e);
                                  if (widget.question.currentChecked.value ==
                                      widget.question.correctAnswer - 1) {
                                    SoundsHelper.checkAudio(Sounds.correct);
                                    colorsI[widget.question.currentChecked
                                        .value] = AppColors.green;
                                    iconsI[widget
                                        .question.currentChecked.value] = Icon(
                                      Icons.check,
                                      color: AppColors.green,
                                    );
                                  } else {
                                    SoundsHelper.checkAudio(Sounds.in_correct);
                                    colorsI[widget.question.currentChecked
                                        .value] = AppColors.red;
                                    colorsI[widget.question.correctAnswer - 1] =
                                        AppColors.green;

                                    iconsI[widget
                                        .question.currentChecked.value] = Icon(
                                      Icons.clear,
                                      color: AppColors.red,
                                    );
                                    iconsI[widget.question.correctAnswer - 1] =
                                        Icon(
                                      Icons.check,
                                      color: AppColors.green,
                                    );
                                  }
                                },
                              ),
                            );
                          }),
                        );
                      }).toList(),
                    ),
                    Dimens.height10,
                    widget.question.currentChecked.value.isNullOrBlank
                        ? SizedBox()
                        : Card(
                            child: ListTile(
                              title: AppText(
                                text: widget.question.explanation,
                              ),
                            ),
                          ),
                    Dimens.height10,
                  ],
                ),
              ),
            ),
            Container(
              child: levelController.index.value == widget.listQuestions.length
                  ? SizedBox()
                  : Column(
                      children: <Widget>[
                        levelController.index.value + 1 > 1
                            ? AppButton(
                                'PREVIOUS',
                                onTap: () async {
                                  SoundsHelper.checkAudio(Sounds.touch);
                                  levelController.index.value--;
                                },
                              )
                            : SizedBox(),
                        Dimens.height10,
                        widget.question.currentChecked.value != null
                            ? widget.listQuestions.length >
                                    (levelController.index.value + 1)
                                ? AppButton(
                                    'NEXT',
                                    onTap: () async {
                                      SoundsHelper.checkAudio(Sounds.touch);
                                      levelController.index.value++;
                                    },
                                  )
                                : levelController
                                        .questionsFromHive.isNullOrBlank
                                    ? widget.isFavorite == false
                                        ? AppButton(
                                            'SUBMIT',
                                            onTap: widget.isFavorite == false
                                                ? () async {
                                                    widget.countTrue.value = 0;
                                                    SoundsHelper.checkAudio(
                                                        Sounds.touch);
                                                    for (var checkTrue in widget
                                                        .listQuestions) {
                                                      if (checkTrue
                                                              .currentChecked
                                                              .value ==
                                                          checkTrue
                                                                  .correctAnswer -
                                                              1)
                                                        widget
                                                            .countTrue.value++;
                                                    }
                                                    levelController
                                                            .index.value =
                                                        widget.listQuestions
                                                            .length;
                                                  }
                                                : () {
                                                    Get.to(CheckAnswerScreen(
                                                      question:
                                                          widget.listQuestions,
                                                    ));
                                                  },
                                          )
                                        : SizedBox()
                                    : SizedBox()
                            : SizedBox(),
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}
