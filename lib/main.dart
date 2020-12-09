import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_enest_english_grammar_test/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {

    runApp(EnglishGrammarTestApp());
  });
}