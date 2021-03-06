import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class Item {
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson(instance) => _$ItemToJson(this);

  @JsonKey(name: 'post_id')
  int? postId;
  @JsonKey(name: 'images')
  String images;
  @JsonKey(name: 'text')
  String? text;
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'likes')
  int likes = 0;
  @JsonKey(name: 'time')
  String time;
  @JsonKey(name: 'shop_name_id')
  String shopNameId;
  @JsonKey(name: 'id')
  int id;

/*  @JsonKey(name: 'comment')
  List<dynamic>? comment;*/

  Item(this.postId, this.images, this.text, this.url, this.likes, this.time,
      this.shopNameId, this.id);

  List<String> imageList() {
    try {
      List result = jsonDecode(images);
      return result.map((e) => e.toString()).toList();
    } catch (e) {
      return List.empty();
    }
  }

  Widget? getImageWidget(int index,
      {double? width, double? height, BoxFit fit = BoxFit.fill}) {
    try {
      return Image.network(imageList()[index],
          width: width, height: height, fit: fit);
    } catch (e) {
      return null;
    }
  }

  Widget? getFirstImage(
      {double? width, double? height, BoxFit fit = BoxFit.fitHeight}) {
    final list = imageList();
    print("market image list $list");
    if (list.isEmpty) {
      return null;
    }

    return Image.network(list[0], width: width, height: height, fit: fit);
  }
}
