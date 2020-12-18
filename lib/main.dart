import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/app/app.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:the_enest_english_grammar_test/model/question_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {

    Directory directory=await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(QuestionAdapter());

    runApp(EnglishGrammarTestApp());
  });
}