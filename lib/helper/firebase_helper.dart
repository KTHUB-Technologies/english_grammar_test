import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper{
  static final  fireBaseAuth = FirebaseAuth.instance;
  static final fireStoreReference = FirebaseFirestore.instance;
}