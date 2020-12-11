
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/screens/check_answer/check_answer_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class QuestionScreen extends StatefulWidget {
  final int level;
  final int categoryId;

  const QuestionScreen({Key key, this.level, this.categoryId}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final LevelController levelController = Get.find();
  int countTrue;

  List<Widget> get listQuestion => levelController.questionsFromCategory.map((question) => buildCardQuestion(question)).toList();


  @override
  void initState() {
    levelController.index.value=0;
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
      body: Obx((){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: levelController.questionsFromCategory.length==levelController.index.value?
                levelController.questionsFromCategory.length!=0?Center(
                  child: Column(
                    children: <Widget>[
                      AppText(
                        text: 'Score: $countTrue/${levelController.questionsFromCategory.length}',
                      ),
                      Dimens.height20,
                      AppButton('Check Answer',onTap: (){
                        Get.to(CheckAnswerScreen(question: levelController.questionsFromCategory,));
                      },),
                    ],
                  ),
                ):Center(
                  child: AppText(text: 'No Question...',),
                ):listQuestion[levelController.index.value],
              ),
              Container(
                child: levelController.index.value==levelController.questionsFromCategory.length?SizedBox():levelController.questionsFromCategory.length>(levelController.index.value+1)?AppButton(
                  '>',
                  onTap: () {
                    levelController.index.value++;
                  },
                ):AppButton(
                  'SUBMIT',
                  onTap: () {
                    countTrue = 0;
                    for (var checkTrue in levelController.questionsFromCategory) {
                      if (checkTrue.checkedAnswer.value ==
                          checkTrue.correctAnswer) countTrue++;
                    }
                    levelController.index.value=levelController.questionsFromCategory.length;
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildCardQuestion(Question question) {
    List<String> options=[];
    options=question.options.split('///');
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          AppText(
            text: question.task,
            textSize: Dimens.paragraphHeaderTextSize,
          ),
          Dimens.height10,
          Column(
            children: options.map((e){
              return GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: question.checkedAnswer.value == options.indexOf(e)
                          ? AppColors.primary
                          : AppColors.transparent,
                    ),
                  ),
                  child: ListTile(
                    title: AppText(
                      text: e,
                    ),
                    trailing: question.checkedAnswer.value == options.indexOf(e)
                        ? question.checkedAnswer.value ==
                        question.correctAnswer
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
                  question.checkedAnswer.value=options.indexOf(e);
                },
              );
            }).toList(),
          ),
          Dimens.height10,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.red,
              ),
            ),
            child: ListTile(
              title: AppText(
                text: question.explanation,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
