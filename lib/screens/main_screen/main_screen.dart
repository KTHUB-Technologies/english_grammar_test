import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_logo.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/level_screen.dart';
import 'package:the_enest_english_grammar_test/screens/setting_screen/setting_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final UserController userController = Get.find();
  final MainController levelController = Get.find();
  final AppController appController = Get.find();

  @override
  void initState() {
    levelController.categories = [];
    levelController.distinctCategory = [];
    super.initState();
    firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingContainer(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(
            child: Row(
              children: [
                _buildLevelNavigationRail(),
                Expanded(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: AppColors.gradientColorPrimary)),
                            height: getScreenHeight(context) / 2,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(70))),
                              height: getScreenHeight(context) / 2,
                              child: Center(
                                child: AppLogo(),
                              )),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            color: AppColors.white,
                            height: getScreenHeight(context) / 2,
                          ),
                          Container(
                            height: getScreenHeight(context) / 2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: AppColors.gradientColorPrimary),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(70))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: AppText(
                                    text: getLevelDescription(
                                        levelController.levelSelected.value + 1,
                                        context),
                                    textAlign: TextAlign.left,
                                    color: AppColors.white,
                                    textSize: Dimens.paragraphHeaderTextSize,
                                  ),
                                ),
                                Dimens.height10,
                                Container(
                                  child: Center(
                                      child: _buildSelectedContent(
                                          levelController.levelSelected.value +
                                              1)),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        isLoading: levelController.isShowLoading.value,
        isShowIndicator: true,
      );
    });
  }

  _buildLevelNavigationRail() {
    return NavigationRail(
        backgroundColor: AppColors.white,
        minWidth: 55.0,
        groupAlignment: 0.0,
        selectedLabelTextStyle: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 14,
          letterSpacing: 1,
          decorationThickness: 2.0,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 13,
          letterSpacing: 0.8,
        ),
        selectedIndex: levelController.levelSelected.value,
        onDestinationSelected: (int index) {
          levelController.levelSelected.value = index;
        },
        labelType: NavigationRailLabelType.all,
        trailing: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: IconButton(
                  icon: userController.user.value == null
                      ? Icon(Icons.person)
                      : CircleAvatar(
                          child: AppText(
                              text: shortUserName(
                                  userController.user.value.displayName??'Unknown Name')),
                        ),
                  onPressed: () async {
                    // await appController.loginWithMicrosoft();
                    userController.user.value == null
                        ? _buildChooseLogin()
                        : showConfirmDialog(context,
                        title: 'WARNING!!!',
                        content: 'Do you want to LOG OUT?', confirm: () async {
                          await userController.logout();
                        }, cancel: () {
                          Get.back();
                        });

                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: IconButton(
                  icon: Icon(Icons.language),
                  onPressed: () async {
                    await _navigateToFacebookApp();
                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    _navigateToSettingScreen();
                  }),
            ),
            userController.user.value==null?Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: IconButton(
                  icon: Icon(Icons.warning,color: AppColors.red,),
                  onPressed: () {
                    showConfirmDialog(context,title: 'WARNING!!!', content: 'Log in to save your results', confirm: (){Get.back();});
                  }),
            ):SizedBox(),
          ],
        ),
        destinations: []..addAll(levelController.distinctLevel
            .map(
              (e) => NavigationRailDestination(
                  icon: SizedBox.shrink(),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Text(getLevel(e)),
                    ),
                  )),
            )
            .toList()));
  }

  _buildSelectedContent(int level) {
    return Column(
      children: [buildAppButtonLevel(level)],
    );
  }

  Widget buildAppButtonLevel(int level) {
    return
        // Stack(
        // children: <Widget>[
        AppButton(
      "Let's Start",
      onTap: () async {
        SoundsHelper.checkAudio(Sounds.touch);
        await levelController.loadQuestionFromLevel(level);
        levelController.categories =
            levelController.questions.map((e) => e.categoryId).toList();
        levelController.distinctCategory =
            levelController.categories.toSet().toList();
        levelController.distinctCategory.sort();

        Get.to(
            LevelScreen(
              level: level,
              isProgress: false,
            ),
            transition: Transition.rightToLeftWithFade,
            duration: Duration(milliseconds: 500));
      },
    );
  }

  _navigateToFacebookApp() async {
    if (Platform.isIOS) {
      if (await canLaunch('https://www.facebook.com/Enestcenter')) {
        await launch('https://www.facebook.com/Enestcenter',
            forceSafariVC: false);
      } else {
        if (await canLaunch('https://www.facebook.com/Enestcenter')) {
          await launch('https://www.facebook.com/Enestcenter');
        } else {
          throw 'Could not launch https://www.facebook.com/Enestcenter';
        }
      }
    } else {
      const url = 'https://www.facebook.com/Enestcenter';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  _navigateToSettingScreen() async {
    Get.to(SettingScreen());
  }

  firstLoad() async {
    final openBox = await Hive.openBox('First_Load');
    await openBox.put('isFirst', true);
    openBox.close();
  }

  _buildChooseLogin() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: AppColors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (Platform.isIOS)
                  SignInButton(
                    Buttons.Apple,
                    onPressed: () async {
                      try{
                        await userController.signInWithApple();
                        Get.back();
                      }catch (e){
                        print(e);
                      }
                    },
                  ),
                SignInButton(Buttons.Facebook, onPressed: () async {
                  try{
                    await userController.signInWithFacebook();
                    Get.back();
                  }catch (e){
                    print(e);
                  }
                }),
                SignInButton(Buttons.Google, onPressed: () async {
                  try{
                    await userController.signInWithGoogle();
                    Get.back();
                  }catch (e){
                    print(e);
                  }
                }),
              ],
            ),
          );
        });
  }
}
