
import 'package:flutter/material.dart';
import 'package:the_enest_english_grammar_test/res/images/images.dart';
import 'package:the_enest_english_grammar_test/theme/dimens.dart';


class Loader extends StatefulWidget {
  createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _opacity;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _opacity = CurvedAnimation(
      curve: Curves.easeInOutCubic,
      parent: _controller,
    );
  }

  @override
  Widget build(ctx) {
    return FadeTransition(
      child: Center(
        child: Image.asset(
          Images.logo,
          width: Dimens.getLogoSize(context),
          height: Dimens.getLogoSize(context),
        ),
      ),
      opacity: _opacity,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
