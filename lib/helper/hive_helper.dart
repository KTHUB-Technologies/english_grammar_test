
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';

class HiveHelper{

  static isExists({String boxName}) async {
    bool exists=await Hive.boxExists(boxName);
    if(exists)
      return true;
    else
      return false;
  }

  static addBoxes(List<Map<dynamic,dynamic>> items, String boxName) async {
    print("adding boxes");
    final openBox = await Hive.openBox(boxName);
    for (var item in items) {
      await openBox.add(item);
    }
    openBox.close();
  }

  static getBoxes(String boxName) async {
    List<Question> boxList = List<Question>();

    final openBox = await Hive.openBox(boxName);

    boxList=openBox.values.map((e) => Question.fromJson(e)).toList();

    return boxList;
  }
}