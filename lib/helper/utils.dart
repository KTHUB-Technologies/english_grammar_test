import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:the_enest_english_grammar_test/localization/flutter_localizations.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';

/// This method is used when we need to call a method after build() function is completed.
void onWidgetBuildDone(function) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    function();
  });
}

double subTotal(List<double> prices) {
  var subTotal;
  if (prices.isNotEmpty) {
    subTotal = prices.reduce((a, b) => a + b);
    return subTotal / double.tryParse(prices.length.toString());
  } else
    subTotal = 0.0;
  return subTotal == 0.0
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
      return 'Beginning';
    case 2:
      return 'Intermediate';
    case 3:
      return 'Advanced';
  }
}

getCategory(num categoryId) {
  switch (categoryId) {
    case 1:
      return 'Phrasal Verb';
    case 2:
      return 'Vocabulary';
    case 3:
      return 'Comparison';
    case 4:
      return 'Reported Speech';
    case 5:
      return 'Present Tenses';
    case 6:
      return 'Relative Clauses';
    case 7:
      return 'Passive Voice';
    case 8:
      return 'Future Tenses';
    case 9:
      return 'Preposition';
    case 10:
      return 'If (Conditional Clauses)';
    case 11:
      return 'Types Of Question';
    case 12:
      return 'Idiom';
    case 13:
      return 'Types Of Clauses';
    case 14:
      return 'Mixed Tenses';
    case 15:
      return 'Past Tenses';
    case 16:
      return 'Modal Verbs';
    case 17:
      return 'Pronoun';
    case 18:
      return 'Modal Verbs';
    case 19:
      return 'Article';
    case 20:
      return 'Conjunction';
    case 21:
      return 'Gerund And Infinitive';
    case 22:
      return 'Collocation';
    case 23:
      return 'Misc Topics';
    case 24:
      return 'Quantifier_Determiner';
    case 25:
      return 'Adjective-Adverb';
    case 26:
      return 'Noun-Noun Phrase';
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
