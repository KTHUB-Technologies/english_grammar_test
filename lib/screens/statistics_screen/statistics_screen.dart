import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/statistics_controller.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin{
  final MainController mainController = Get.find();
  final AppController appController = Get.find();
  final StatisticsController statisticsController = Get.find();

  TabController _tabController;

  @override
  void initState() {
    getTotalScoreAndTest();
    _tabController = TabController(length: mainController.distinctLevel.length, vsync: this);
    _tabController.index = appController.selectedIndex.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blue,
          title: AppText(
            text: 'Statistics',
            color: AppColors.white,
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              TabBar(
                controller: _tabController,
                labelColor: AppColors.blue,
                unselectedLabelColor: AppColors.black,
                onTap: (index){
                  appController.setSelectedIndex(index);
                  statisticsController.statisticsLevel.value = mainController.distinctLevel[index];
                  getTotalScoreAndTest();
                },
                tabs: mainController.distinctLevel.map((e){
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                    child: Center(
                      child: AppText(
                        text: getLevel(e),
                        textSize: Dimens.errorTextSize,
                        color: AppColors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppText(
                        text: "Game",
                        color: AppColors.black,
                      ),
                      Dimens.height10,
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _buildStatisticsRow(Icons.score, 'True Question', '${statisticsController.totalTrueQues.value.round()}'),
                              Dimens.height20,
                              _buildStatisticsRow(Icons.score, 'Wrong Question', '${statisticsController.totalWrongQues.value.round()}'),
                              Dimens.height20,
                              _buildStatisticsRow(Icons.score, 'Not Yet', '${(statisticsController.totalQues.value-statisticsController.totalTrueQues.value-statisticsController.totalWrongQues.value).round()}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatisticsRow(IconData icon, String title, String score){
    return Row(
      children: <Widget>[
        Icon(icon, color: AppColors.blue,),
        Dimens.width10,
        Expanded(
          child: AppText(
            text: title,
            color: AppColors.black,
          ),
        ),
        AppText(
          text: score,
          color: AppColors.black,
        ),
      ],
    );
  }

  getTrueQuesOfCate(int index) {
    double score = Dimens.doubleValue0;
    Map scoreCate = new Map();
    if (mainController.scoreOfCate
        .containsKey('${statisticsController.statisticsLevel.value}_$index')) {
      if (mainController.scoreOfCate['${statisticsController.statisticsLevel.value}_$index'] != null ||
          mainController.scoreOfCate['${statisticsController.statisticsLevel.value}_$index'] == '0_0') {
        scoreCate
            .addAll(mainController.scoreOfCate['${statisticsController.statisticsLevel.value}_$index']);
        scoreCate.forEach((key, value) {
          List<String> split = value.toString().split('_');
          score += double.tryParse(split[0]);
        });
      }
    }
    return score;
  }

  getWrongQuesOfCate(int index) {
    double score = Dimens.doubleValue0;
    Map scoreCate = new Map();
    if (mainController.scoreOfCate
        .containsKey('${statisticsController.statisticsLevel.value}_$index')) {
      if (mainController.scoreOfCate['${statisticsController.statisticsLevel.value}_$index'] != null ||
          mainController.scoreOfCate['${statisticsController.statisticsLevel.value}_$index'] == '0_0') {
        scoreCate
            .addAll(mainController.scoreOfCate['${statisticsController.statisticsLevel.value}_$index']);
        scoreCate.forEach((key, value) {
          List<String> split = value.toString().split('_');
          score += (double.tryParse(split[1]) - double.tryParse(split[0]));
        });
      }
    }
    return score;
  }

  getTotalQuestion(int index){
    return RxList<Question>(mainController
        .questions
        .where((c) => c.categoryId == index)
        .toList())
        .length;
  }

  getTotalScoreAndTest() async{
    statisticsController.totalTrueQues.value = 0;
    statisticsController.totalWrongQues.value = 0;
    statisticsController.totalQues.value = 0;
    await mainController.loadQuestionFromLevel(statisticsController.statisticsLevel.value);
    mainController.categories =
        mainController.questions.map((e) => e.categoryId).toList();
    mainController.distinctCategory =
        mainController.categories.toSet().toList();
    mainController.distinctCategory.sort();

    final openBox = await Hive.openBox('Table_Score_${statisticsController.statisticsLevel.value}');
    mainController.scoreOfCate.assignAll(openBox.toMap());
    openBox.close();

    mainController.distinctCategory.forEach((e) {
      statisticsController.totalTrueQues.value += getTrueQuesOfCate(e);
      statisticsController.totalWrongQues.value += getWrongQuesOfCate(e);
      statisticsController.totalQues.value += getTotalQuestion(e);
    });
  }
}
