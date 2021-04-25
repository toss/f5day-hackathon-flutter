// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    json['id'] as int?,
    json['image1'] as String?,
    json['image2'] as String?,
    json['image3'] as String?,
    json['url'] as String?,
    json['tag'] as String?,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'image1': instance.image1,
      'image2': instance.image2,
      'image3': instance.image3,
      'url': instance.url,
      'tag': instance.tag,
    };
