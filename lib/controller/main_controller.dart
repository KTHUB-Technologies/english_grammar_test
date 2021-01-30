import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/helper/firebase_helper.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';

class MainController extends GetxController {
  ///SECTION
  List<int> sections = [1, 2];
  RxList<bool> selected = RxList<bool>([true, false]);
  Rx<int> sectionSelected = Rx<int>(0);

  ///JSON DATA
  RxList<Question> questions = RxList<Question>([]);

  List<int> categories = List<int>();
  List<int> distinctCategory = List<int>();

  List<int> levels = List<int>();
  List<int> distinctLevel = List<int>();
  RxInt levelSelected = RxInt(0);

  RxList<Question> containFromFavorite = RxList<Question>([]);

  RxList<Question> questionsFromCategory = RxList<Question>([]);
  RxList<List<Question>> listChunkQuestions = RxList<List<Question>>([]);
  List<Question> listQuestions = List<Question>();
  Rx<int> index = Rx<int>(0);
  Rx<int> currentTrue = Rx<int>(0);
  Rx<bool> isShowLoading = Rx<bool>(false);
  RxList<Widget> answers = RxList<Widget>([]);
  RxList<Question> questionsFromHive = RxList<Question>([]);
  RxList<Question> questionsHiveFavorite = RxList<Question>([]);

  Rx<Map> score = Rx<Map>({});

  Rx<Map> scoreOfCate = Rx<Map>({});

  Future loadJson() async {
    isShowLoading.value = true;
    var data =
        await rootBundle.loadString('lib/res/strings/Question_Data.json');
    var result = jsonDecode(data);
    listQuestions = result.map<Question>((e) => Question.fromJson(e)).toList();
  }

   loadQuestionFromLevel(int level) async {
  //  isShowLoading.value = true;
    questions =
        RxList<Question>(listQuestions.where((f) => f.level == level).toList());
    //isShowLoading.value = false;
  }

  Future loadQuestionFromLevelAndCategory(int level, int categoryId) async {
    isShowLoading.value = true;
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

      ///Merge last test to previous test if total questions less than 10

      if (listChunkQuestions.length >= 2 &&
          listChunkQuestions.last.length < 10) {
        listChunkQuestions
            .elementAt(listChunkQuestions.length - 2)
            .addAll(listChunkQuestions.last);
        listChunkQuestions.removeLast();
      }
    }
    isShowLoading.value = false;
  }


  ///Load data from firebase

  RxList<ListQuestion> questionsFromFirebase = RxList<ListQuestion>([]);

  getAllQuestions() async {
    final openBox = await Hive.openBox("Questions");

    if (openBox.get('AllQuestions') != null) {
      print('-----------> local');
      List<dynamic> allQues = openBox.get('AllQuestions');

      listQuestions = allQues.map((e) => Question.fromJson(e)).toList();
    } else {
      print('-----------> firebase');
      await loadJson();
      QuerySnapshot data = await FireBaseHelper.fireStoreReference
          .collection(Constants.QUESTIONS_DATA)
          .get();

      for (var i in data.docs) {
        questionsFromFirebase.add(ListQuestion.fromJson(i.data()));
      }

      questionsFromFirebase
          .map((element) => element.questions.forEach((ques) {
                listQuestions.add(ques);
              }))
          .toList();

      var allQuestion = listQuestions.map((e) => e.toJson()).toList();

      await openBox.put('AllQuestions', allQuestion);
    }

    openBox.close();

    loadQuestions();
  }

  loadQuestions() {
    levels = listQuestions.map((e) => e.level).toList();
    distinctLevel = levels.toSet().toList();
    distinctLevel.sort();
    isShowLoading.value = false;
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
