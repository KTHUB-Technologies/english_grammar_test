import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/android_dialog.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/ios_dialog.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

/// This method is used when we need to call a method after build() function is completed.
void onWidgetBuildDone(function) {
  SchedulerBinding.instance!.addPostFrameCallback((_) {
    function();
  });
}

double subTotal(List<double> prices) {
  var subTotal;
  if (prices.isNotEmpty) {
    subTotal = prices.reduce((a, b) => a + b);
    return subTotal / double.tryParse(prices.length.toString());
  } else
    subTotal = Dimens.doubleValue0;
  return subTotal == Dimens.doubleValue0
      ? subTotal
      : subTotal / double.tryParse(prices.length.toString());
}

getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

getLevel(num levelId) {
  switch (levelId) {
    case 1:
      return Constants.BEGINNING;
    case 2:
      return Constants.INTERMEDIATE;
    case 3:
      return Constants.ADVANCED;
  }
}

getCategory(num categoryId) {
  switch (categoryId) {
    case 1:
      return Constants.PHRASAL_VERB;
    case 2:
      return Constants.VOCABULARY;
    case 3:
      return Constants.COMPARISON;
    case 4:
      return Constants.REPORTED_SPEECH;
    case 5:
      return Constants.PRESENT_TENSES;
    case 6:
      return Constants.RELATIVE_CLAUSES;
    case 7:
      return Constants.PASSIVE_VOICE;
    case 8:
      return Constants.FUTURE_TENSES;
    case 9:
      return Constants.PREPOSITION;
    case 10:
      return Constants.IF;
    case 11:
      return Constants.TYPES_OF_QUESTION;
    case 12:
      return Constants.IDIOM;
    case 13:
      return Constants.TYPES_OF_CLAUSES;
    case 14:
      return Constants.MIXED_TENSES;
    case 15:
      return Constants.PAST_TENSES;
    case 16:
      return Constants.MODAL_VERBS;
    case 17:
      return Constants.PRONOUN;
    case 18:
      return Constants.MODAL_VERBS;
    case 19:
      return Constants.ARTICLE;
    case 20:
      return Constants.CONJUNCTION;
    case 21:
      return Constants.GERUND_AND_INFINITIVE;
    case 22:
      return Constants.COLLOCATION;
    case 23:
      return Constants.MISC_TOPICS;
    case 24:
      return Constants.QUANTIFIER_DETERMINER;
    case 25:
      return Constants.ADJECTIVE_ADVERB;
    case 26:
      return Constants.NOUN_NOUN_PHRASE;
  }
}

getLevelDescription(int level, context) {
  switch (level) {
    case 1:
      return "You can use English for everyday tasks and activities. You can also understand common phrases related to topics such as personal information and employment.";
    case 2:
      return "You can communicate confidently about many topics. You can also understand the main ideas of texts within your field of specialization.";
    case 3:
      return "You can express yourself fluently in almost any situation. You are able to perform complex tasks related to work and study. You can also produce clear, detailed texts on challenging subjects.";
    default:
      return '';
  }
}

getSection(int sectionSelected) {
  switch (sectionSelected) {
    case 1:
      return "TOPIC";
    case 2:
      return "MIX";
    default:
      return "";
  }
}

shortUserName(String displayName) {
  return displayName.split(' ').map((e) => e.substring(0, 1)).toList().join("");
}

showConfirmDialog(BuildContext context,
    {String? title, String? content, Function? cancel, Function? confirm}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return IOSDialog(
            title: title!,
            content: content!,
            cancel: cancel!,
            confirm: () {
              Navigator.pop(context);
              confirm!();
            },
          );
        });
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AndroidDialog(
            title: title!,
            content: content!,
            cancel: cancel!,
            confirm: () {
              Navigator.pop(context);
              confirm!();
            },
          );
        });
  }
}

categoryColorCard(int index){
  var position = index%4;

  switch(position){
    case 0 :
      return AppColors.gradientColorCard1;
    case 1 :
      return AppColors.gradientColorCard2;
    case 2 :
      return AppColors.gradientColorCard3;
    case 3 :
      return AppColors.gradientColorCard4;
    default:
  }
}
getTotalTest(int totalQuestion){
  int totalTest= Dimens.initialValue0;
  if(totalQuestion<=Dimens.intValue10){
    totalTest = Dimens.intValue1;
  }else{
    totalTest = (totalQuestion/Dimens.intValue20).round();
  }
  return totalTest;
}

alertDialog(BuildContext context, String content, Function confirm) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.border15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.padding10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                textSize: Dimens.paragraphHeaderTextSize,
                text: FlutterLocalizations.of(context)!.getString(context, 'waring'),
                color: AppColors.red,
              ),
              Dimens.height10,
              AppText(
                text: content,
                color: AppColors.black,
                textSize: Dimens.errorTextSize,
              ),
              Dimens.height20,
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimens.padding3, horizontal: Dimens.padding10),
                    child: AppText(
                      text: FlutterLocalizations.of(context)!.getString(context, 'confirm'),
                      color: AppColors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.blue),
                  ),
                  onPressed: (){
                    confirm();
                  },
                ),
              )
            ],
          ),
        ),
      ));
}

getStringChoice(int id, BuildContext context){
  switch(id){
    case 1:
      return FlutterLocalizations.of(context)!.getString(
          context, 'favorite');
    case 2:
      return FlutterLocalizations.of(context)!.getString(
          context, 'setting');
    default:
      return '';
  }
}
