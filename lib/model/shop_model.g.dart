// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return Shop(
    json['id'] as int?,
    json['name_display'] as String?,
    json['name_id'] as String?,
    json['image_profile'] as String?,
    json['likes'] as int,
    json['created'] as String?,
    json['updated'] as String?,
    json['url'] as String?,
  );
}

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
      'id': instance.id,
      'name_display': instance.nameDisplay,
      'name_id': instance.nameId,
      'image_profile': instance.imageProfile,
      'likes': instance.likes,
      'created': instance.created,
      'updated': instance.updated,
      'url': instance.url,
    };
