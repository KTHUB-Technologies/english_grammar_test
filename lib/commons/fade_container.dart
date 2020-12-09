import 'package:flutter/material.dart';
import 'package:tocviet_customer/utils/utils.dart';

class FadeContainer extends StatefulWidget {
  final Widget child;

  const FadeContainer({Key key, this.child}) : super(key: key);

  @override
  _FadeContainerState createState() => _FadeContainerState();
}

class _FadeContainerState extends State<FadeContainer> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    /// Activate opacity animation
    onWidgetBuildDone(() {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(seconds: 2),
      child: widget.child,
    );
  }
}
