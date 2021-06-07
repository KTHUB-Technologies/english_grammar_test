import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
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
  final MainController mainController = Get.find();
  final UserController userController = Get.find();
  List<String> options = [];
  Rx<int> index = Rx<int>(0);

  List<Widget> get listCheckedAnswer => widget.question.map((e) {
        options = e.options.split('///');
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.padding10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(Dimens.padding10),
                  child: AppText(
                    text: '${widget.question.indexOf(e) + Dimens.intValue1}. ${e.task}',
                    color: AppColors.white,
                    textSize: Dimens.paragraphHeaderTextSize,
                  ),
                ),
                Dimens.height10,
                e.currentChecked.value == e.correctAnswer - Dimens.intValue1
                    ? AppText(
                        text: '${FlutterLocalizations.of(context).getString(
                            context, 'your_answer')}: ${options[e.currentChecked.value]}',
                        color: AppColors.green,
                      )
                    : AppText(
                        text: '${FlutterLocalizations.of(context).getString(
                            context, 'your_answer')}: ${options[e.currentChecked.value]}',
                        color: AppColors.red,
                      ),
                Dimens.height10,
                e.currentChecked.value == e.correctAnswer - Dimens.intValue1
                    ? SizedBox()
                    : AppText(
                        text: '${FlutterLocalizations.of(context).getString(
                            context, 'correct_answer')}: ${options[e.correctAnswer - Dimens.intValue1]}',
                        color: AppColors.green,
                      ),
                Dimens.height10,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.border10),
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
    index.value = Dimens.initialValue0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Dimens.height10,
          _buildHeader(),
          Expanded(
            child: Obx(() {
              return Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.border15))),
                child: Row(
                  children: [
                    widget.question.isEmpty
                        ? SizedBox()
                        : ListCheck(
                            question: widget.question,
                            index: index,
                          ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Images.quiz_bg),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimens.border30),
                              topLeft: Radius.circular(Dimens.border30))),
                      child: listCheckedAnswer[index.value],
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
    return Container(
      color: AppColors.white,
      child: ListTile(
        title: AppText(
          text: FlutterLocalizations.of(context).getString(
              context, 'review'),
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.secondary,
        ),
        trailing: GestureDetector(
          onTap: _navigateBack,
          child: AppText(
            text: FlutterLocalizations.of(context).getString(
                context, 'back_home'),
            color: AppColors.red,
          ),
        ),
      ),
    );
  }

  _navigateBack() async {
    Get.close(1);
    mainController.score.clear();
    if (userController.user.value != null && mainController.scoreOfCate.containsKey(
        '${widget.question.first.level}'
            '_'
            '${widget.question.first.categoryId}') && mainController.scoreOfCate['${widget.question.first.level}'
        '_'
        '${widget.question.first.categoryId}'] !=
        null) {
      mainController.score.assignAll(mainController.scoreOfCate[
      '${widget.question.first.level}'
          '_'
          '${widget.question.first.categoryId}']);
    } else {
      final openBox =
      await Hive.openBox('Table_Score_${widget.question.first.level}');
      if (openBox.containsKey('${widget.question.first.level}'
          '_'
          '${widget.question.first.categoryId}') && openBox.get('${widget.question.first.level}'
          '_'
          '${widget.question.first.categoryId}') !=
          null) {
        mainController.score.assignAll(openBox.get(
            '${widget.question.first.level}'
                '_'
                '${widget.question.first.categoryId}'));
      } else {
        mainController.score.clear();
      }
      openBox.close();
    }
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
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: getScreenHeight(context)),
        child: IntrinsicHeight(
          child: NavigationRail(
            groupAlignment: -Dimens.doubleValue1,
            backgroundColor: AppColors.white,
            minWidth: Dimens.width90,
            destinations: widget.question
                .map((element) => NavigationRailDestination(
                      icon: Row(
                        children: [
                          Dimens.width10,
                          AppText(
                              text:
                                  '${widget.question.indexOf(element) + Dimens.intValue1}. '),
                          element.currentChecked.value ==
                                  element.correctAnswer - Dimens.intValue1
                              ? Icon(
                                  Icons.check,
                                  color: AppColors.green,
                                )
                              : Icon(
                                  Icons.clear,
                                  color: AppColors.red,
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
      ),
    );
  }
}
