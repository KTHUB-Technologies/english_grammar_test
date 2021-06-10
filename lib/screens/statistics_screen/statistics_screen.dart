import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin{
  final MainController mainController = Get.find();
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: mainController.distinctLevel.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              tabs: mainController.distinctLevel.map((e){
                return Padding(
                  padding: const EdgeInsets.all(10.0),
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
              child: TabBarView(
                controller: _tabController,
                children: mainController.distinctLevel.map((e){
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
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
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _buildStatisticsRow(Icons.map, 'Score', '20%'),
                                Dimens.height10,
                                _buildStatisticsRow(Icons.map, 'Score', '20%'),
                                Dimens.height10,
                                _buildStatisticsRow(Icons.map, 'Score', '20%'),
                                Dimens.height10,
                                _buildStatisticsRow(Icons.map, 'Score', '20%'),
                                Dimens.height10,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
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
}
