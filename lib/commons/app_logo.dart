import 'package:flutter/material.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';
class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Image.asset(Images.logo),
      height: Dimens.getLogoSize(context),
      width: Dimens.getLogoSize(context),
    );
  }
}
