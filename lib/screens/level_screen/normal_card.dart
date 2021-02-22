import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class NormalCategoryCard extends StatefulWidget {
  final int level;
  final int category;
  final Rx<double> score;
  final int index;
  final num totalQuestion;
  final Function onTap;

  const NormalCategoryCard({Key key, this.level, this.category, this.onTap, this.index, this.score, this.totalQuestion}) : super(key: key);
  @override
  _NormalCategoryCardState createState() => _NormalCategoryCardState();
}

class _NormalCategoryCardState extends State<NormalCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.bubbles),
                fit: BoxFit.fitWidth,
              ),
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
            padding: EdgeInsets.all(Dimens.formPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: AppText(
                    text: getCategory(widget.category),
                    textSize: Dimens.paragraphHeaderTextSize,
                    color: AppColors.white,
                  ),
                ),
              ],
            )),
      ),
      onTap: () async {
        widget.onTap();
      },
    );
  }
}
