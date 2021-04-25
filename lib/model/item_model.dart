import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class Item {
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson(instance) => _$ItemToJson(this);

  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'image1')
  String? image1;
  @JsonKey(name: 'image2')
  String? image2;
  @JsonKey(name: 'image3')
  String? image3;
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'tag')
  String? tag;

  Item(this.id, this.image1, this.image2, this.image3, this.url, this.tag);
}
