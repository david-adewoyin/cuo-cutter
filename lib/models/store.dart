// every user is associated with a store
import 'dart:math';

import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'store.g.dart';

class ColorSerializer implements JsonConverter<Color, String> {
  const ColorSerializer();
  @override
  Color fromJson(String json) {
    if (json == null) {
      return colorList[Random().nextInt(colorList.length)];
    }
    try {
      var hex = json.replaceFirst("#", "");
      int c = int.parse('FF$hex', radix: 16);
      return Color(c);
    } catch (_) {
      return colorList[Random().nextInt(colorList.length)];
    }
  }

  @override
  String toJson(Color color) {
    return null;
  }
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class Store {
  @JsonKey(required: true)
  final String storeId;
  // final String image;
  @JsonKey(required: true)
  final String storeName;
  @JsonKey(defaultValue: false)
  final bool following;
  final String tagline;
  final String address;
  final int couponCount;
  @ColorSerializer()
  @JsonKey(toJson: null)
  final Color themeColor;

  Store({
    //this.image,
    @required this.storeId,
    @required this.storeName,
    this.tagline,
    this.following,
    this.couponCount,
    this.address,
    this.themeColor,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
