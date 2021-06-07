import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/screens/promotion_screen/promotion_detail/promotion_detail.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({Key key}) : super(key: key);

  @override
  _PromotionsScreenState createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: FlutterLocalizations.of(context).getString(
              context, 'promotion'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          GestureDetector(
            child: Container(
              height: getScreenHeight(context)/Dimens.intValue4,
              padding: const EdgeInsets.all(Dimens.padding15),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.border10),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withOpacity(Dimens.opacityColor0_5),
                        spreadRadius: Dimens.spreedRadius2,
                        blurRadius: Dimens.blurRadius8,
                        offset: Offset(Dimens.offSet2,Dimens.offSet5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(Dimens.formPadding),
                  child: Row(
                    children: [
                      Image.asset(
                        Images.logo,
                        width: 120,
                        height: 120,
                      ),
                      Expanded(
                        child: Center(
                          child: AppText(
                            text: FlutterLocalizations.of(context).getString(
                                context, 'coupon'),
                          ),
                        ),
                      ),
                    ]
                  ),
              ),
            ),
            onTap: () async {
              Get.to(PromotionDetail());
            },
          ),
        ],
      ),
    );
  }
}
