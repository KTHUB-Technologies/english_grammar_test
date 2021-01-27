import 'package:flutter/material.dart';

class SlideUpTransition extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;

  const SlideUpTransition({Key key, this.child, this.animationController}) : super(key: key);

  @override
  _SlideUpTransitionState createState() => _SlideUpTransitionState();
}

class _SlideUpTransitionState extends State<SlideUpTransition>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();

    if (widget.animationController == null) {
      _controller =
          AnimationController(
              vsync: this, duration: Duration(milliseconds: 500));
    } else {
      _controller = widget.animationController;
    }

    _offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: widget.child,
    );
  }
}
