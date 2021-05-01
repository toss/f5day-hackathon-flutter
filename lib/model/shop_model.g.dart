// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return Shop(
    json['name'] as String?,
    json['imageSmall'] as String?,
    json['likes'] as int,
    json['tag'] as String?,
    json['url'] as String?,
  );
}

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
      'name': instance.name,
      'imageSmall': instance.imageSmall,
      'likes': instance.likes,
      'tag': instance.tag,
      'url': instance.url,
    };
