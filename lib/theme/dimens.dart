import 'package:flutter/material.dart';
import '../helper/utils.dart';

class Dimens {
  static double getLogoSize(BuildContext context) =>
      getScreenWidth(context) / 2;
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

  static aHalfHeight(BuildContext context) => SizedBox(
    height: getScreenHeight(context) / 2,
  );

  static quarterWidth(BuildContext context) => SizedBox(
    height: getScreenWidth(context) / 4,
  );

  static aHalfWidth(BuildContext context) => SizedBox(
    height: getScreenWidth(context) / 2,
  );

  static const int initialValue0 = 0;

  static const int intValue2 =2;

  static const int intValue4 =4;

  ///Splash Screen
  static const int durationSeconds2 = 2;

  ///Setting Screen
  static const double container30 = 30;
  static const double padding17 = 17;

  ///Questions Screen
  static const double widthValue150 = 150;
  static const int duration1200 = 1200;
  static const int durationMilliseconds500 = 500;
  static const int durationSeconds10 = 10;
  static const double offSet0 = 0;
  static const double offSet400 = 400;
  static const double opacityDisabled = 0;
  static const double opacityEnabled = 1;
  static const int getBack2 = 2;
  static const int intValue1 = 1;
  static const double line13 = 13;
  static const double linePercentIndicatorWidth = 1.1;
  static const double zeroPercent = 0.0;
  static const double padding5 = 5;
  static const double radius150 = 150;
  static const int intValue100 = 100;

  ///Card Question
  static const double opacityColor0_2 = 0.2;
  static const double opacityColor0 = 0;
  static const double opacityColor1 = 1;
  static const double padding10 = 10;
  static const int durationMilliseconds200 = 200;
  static const double border10 = 10;
  static const int durationSeconds5 = 5;
  static const double elevation0 = 0;

  ///Promotion Screen
  static const double padding15= 15;
  static const double border25 = 25;
  static const double opacityColor0_5 = 0.5;
  static const double spreedRadius2 = 2;
  static const double blurRadius8 = 8;
  static const double offSet2 = 2;
  static const double offSet5 = 5;

  ///Promotion Detail
  static const double doubleValue1_4 = 1.4;
  static const double border15 = 15;

  ///Progress Screen
  static const double borderWidth0 = 0;
  static const double border70 = 70;
  static const double height54 = 54;
  static const double doubleValue0 = 0;

  ///Main Screen
  static const double padding20= 20;
  static const double minWidth = 55;
  static const double doubleValue1 =1;
  static const double doubleValue2 =2;

  ///Normal Card
  static const double doubleValue1_3 = 1.3;
  static const double container20 = 20;
  static const double container15 = 15;
  static const double border20 = 20;
  static const int intValue6 =6;
  static const int intValue25 =25;
  static const double elevation20 = 20;

  ///Category Card
  static const double padding3 = 3;
  static const double line7 = 7;
  static const double angle0_8 = 0.8;
  static const double height60 = 60;
  static const double width60 = 60;
  static const double width3 = 3;

  ///Modal_Bottom_Sheet
  static const double radius35 = 35;
  static const double line2 = 2;
  static const double textSize10 = 10;

  ///Check Answer Screen
  static const double border30 = 30;
  static const double width90 = 90;

  ///Utils
  static const double padding25= 25;
  static const int intValue10 = 10;
  static const int intValue20 = 20;
}
