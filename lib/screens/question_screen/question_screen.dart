import 'package:animated_widgets/animated_widgets.dart';
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
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/check_answer/check_answer_screen.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/screens/question_screen/card_question/card_question.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';
import 'package:websafe_svg/websafe_svg.dart';

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

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  final MainController mainController = Get.find();
  AnimationController _formController;
  Rx<int> countTrue = Rx<int>();
  ConfettiController _controllerCenter;
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
    mainController.currentTrue.value = 0;
    _formController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebsafeSvg.asset(Images.quiz_bg, fit: BoxFit.fill),
          Container(
            child: Column(
              children: [
                Dimens.height30,
                _buildHeader(),
                _buildProgress(),
                Dimens.height30,
                _buildQuestion()
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return ListTile(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
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
                }),

      trailing: mainController.questionsFromHive.isNotEmpty
          ? widget.isFavorite == false
              ? IconButton(
                  icon: Icon(
                    Icons.rotate_left,
                    color: AppColors.white,
                  ),
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
      title: AppText(
        text: widget.isFavorite == true
            ? "Favorite"
            : getCategory(widget.categoryId),
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        textSize: Dimens.paragraphHeaderTextSize,
      ),
    );
  }

  _buildProgress() {
    return ListTile(
      title: Obx(() => Text.rich(
            TextSpan(
              text: "Question ${mainController.index.value + 1}",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: AppColors.secondary),
              children: [
                TextSpan(
                  text: "/${widget.question.length}",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: AppColors.secondary),
                ),
              ],
            ),
          )),
      subtitle: widget.isFavorite
          ? null
          : Obx(() => LinearPercentIndicator(
        width: getScreenWidth(context)/1.1,
        animation: true,
        lineHeight: 20.0,
        animationDuration: 0,
        percent: ((mainController.currentTrue.value) /
            widget.question.length)
            .toDouble(),
        center: AppText(
            text:
            "${(((mainController.currentTrue.value) / widget.question.length) * 100).round()}%"),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.greenAccent,
      )),
    );
  }

  _buildQuestion() {
    return Expanded(
      child: SlideUpTransition(
        animationController: _formController,
        child: BackdropContainer(
          child: Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.question.length == mainController.index.value
                      ? widget.question.length != 0
                          ? widget.isFavorite == false
                              ? _buildFinalResultContent()
                              : SizedBox()
                          : Center(
                              child: AppText(
                                text: 'No Question...',
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
  _buildFinalResultContent(){
    _controllerCenter.play();
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
            true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
          ),
        ),
        Center(
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
                circularStrokeCap:
                CircularStrokeCap.butt,
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
        ),
      ],
    );
  }

  saveResult() async {
    var listQuestions = widget.question.map((e) => e.toJson()).toList();
    final openBoxLevel = await Hive.openBox('Table_${widget.level}');
    Map level = await openBoxLevel.get('${widget.categoryId}');
    // ignore: deprecated_member_use
    if (level.isNullOrBlank) {
      level = {'${widget.testNumber}': listQuestions};
    } else {
      level['${widget.testNumber}'] = listQuestions;
    }
    await openBoxLevel.put('${widget.categoryId}', level);
    openBoxLevel.close();

    final openBox = await Hive.openBox('Table_Score_${widget.level}');
    Map score = await openBox.get('${widget.level}_${widget.categoryId}');
    // ignore: deprecated_member_use
    if (score.isNullOrBlank) {
      score = {
        '${widget.testNumber}': '${countTrue.value}_${widget.question.length}'
      };
    } else {
      score['${widget.testNumber}'] =
          '${countTrue.value}_${widget.question.length}';
    }
    await openBox.put('${widget.level}_${widget.categoryId}', score);
    openBox.close();
  }

  deleteResult() async {
    mainController.questionsFromHive.clear();
    final openBox = await Hive.openBox('Table_${widget.level}');
    Map level = await openBox.get('${widget.categoryId}');
    level['${widget.testNumber}'] = null;
    await openBox.put('${widget.categoryId}', level);

    Get.offAll(MainScreen());

    final openBoxScore = await Hive.openBox('Table_Score_${widget.level}');
    Map score = openBoxScore.get('${widget.level}_${widget.categoryId}');
    score['${widget.testNumber}'] = '0_0';
    await openBoxScore.put('${widget.level}_${widget.categoryId}', score);
    mainController.score.value.clear();
    openBoxScore.close();
  }
}
