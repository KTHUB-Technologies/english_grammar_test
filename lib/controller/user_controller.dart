import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/helper/firebase_helper.dart';

class UserController extends GetxController{
  Rx<bool> isShowLoading = Rx<bool>(false);
  Rx<Map> user = Rx<Map>(null);
  final GoogleSignIn googleSignIn=GoogleSignIn(scopes: ['email']);
  final FacebookLogin facebookLogin=FacebookLogin();

  ///Login with GOOGLE
  signInWithGoogle() async{
    try{
      isShowLoading.value=true;
      final googleSignInAccount =await googleSignIn.signIn();
      if(googleSignIn.currentUser==null){
        isShowLoading.value=false;
        return false;
      }
      else{
        user.value={'id':googleSignInAccount.id,'name':googleSignInAccount.displayName};
        getDataScore(user.value['id']);

        print(user.value);
        isShowLoading.value=false;
      }
    }
    catch(err){
      print(err);
    }
  }


  ///Login with FACEBOOK
  signInWithFaceBook() async{
    final FacebookLoginResult result=await facebookLogin.logIn(['email']);

    switch(result.status){
      case FacebookLoginStatus.loggedIn:
        isShowLoading.value=true;
        final String token=result.accessToken.token;
        final graphResponse = await Dio().get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        Map facebookUser = jsonDecode(graphResponse.toString());
        user.value={'id':facebookUser['id'],'name':facebookUser['name']};
        getDataScore(user.value['id']);

        print(user.value);
        isShowLoading.value=false;
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }


  ///Log Out
  logout() async {
    isShowLoading.value = true;
    await FireBaseHelper.fireBaseAuth.signOut();
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    user.value=null;
    isShowLoading.value = false;
  }

  ///Login with APPLE ID
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
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
    user.value={'id':userApple.user.uid,'name':userApple.user.email};
    getDataScore(user.value['id']);

    print(user.value);
  }

  ///Fire store
  setDataScore(String userId) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS_SCORES).doc(userId).set({'scores':[]});
  }

  getDataScore(String userId) async{
    DocumentSnapshot doc = await FireBaseHelper.fireStoreReference
        .collection(Constants.USERS_SCORES)
        .doc(userId)
        .get();
    if(doc.data()==null){
      setDataScore(userId);
    }
  }

  updateDataScore(String userId, var data) async{
    await FireBaseHelper.fireStoreReference.collection(Constants.USERS_SCORES).doc(userId).update(data);
  }
}