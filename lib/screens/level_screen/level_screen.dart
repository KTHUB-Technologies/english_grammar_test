import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/assets/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/commons/loading_container.dart';
import 'package:the_enest_english_grammar_test/controller/level_controller.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/screens/question_screen/question_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class LevelScreen extends StatefulWidget {
  final int level;

  const LevelScreen({Key key, this.level}) : super(key: key);
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  final LevelController levelController = Get.find();
  final player = AudioCache();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: '${widget.level}',
          textSize: Dimens.paragraphHeaderTextSize,
          color: AppColors.white,
        ),
      ),
      body: Obx(() {
        return LoadingContainer(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                TabBar(
                  labelColor: AppColors.black,
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 3.0, color: AppColors.blue),
                    ),
                  ),
                  tabs: [
                    Tab(
                      text: 'TOPIC',
                    ),
                    Tab(
                      text: 'MIXED',
                    ),
                  ],
                ),
                Dimens.height10,
                Expanded(
                  child: TabBarView(children: [
                    ListView(children: <Widget>[
                      buildListCategories(context, 1, 'Cate 1', () async {
                        await levelController.loadQuestionFromLevelAndCategory(
                            widget.level, 1);
                        Get.to(QuestionScreen(level: widget.level));
                      }),
                      buildListCategories(context, 2, 'Cate 2', () async{
                        await levelController.loadQuestionFromLevelAndCategory(
                            widget.level, 2);
                        Get.to(QuestionScreen(level: widget.level));
                      }),
                      buildListCategories(context, 3, 'Cate 3', () async{
                        await levelController.loadQuestionFromLevelAndCategory(
                            widget.level, 3);
                        Get.to(QuestionScreen(level: widget.level));
                      }),
                      buildListCategories(context, 4, '', () {}),
                      buildListCategories(context, 5, '', () {}),
                      buildListCategories(context, 6, '', () {}),
                      buildListCategories(context, 7, '', () {}),
                      buildListCategories(context, 8, '', () {}),
                      buildListCategories(context, 9, '', () {}),
                      buildListCategories(context, 10, '', () {}),
                      buildListCategories(context, 11, '', () {}),
                      buildListCategories(context, 12, '', () {}),
                      buildListCategories(context, 13, '', () {}),
                      buildListCategories(context, 14, '', () {}),
                      buildListCategories(context, 15, '', () {}),
                      buildListCategories(context, 16, '', () {}),
                      buildListCategories(context, 17, '', () {}),
                      buildListCategories(context, 18, '', () {}),
                      buildListCategories(context, 19, '', () {}),
                      buildListCategories(context, 20, '', () {}),
                      buildListCategories(context, 21, '', () {}),
                      buildListCategories(context, 22, '', () {}),
                      buildListCategories(context, 23, '', () {}),
                      buildListCategories(context, 24, '', () {}),
                      buildListCategories(context, 25, '', () {}),
                      buildListCategories(context, 26, '', () {}),
                      buildListCategories(context, 27, '', () {}),
                      buildListCategories(context, 28, '', () {}),
                    ]),
                    AppText(text: 'Test'),
                  ]),
                ),
              ],
            ),
          ),
          isLoading: levelController.isShowLoading.value,
        );
      }),
    );
  }

  Widget buildListCategories(
      BuildContext context, int index, String nameCategory, Function onTap) {
    return GestureDetector(
      child: Card(
        child: Container(
          height: getScreenHeight(context) / 15,
          child: Row(
            children: <Widget>[
              Dimens.width20,
              AppText(
                text: '$index',
                color: AppColors.clickableText,
              ),
              Dimens.width20,
              AppText(
                text: nameCategory,
                color: AppColors.clickableText,
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        player.play(Sounds.touch);
        onTap();
      },
    );
  }
}
