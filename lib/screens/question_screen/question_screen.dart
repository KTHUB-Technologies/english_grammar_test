import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/assets/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/ios_dialog.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/screens/check_answer/check_answer_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class QuestionScreen extends StatefulWidget {
  final int level;
  final int categoryId;
  final int testNumber;
  final RxList<Question> question;

  const QuestionScreen(
      {Key key, this.level, this.categoryId, this.question, this.testNumber})
      : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final LevelController levelController = Get.find();
  final player = AudioCache();
  Rx<int> countTrue = Rx<int>();

  List<Widget> get listQuestion => widget.question
      .map((question) => CardQuestion(
            player: player,
            question: question,
            countTrue: countTrue,
            listQuestions: widget.question,
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
          text: '${widget.level}',
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return IOSDialog(
                    title: 'WARNING',
                    content: "If you exit now, your results will be cancel!!!",
                    cancel: () {
                      Get.back();
                    },
                    confirm: () {
                      Get.back();
                      Get.back();
                    },
                  );
                });
          },
        ),
      ),
      body: Obx(() {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: widget.question.length == levelController.index.value
                    ? widget.question.length != 0
                        ? Center(
                            child: Column(
                              children: <Widget>[
                                AppText(
                                  text:
                                      'Score: ${countTrue.value}/${widget.question.length}',
                                ),
                                Dimens.height20,
                                AppButton(
                                  'Check Answer',
                                  onTap: () async {
                                    player.play(Sounds.touch);
                                    Get.to(CheckAnswerScreen(
                                      question: widget.question,
                                    ));
                                    bool exist = await HiveHelper.isExists(
                                        boxName:
                                            'Table_${widget.level}_${widget.categoryId}_${widget.testNumber}');
                                    if (!exist) {
                                      var listQuestions = widget.question
                                          .map((e) => e.toJson())
                                          .toList();
                                      await HiveHelper.addBoxes(listQuestions,
                                          'Table_${widget.level}_${widget.categoryId}_${widget.testNumber}');
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: AppText(
                              text: 'No Question...',
                            ),
                          )
                    : listQuestion[levelController.index.value],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class CardQuestion extends StatefulWidget {
  const CardQuestion({
    Key key,
    this.player,
    this.question,
    this.countTrue,
    this.listQuestions,
  }) : super(key: key);

  final AudioCache player;
  final Question question;
  final Rx<int> countTrue;
  final RxList<Question> listQuestions;

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
    options = widget.question.options.split('///');
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            AppText(
              text: widget.question.task,
              textSize: Dimens.paragraphHeaderTextSize,
            ),
            Dimens.height10,
            Column(
              children: options.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AbsorbPointer(
                    ignoringSemantics: true,
                    absorbing:
                        widget.question.currentChecked.value.isNullOrBlank
                            ? false
                            : true,
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: widget.question.currentChecked.value ==
                                    options.indexOf(e)
                                ? widget.question.currentChecked.value ==
                                        widget.question.correctAnswer - 1
                                    ? AppColors.green
                                    : AppColors.red
                                : AppColors.transparent,
                          ),
                        ),
                        child: ListTile(
                          title: AppText(
                            text: e,
                          ),
                          trailing: widget.question.currentChecked.value ==
                                  options.indexOf(e)
                              ? widget.question.currentChecked.value ==
                                      widget.question.correctAnswer - 1
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    )
                              : SizedBox(),
                        ),
                      ),
                      onTap: () {
                        widget.question.currentChecked.value =
                            options.indexOf(e);
                        if (widget.question.currentChecked.value ==
                            widget.question.correctAnswer - 1) {
                          widget.player.play(Sounds.correct);
                        } else {
                          widget.player.play(Sounds.in_correct);
                        }
                      },
                    ),
                  ),
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
            Container(
              child: levelController.index.value == widget.listQuestions.length
                  ? SizedBox()
                  : widget.listQuestions.length >
                          (levelController.index.value + 1)
                      ? widget.question.currentChecked.value != null
                          ? AppButton(
                              'NEXT',
                              onTap: () {
                                widget.player.play(Sounds.touch);
                                levelController.index.value++;
                              },
                            )
                          : SizedBox()
                      : Column(
                          children: <Widget>[
                            AppButton(
                              'PREVIOUS',
                              onTap: () {
                                widget.player.play(Sounds.touch);
                                levelController.index.value--;
                              },
                            ),
                            Dimens.height10,
                            widget.question.currentChecked.value != null
                                ? AppButton(
                                    'SUBMIT',
                                    onTap: () {
                                      widget.countTrue.value = 0;
                                      widget.player.play(Sounds.touch);
                                      for (var checkTrue
                                          in widget.listQuestions) {
                                        if (checkTrue.currentChecked.value ==
                                            checkTrue.correctAnswer - 1)
                                          widget.countTrue.value++;
                                      }
                                      levelController.index.value =
                                          widget.listQuestions.length;
                                    },
                                  )
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
