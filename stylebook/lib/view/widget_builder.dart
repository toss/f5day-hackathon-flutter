import 'package:flutter/material.dart';

class WidgetUtils {
  static ClipRRect shopPicture(String imageUrl,
      {double width = 100, double height = 100}) {
    Widget child;

    if (imageUrl.isEmpty) {
      child = SizedBox(width: width, height: height);
    } else {
      child = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(300),
      child: child,
    );
  }
}
