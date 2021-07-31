import 'dart:collection';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/backdrop_container.dart';
import 'package:the_enest_english_grammar_test/commons/ios_dialog.dart';
import 'package:the_enest_english_grammar_test/commons/slide_up_container.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/check_answer/check_answer_screen.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/screens/question_screen/card_question/card_question.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class QuestionScreen extends StatefulWidget {
  final int? level;
  final int? categoryId;
  final int? testNumber;
  final RxList<Question> question;
  final bool isFavorite;
  final RxList<Question?>? questionTemp;

  const QuestionScreen(
      {Key? key,
       this.level,
         this.categoryId,
        required this.question,
         this.testNumber,
        required this.isFavorite,
         this.questionTemp})
      : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  final MainController mainController = Get.find();
  final UserController userController = Get.find();
  AnimationController? _formController;
  Rx<int> countTrue = Rx<int>(0);
  ConfettiController? _controllerCenter;

  List<Widget> get listQuestion => widget.question
      .map((question) => TranslationAnimatedWidget.tween(
            enabled: true,
            duration: Duration(milliseconds: Dimens.durationMilliseconds500),
            translationDisabled: Offset(Dimens.offSet0, -Dimens.offSet400),
            translationEnabled: Offset(Dimens.offSet0, Dimens.offSet0),
            child: OpacityAnimatedWidget.tween(
              enabled: true,
              opacityDisabled: Dimens.opacityDisabled,
              opacityEnabled: Dimens.opacityEnabled,
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
    mainController.index.value = Dimens.initialValue0;
    mainController.currentTrue.value = Dimens.initialValue0;
    _formController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: Dimens.durationMilliseconds500));
    _controllerCenter = ConfettiController(
        duration: const Duration(seconds: Dimens.durationSeconds10));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        body: Container(
          width: getScreenWidth(context),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Images.quiz_bg), fit: BoxFit.fill)),
            child: Column(
              children: [
                Dimens.height20,
                _buildHeader(),
                _buildProgress(),
                Dimens.height10,
                _buildQuestion()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    return Obx((){
      return ListTile(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
            onPressed: mainController.questionsFromHive.isEmpty
                ? widget.isFavorite == false
                ? () {
              alertDialog(
                  context,
                  FlutterLocalizations.of(context)!
                      .getString(context, 'ask_cancel_result'), () {
                Get.close(Dimens.getBack2);
              });
            }
                : () {
              Get.back();
            }
                : () {
              Get.back();
            }),
        trailing: mainController.questionsFromHive.isNotEmpty
            ? widget.isFavorite == false
            ? IconButton(
            icon: Icon(
              Icons.rotate_left,
              color: AppColors.white,
            ),
            onPressed: () async {
              alertDialog(
                  context,
                  FlutterLocalizations.of(context)!.getString(
                      context, 'ask_restart_result'), () async {
                Get.back();

                await deleteResult();
              });
            })
            : SizedBox()
            : SizedBox(),
        title: AppText(
          text: widget.isFavorite == true
              ? FlutterLocalizations.of(context)!.getString(
              context, 'favorite')
              : getCategory(widget.categoryId!),
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          textSize: Dimens.paragraphHeaderTextSize,
        ),
      );
    });
  }

  _buildProgress() {
    return ListTile(
      title: Obx(() {
        return Align(
          alignment: Alignment.centerRight,
          child: Text.rich(
            TextSpan(
              text:
                  "${(widget.question.length < mainController.index.value + Dimens.intValue1) ? mainController.index.value : (mainController.index.value + Dimens.intValue1)}",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: AppColors.secondary),
              children: [
                TextSpan(
                  text: "/${widget.question.length}",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: AppColors.secondary),
                ),
              ],
            ),
          ),
        );
      }),
      subtitle: widget.isFavorite
          ? null
          : Obx(() => LinearPercentIndicator(
                width: getScreenWidth(context) / Dimens.linePercentIndicatorWidth,
                animation: true,
                lineHeight: Dimens.line13,
                animationDuration: Dimens.initialValue0,
                percent: ((mainController.currentTrue.value) /
                                widget.question.length)
                            .isInfinite ||
                        ((mainController.currentTrue.value) /
                                widget.question.length)
                            .isNaN
                    ? Dimens.zeroPercent
                    : ((mainController.currentTrue.value) /
                            widget.question.length)
                        .toDouble(),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: AppColors.blue,
              )),
    );
  }

  _buildQuestion() {
    return Expanded(
      child: SlideUpTransition(
        animationController: _formController!,
        child: BackdropContainer(
          child: Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: Dimens.padding5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.question.length == mainController.index.value
                      ? widget.question.length != Dimens.initialValue0
                          ? widget.isFavorite == false
                              ? _buildFinalResultContent()
                              : SizedBox()
                          : Center(
                              child: AppText(
                                text: FlutterLocalizations.of(context)!.getString(
                                    context, 'no_question'),
                                color: AppColors.blue,
                              ),
                            )
                      : Expanded(
                          child: listQuestion[mainController.index.value]),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  _buildFinalResultContent() {
    _controllerCenter!.play();
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerCenter!,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: const [
              AppColors.green,
              AppColors.blue,
              AppColors.pink,
              AppColors.orange,
              AppColors.purple
            ], // manually specify the colors to be used
          ),
        ),
        Center(
          child: Column(
            children: <Widget>[
              CircularPercentIndicator(
                radius: Dimens.radius150,
                lineWidth: Dimens.line13,
                animation: true,
                animationDuration: Dimens.duration1200,
                percent: (countTrue.value / widget.question.length),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppText(
                      text:
                          '${((countTrue.value / widget.question.length) * Dimens.intValue100).round()}%',
                      textSize: Dimens.paragraphHeaderTextSize,
                    ),
                    AppText(
                      text:
                          '${FlutterLocalizations.of(context)!.getString(
                              context, 'score')}: ${countTrue.value}/${widget.question.length}',
                      textSize: Dimens.errorTextSize,
                    ),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: AppColors.divider,
                progressColor: AppColors.green,
              ),
              Dimens.height20,
              AppButton(
                FlutterLocalizations.of(context)!.getString(
                    context, 'review'),
                widthButton: Dimens.widthValue150,
                onTap: () async {
                  SoundsHelper.checkAudio(Sounds.touch);
                  Get.off(CheckAnswerScreen(
                    question: widget.question,
                  ));

                  await saveResult();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  saveResult() async {
    var listQuestions = widget.question.map((e) => e.toJson()).toList();
    if (userController.user.value != null) {
      var score = {
        'scores.${widget.level}.${widget.level}_${widget.categoryId}.${widget.testNumber}':
            '${countTrue.value}_${widget.question.length}'
      };

      userController.updateDataScore(userController.user.value!.uid, score);

      var dataScore =
          await userController.getDataScore(userController.user.value!.uid);
      if (dataScore['${widget.level}'] != null)
        mainController.scoreOfCate.assignAll(dataScore['${widget.level}']);
      else
        mainController.scoreOfCate.clear();

      var question = {
        'questions.${widget.level}.${widget.categoryId}.${widget.testNumber}':
            listQuestions
      };

      userController.updateDataQuestion(
          userController.user.value!.uid, question);

      var dataQuestion =
          await userController.getDataQuestion(userController.user.value!.uid);
      if (dataQuestion != null) {
        if (dataQuestion['${widget.level}'] != null)
          mainController.allQuestionsFromFS.value =
              HashMap.from(dataQuestion['${widget.level}']);
        else
          mainController.allQuestionsFromFS.value = {};
      }
    } else {
      final openBoxLevel = await Hive.openBox('Table_${widget.level}');
      Map? level = await openBoxLevel.get('${widget.categoryId}');
      if (level == null) {
        level = {'${widget.testNumber}': listQuestions};
      } else {
        level['${widget.testNumber}'] = listQuestions;
      }
      await openBoxLevel.put('${widget.categoryId}', level);
      openBoxLevel.close();

      final openBox = await Hive.openBox('Table_Score_${widget.level}');
      Map? score = await openBox.get('${widget.level}_${widget.categoryId}');
      if (score == null) {
        score = {
          '${widget.testNumber}': '${countTrue.value}_${widget.question.length}'
        };
      } else {
        score['${widget.testNumber}'] =
            '${countTrue.value}_${widget.question.length}';
      }

      await openBox.put('${widget.level}_${widget.categoryId}', score);

      mainController.scoreOfCate.assignAll(openBox.toMap());
      openBox.close();
    }
  }

  deleteResult() async {
    mainController.index.value = Dimens.initialValue0;
    Get.close(Dimens.getBack2);
    mainController.questionsFromHive.clear();
    if (userController.user.value != null) {
      var data = {
        'scores.${widget.level}.${widget.level}_${widget.categoryId}.${widget.testNumber}':
            '0_0'
      };

      userController.deleteDataScore(userController.user.value!.uid, data);

      var dataScore =
          await userController.getDataScore(userController.user.value!.uid);
      if (dataScore['${widget.level}'] != null)
        mainController.scoreOfCate.assignAll(dataScore['${widget.level}']);
      else
        mainController.scoreOfCate.clear();

      var questions = {
        'questions.${widget.level}.${widget.categoryId}.${widget.testNumber}':
            FieldValue.delete()
      };

      userController.deleteDataQuestion(
          userController.user.value!.uid, questions);

      var dataQuestion =
          await userController.getDataQuestion(userController.user.value!.uid);
      if (dataQuestion != null) {
        if (dataQuestion['${widget.level}'] != null)
          mainController.allQuestionsFromFS.value =
              HashMap.from(dataQuestion['${widget.level}']);
        else
          mainController.allQuestionsFromFS.value = {};
      }
    } else {
      final openBox = await Hive.openBox('Table_${widget.level}');
      Map level = await openBox.get('${widget.categoryId}');
      level['${widget.testNumber}'] = null;
      await openBox.put('${widget.categoryId}', level);

      final openBoxScore = await Hive.openBox('Table_Score_${widget.level}');
      Map score = openBoxScore.get('${widget.level}_${widget.categoryId}');
      score['${widget.testNumber}'] = '0_0';
      await openBoxScore.put('${widget.level}_${widget.categoryId}', score);
      mainController.score.clear();

      mainController.scoreOfCate.assignAll(openBoxScore.toMap());
      openBoxScore.close();
    }
  }
}
