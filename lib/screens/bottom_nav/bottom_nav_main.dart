import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_enest_english_grammar_test/controller/app_controller.dart';
import 'package:the_enest_english_grammar_test/screens/main_screen/main_screen.dart';
import 'package:the_enest_english_grammar_test/screens/statistics_screen/statistics_screen.dart';
import 'package:the_enest_english_grammar_test/theme/colors.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key key}) : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final AppController appController = Get.find();

  final List<BottomNavigationBarItem> listItem = [
    BottomNavigationBarItem(
      backgroundColor: AppColors.white,
      label: 'Home',
      icon: Icon(Icons.people_alt_outlined),
    ),
    BottomNavigationBarItem(
      backgroundColor: AppColors.white,
      label: 'Statistics',
      icon: Icon(Icons.people_alt_outlined),
    )
  ];

  final List<Widget> listScreen = [
    MainScreen(),
    StatisticsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContentView(),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }

  Widget buildContentView(){
    return Obx((){
      return IndexedStack(
        index: appController.selectedIndex.value,
        children: listScreen,
      );
    });
  }

  Widget bottomNavigationBar(BuildContext context) {
    return Obx((){
      return BottomNavigationBar(
        selectedItemColor: AppColors.blue,
        unselectedItemColor: AppColors.black,
        items: listItem,
        onTap: appController.setSelectedIndex,
        currentIndex: appController.selectedIndex.value,
        backgroundColor: AppColors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      );
    });
  }
}
