import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/controller/main_controller.dart';
import 'package:the_enest_english_grammar_test/controller/user_controller.dart';
import 'package:the_enest_english_grammar_test/helper/hive_helper.dart';
import 'package:the_enest_english_grammar_test/helper/sounds_helper.dart';
import 'package:the_enest_english_grammar_test/model/question_model.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/res/sounds/sounds.dart';
import 'package:the_enest_english_grammar_test/screens/check_answer/check_answer_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class CardQuestion extends StatefulWidget {
  const CardQuestion(
      {Key key,
      this.question,
      this.countTrue,
      this.listQuestions,
      this.isFavorite})
      : super(key: key);

  final Question question;
  final Rx<int> countTrue;
  final RxList<Question> listQuestions;
  final bool isFavorite;

  @override
  _CardQuestionState createState() => _CardQuestionState();
}

class _CardQuestionState extends State<CardQuestion> {
  final MainController mainController = Get.find();
  final UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = [];
    RxList<Color> colorsI = RxList<Color>([]);
    RxList<Icon> iconsI = RxList<Icon>([]);
    options = widget.question.options.split('///');
    for (var i = 0; i < options.length; i++) {
      colorsI.add(AppColors.transparent);
      iconsI.add(Icon(Icons.adjust));
    }
    if (widget.isFavorite == true) {
      widget.question.currentChecked.value = widget.question.correctAnswer - 1;
      colorsI[widget.question.currentChecked.value] =
          AppColors.green.withOpacity(0.2);
      iconsI[widget.question.currentChecked.value] = Icon(
        Icons.check,
        color: AppColors.green,
      );
    } else {
      if (widget.question.currentChecked.value != null) {
        if (widget.question.currentChecked.value ==
            widget.question.correctAnswer - 1) {
          colorsI[widget.question.currentChecked.value] =
              AppColors.green.withOpacity(0.2);
          iconsI[widget.question.currentChecked.value] = Icon(
            Icons.check,
            color: AppColors.green,
          );
        } else {
          colorsI[widget.question.currentChecked.value] =
              AppColors.red.withOpacity(0.2);
          colorsI[widget.question.correctAnswer - 1] =
              AppColors.green.withOpacity(0.2);

          iconsI[widget.question.currentChecked.value] = Icon(
            Icons.clear,
            color: AppColors.red,
          );
          iconsI[widget.question.correctAnswer - 1] = Icon(
            Icons.check,
            color: AppColors.green,
          );
        }
      }
    }
    return Obx(() {
      mainController.containFromFavorite = RxList<Question>(mainController
          .questionsHiveFavorite
          .where((e) => e.id == widget.question.id)
          .toList());
      return Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                buildQuestionContent(options, colorsI, iconsI),
              ],
            ),
          ),
          _buildFloatingPreviousButton(),
          _buildCompleteButton(),
          _buildFloatingAddFavoriteButton()
        ],
      );
    });
  }

  Widget buildQuestionContent(
      List<String> options, RxList<Color> colorsI, RxList<Icon> iconsI) {
    return Expanded(

      child: GestureDetector(
        onHorizontalDragStart: (value) {
      ///TODO
        },
        child: ListView(
          children: <Widget>[
            AppText(
              text: widget.question.task,
              textSize: Dimens.paragraphHeaderTextSize,
            ),
            Dimens.height10,
            Column(
              children: options.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Obx(() {
                    return AbsorbPointer(
                      ignoringSemantics: true,
                      absorbing: widget
                              .question
                              .currentChecked
                              .value==null
                          ? false
                          : true,
                      child: GestureDetector(
                        child: AnimatedContainer(
                          duration: Duration(
                              milliseconds:
                                  widget.question.currentChecked.value==null
                                      ? 0
                                      : 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),

                            color: widget.question.currentChecked.value != null
                                ? colorsI[options.indexOf(e)]
                                : Colors.transparent,
                            border: Border.all(
                              color:
                                  widget.question.currentChecked.value != null
                                      ? colorsI[options.indexOf(e)]
                                      : Colors.blueGrey,
                            ),
                          ),
                          child: ListTile(
                            title: AppText(
                              text: e,
                            ),
                            trailing: iconsI[options.indexOf(e)],
                          ),
                        ),
                        onTap: () async {
                          _handleOption(options.indexOf(e), colorsI, iconsI);
                        },
                      ),
                    );
                  }),
                );
              }).toList(),
            ),
            Dimens.height10,
            AnimatedOpacity(
              opacity: widget.question.currentChecked.value==null
                  ? 0.0
                  : 1.0,
              duration: Duration(
                  milliseconds:
                      widget.question.currentChecked.value==null
                          ? 0
                          : 500),
              curve: Curves.easeInOut,
              child: Card(
                child: ListTile(
                  title: AppText(
                    text: widget.question.explanation,
                  ),

                ),
              ),
            ),
            Dimens.height10,
          ],
        ),
      ),
    );
  }

  addOrRemoveFromFavorite() async {
    if (userController.user.value != null) {
      if (mainController.containFromFavorite.isEmpty) {
        Question ques=widget.question;
        ques.currentChecked.value=null;
        var favorite ={'favorites': FieldValue.arrayUnion([ques.toJson()])};
        userController.updateDataFavorite(userController.user.value.uid, favorite);
        mainController.questionsHiveFavorite.add(widget.question);
        mainController.containFromFavorite = RxList<Question>(mainController
            .questionsHiveFavorite
            .where((e) => e.id == widget.question.id)
            .toList());
      } else {
        if (widget.isFavorite == true) {
          widget.listQuestions
              .removeWhere((element) => element.id == widget.question.id);
          if (mainController.index.value > 0) mainController.index.value--;
        } else {
          mainController.questionsHiveFavorite
              .removeWhere((e) => e.id == widget.question.id);
          mainController.containFromFavorite = RxList<Question>(mainController
              .questionsHiveFavorite
              .where((e) => e.id == widget.question.id)
              .toList());
        }
        Question ques=widget.question;
        ques.currentChecked.value=null;
        var favorite ={'favorites': FieldValue.arrayRemove([ques.toJson()])};
        await userController.deleteDataFavorite(userController.user.value.uid, favorite);
      }
    } else {
      if (mainController.containFromFavorite.isEmpty) {
        List<Question> question = [];
        question.add(widget.question);
        var questions = question.map((e) => e.toJson()).toList();
        await HiveHelper.addBoxes(questions, 'Table_Favorite');
        mainController.questionsHiveFavorite.add(widget.question);
        mainController.containFromFavorite = RxList<Question>(mainController
            .questionsHiveFavorite
            .where((e) => e.id == widget.question.id)
            .toList());
      } else {
        final openBox = await Hive.openBox('Table_Favorite');
        if (widget.isFavorite == true) {
          openBox.deleteAt(widget.listQuestions.indexOf(widget.question));
          widget.listQuestions
              .removeWhere((element) => element.id == widget.question.id);
          if (mainController.index.value > 0) mainController.index.value--;
        } else {
          openBox.deleteAt(mainController.questionsHiveFavorite
              .indexWhere((e) => e.id == widget.question.id));
          mainController.questionsHiveFavorite
              .removeWhere((e) => e.id == widget.question.id);
          mainController.containFromFavorite = RxList<Question>(mainController
              .questionsHiveFavorite
              .where((e) => e.id == widget.question.id)
              .toList());
        }
      }
    }
  }

  countTrueAnswer() {
    widget.countTrue.value = 0;
    SoundsHelper.checkAudio(Sounds.touch);
    for (var checkTrue in widget.listQuestions) {
      if (checkTrue.currentChecked.value == checkTrue.correctAnswer - 1)
        widget.countTrue.value++;
    }
    mainController.index.value = widget.listQuestions.length;
  }

  _buildFloatingPreviousButton() {
    return mainController.index.value + 1 > 1
        ? Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.transparent,
                heroTag: 'previous',
                onPressed: () async {
                  SoundsHelper.checkAudio(Sounds.touch);
                  mainController.index.value--;
                },
                child: Image.asset(Images.arrow_back),
              ),
            ),
          )
        : SizedBox();
  }

  _buildCompleteButton() {
    return widget.question.currentChecked.value != null
        ? widget.listQuestions.length > (mainController.index.value + 1)
            ? _buildFloatingNextButton()
            : mainController
                    .questionsFromHive.isEmpty
                ? widget.isFavorite == false
                    ? _buildFloatingSubmitButton()
                    : SizedBox()
                : SizedBox()
        : SizedBox();
  }

  _buildFloatingNextButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          heroTag: 'next',
          onPressed: () async {
            SoundsHelper.checkAudio(Sounds.touch);

            mainController.index.value++;
          },
          child: Image.asset(Images.arrow_forward),
        ),
      ),
    );
  }

  _buildFloatingSubmitButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          heroTag: 'submit',
          onPressed: () async {
            SoundsHelper.checkAudio(Sounds.touch);
            widget.isFavorite == false
                ? countTrueAnswer()
                : Get.to(CheckAnswerScreen(
                    question: widget.listQuestions,
                  ));
          },
          child: Image.asset(Images.finish_flag),
        ),
      ),
    );
  }

  _buildFloatingAddFavoriteButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          heroTag: 'favorite',
          onPressed: () async {},
          child: IconButton(icon: Obx(() {
            return mainController.containFromFavorite.isNotEmpty
                ? Icon(
                    Icons.favorite,
                    color: AppColors.red,
                  )
                : Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                  );
          }), onPressed: () async {
            SoundsHelper.checkAudio(Sounds.touch);
            addOrRemoveFromFavorite();
          }),
        ),
      ),
    );
  }

  _handleOption(int selected, colorsI, iconsI) {
    widget.question.currentChecked.value = selected;
    if (widget.question.currentChecked.value ==
        widget.question.correctAnswer - 1) {
      SoundsHelper.checkAudio(Sounds.correct);
      colorsI[widget.question.currentChecked.value] =
          AppColors.green.withOpacity(0.2);
      iconsI[widget.question.currentChecked.value] = Icon(
        Icons.check,
        color: AppColors.green,
      );
      mainController.currentTrue.value++;
    } else {
      SoundsHelper.checkAudio(Sounds.in_correct);
      colorsI[widget.question.currentChecked.value] =
          AppColors.red.withOpacity(0.2);
      colorsI[widget.question.correctAnswer - 1] =
          AppColors.green.withOpacity(0.2);
      iconsI[widget.question.currentChecked.value] = Icon(
        Icons.clear,
        color: AppColors.red,
      );
      iconsI[widget.question.correctAnswer - 1] = Icon(
        Icons.check,
        color: AppColors.green,
      );
      mainController.currentTrue.value++;
    }
  }
}
