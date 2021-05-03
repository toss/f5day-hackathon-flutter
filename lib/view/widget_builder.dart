import 'package:flutter/material.dart';

class WidgetUtils {
  static ClipRRect shopPicture(String imageUrl,
      {double width = 100, double height = 100}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(300),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
    );
  }
}
