
import 'package:hive/hive.dart';

class HiveHelper{

  static isExists({String boxName}) async {
    bool exists=await Hive.boxExists(boxName);
    if(exists)
      return true;
    else
      return false;
  }

  static addBoxes<Question>(List<Question> items, String boxName) async {
    print("adding boxes");
    final openBox = await Hive.openBox(boxName);
    openBox.clear();
    for (var item in items) {
      openBox.add(item);
    }
  }

  static getBoxes<Question>(String boxName) async {
    List<Question> boxList = List<Question>();

    final openBox = await Hive.openBox(boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }

    return boxList;
  }
}