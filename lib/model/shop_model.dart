import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop_model.g.dart';

@JsonSerializable()
class Shop {
  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson(instance) => _$ShopToJson(this);

  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name_display")
  final String? nameDisplay;
  @JsonKey(name: "name_id")
  final String? nameId;
  @JsonKey(name: "image_profile")
  final String? imageProfile;
  @JsonKey(name: "likes")
  final int likes;
  @JsonKey(name: "created")
  final String? created;
  @JsonKey(name: "updated")
  final String? updated;
  @JsonKey(name: "url")
  final String? url;

  Shop(this.id, this.nameDisplay, this.nameId, this.imageProfile, this.likes,
      this.created, this.updated, this.url);

  String likesToString() {
    return NumberFormat.decimalPattern("vi").format(likes).toString();
  }
}
