import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
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
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimens.border20), topLeft: Radius.circular(Dimens.border20))),
      padding: EdgeInsets.all(Dimens.padding10),
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
  }

  Widget buildCardTestWithProgress() {
    return Obx((){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: mainController.listChunkQuestions.map((e) {
          return GestureDetector(
            child: Card(
              child: ListTile(
                title: AppText(
                  text:
                  '${FlutterLocalizations.of(context).getString(
                      context, 'test')}'' ${mainController.listChunkQuestions.indexOf(e) + Dimens.intValue1}',
                ),
                trailing:getScoreOfTest(e) == null || getScoreOfTest(e).isNaN ? Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.yellow,width: Dimens.width3)
                  ),
                  child: CircleAvatar(
                    radius: Dimens.border15,
                    backgroundColor: AppColors.transparent,
                    child: AppText(
                      text: FlutterLocalizations.of(context).getString(
                          context, 'go'),
                      color: AppColors.black,
                      textSize: Dimens.errorTextSize,
                    ),
                  ),
                ) : CircularPercentIndicator(
                  radius: Dimens.radius35,
                  lineWidth: Dimens.line2,
                  animation: true,
                  percent:
                  getScoreOfTest(e) == null || getScoreOfTest(e).isNaN
                      ? Dimens.doubleValue0
                      : getScoreOfTest(e).round()==Dimens.initialValue0?Dimens.doubleValue1:getScoreOfTest(e) / Dimens.intValue100.round(),
                  center:  Text(
                    '${getScoreOfTest(e) == null || getScoreOfTest(e).isNaN ? Dimens.initialValue0 : getScoreOfTest(e).round()}%',
                    style:  TextStyle(
                        fontWeight: FontWeight.bold, fontSize: Dimens.textSize10),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: getScoreOfTest(e).round()==Dimens.initialValue0?AppColors.red:AppColors.green,
                ),
              ),
            ),
            onTap: () async {
              // Get.back();
              if (userController.user.value != null) {
                List<dynamic> favorite=await userController.getDataFavorite(userController.user.value.uid);
                if(favorite.isNotEmpty){
                  mainController.questionsHiveFavorite=  RxList<Question>(favorite.map((e) => Question.fromJson(e)).toList());
                }
              } else {
                mainController.questionsHiveFavorite =
                    RxList<Question>(await HiveHelper.getBoxes(Constants.TABLE_FAVORITE_BOX_NAME));
              }
              await checkExistTable(
                  mainController.listChunkQuestions.indexOf(e) + Dimens.intValue1);
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
                    testNumber: mainController.listChunkQuestions.indexOf(e) + Dimens.intValue1,
                    isFavorite: false,
                    questionTemp: RxList<Question>(e),
                  ),
                  transition: Transition.fadeIn,

                  duration: Duration(milliseconds: Dimens.durationMilliseconds500),preventDuplicates: false);

            },
          );
        }).toList(),
      );
    });
  }

  getScoreOfTest(List<Question> index){
    if (mainController.score
        ['${mainController.listChunkQuestions.indexOf(index) + Dimens.intValue1}'] !=
        null) {
      List<String> splitScore =
      '${mainController.score['${mainController.listChunkQuestions.indexOf(index) + Dimens.intValue1}']}'
          .split('_');
      return (double.tryParse(splitScore[0]) /
          double.tryParse(splitScore[1])) *
          Dimens.intValue100;
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
      final openBox = await Hive.openBox('Table_${widget.level}');
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
