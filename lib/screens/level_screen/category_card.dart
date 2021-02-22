import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class CategoryCard extends StatefulWidget {
  final int level;
  final int index;
  final int category;
  final Function onTap;
  final Rx<double> score;
  final num totalQuestion;
  final Rx<int> testCompleted;
  final num questionComplete;

  const CategoryCard(
      {Key key,
      this.index,
      this.onTap,
      this.score,
      this.level,
      this.category,
      this.totalQuestion,
      this.testCompleted,
      this.questionComplete})
      : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final totalTest = getTotalTest(widget.totalQuestion);
    return Obx(() {
      return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                      colors: categoryColorCard(widget.index - 1)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.red.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(2,5),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: Dimens.formPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: AppText(
                          text: getCategory(widget.category),
                          textSize: Dimens.paragraphHeaderTextSize,
                          color: AppColors.white,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Dimens.height10,
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: LinearPercentIndicator(
                                width: getScreenWidth(context) / 2,
                                lineHeight: 7.0,
                                backgroundColor: AppColors.white,
                                progressColor: Colors.deepOrange[500],
                                percent: widget.score.value == null ||
                                        widget.score.value.isNaN
                                    ? 0
                                    : widget.score.value /
                                        widget.totalQuestion),
                          ),
                          Dimens.height10,
                          Row(
                            children: [
                              _buildProgress('Question', widget.totalQuestion,
                                  widget.score.value.round()),
                              Dimens.width30,
                              _buildProgress('Test', totalTest,
                                  widget.testCompleted.value),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: 0.8,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 3, color: Colors.deepOrange[800]),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: AppColors.white,
                      ),
                      child: Transform.rotate(
                        angle: -0.8,
                        child: Center(
                          child: AppText(
                            text:
                                '${((widget.score.value.round() / widget.totalQuestion) * 100).round()}%',
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange[800],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Dimens.width10,
                ],
              )),
        ),
        onTap: () async {
          SoundsHelper.checkAudio(Sounds.touch);
          widget.onTap();
        },
      );
    });
  }

  _buildProgress(String section, num total, num currentReach) {
    return Column(
      children: [
        AppText(
          text: '$currentReach/$total',
          color: AppColors.white,
        ),
        AppText(
          text: section,
          color: AppColors.white,
          textSize: Dimens.errorTextSize,
        )
      ],
    );
  }

  restartScoreOfCate(int category, Rx<double> score) async {
    final openBox = await Hive.openBox('Table_${widget.level}');
    openBox.put('$category', null);
    openBox.close();

    final openBoxScore = await Hive.openBox('Table_Score_${widget.level}');
    openBoxScore.put('${widget.level}_$category', null);
    openBoxScore.close();

    score.value = 0.0;
  }
}
