import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class CheckAnswerScreen extends StatefulWidget {
  final RxList<Question> question;

  const CheckAnswerScreen({Key key, this.question}) : super(key: key);
  @override
  _CheckAnswerScreenState createState() => _CheckAnswerScreenState();
}

class _CheckAnswerScreenState extends State<CheckAnswerScreen> {
  List<String> options = [];
  Rx<int> index=Rx<int>(0);

  List<Widget> get listCheckedAnswer => widget.question.map((e){
    options=e.options.split('///');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppText(text: '${widget.question.indexOf(e)+1}. ${e.task}'),
            Dimens.height10,
            e.checkedAnswer.value == e.correctAnswer - 1
                ? AppText(
              text: options[e.checkedAnswer.value],
              color: Colors.green,
            )
                : AppText(
              text: options[e.checkedAnswer.value],
              color: Colors.red,
            ),
            Dimens.height10,
            e.checkedAnswer.value == e.correctAnswer - 1
                ? SizedBox()
                : AppText(
              text: 'Correct Answer: ${options[e.correctAnswer - 1]}',
              color: Colors.green,
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
                  text: e.explanation,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }).toList();

  @override
  void initState() {
    index.value=0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ListCheck(
        question: widget.question,
        index: index,
      ),
      appBar: AppBar(
        title: AppText(text: 'Check Answer'),
      ),
      body: Obx((){
        return listCheckedAnswer[index.value];
      }),
    );
  }
}

class ListCheck extends StatefulWidget {
  final RxList<Question> question;
  final Rx<int> index;

  const ListCheck({Key key, this.question,this.index}) : super(key: key);
  @override
  _ListCheckState createState() => _ListCheckState();
}

class _ListCheckState extends State<ListCheck> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        Container(
          color: Colors.blue,
          width: getScreenWidth(context),
          height: getScreenHeight(context)/8,
          child: DrawerHeader(
            child: Center(
              child: AppText(
                text: 'List Checked',
              ),
            ),
          ),
        ),
        Container(
          height: getScreenHeight(context)/5,
          color: Colors.red,
          child: ListView(
            padding: EdgeInsets.zero,
            children: widget.question.map((e) {
              return GestureDetector(
                child: Card(
                  child: ListTile(
                    title: AppText(
                      text: '${widget.question.indexOf(e)+1}. ${e.task}',
                    ),
                    trailing: e.checkedAnswer.value == e.correctAnswer - 1
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                  ),
                ),
                onTap: (){
                  Get.back();
                  widget.index.value=widget.question.indexOf(e);
                },
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}
