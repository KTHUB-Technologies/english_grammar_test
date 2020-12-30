import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';


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
    return subTotal/double.tryParse(prices.length.toString());
  } else
    subTotal = 0.0;
  return subTotal==0.0?subTotal:subTotal/double.tryParse(prices.length.toString());
}

getScreenWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

getScreenHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}

getLevel(num levelId){
  switch(levelId){
    case 1:
      return 'Beginning';
    case 2:
      return 'Intermediate';
    case  3:
      return 'Advanced';
  }
}
getCategory(num categoryId){
  switch(categoryId){
    case 1 :
      return 'Phrasal Verb';
    case 2 :
      return 'Vocabulary';
    case 3 :
      return 'Comparison';
    case 4 :
      return 'Reported Speech';
    case 5 :
      return 'Present Tenses';
    case 6 :
      return 'Relative Clauses';
    case 7 :
      return 'Passive Voice';
    case 8 :
      return 'Future Tenses';
    case 9 :
      return 'Preposition';
    case 10 :
      return 'If (Conditional Clauses)';
    case 11 :
      return 'Types Of Question';
    case 12 :
      return 'Idiom';
    case 13 :
      return 'Types Of Clauses';
    case 14 :
      return 'Mixed Tenses';
    case 15 :
      return 'Past Tenses';
    case 16 :
      return 'Modal Verbs';
    case 17 :
      return 'Pronoun';
    case 18 :
      return 'Modal Verbs';
    case 19 :
      return 'Article';
    case 20 :
      return 'Conjunction';
    case 21 :
      return 'Gerund And Infinitive';
    case 22 :
      return 'Collocation';
    case 23 :
      return 'Misc Topics';
    case 24 :
      return 'Quantifier_Determiner';
    case 25 :
      return 'Adjective-Adverb';
    case 26 :
      return 'Noun-Noun Phrase';
  }
}