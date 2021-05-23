// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkRequest _$BookmarkRequestFromJson(Map<String, dynamic> json) {
  return BookmarkRequest(
    json['user_id'] as String,
    json['item_id'] as int,
    json['on_off'] as int,
  );
}

Map<String, dynamic> _$BookmarkRequestToJson(BookmarkRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'item_id': instance.itemId,
      'on_off': instance.onOff,
    };

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) {
  return Bookmark(
    json['id'] as int,
    json['item_id'] as int,
    json['on_off'] as int,
  );
}

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'on_off': instance.on_off,
    };
