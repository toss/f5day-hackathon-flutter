import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
            child: Image.asset(
      'images/app_logo.png',
      height: 90,
      width: 90,
    )));
  }
}
