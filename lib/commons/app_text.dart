
import 'package:flutter/material.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';
import 'package:the_enest_english_grammar_test/theme/fonts.dart';

class AppText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Text(text ?? '',
        overflow: textOverflow,
        textAlign: textAlign,
        maxLines: maxLines,
        style: TextStyle(
            fontStyle: fontStyle,
            fontSize: textSize == null ? Dimens.descriptionTextSize : textSize,
            fontFamily: font == null ? Fonts.Lato : font,
            color: color == null ? AppColors.paragraphText : color,
            fontWeight: fontWeight));
  }
}
