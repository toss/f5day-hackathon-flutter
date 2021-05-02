// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    json['userId'] as String?,
    json['post_id'] as int?,
    json['images'] as String,
    json['text'] as String?,
    json['url'] as String?,
    json['likes'] as int,
    json['time'] as String,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'userId': instance.userId,
      'post_id': instance.postId,
      'images': instance.images,
      'text': instance.text,
      'url': instance.url,
      'likes': instance.likes,
      'time': instance.time,
    };
