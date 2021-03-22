// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['store_id', 'store_name']);
  return Store(
    storeId: json['store_id'] as String,
    storeName: json['store_name'] as String,
    tagline: json['tagline'] as String,
    following: json['following'] as bool ?? false,
    couponCount: json['coupon_count'] as int,
    address: json['address'] as String,
    themeColor: const ColorSerializer().fromJson(json['theme_color'] as String),
  );
}

Map<String, dynamic> _$StoreToJson(Store instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('store_id', instance.storeId);
  writeNotNull('store_name', instance.storeName);
  writeNotNull('following', instance.following);
  writeNotNull('tagline', instance.tagline);
  writeNotNull('address', instance.address);
  writeNotNull('coupon_count', instance.couponCount);
  writeNotNull(
      'theme_color', const ColorSerializer().toJson(instance.themeColor));
  return val;
}
