import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';


/// This method is used when we need to call a method after build() function is completed.
void onWidgetBuildDone(function) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    function();
  });
}
getScreenWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}
getScreenHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}