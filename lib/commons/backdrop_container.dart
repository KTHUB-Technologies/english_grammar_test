import 'package:flutter/material.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';


class BackdropContainer extends StatelessWidget {
  final Widget? child;

  const BackdropContainer({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.getFormWidth(context),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.formBorderRadius),
              topRight: Radius.circular(Dimens.formBorderRadius))),
      padding: EdgeInsets.only(
          top: Dimens.formPadding,
          left: Dimens.formPadding,
          right: Dimens.formPadding),
      child: this.child,
    );
  }
}
