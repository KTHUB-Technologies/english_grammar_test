
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class CheckAnswerScreen extends StatefulWidget {
  final RxList<Question> question;

  const CheckAnswerScreen({Key key, this.question}) : super(key: key);
  @override
  _CheckAnswerScreenState createState() => _CheckAnswerScreenState();
}

class _CheckAnswerScreenState extends State<CheckAnswerScreen> {
  List<String> options=[];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text:'Check Answer'),
      ),
      body: ListView(
        children: widget.question.map((e){
          options=(e.options.split('///'));
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(text: e.task),
                  Dimens.height10,
                  e.checkedAnswer.value==e.correctAnswer?AppText(text: options[e.checkedAnswer.value],color: Colors.green,):AppText(text: options[e.checkedAnswer.value],color: Colors.red,),
                  Dimens.height10,
                  e.checkedAnswer.value==e.correctAnswer?SizedBox():AppText(text: 'Correct Answer: ${options[e.correctAnswer]}',color: Colors.green,),
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
                        text: e.explanation,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList()
      ),
    );
  }
}
