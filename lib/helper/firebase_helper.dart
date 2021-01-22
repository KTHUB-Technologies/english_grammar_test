import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FireBaseHelper{
  static final initializeFirebase = Firebase.initializeApp();
  static final fireStoreReference = FirebaseFirestore.instance;
  static final fireStoreSetMerge = SetOptions(merge: true);
}