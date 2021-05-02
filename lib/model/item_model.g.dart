// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    json['userId'] as String?,
    json['postId'] as String?,
    json['images'] as String,
    json['text'] as String?,
    json['postUrl'] as String?,
    json['likes'] as int,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'postId': instance.postId,
      'images': instance.images,
      'text': instance.text,
      'postUrl': instance.postUrl,
      'likes': instance.likes,
    };
