import 'package:flutter/material.dart';

class WidgetUtils {
  static ClipRRect shopPicture(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.fill,
        width: 100,
        height: 100,
      ),
    );
  }
}
