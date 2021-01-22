import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_enest_english_grammar_test/commons/animted_list.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/ios_dialog.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/constants/constants.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/level_screen/modal_bottom_sheet/modal_bottom_sheet.dart';
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
  final MainController mainController = Get.find();
  final AppController appController = Get.put(AppController());
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
    return Scaffold(
      body: Obx(() {
        return LoadingContainer(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: AppColors.gradientColorPrimary),
                        border: Border.all(width: 0, color: Colors.transparent),
                      ),
                    ),
                    _buildCategoryContent(mainController.sectionSelected.value)
                  ],
                ),
              )
            ],
          ),
          isLoading: mainController.isShowLoading.value,
        );
      }),
    );
  }

  _buildHeader() {
    return Stack(
      children: [
        Container(
          color: AppColors.white,
          height: getScreenHeight(context) / 4,
        ),
        Container(
          height: getScreenHeight(context) / 4,
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.transparent),
              gradient: LinearGradient(colors: AppColors.gradientColorPrimary),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70))),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: Dimens.formPadding),
            child: Column(
              children: [
                Dimens.height10,
                ListTile(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      if (!widget.isProgress) {
                        Navigator.pop(context);
                      } else {
                        Get.back();
                        Get.to(
                            LevelScreen(
                              level: widget.level,
                              isProgress: false,
                            ),
                            transition: Transition.rightToLeftWithFade,
                            duration: Duration(milliseconds: 500));
                      }
                    },
                  ),
                  title: AppText(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    textSize: Dimens.paragraphHeaderTextSize,
                    text: getLevel(widget.level),
                  ),
                  trailing: PopupMenuButton(
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
                ),
                _buildSectionTitle()
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildSectionTitle() {
    return ToggleButtons(
      children: mainController.sections
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppText(
                  text: getSection(e),
                  color: AppColors.white,
                ),
              ))
          .toList(),
      borderRadius: BorderRadius.circular(15),
      onPressed: (int index) {
          for (int buttonIndex = 0;
              buttonIndex < mainController.selected.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              mainController.selected[buttonIndex] = true;
            } else {
              mainController.selected[buttonIndex] = false;
            }
          }
          mainController.sectionSelected.value = index;
      },
      isSelected: mainController.selected,
    );
  }

  _buildCategoryContent(int sectionSelected) {
    switch (sectionSelected) {
      case 0:
        return Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.transparent),
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(70))),
          child: Column(
            children: [
              SizedBox(
                child: _buildProgress(),
                height: 54,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: mainController.distinctCategory.map((e) {
                    return WidgetAnimator(
                      FutureBuilder(
                          future: getScoreOfCate(e),
                          builder: (context, snapshot) {
                            return buildListCategories(
                                context,
                                e,
                                widget.isProgress == false
                                    ? () async {
                                        await mainController
                                            .loadQuestionFromLevelAndCategory(
                                                widget.level, e);

                                        modalBottomSheet(
                                            getCategory(e), widget.level, e);
                                      }
                                    : () {},
                                Rx<double>(snapshot.data));
                          }),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      case 1:
        return Container(
          height: getScreenHeight(context),
          width: getScreenWidth(context),
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.transparent),
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(70))),
          child: Center(
            child: AppText(
              text: "COMING SOON",
            ),
          ),
        );
      default:
        return Container(
          height: getScreenHeight(context),
          width: getScreenWidth(context),
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: Colors.transparent),
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(70))),
          child: Center(
            child: AppText(
              text: "Something wrong",
            ),
          ),
        );
    }
  }

  _buildProgress() {
    return widget.isProgress == false
        ? SizedBox()
        : Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Dimens.formPadding, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Delete All At This Level',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: Dimens.paragraphHeaderTextSize,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: AppColors.red,
                      ),
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
                                  Get.offAll(MainScreen());

                                  await restartLevel();
                                },
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ],
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
                CircularPercentIndicator(
                  radius: 35.0,
                  lineWidth: 2.0,
                  animation: true,
                  percent: score.value == null || score.value.toString() == 'NaN' ? 0 : score.value/100.round(),
                  center: new Text(
                    '${score.value == null || score.value.toString() == 'NaN' ? 0 : score.value.round()}%',
                    style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.purple,
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

                                          restartScoreOfCate(index, score);
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

  restartScoreOfCate(int index, Rx<double> score) async{
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
  }

  restartLevel() async{
    final openBox = await Hive.openBox(
        'Table_${widget.level}');
    openBox.deleteFromDisk();
    openBox.close();

    final openBoxScore = await Hive.openBox(
        'Table_Score_${widget.level}');
    openBoxScore.deleteFromDisk();
    openBoxScore.close();
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
    mainController.score.value.clear();
    final openBox = await Hive.openBox('Table_Score_${widget.level}');
    if (openBox.containsKey('$level' '_' '$categoryId')) {
      if (openBox.get('$level' '_' '$categoryId') != null) {
        mainController.score.value
            .addAll(openBox.get('$level' '_' '$categoryId'));
      } else {
        mainController.score.value.clear();
      }
    } else {
      mainController.score.value.clear();
    }
    showModalBottomSheet(
        backgroundColor: AppColors.transparent,
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
    switch(choice){
      case 'Favorite':
        bool exist = await HiveHelper.isExists(boxName: 'Table_Favorite');
        if (exist) {
          print('-----------------------------------------');
          mainController.questionsHiveFavorite =
              RxList<Question>(await HiveHelper.getBoxes('Table_Favorite'));
        }
        Get.to(
            QuestionScreen(
              question: mainController.questionsHiveFavorite,
              isFavorite: true,
            ),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 500));
        return;
      case 'Progress':
        if (!widget.isProgress) {
          Get.back();
          Get.to(
              LevelScreen(
                level: widget.level,
                isProgress: true,
              ),
              transition: Transition.rightToLeftWithFade,
              duration: Duration(milliseconds: 500));
        }
        return;
      case 'Settings':
        Get.to(SettingScreen(),
            transition: Transition.rightToLeftWithFade,
            duration: Duration(milliseconds: 500));
        return;
    }
  }
}
