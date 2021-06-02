import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WidgetUtils {
  static ClipRRect shopPicture(String imageUrl,
      {double width = 100, double height = 100}) {
    Widget child;

    if (imageUrl.isEmpty) {
      child = SizedBox(width: width, height: height);
    } else {
      try {
        child = Image(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
          width: width,
          height: height,
        );
      } catch (e) {
        child = SizedBox(width: width, height: height);
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(300),
      child: child,
    );
  }
}
