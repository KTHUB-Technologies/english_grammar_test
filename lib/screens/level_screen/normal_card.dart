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
  final Rx<double> trueQues;
  final Rx<double> wrongQues;
  final int index;
  final num totalQuestion;
  final Function onTap;

  const NormalCategoryCard({Key? key, required this.level,required  this.category,required  this.onTap,required  this.index,required  this.trueQues,required  this.wrongQues,required  this.totalQuestion}) : super(key: key);
  @override
  _NormalCategoryCardState createState() => _NormalCategoryCardState();
}

class _NormalCategoryCardState extends State<NormalCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Obx((){
      return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.padding15),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.border25),
                gradient: LinearGradient(
                  colors: categoryColorCard(widget.index - Dimens.intValue1),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.red.withOpacity(Dimens.opacityColor0_5),
                    spreadRadius: Dimens.spreedRadius2,
                    blurRadius: Dimens.blurRadius8,
                    offset: Offset(Dimens.offSet2,Dimens.offSet5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(Dimens.formPadding),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: AppText(
                      text: getCategory(widget.category),
                      textSize: Dimens.paragraphHeaderTextSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Dimens.height10,
                  Container(
                    height: Dimens.container15,
                    width: getScreenWidth(context)/Dimens.doubleValue1_3,
                    child: Row(
                      children: <Widget>[
                        widget.trueQues.value==Dimens.initialValue0?SizedBox():Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(Dimens.border20), right: Radius.circular((widget.totalQuestion-widget.trueQues.value-widget.wrongQues.value)==Dimens.initialValue0 && widget.wrongQues.value==Dimens.initialValue0 ? Dimens.border20:Dimens.doubleValue0)),
                            color: AppColors.green,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.green.withOpacity(Dimens.opacityColor0_5),
                                spreadRadius: Dimens.spreedRadius2,
                                blurRadius: Dimens.blurRadius5,
                                offset: Offset(Dimens.offSet0, Dimens.offset3), // changes position of shadow
                              ),
                            ],
                          ),
                          width: (widget.trueQues.value/widget.totalQuestion)*(getScreenWidth(context)/Dimens.doubleValue1_3),
                          child: Center(
                            child: AppText(
                              textSize: Dimens.textSize10,
                              color: AppColors.white,
                              text: '${widget.trueQues.value.round()}',
                            ),
                          ),
                        ),
                        (widget.totalQuestion-widget.trueQues.value-widget.wrongQues.value)==Dimens.initialValue0?SizedBox():Container(
                          width: ((widget.totalQuestion-widget.trueQues.value-widget.wrongQues.value)/widget.totalQuestion)*(getScreenWidth(context)/Dimens.doubleValue1_3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(widget.trueQues.value==Dimens.initialValue0?Dimens.border20:Dimens.doubleValue0), right: Radius.circular(widget.wrongQues.value==Dimens.initialValue0?Dimens.border20:Dimens.doubleValue0)),
                            color: AppColors.divider,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.closeIcon.withOpacity(Dimens.opacityColor0_5),
                                spreadRadius: Dimens.spreedRadius2,
                                blurRadius: Dimens.blurRadius5,
                                offset: Offset(Dimens.offSet0, Dimens.offset3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: AppText(
                              textSize: Dimens.textSize10,
                              color: AppColors.white,
                              text: '${(widget.totalQuestion-widget.trueQues.value-widget.wrongQues.value).round()}',
                            ),
                          ),
                        ),
                        widget.wrongQues.value==Dimens.initialValue0?SizedBox():Container(
                          width: (widget.wrongQues.value/widget.totalQuestion)*(getScreenWidth(context)/Dimens.doubleValue1_3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(Dimens.border20), left: Radius.circular((widget.totalQuestion-widget.trueQues.value-widget.wrongQues.value)==Dimens.initialValue0 && widget.trueQues.value==Dimens.initialValue0 ? Dimens.border20:Dimens.doubleValue0)),
                            color: AppColors.red,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.red.withOpacity(Dimens.opacityColor0_5),
                                spreadRadius: Dimens.spreedRadius2,
                                blurRadius: Dimens.blurRadius5,
                                offset: Offset(Dimens.offSet0, Dimens.offset3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: AppText(
                              textSize: Dimens.textSize10,
                              color: AppColors.white,
                              text: '${widget.wrongQues.value.round()}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Dimens.height10,
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: Container(
                  //     width: getScreenWidth(context)/Dimens.intValue6,
                  //     height: getScreenHeight(context)/Dimens.intValue25,
                  //     // decoration: BoxDecoration(
                  //     //   color: AppColors.transparent,
                  //     //   border: Border.all(color: AppColors.white,width: 2.0),
                  //     //   borderRadius: BorderRadius.circular(8.0),
                  //     // ),
                  //     child: Icon(Icons.arrow_forward,color: AppColors.white,),
                  //   ),
                  // ),
                ],
              )),
        ),
        onTap: () async {
          widget.onTap();
        },
      );
    });
  }
}
