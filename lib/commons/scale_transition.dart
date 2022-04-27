import 'dart:async';

import 'package:flutter/material.dart';

class Animator extends StatefulWidget {
  final Widget child;
  final Duration time;
  Animator(this.child, this.time);
  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator>
    with SingleTickerProviderStateMixin {
  Timer? timer;
  AnimationController? animationController;
  Animation? animation;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    animation =
        CurvedAnimation(parent: animationController!, curve: Curves.fastOutSlowIn);
    timer = Timer(widget.time, animationController!.forward);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
    timer!.cancel();

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return ScaleTransition(scale: animationController!, child: child);
      },
    );
  }
}

Timer? timer;
Duration duration = Duration();
wait() {
  if (timer == null || !timer!.isActive) {
    timer = Timer(Duration(microseconds: 120), () {
      duration = Duration();
    });
  }
  duration += Duration(milliseconds: 100);
  return duration;
}

class WidgetAnimatorScaleTransition extends StatelessWidget {
  final Widget child;
  WidgetAnimatorScaleTransition(this.child);
  @override
  Widget build(BuildContext context) {
    return Animator(child, wait());
  }
}