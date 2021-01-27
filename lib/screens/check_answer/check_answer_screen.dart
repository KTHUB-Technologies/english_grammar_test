import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/level_screen.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';
import 'package:websafe_svg/websafe_svg.dart';

class CheckAnswerScreen extends StatefulWidget {
  final RxList<Question> question;

  const CheckAnswerScreen({Key key, this.question}) : super(key: key);

  @override
  _CheckAnswerScreenState createState() => _CheckAnswerScreenState();
}

class _CheckAnswerScreenState extends State<CheckAnswerScreen> {
  List<String> options = [];
  Rx<int> index = Rx<int>(0);
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<Widget> get listCheckedAnswer => widget.question.map((e) {
        options = e.options.split('///');
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  text: '${widget.question.indexOf(e) + 1}. ${e.task}',
                  color: AppColors.white,
                  textSize: Dimens.paragraphHeaderTextSize,
                ),
                Dimens.height10,
                e.currentChecked.value == e.correctAnswer - 1
                    ? AppText(
                        text: options[e.currentChecked.value],
                        color: Colors.green,
                      )
                    : AppText(
                        text: options[e.currentChecked.value],
                        color: Colors.red,
                      ),
                Dimens.height10,
                e.currentChecked.value == e.correctAnswer - 1
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
                    title: AppText(text: e.explanation, color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();

  @override
  void initState() {
    index.value = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Obx(() {
              return Container(
                child: Row(
                  children: [
                    widget.question.isEmpty
                        ? SizedBox()
                        : ListCheck(
                            question: widget.question,
                            index: index,
                          ),
                    Expanded(
                        child: Stack(
                      children: [
                        WebsafeSvg.asset(Images.quiz_bg, fit: BoxFit.fill),
                        listCheckedAnswer[index.value]
                      ],
                    ))
                    //Expanded(child:   Container(child: AppText(text: "TEST",),))
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return ListTile(
      leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: _navigateBack),
      title: AppText(
        text: 'Check Answer',
      ),
    );
  }
  _navigateBack(){
    int count = 0;
    Navigator.popUntil(context, (route){
      return count++ == 2;

    });
  }
}

class ListCheck extends StatefulWidget {
  final RxList<Question> question;
  final Rx<int> index;

  const ListCheck({Key key, this.question, this.index}) : super(key: key);

  @override
  _ListCheckState createState() => _ListCheckState();
}

class _ListCheckState extends State<ListCheck> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: NavigationRail(
          minWidth: 80,
          destinations: widget.question
              .map((element) => NavigationRailDestination(
                    icon: Row(
                      children: [
                        Dimens.width10,
                        AppText(
                            text: '${widget.question.indexOf(element) + 1}. '),
                        element.currentChecked.value ==
                                element.correctAnswer - 1
                            ? Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                        widget.index.value == widget.question.indexOf(element)
                            ? Icon(Icons.arrow_forward_rounded)
                            : SizedBox()
                      ],
                    ),
                    label: SizedBox(),
                  ))
              .toList(),
          selectedIndex: widget.index.value,
          onDestinationSelected: (int value) {
            widget.index.value = value;
          },
        ),
      ),
    );
  }
}
