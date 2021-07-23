import 'package:get/get.dart';

class StatisticsController extends GetxController{
  Rx<num> statisticsLevel = Rx<num>(1);

  Rx<num> totalTrueQues = Rx<num>(0);
  Rx<num> totalWrongQues = Rx<num>(0);
  Rx<num> totalQues = Rx<num>(0);
}