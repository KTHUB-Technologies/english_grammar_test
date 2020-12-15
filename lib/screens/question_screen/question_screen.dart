import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/check_answer/check_answer_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class QuestionScreen extends StatefulWidget {
  final int level;
  final int categoryId;

  const QuestionScreen({Key key, this.level, this.categoryId})
      : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final LevelController levelController = Get.find();
  final player = AudioPlayer();
  int countTrue;

  List<Widget> get listQuestion => levelController.questionsFromCategory
      .map((question) => CardQuestion(player: player, question: question))
      .toList();

  @override
  void initState() {
    levelController.index.value = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: '${widget.categoryId}',
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.white,
        ),
      ),
      body: Obx(() {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: levelController.questionsFromCategory.length ==
                        levelController.index.value
                    ? levelController.questionsFromCategory.length != 0
                        ? Center(
                            child: Column(
                              children: <Widget>[
                                AppText(
                                  text:
                                      'Score: $countTrue/${levelController.questionsFromCategory.length}',
                                ),
                                Dimens.height20,
                                AppButton(
                                  'Check Answer',
                                  onTap: () {
                                    player.play(Sounds.touch);
                                    Get.to(CheckAnswerScreen(
                                      question:
                                          levelController.questionsFromCategory,
                                    ));
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
              Container(
                child: levelController.index.value ==
                        levelController.questionsFromCategory.length
                    ? SizedBox()
                    : levelController.questionsFromCategory.length >
                            (levelController.index.value + 1)
                        ? AppButton(
                            'NEXT',
                            onTap: () {
                              player.play(Sounds.touch);
                              levelController.index.value++;
                            },
                          )
                        : Row(
                            children: <Widget>[
                              Expanded(
                                child: AppButton(
                                  'PREVIOUS',
                                  onTap: () {
                                    player.play(Sounds.touch);
                                    levelController.index.value--;
                                  },
                                ),
                              ),
                              Dimens.width10,
                              Expanded(
                                child: AppButton(
                                  'SUBMIT',
                                  onTap: () {
                                    countTrue = 0;
                                    player.play(Sounds.touch);
                                    for (var checkTrue in levelController
                                        .questionsFromCategory) {
                                      if (checkTrue.currentChecked.value ==
                                          checkTrue.correctAnswer - 1)
                                        countTrue++;
                                    }
                                    levelController.index.value =
                                        levelController
                                            .questionsFromCategory.length;
                                  },
                                ),
                              ),
                            ],
                          ),
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
  }) : super(key: key);

  final AudioPlayer player;
  final Question question;

  @override
  _CardQuestionState createState() => _CardQuestionState();
}

class _CardQuestionState extends State<CardQuestion> {
  bool isSelected = false;
  bool isShowAnswer;

  @override
  void initState() {
     isShowAnswer =false;
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
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: widget.question.currentChecked.value ==
                                  options.indexOf(e)
                              ? widget.question.currentChecked.value ==
                                      widget.question.isCorrectA.value
                                  ? AppColors.green
                                  : AppColors.red
                              : AppColors.black,

                          // color: widget.question.currentChecked.value != null
                          //     ? widget.question.currentChecked.value ==
                          //             options.indexOf(e)
                          //         ? widget.question.currentChecked.value ==
                          //                 widget.question.correctAnswer - 1
                          //             ? widget.question.isCorrectA.value != null
                          //                 ? widget.question.isCorrectA.value ==
                          //                         options.indexOf(e)
                          //                     ? widget.question.isCorrectA
                          //                                 .value ==
                          //                             widget.question
                          //                                     .correctAnswer -
                          //                                 1
                          //                         ? widget.question.isCorrectA
                          //                                     .value ==
                          //                                 widget.question
                          //                                         .correctAnswer -
                          //                                     1
                          //                             ? AppColors.green
                          //                             : AppColors.red
                          //                         : AppColors.green
                          //                     : AppColors.red
                          //                 : AppColors.green
                          //             : AppColors.red
                          //         : AppColors.green
                          //     : AppColors.transparent,
                        ),
                      ),
                      child: ListTile(
                        title: AppText(
                          text: e,
                        ),
                        // trailing: widget.question.currentChecked.value ==
                        //         options.indexOf(e)
                        //     ? widget.question.currentChecked.value ==
                        //             widget.question.correctAnswer - 1
                        //         ? widget.question.isCorrectA.value ==
                        //                 options.indexOf(e)
                        //             ? widget.question.isCorrectA.value ==
                        //                     widget.question.correctAnswer - 1
                        //                 ? Icon(
                        //                     Icons.check,
                        //                     color: Colors.green,
                        //                   )
                        //                 : Icon(
                        //                     Icons.clear,
                        //                     color: Colors.red,
                        //                   )
                        //             : SizedBox()
                        //         : Icon(
                        //             Icons.clear,
                        //             color: Colors.red,
                        //           )
                        //     : SizedBox(),
                      ),
                    ),
                    onTap: () {
                      widget.question.currentChecked.value = options.indexOf(e);
                      widget.question.isCorrectA.value =
                          widget.question.correctAnswer - 1;
                      if (widget.question.currentChecked.value ==
                          widget.question.correctAnswer - 1) {
                        widget.player.play(Sounds.correct);
                      } else {
                        widget.player.play(Sounds.in_correct);
                      }
                    },
                  ),
                );
              }).toList(),
            ),

            // Column(
            //   children: options.map((e) {
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 8.0),
            //       child: GestureDetector(
            //         child: Answer(
            //           question: widget.question,
            //           options: options,
            //           answer: e,
            //           player: widget.player,
            //         ),
            //         onTap: () {
            //           widget.question.currentChecked.value = options.indexOf(e);
            //           widget.question.isCorrectA.value =
            //               widget.question.correctAnswer - 1;
            //         },
            //       ),
            //     );
            //   }).toList(),
            // ),

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
      );
    });
  }
}

// class Answer extends StatefulWidget {
//   const Answer({
//     Key key,
//     this.question,
//     this.options,
//     this.player,
//     this.answer,
//   }) : super(key: key);
//
//   final Question question;
//   final List<String> options;
//   final AudioPlayer player;
//   final String answer;
//
//   @override
//   _AnswerState createState() => _AnswerState();
// }
//
// class _AnswerState extends State<Answer> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: widget.question.isCorrectA.value == widget.options.indexOf(widget.answer)
//                 ? widget.question.isCorrectA.value == widget.question.correctAnswer - 1
//                         ? AppColors.green
//                         : AppColors.red
//                 : AppColors.transparent,
//           ),
//         ),
//         child: ListTile(
//           title: AppText(
//             text: widget.answer,
//           ),
//           trailing: widget.question.isCorrectA.value == widget.options.indexOf(widget.answer)
//               ? widget.question.isCorrectA.value == widget.question.correctAnswer - 1
//                   ? Icon(
//                       Icons.check,
//                       color: Colors.green,
//                     )
//                   : Icon(
//                       Icons.clear,
//                       color: Colors.red,
//                     )
//               : SizedBox(),
//         ),
//       );
//     });
//   }
// }
