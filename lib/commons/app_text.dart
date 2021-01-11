
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';
import 'package:the_enest_english_grammar_test/theme/fonts.dart';

class AppText extends StatefulWidget {
  final String text;
  final double textSize;
  final Color color;
  final Fonts font;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow textOverflow;
  final FontStyle fontStyle;

  AppText(
      {@required this.text,
      this.textSize,
      this.color,
      this.font,
      this.fontStyle,
      this.fontWeight,
      this.textAlign,
      this.maxLines,
      this.textOverflow});

  @override
  _AppTextState createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  final AppController appController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Text(widget.text ?? '',
          overflow: widget.textOverflow,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          style: TextStyle(
              fontStyle: widget.fontStyle,
              fontSize: widget.textSize == null ? Dimens.descriptionTextSize : widget.textSize,
              fontFamily: widget.font == null ? Fonts.Lato : widget.font,
              color:  appController.isDark.value==true?AppColors.white:widget.color,
              fontWeight: widget.fontWeight));
    });
  }
}
