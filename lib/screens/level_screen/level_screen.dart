
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/animted_list.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/ios_dialog.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/screens/question_screen/question_screen.dart';
import 'package:the_enest_english_grammar_test/screens/setting_screen/setting_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class LevelScreen extends StatefulWidget {
  final int level;
  final bool isProgress;
  const LevelScreen({Key key, this.level, this.isProgress}) : super(key: key);
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final LevelController levelController = Get.find();
  final AppController appController= Get.put(AppController());
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Obx((){
        return Scaffold(
          appBar: AppBar(
            title: AppText(
              text:
              widget.isProgress == false ? getLevel(widget.level) : 'PROGRESS',
              textSize: Dimens.paragraphHeaderTextSize,
              color: AppColors.white,
            ),
            actions: <Widget>[
              PopupMenuButton(
                  onSelected: choiceAction,
                  itemBuilder: (context) {
                    return Constants.choices.map((e) {
                      return PopupMenuItem(
                        value: e,
                        child: ListTile(
                          title: AppText(
                            text: e,
                            color: AppColors.blue,
                          ),
                        ),
                      );
                    }).toList();
                  }),
            ],
            bottom: TabBar(
              labelColor: AppColors.blue,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: appController.isDark.value==false?AppColors.white:AppColors.divider),
              tabs: [
                Tab(
                  text: 'TOPIC',
                ),
                Tab(
                  text: 'MIXED',
                ),
              ],
            ),
          ),
          body: Obx(() {
            return LoadingContainer(
              child: TabBarView(children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      widget.isProgress == false
                          ? SizedBox()
                          : Column(
                        children: <Widget>[
                          Container(child: AppText(text: getLevel(widget.level),fontWeight: FontWeight.bold,),padding: EdgeInsets.symmetric(vertical: 15),),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.formPadding,vertical: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Delete All At This Level',
                                    style: TextStyle(
                                      color: AppColors.red,
                                      fontSize: Dimens.paragraphHeaderTextSize,
                                    ),
                                  ),),
                                GestureDetector(
                                  child: Icon(Icons.delete,color: AppColors.red,),
                                  onTap: () {
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return IOSDialog(
                                            title: 'WARNING',
                                            content:
                                            "Do you want to reset all question in this level?",
                                            cancel: () {
                                              Get.back();
                                            },
                                            confirm: () async {
                                              Get.offAll(
                                                  MainScreen());

                                              final openBox =
                                              await Hive.openBox(
                                                  'Table_${widget.level}');
                                              openBox
                                                  .deleteFromDisk();
                                              openBox.close();

                                              final openBoxScore =
                                              await Hive.openBox(
                                                  'Table_Score_${widget.level}');
                                              openBoxScore
                                                  .deleteFromDisk();
                                              openBoxScore.close();
                                            },
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: ListView(
                        children: levelController.distinctCategory.map((e) {
                          return WidgetAnimator(
                            FutureBuilder(
                                future: getScoreOfCate(e),
                                builder: (context, snapshot) {
                                  return buildListCategories(
                                      context,
                                      e,
                                      widget.isProgress == false
                                          ? () async {
                                        await levelController
                                            .loadQuestionFromLevelAndCategory(
                                            widget.level, e);
                                        modalBottomSheet(
                                            getCategory(e),
                                            widget.level,
                                            e);
                                      }
                                          : () {},
                                      Rx<double>(snapshot.data));
                                }),
                          );
                        }).toList(),
                      ),),
                    ],
                  ),
                ),
                Center(child: AppText(text: 'COMING SOON',color: AppColors.blue,)),
              ]),
              isLoading: levelController.isShowLoading.value,
            );
          }),
        );
      }),
    );
  }

  Widget buildListCategories(
      BuildContext context, int index, Function onTap, Rx<double> score) {
    return Obx(() {
      return GestureDetector(
        child: Card(
          child: Container(
            height: getScreenHeight(context) / 15,
            padding: EdgeInsets.symmetric(horizontal: Dimens.formPadding),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AppText(
                    text: getCategory(index),
                    color: AppColors.blue,
                  ),
                ),
                Dimens.width20,
                AppText(
                  text:
                      'Score: ${score.value == null || score.value.toString() == 'NaN' ? 0 : score.value.round()}%',
                  color: AppColors.blue,
                ),
                Dimens.width20,
                widget.isProgress == false
                    ? SizedBox()
                    : GestureDetector(
                        child: Icon(
                          Icons.rotate_left,
                          color: score.value == null ||
                                  score.value.toString() == 'NaN'
                              ? AppColors.divider
                              : AppColors.green,
                        ),
                        onTap: score.value.toString() != 'NaN' &&
                                score.value != null
                            ? () {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return IOSDialog(
                                        title: 'WARNING',
                                        content:
                                            "Do you want to restart ${getCategory(index)}?",
                                        cancel: () {
                                          Get.back();
                                        },
                                        confirm: () async {
                                          Get.back();

                                          final openBox = await Hive.openBox(
                                              'Table_${widget.level}');
                                          openBox.put('$index', null);
                                          openBox.close();

                                          final openBoxScore =
                                              await Hive.openBox(
                                                  'Table_Score_${widget.level}');
                                          openBoxScore.put(
                                              '${widget.level}_$index', null);
                                          openBoxScore.close();

                                          score.value = null;
                                        },
                                      );
                                    });
                              }
                            : () {},
                      ),
              ],
            ),
          ),
        ),
        onTap: () async {
          SoundsHelper.checkAudio(Sounds.touch);
          onTap();
        },
      );
    });
  }

  Future<double> getScoreOfCate(int index) async {
    double score = 0;
    Map scoreCate = new Map();
    int length = 0;
    final openBox = await Hive.openBox('Table_Score_${widget.level}');
    if (openBox.get('${widget.level}_$index') != null) {
      scoreCate.addAll(openBox.get('${widget.level}_$index'));
      scoreCate.forEach((key, value) {
        List<String> split = value.toString().split('_');
        if ((double.tryParse(split[0]) / double.tryParse(split[1]))
                .toString() !=
            'NaN') {
          score +=
              (double.tryParse(split[0]) / double.tryParse(split[1])) * 100;
          length++;
        }
      });
    }
    return score / length;
  }

  modalBottomSheet(String cateName, int level, int categoryId) async {
    levelController.score.value.clear();
    final openBox = await Hive.openBox('Table_Score_${widget.level}');
    if (openBox.containsKey('$level' '_' '$categoryId')) {
      if (openBox.get('$level' '_' '$categoryId') != null) {
        levelController.score.value
            .addAll(openBox.get('$level' '_' '$categoryId'));
      } else {
        levelController.score.value.clear();
      }
    } else {
      levelController.score.value.clear();
    }
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ModalBottomSheet(
            categoryName: cateName,
            level: level,
            categoryId: categoryId,
          );
        });
  }

  choiceAction(String choice) async {
    if (choice == 'Favorite') {
      bool exist = await HiveHelper.isExists(boxName: 'Table_Favorite');
      if (exist) {
        print('-----------------------------------------');
        levelController.questionsHiveFavorite =
            RxList<Question>(await HiveHelper.getBoxes('Table_Favorite'));
      }
      Get.to(QuestionScreen(
        question: levelController.questionsHiveFavorite,
        isFavorite: true,
      ),transition: Transition.fadeIn,duration: Duration(milliseconds: 500));
    } else if (choice == 'Progress') {
      Get.back();
      Get.to(LevelScreen(
        level: widget.level,
        isProgress: true,
      ),transition: Transition.rightToLeftWithFade,duration: Duration(milliseconds: 500));
    } else if(choice=='Settings')setState(() {
      Get.to(SettingScreen(),transition: Transition.rightToLeftWithFade,duration: Duration(milliseconds: 500));
    });
  }
}

