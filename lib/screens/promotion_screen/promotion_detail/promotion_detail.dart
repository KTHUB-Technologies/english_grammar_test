import 'package:flutter/material.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class PromotionDetail extends StatefulWidget {
  const PromotionDetail({Key key}) : super(key: key);

  @override
  _PromotionDetailState createState() => _PromotionDetailState();
}

class _PromotionDetailState extends State<PromotionDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: FlutterLocalizations.of(context).getString(
              context, 'promotion_detail'),
        ),
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(Dimens.border15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _rowInputTextField(FlutterLocalizations.of(context).getString(
                  context, 'user'),FlutterLocalizations.of(context).getString(
                  context, 'enter_name')),
              _rowInputTextField(FlutterLocalizations.of(context).getString(
                  context, 'phone'),FlutterLocalizations.of(context).getString(
                  context, 'enter_phone')),
              Dimens.height10,
              TextButton(
                child: AppText(
                  text: FlutterLocalizations.of(context).getString(
                      context, 'submit'),
                  color: AppColors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.blue),
                ),
                onPressed: (){},
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _rowInputTextField (String title, String hintText){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AppText(
          text: title,
        ),
        Container(
          width: getScreenWidth(context)/Dimens.doubleValue1_4,
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        )
      ],
    );
  }
}
