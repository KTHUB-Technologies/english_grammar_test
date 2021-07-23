import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_enest_english_grammar_test/app/app.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    await Firebase.initializeApp();
    Directory directory= await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    print(directory.path);
    Hive.registerAdapter(QuestionAdapter());

    runApp(EnglishGrammarTestApp());
  });
}
