import 'package:flutter/material.dart';
import '../helper/utils.dart';

class Dimens {
  static double getLogoSize(BuildContext context) =>
      getScreenWidth(context) / 6;
  static const double screenPaddingTop = 16;
  static const double defaultButtonTextSize = 12;
  static const double descriptionTextSize = 16;
  static const double errorTextSize = 12;
  static const double paragraphHeaderTextSize = 20;
  static const double paragraphTextSize = 14;
  static const double clickableTextSize = 14;
  static const double textFieldTextSize = 14;
  static const double messageTextSize = 12;
  static const double headerTextSize = 40;
  static const double buttonBorderRadius = 5;
  static const double formBorderRadius = 10;
  static const double formPadding = 20;
  static const double formMarginTop = 20;
  static const double formMarginHorizontal = 10;

  static double getFormWidth(BuildContext context) =>
      getScreenWidth(context) * 0.95;
  static const double descriptionTextMarginTop = 5;
  static const double inputFieldMarginTop = 20;
  static const double socialNetworkButtonMarginTop = 5;
  static const double defaultButtonHeight = 45;

  static double getTextFieldSuffixIconSize(BuildContext context) =>
      getScreenWidth(context) * 0.07;

  static double getHeaderPadding(BuildContext context) =>
      getScreenWidth(context) * 0.07;

  static double getHeaderIconWidth(BuildContext context) =>
      getScreenWidth(context) * 0.05;

  static double getTermsAndConditionsMarginTop(BuildContext context) =>
      getScreenHeight(context) / 30;

  static double getTermsAndConditionsHorizontalMargin(BuildContext context) =>
      getScreenWidth(context) / 12;

  static double getSelectCountriesHorizontalMargin(BuildContext context) =>
      getScreenWidth(context) / 12;

  static double getSelectCountriesMarginTop(BuildContext context) =>
      getScreenWidth(context) / 15;
  static const double applyButtonMargin = 10;
  static const double applyButtonWidth = 70;

  static double getCloseButtonMargin(BuildContext context) =>
      getScreenWidth(context) / 50;
  static const height10 = SizedBox(
    height: 10,
  );
  static const height20 = SizedBox(
    height: 20,
  );
  static const height30 = SizedBox(
    height: 30,
  );
  static const width10 = SizedBox(width: 10,);
  static const width20 = SizedBox(width: 20,);
  static const width30 = SizedBox(width: 30,);

  static quarterHeight(BuildContext context) => SizedBox(
        height: getScreenHeight(context) / 4,
      );
}
