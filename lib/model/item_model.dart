import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class Item {
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson(instance) => _$ItemToJson(this);

  @JsonKey(name: 'userId')
  String? userId;
  @JsonKey(name: 'postId')
  String? postId;
  @JsonKey(name: 'images')
  String images;
  @JsonKey(name: 'text')
  String? text;
  @JsonKey(name: 'postUrl')
  String? postUrl;
  @JsonKey(name: 'likes')
  int likes = 0;
  @JsonKey(name: 'time')
  String time;

/*  @JsonKey(name: 'comment')
  List<dynamic>? comment;*/

  Item(this.userId, this.postId, this.images, this.text, this.postUrl,
      this.likes, this.time);

  List<String> imageList() {
    try {
      List result = jsonDecode(images);
      return result.map((e) => e.toString()).toList();
    } catch (e) {
      return List.empty();
    }
  }

  Widget? getImageWidget(int index, {BoxFit fit = BoxFit.fill}) {
    try {
      return Image.network(imageList()[index], fit: fit);
    } catch (e) {
      return null;
    }
  }
}
