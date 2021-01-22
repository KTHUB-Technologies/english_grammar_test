
import 'package:get/get.dart';
import 'package:hive/hive.dart';
part 'question_model.g.dart';

@HiveType(typeId: 0)
class Question extends HiveObject{
  @HiveField(0)
  final int categoryId;
  @HiveField(1)
  final String categoryName;
  @HiveField(2)
  final int correctAnswer;
  @HiveField(3)
  final String explanation;
  @HiveField(4)
  final String explanationVi;
  @HiveField(5)
  final String groupId;
  @HiveField(6)
  final int id;
  @HiveField(7)
  final int level;
  @HiveField(8)
  final String options;
  @HiveField(9)
  final String task;
  @HiveField(10)
  Rx<int> currentChecked;

  Question({this.categoryId,this.categoryName,this.correctAnswer,this.explanation,this.explanationVi,this.groupId,this.id,this.level,this.options,this.task,this.currentChecked});

  Question.fromJson(Map<dynamic,dynamic>json):
        categoryId=json['categoryId'],
        categoryName=json['categoryName'],
        correctAnswer=json['correctAnswer'],
        explanation=json['explanation'],
        explanationVi=json['explanationVi'],
        groupId=json['groupId'],
        id=json['id'],
        level=json['level'],
        options=json['options'],
        task=json['task'],
        currentChecked=Rx<int>(json['currentChecked']);

  Map<dynamic, dynamic> toJson()=>{
    'categoryId':categoryId,
    'categoryName':categoryName,
    'correctAnswer':correctAnswer,
    'explanation':explanation,
    'explanationVi':explanationVi,
    'groupId':groupId,
    'id':id,
    'level':level,
    'options':options,
    'task':task,
    'currentChecked':int.tryParse(currentChecked.toString())
  };
}

// abstract class Model{
//   int id;
//   static fromMap(){}
//   toMap(){}
// }
//
// class Level extends Model{
//   static String table="level";
//
//   int id;
//   String nameLevel;
//
//   Level({this.id, this.nameLevel});
//
//   Map<String,dynamic> toMap(){
//     Map<String,dynamic> map={
//       'id':id,
//       'nameLevel':nameLevel
//     };
//     if(id!=null)
//       map['id']=id;
//     return map;
//   }
//
//   static Level fromMap(Map<String, dynamic>map){
//     return Level(
//       id: map['id'],
//       nameLevel: map['nameLevel']
//     );
//   }
// }
//
// class Topic extends Model{
//   static String table="topic";
//
//   int id;
//   int idLevel;
//   String nameTopic;
//
//   Topic({this.id,this.idLevel,this.nameTopic});
//
//   Map<String,dynamic> toMap(){
//     Map<String, dynamic> map={
//       'id':id,
//       'idLevel':idLevel,
//       'nameTopic':nameTopic,
//     };
//     if(id!=null)
//       map['id']=id;
//     return map;
//   }
//
//   static Topic fromMap(Map<String, dynamic>map){
//     return Topic(
//       id: map['id'],
//       idLevel: map['idLevel'],
//       nameTopic: map['nameTopic'],
//     );
//   }
// }
//
// class General extends Model{
//   static String table='general';
//
//   int id;
//   int idLevel;
//   String nameGeneral;
//   num rate;
//
//   General({this.id,this.idLevel,this.nameGeneral,this.rate});
//
//   Map<String, dynamic> toMap(){
//     Map<String, dynamic> map={
//       'id':id,
//       'idLevel':idLevel,
//       'nameGeneral':nameGeneral,
//       'rate':rate,
//     };
//     if(id!=null)
//       map['id']=id;
//     return map;
//   }
//
//   static General fromMap(Map<String, dynamic>map){
//     return General(
//       id: map['id'],
//       idLevel: map['idLevel'],
//       nameGeneral: map['nameGeneral'],
//       rate: map['rate'],
//     );
//   }
// }
//
// class QuestionFromTopic extends Model{
//   static String table="questionFromTopic";
//
//   int id;
//   int idTopic;
//   String question;
//   String correctAnswer;
//   String wrongAnswerA;
//   String wrongAnswerB;
//   String wrongAnswerC;
//   String explain;
//   Rx<String> checkedAnswer;
//
//   QuestionFromTopic({this.id,this.idTopic,this.question,this.correctAnswer,this.wrongAnswerA,this.wrongAnswerB,this.wrongAnswerC,this.explain,this.checkedAnswer});
//
//   Map<String,dynamic> toMap(){
//     Map<String,dynamic> map={
//       'id':id,
//       'idTopic':idTopic,
//       'question':question,
//       'correctAnswer': correctAnswer,
//       'wrongAnswerA': wrongAnswerA,
//       'wrongAnswerB': wrongAnswerB,
//       'wrongAnswerC': wrongAnswerC,
//       'explain':explain,
//     };
//     if(id!=null)
//       map['id']=id;
//     return map;
//   }
//
//   static QuestionFromTopic fromMap(Map<String, dynamic>map){
//     return QuestionFromTopic(
//       id: map['id'],
//       idTopic: map['idTopic'],
//       question: map['question'],
//       correctAnswer: map['correctAnswer'],
//       wrongAnswerA: map['wrongAnswerA'],
//       wrongAnswerB: map['wrongAnswerB'],
//       wrongAnswerC: map['wrongAnswerC'],
//       explain: map['explain'],
//       checkedAnswer: Rx<String>(map['checkedAnswer'])
//     );
//   }
// }
//
// class QuestionFromGeneral extends Model{
//   static String table="questionFromGeneral";
//
//   int id;
//   int idGeneral;
//   String question;
//   String correctAnswer;
//   String wrongAnswerA;
//   String wrongAnswerB;
//   String wrongAnswerC;
//   String explain;
//   Rx<String> checkedAnswer;
//
//   QuestionFromGeneral({this.id,this.idGeneral,this.question,this.correctAnswer,this.wrongAnswerA,this.wrongAnswerB,this.wrongAnswerC,this.explain,this.checkedAnswer});
//
//   Map<String,dynamic> toMap(){
//     Map<String,dynamic> map={
//       'id':id,
//       'idGeneral':idGeneral,
//       'question':question,
//       'correctAnswer': correctAnswer,
//       'wrongAnswerA': wrongAnswerA,
//       'wrongAnswerB': wrongAnswerB,
//       'wrongAnswerC': wrongAnswerC,
//       'explain':explain,
//     };
//     if(id!=null)
//       map['id']=id;
//     return map;
//   }
//
//   static QuestionFromGeneral fromMap(Map<String, dynamic>map){
//     return QuestionFromGeneral(
//         id: map['id'],
//         idGeneral: map['idGeneral'],
//         question: map['question'],
//         correctAnswer: map['correctAnswer'],
//         wrongAnswerA: map['wrongAnswerA'],
//         wrongAnswerB: map['wrongAnswerB'],
//         wrongAnswerC: map['wrongAnswerC'],
//         explain: map['explain'],
//         checkedAnswer: Rx<String>(map['checkedAnswer'])
//     );
//   }
// }
