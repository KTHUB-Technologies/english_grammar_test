import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/screens/question_screen/question_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class ModalBottomSheet extends StatefulWidget {
  final int level;
  final int categoryId;
  final String categoryName;

  const ModalBottomSheet(
      {Key key, this.level, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final MainController mainController = Get.find();
  final UserController userController= Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppText(
              text: widget.categoryName,
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
              textSize: Dimens.paragraphHeaderTextSize,
            ),
            Dimens.height10,
            buildCardTestWithProgress(),
          ],
        ),
      );
    });
  }

  Widget buildCardTestWithProgress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: mainController.listChunkQuestions.map((e) {
        return GestureDetector(
          child: Card(
            child: ListTile(
              title: AppText(
                text:
                    'Test ${mainController.listChunkQuestions.indexOf(e) + 1}',
              ),
              trailing: CircularPercentIndicator(
                radius: 35.0,
                lineWidth: 2.0,
                animation: true,
                percent:
                    getScoreOfTest(e) == null || getScoreOfTest(e).isNaN
                        ? 0
                        : getScoreOfTest(e) / 100.round(),
                center:  Text(
                  '${getScoreOfTest(e) == null || getScoreOfTest(e).isNaN ? 0 : getScoreOfTest(e).round()}%',
                  style:  TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 10.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: AppColors.green,
              ),
            ),
          ),
          onTap: () async {
            if (userController.user.value != null) {
              List<dynamic> favorite=await userController.getDataFavorite(userController.user.value.uid);
              if(favorite.isNotEmpty){
                mainController.questionsHiveFavorite=  RxList<Question>(favorite.map((e) => Question.fromJson(e)).toList());
              }
            } else {
                mainController.questionsHiveFavorite =
                    RxList<Question>(await HiveHelper.getBoxes(Constants.TABLE_FAVORITES));
            }
            await checkExistTable(
                mainController.listChunkQuestions.indexOf(e) + 1);
            e.forEach((question) {
              question.currentChecked.value = null;
            });

            Get.to(
                QuestionScreen(
                  level: widget.level,
                  categoryId: widget.categoryId,
                  question:
                      mainController.questionsFromHive.isEmpty
                          ? RxList<Question>(e)
                          : mainController.questionsFromHive,
                  testNumber: mainController.listChunkQuestions.indexOf(e) + 1,
                  isFavorite: false,
                  questionTemp: RxList<Question>(e),
                ),
                transition: Transition.fadeIn,

                duration: Duration(milliseconds: 500),preventDuplicates: false);

          },
        );
      }).toList(),
    );
  }

  getScoreOfTest(List<Question> index){
    if (mainController.score
        .value['${mainController.listChunkQuestions.indexOf(index) + 1}'] !=
        null) {
      List<String> splitScore =
      '${mainController.score.value['${mainController.listChunkQuestions.indexOf(index) + 1}']}'
          .split('_');
      return (double.tryParse(splitScore[0]) /
          double.tryParse(splitScore[1])) *
          100;
    }
  }

  checkExistTable(int testNumber) async {
    if(userController.user.value!=null){
      if(mainController.allQuestionsFromFS.value['${widget.categoryId}']!=null){
        if(mainController.allQuestionsFromFS.value['${widget.categoryId}']['$testNumber']!=null){
          List<dynamic> questions = mainController.allQuestionsFromFS.value['${widget.categoryId}']['$testNumber'];
          mainController.questionsFromHive=RxList<Question>(questions.map((e) => Question.fromJson(e)).toList());
        }else
          mainController.questionsFromHive.clear();
      }else{
        mainController.questionsFromHive.clear();
      }
    }else{
      final openBox = await Hive.openBox('${Constants.TABLE}${widget.level}');
      if (openBox.containsKey('${widget.categoryId}')) {
        Map getCate = openBox.get('${widget.categoryId}');
        if (getCate != null) {
          List<dynamic> questions = getCate['$testNumber'];
          if (questions != null) {
            mainController.questionsFromHive = RxList<Question>(
                questions.map((e) => Question.fromJson(e)).toList());
          } else {
            mainController.questionsFromHive.clear();
          }
        }
      } else {
        mainController.questionsFromHive.clear();
      }
      openBox.close();
    }
  }
}
