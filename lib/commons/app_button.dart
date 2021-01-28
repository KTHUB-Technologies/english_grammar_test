
import 'package:flutter/material.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';

import '../helper/utils.dart';

class AppButton extends StatelessWidget {
  final String titleButton;
  final double widthButton;
  final double heightButton;
  final Color textColor;
  final Function onTap;

  const AppButton(this.titleButton,
      {this.widthButton, this.heightButton, this.textColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return _buildAppButton(
        context, titleButton, widthButton, heightButton, textColor);
  }

  Widget _buildAppButton(BuildContext context, String titleButton,
      double widthButton, double heightButton, textColor) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width:
            widthButton != null ? widthButton : getScreenWidth(context) / 1.8,
        height:
            heightButton != null ? heightButton : getScreenWidth(context) / 8,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.gradientColorPrimary),
            borderRadius: BorderRadius.circular(15)),
        child: Align(
          alignment: Alignment.center,
          child: AppText(
            color: textColor != null ? textColor : AppColors.white,
            text: titleButton,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
