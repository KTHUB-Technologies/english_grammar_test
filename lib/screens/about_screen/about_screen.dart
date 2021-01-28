import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/commons/app_button.dart';
import 'package:the_enest_english_grammar_test/commons/app_text.dart';
import 'package:the_enest_english_grammar_test/helper/utils.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Rx<int> currentPage=Rx<int>(0);
  PageController _controller=PageController(initialPage: 0);
  List<Map<String, String>> data = [
    {
      "text": "Welcome to ENEST, Let’s hatching your future!",
      "image": Images.logo
    },
    {
      "text":
      "We help people connect with teacher \naround the world",
      "image": Images.logo
    },
    {
      "text": "We show the easy way to study english communicate. \nJust stay at home with us",
      "image": Images.logo
    },
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildPageViewBody(context),
          buildButtonContinue(),
        ],
      ),
    );
  }

  Widget buildButtonContinue() {
    return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  data.length,
                      (index) => buildDot(index: index),
                ),
              ),
              Dimens.height30,
              Obx((){
                return AppButton(currentPage.value==data.length-1?'Get Started':'Continue',onTap: currentPage.value==data.length-1?(){
                  Get.offAll(MainScreen());
                }:(){
                  _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                },);
              }),
            ],
          ),
        );
  }

  Widget buildPageViewBody(BuildContext context) {
    return Container(
          height: getScreenHeight(context)/1.5,
          width: getScreenWidth(context),
          child: PageView.builder(
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              currentPage.value = value;
            },
            itemCount: data.length,
            itemBuilder: (context, index) => Content(
              image: data[index]["image"],
              text: data[index]['text'],
            ),
          ),
        );
  }

  Widget buildDot({int index}) {
    return Obx((){
      return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.only(right: 5),
        height: 6,
        width: currentPage.value == index ? 20 : 6,
        decoration: BoxDecoration(
          color: currentPage.value == index ? AppColors.blue : AppColors.divider,
          borderRadius: BorderRadius.circular(3),
        ),
      );
    });
  }
}

class Content extends StatelessWidget {
  const Content({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppText(text: "THE ENEST",color: AppColors.blue,fontWeight: FontWeight.bold,textSize: 25,),
        Dimens.height10,
        AppText(text: text,textAlign: TextAlign.center,textSize: 15,),
        Image.asset(
          image,
          height: 300,
          width: 300,
        ),
      ],
    );
  }
}
