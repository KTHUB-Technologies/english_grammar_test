import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:firebase_core/firebase_core.dart';

class FireBaseHelper {
  static final initializeFirebase = Firebase.initializeApp();
  static final fireBaseAuth = FirebaseAuth.instance;
  static final fireStoreReference = FirebaseFirestore.instance;
  static final fireStoreSetMerge = SetOptions(merge: true);
  static final fireBaseAuthOath = FirebaseAuthOAuth();
  static final loginWithMicrosoft = fireBaseAuthOath.linkExistingUserWithCredentials("microsoft.com", ["user.read"],{"tenant": "351983a7-160f-4e5b-8100-6518447a1937",
    "clientId": "0900e203-5228-495b-8b46-772bcd81d2bf",});
}
