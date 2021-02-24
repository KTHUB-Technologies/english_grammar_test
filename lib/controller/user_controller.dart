import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/helper/firebase_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/user_model.dart';

class UserController extends GetxController{
  Rx<bool> isShowLoading = Rx<bool>(false);
  Rx<User> user = Rx<User>(null);

  ///Login with GOOGLE
  signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var userGoogle= await FirebaseAuth.instance.signInWithCredential(credential);

    user.value=userGoogle.user;
    UserInfo userInfo=user.value.providerData.first;
    getDataUser(user.value.uid,email: userInfo.email, displayName: userInfo.displayName, phoneNumber: userInfo.phoneNumber, providerNumber: getProviderNumber(userInfo.providerId));
  }


  ///Login with FACEBOOK
  signInWithFacebook() async {
    final AccessToken accessToken = await FacebookAuth.instance.login();
    final FacebookAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(accessToken.token);
    var userFacebook= await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    user.value=userFacebook.user;
    print(user.value);
    UserInfo userInfo=user.value.providerData.first;
    getDataUser(user.value.uid,email: userInfo.email, displayName: userInfo.displayName, phoneNumber: userInfo.phoneNumber, providerNumber: getProviderNumber(userInfo.providerId));
  }


  ///Log Out
  logout() async {
    isShowLoading.value = true;

    await FireBaseHelper.fireBaseAuth.signOut();
    user.value=null;
    isShowLoading.value = false;
  }

  ///Login with APPLE ID
  String generateNonce([int length = 32]) {
    final charset = Constants.CHARSET;
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    var userApple = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    user.value=userApple.user;
    UserInfo userInfo=user.value.providerData.first;
    getDataUser(user.value.uid,email: userInfo.email, displayName: userInfo.displayName, phoneNumber: userInfo.phoneNumber, providerNumber: getProviderNumber(userInfo.providerId));
  }

  ///Fire store
  ///User
  getDataUser(String uid, {String email, String displayName, String phoneNumber, num providerNumber}) async{
    DocumentSnapshot doc=await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).get();
    if(doc.data()==null) {
      num numberUser=await getNumberUser();
      addDataUser(uid, email, displayName, phoneNumber, providerNumber,numberUser);
    }else
      print('Already Exist Information!!!');
  }

  addDataUser(String uid, String email, String displayName, String phoneNumber, num providerNumber,num numberUser) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).set({'email': email, 'displayName': displayName, 'phoneNumber': phoneNumber, 'providerNumber': providerNumber,'numberUser':numberUser+1 });
  }

  getNumberUser() async{
    QuerySnapshot snapshot= await FireBaseHelper.fireStoreReference.collection(Constants.USERS).orderBy('numberUser').get();
    if(snapshot.docs.isEmpty)
      return 0;
    else{
      List<UserApp> listUser =snapshot.docs.map((e) => UserApp.fromJson(e.data())).toList();
      UserApp userLast=listUser.last;
      return userLast.numberUser;
    }
  }

  ///Scores
  setDataScore(String uid) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('ALL_SCORES').set({'scores':{}});
  }

  getDataScore(String uid) async{
    DocumentSnapshot doc = await FireBaseHelper.fireStoreReference
        .collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('ALL_SCORES')
        .get();
    if(doc.data()==null){
      await setDataScore(uid);
    }else{
      if(doc.data()['scores']!=null)
        return doc.data()['scores'];
      else
        return {};
    }
  }

  updateDataScore(String uid, var data) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('ALL_SCORES').update(data);
  }

  deleteDataScore(String uid, var data) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('ALL_SCORES').update(data);
  }

  ///Questions
  setDataQuestion(String uid) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('ALL_QUESTIONS').set({'questions':{}});
  }

  getDataQuestion(String uid) async{
    DocumentSnapshot doc = await FireBaseHelper.fireStoreReference
        .collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('ALL_QUESTIONS')
        .get();
    if(doc.data()==null){
      await setDataQuestion(uid);
    }else{
      if(doc.data()['questions']!=null)
        return doc.data()['questions'];
      else
        return {};
    }
  }

  updateDataQuestion(String uid, var data) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('ALL_QUESTIONS').update(data);
  }

  deleteDataQuestion(String uid, var data) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('ALL_QUESTIONS').update(data);
  }

  ///Favorites
  setDataFavorite(String uid) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('FAVORITES').set({'favorites':[]});
  }

  getDataFavorite(String uid) async{
    DocumentSnapshot doc = await FireBaseHelper.fireStoreReference
        .collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('FAVORITES')
        .get();
    if(doc.data()==null){
      await setDataFavorite(uid);
    }else{
      if(doc.data()['favorites']!=null)
        return doc.data()['favorites'];
      else
        return [];
    }
  }

  updateDataFavorite(String uid, var data) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('FAVORITES').update(data);
  }

  deleteDataFavorite(String uid, var data) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS).doc(uid).collection(Constants.DATA).doc('FAVORITES').update(data);
  }
}