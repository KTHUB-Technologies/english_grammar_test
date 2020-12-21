import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiver/iterables.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';

class LevelController extends GetxController {
  ///JSON DATA
  RxList<Question> questions = RxList<Question>([]);

  List<int> categories = List<int>();
  List<int> distinctCategory = List<int>();

  List<int> levels = List<int>();
  List<int> distinctLevel = List<int>();

  RxList<Question> questionsFromCategory = RxList<Question>([]);
  RxList<List<Question>> listChunkQuestions = RxList<List<Question>>([]);
  List<Question> listQuestions;
  Rx<int> index = Rx<int>(0);
  Rx<bool> isShowLoading = Rx<bool>(false);
  RxList<Widget> answers = RxList<Widget>([]);
  RxList<Question> questionsFromHive = RxList<Question>([]);

  Future loadJson() async {
    isShowLoading.value = true;
    var data =
        await rootBundle.loadString('lib/res/strings/Question_Data.json');
    var result = jsonDecode(data);
    listQuestions = result.map<Question>((e) => Question.fromJson(e)).toList();

    levels = listQuestions.map((e) => e.level).toList();
    distinctLevel = levels.toSet().toList();
    distinctLevel.sort();

    isShowLoading.value = false;
  }

  Future loadQuestionFromLevel(int level) async {
    await loadJson();
    questions =
        RxList<Question>(listQuestions.where((f) => f.level == level).toList());
  }

  Future loadQuestionFromLevelAndCategory(int level, int categoryId) async {
    await loadQuestionFromLevel(level);

    questionsFromCategory = RxList<Question>(
        questions.where((c) => c.categoryId == categoryId).toList());
    questionsFromCategory.sort((a, b) => a.id.compareTo(b.id));
    listChunkQuestions.clear();

    for (var i = 0; i < questionsFromCategory.length; i += 20) {
      listChunkQuestions.add(questionsFromCategory.sublist(
          i,
          i + 20 > questionsFromCategory.length
              ? questionsFromCategory.length
              : i + 20));
    }
  }

  // RxList<Widget> answers = RxList<Widget>([]);
  // Rx<int> index = Rx<int>(0);
  //
  // ///SQFLite DATA
  // ///Level
  // RxList<Level> levels = RxList<Level>();
  //
  // fetchLevel() async {
  //   try {
  //     List<Map<dynamic, dynamic>> _result =
  //         await DatabaseHelper.queryLevel(Level.table);
  //     levels =
  //         RxList<Level>(_result.map((level) => Level.fromMap(level)).toList());
  //   } catch (_) {}
  // }
  //
  // insertLevel(String nameLevel) async {
  //   Level level = Level(nameLevel: nameLevel);
  //   await DatabaseHelper.insert(Level.table, level);
  //   await fetchLevel();
  // }
  //
  // ///Topic
  // RxList<Topic> topics = RxList<Topic>();
  //
  // fetchTopic(Model model) async {
  //   try {
  //     List<Map<dynamic, dynamic>> _result =
  //         await DatabaseHelper.queryTopic(Topic.table, model);
  //     topics =
  //         RxList<Topic>(_result.map((topic) => Topic.fromMap(topic)).toList());
  //   } catch (_) {}
  // }
  //
  // insertLesson(String nameLesson, int idLevel, Model model) async {
  //   Lesson lesson = Lesson(idLevel: idLevel, nameLesson: nameLesson);
  //   await DatabaseHelper.insert(Lesson.table, lesson);
  //   await fetchLesson(model);
  // }
  //
  // ///Questions From Topic
  // RxList<QuestionFromTopic> questionsFromTopic = RxList<QuestionFromTopic>();
  //
  // fetchQuestionFromTopic(Model model) async {
  //   try {
  //     List<Map<dynamic, dynamic>> _result =
  //         await DatabaseHelper.queryQuestionFromTopic(
  //             QuestionFromTopic.table, model);
  //     questionsFromTopic = RxList<QuestionFromTopic>(_result
  //         .map((questionFromTopic) =>
  //             QuestionFromTopic.fromMap(questionFromTopic))
  //         .toList());
  //   } catch (_) {}
  // }
  //
  // insertQuestion(
  //     int idLesson,
  //     String content,
  //     String correctAnswer,
  //     String wrongAnswerA,
  //     String wrongAnswerB,
  //     String wrongAnswerC,
  //     Model model) async {
  //   Questions question = Questions(
  //     idLesson: idLesson,
  //     question: content,
  //     correctAnswer: correctAnswer,
  //     wrongAnswerA: wrongAnswerA,
  //     wrongAnswerB: wrongAnswerB,
  //     wrongAnswerC: wrongAnswerC,
  //   );
  //   await DatabaseHelper.insert(Questions.table, question);
  //   await fetchQuestion(model);
  // }
  //
  // ///General
  // RxList<General> generals = RxList<General>();
  //
  // fetchGeneral(Model model) async {
  //   try {
  //     List<Map<dynamic, dynamic>> _result =
  //         await DatabaseHelper.queryGeneral(General.table, model);
  //     generals = RxList<General>(
  //         _result.map((general) => General.fromMap(general)).toList());
  //   } catch (_) {}
  // }
  //
  // ///Questions From General
  // RxList<QuestionFromGeneral> questionsFromGeneral =
  //     RxList<QuestionFromGeneral>([]);
  // RxList<Widget> general = RxList<Widget>([]);
  //
  // fetchQuestionFromGeneral(Model model) async {
  //   try {
  //     List<Map<dynamic, dynamic>> _result =
  //         await DatabaseHelper.queryQuestionFromGeneral(
  //             QuestionFromGeneral.table, model);
  //     questionsFromGeneral = RxList<QuestionFromGeneral>(_result
  //         .map((questionFromGeneral) =>
  //             QuestionFromGeneral.fromMap(questionFromGeneral))
  //         .toList());
  //   } catch (_) {}
  // }
  //
  // ///Version
  // num dataLocalVersion;
  // num dataNewVersion;
  // Rx<Version> version = Rx<Version>();
  //
  // getVersion() async {
  //   DocumentSnapshot documentSnapshot = await FirebaseHelper.fireStoreReference
  //       .collection('VERSION')
  //       .doc('Version')
  //       .get();
  //   version.value = Version.fromMap(documentSnapshot.data());
  //   update();
  // }
  //
  // getNewDataVersion() async {
  //   DocumentSnapshot documentSnapshot = await FirebaseHelper.fireStoreReference
  //       .collection('VERSION')
  //       .doc('Version')
  //       .get();
  //   dataNewVersion = documentSnapshot.data()['version'];
  //   await SharedPreferencesHelper.saveIntValue(
  //       SharedPreferencesHelper.DATA_VERSION, dataNewVersion);
  // }
  //
  // getLocalDataVersion() async {
  //   dataLocalVersion = await SharedPreferencesHelper.getIntValue(
  //           SharedPreferencesHelper.DATA_VERSION) ??
  //       0;
  // }
}
