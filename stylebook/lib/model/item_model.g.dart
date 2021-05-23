// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    json['post_id'] as int?,
    json['images'] as String,
    json['text'] as String?,
    json['url'] as String?,
    json['likes'] as int,
    json['time'] as String,
    json['shop_name_id'] as String,
    json['id'] as int,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'post_id': instance.postId,
      'images': instance.images,
      'text': instance.text,
      'url': instance.url,
      'likes': instance.likes,
      'time': instance.time,
      'shop_name_id': instance.shopNameId,
      'id': instance.id,
    };
