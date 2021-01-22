import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/ios_dialog.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/check_answer/check_answer_screen.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/screens/question_screen/card_question/card_question.dart';
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
  final MainController mainController = Get.find();
  Rx<int> countTrue = Rx<int>();

  List<Widget> get listQuestion => widget.question
      .map((question) => TranslationAnimatedWidget.tween(
            enabled: true,
            duration: Duration(milliseconds: 500),
            translationDisabled: Offset(0, -400),
            translationEnabled: Offset(0, 0),
            child: OpacityAnimatedWidget.tween(
              enabled: true,
              opacityDisabled: 0,
              opacityEnabled: 1,
              child: CardQuestion(
                question: question,
                countTrue: countTrue,
                listQuestions: widget.question,
                isFavorite: widget.isFavorite,
              ),
            ),
          ))
      .toList();

  @override
  void initState() {
    mainController.index.value = 0;
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
          // ignore: deprecated_member_use
          onPressed: mainController.questionsFromHive.isNullOrBlank
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
          mainController.questionsFromHive.isNotEmpty
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

                                  await deleteResult();
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
              widget.question.length == mainController.index.value
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

                                      await saveResult();
                                    },
                                  ),
                                ],
                              ),
                            )
                          : SizedBox()
                      : Center(
                          child: AppText(
                            text: 'No Question...',
                            color: AppColors.blue,
                          ),
                        )
                  : Expanded(child: listQuestion[mainController.index.value]),
            ],
          ),
        );
      }),
    );
  }

  saveResult()async{
    var listQuestions = widget.question
        .map((e) => e.toJson())
        .toList();
    final openBoxLevel = await Hive.openBox(
        'Table_${widget.level}');
    Map level = await openBoxLevel
        .get('${widget.categoryId}');
    // ignore: deprecated_member_use
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
    // ignore: deprecated_member_use
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
  }

  deleteResult() async{
    mainController.questionsFromHive.clear();
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
    mainController.score.value.clear();
    openBoxScore.close();
  }
}
