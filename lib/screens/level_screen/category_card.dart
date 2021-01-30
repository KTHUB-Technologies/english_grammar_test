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

  const CategoryCard({Key key, this.index, this.onTap, this.score, this.level, this.category})
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
    return Obx(() {
      return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient:
                          LinearGradient(colors: categoryColorCard(widget.index-1))),
                  padding: EdgeInsets.symmetric(horizontal: Dimens.formPadding),
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
                              backgroundColor: Colors.blueGrey,
                              progressColor: AppColors.green,
                              percent: widget.score.value == null ||
                                      widget.score.value.isNaN
                                  ? 0
                                  : widget.score.value / 100.round()),
                        ),
                        Dimens.height10,
                        Row(
                          children: [
                            Expanded(child: SizedBox()),
                            _buildProgress('Question', 100, 40),
                            _buildProgress('Test', 4, 2),
                            Expanded(child: SizedBox()),
                          ],
                        )
                      ],
                    ),
                  )
                  // Row(
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: AppText(
                  //         text: getCategory(widget.index),
                  //         color: AppColors.orangeAccent,
                  //       ),
                  //     ),
                  //     Dimens.width20,
                  //     CircularPercentIndicator(
                  //       radius: 35.0,
                  //       lineWidth: 2.0,
                  //       animation: true,
                  //       percent:
                  //           widget.score.value == null || widget.score.value.isNaN
                  //               ? 0
                  //               : widget.score.value / 100.round(),
                  //       center: Text(
                  //         '${widget.score.value == null || widget.score.value.isNaN ? 0 : widget.score.value.round()}%',
                  //         style:
                  //             TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                  //       ),
                  //       circularStrokeCap: CircularStrokeCap.round,
                  //       progressColor: Colors.purple,
                  //     ),
                  //     Dimens.width20,
                  //
                  //     ///
                  //     // widget.isProgress == false
                  //     //     ? SizedBox()
                  //     //     : GestureDetector(
                  //     //         child: Icon(
                  //     //           Icons.rotate_left,
                  //     //           color: widget.score.value == 0.0
                  //     //               ? AppColors.divider
                  //     //               : AppColors.green,
                  //     //         ),
                  //     //         onTap: () {
                  //     //           if (widget.score.value != 0.0) {
                  //     //             showCupertinoDialog(
                  //     //                 context: context,
                  //     //                 builder: (context) {
                  //     //                   return IOSDialog(
                  //     //                     title: 'WARNING',
                  //     //                     content:
                  //     //                         "Do you want to restart ${getCategory(index)}?",
                  //     //                     cancel: () {
                  //     //                       Get.back();
                  //     //                     },
                  //     //                     confirm: () async {
                  //     //                       Get.back();
                  //     //
                  //     //                       restartScoreOfCate(index, score);
                  //     //                     },
                  //     //                   );
                  //     //                 });
                  //     //           }
                  //     //         },
                  //     //       ),
                  //   ],
                  // ),
                  ),
            ],
          ),
        ),
        onTap: () async {
          SoundsHelper.checkAudio(Sounds.touch);
          widget.onTap();
        },
      );
    });
  }

  _buildProgress(String section, num total, num currentReach) {
    return Expanded(
        child: Column(
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
    ));
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
