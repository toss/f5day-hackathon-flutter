import 'package:json_annotation/json_annotation.dart';

part 'bookmark_model.g.dart';

//user_id=1&item_id=1&on_off=1
@JsonSerializable()
class BookmarkRequest {
  factory BookmarkRequest.fromJson(Map<String, dynamic> json) =>
      _$BookmarkRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkRequestToJson(this);
  @JsonKey(name: "user_id")
  String userId;
  @JsonKey(name: "item_id")
  int itemId;
  @JsonKey(name: "on_off")
  int onOff;

  BookmarkRequest(this.userId, this.itemId, this.onOff);
}

@JsonSerializable()
class Bookmark {
  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkToJson(this);

  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "item_id")
  int itemId;
  @JsonKey(name: "on_off")
  int on_off;

  Bookmark(this.id, this.itemId, this.on_off);
}
/*
{
    "created": "Mon, 03 May 2021 09:18:54 GMT",
    "id": 8,
    "item_id": 1,
    "on_off": 1,
    "updated": "Mon, 03 May 2021 09:37:14 GMT",
    "user_id": "270d6c28-e5b2-44e2-acac-35bc48b0ebb1"
  },
 */