class ModalBottomSheet extends StatefulWidget {
  final int level;
  final int categoryId;
  final String categoryName;

  const ModalBottomSheet(
      {Key key, this.level, this.categoryId, this.categoryName})
      : super(key: key);
  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final LevelController levelController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppText(
              text: widget.categoryName,
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
              textSize: Dimens.paragraphHeaderTextSize,
            ),
            Dimens.height10,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: levelController.listChunkQuestions.map((e) {
                double scorePercent;
                if (levelController.score.value[
                        '${levelController.listChunkQuestions.indexOf(e) + 1}'] !=
                    null) {
                  List<String> splitScore =
                      '${levelController.score.value['${levelController.listChunkQuestions.indexOf(e) + 1}']}'
                          .split('_');
                  scorePercent = (double.tryParse(splitScore[0]) /
                          double.tryParse(splitScore[1])) *
                      100;
                }
                return GestureDetector(
                  child: Card(
                    child: ListTile(
                      title: AppText(
                        text:
                            'Test ${levelController.listChunkQuestions.indexOf(e) + 1}',
                      ),
                      trailing: AppText(
                          text:
                              'Score: ${scorePercent == null || scorePercent.isNaN ? 0 : scorePercent.round()} %'),
                    ),
                  ),
                  onTap: () async {
                    Get.back();
                    levelController.questionsHiveFavorite = RxList<Question>(
                        await HiveHelper.getBoxes('Table_Favorite'));
                    await checkExistTable(
                        levelController.listChunkQuestions.indexOf(e) + 1);
                    Get.to(QuestionScreen(
                      level: widget.level,
                      categoryId: widget.categoryId,
                      // ignore: deprecated_member_use
                      question: levelController.questionsFromHive.isNullOrBlank
                          ? RxList<Question>(e)
                          : levelController.questionsFromHive,
                      testNumber:
                          levelController.listChunkQuestions.indexOf(e) + 1,
                      isFavorite: false,
                      questionTemp: RxList<Question>(e),
                    ),transition: Transition.fadeIn,duration: Duration(milliseconds: 500));
                  },
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  checkExistTable(int testNumber) async {
    final openBox = await Hive.openBox('Table_${widget.level}');
    if (openBox.containsKey('${widget.categoryId}')) {
      Map getCate = openBox.get('${widget.categoryId}');
      if (getCate != null) {
        List<dynamic> questions = getCate['$testNumber'];
        if (questions != null) {
          levelController.questionsFromHive = RxList<Question>(
              questions.map((e) => Question.fromJson(e)).toList());
        } else {
          levelController.questionsFromHive.clear();
        }
      }
    } else {
      levelController.questionsFromHive.clear();
    }
    openBox.close();
  }
}
