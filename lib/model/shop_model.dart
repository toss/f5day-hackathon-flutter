import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop_model.g.dart';

@JsonSerializable()
class Shop {
  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

  Map<String, dynamic> toJson(instance) => _$ShopToJson(this);

  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "image")
  final String? image;
  @JsonKey(name: "likes")
  final int likes;
  @JsonKey(name: "userName")
  final String? userName;
  @JsonKey(name: "url")
  final String? url;

  Shop(this.name, this.image, this.likes, this.userName, this.url);

  String likesToString() {
    return NumberFormat.decimalPattern("vi").format(likes).toString();
  }
}
