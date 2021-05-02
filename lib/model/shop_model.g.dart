// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return Shop(
    json['name'] as String?,
    json['image'] as String?,
    json['likes'] as int,
    json['userName'] as String?,
    json['url'] as String?,
  );
}

Map<String, dynamic> _$ShopToJson(Shop instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'likes': instance.likes,
      'userName': instance.userName,
      'url': instance.url,
    };
