import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserApp extends HiveObject{
  @HiveField(0)
  final User user;

  UserApp({this.user});

  UserApp.fromJson(Map<dynamic,dynamic>json):
        user=json['user']??'';

  Map<dynamic, dynamic> toJson()=>{
    'user':user??null
  };
}