// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'coupon_id',
    'store',
    'offer',
    'desc',
    'expiring_date',
    'discount_type'
  ]);
  return Coupon(
    couponId: json['coupon_id'] as String,
    isTextCoupon: json['is_text_coupon'] as bool ?? false,
    qrCodeUrl: json['qr_code_url'] as String,
    desc: json['desc'] as String,
    expiringTimeStamp: json['expiring_date'] as int,
    store: json['store'] == null
        ? null
        : Store.fromJson(json['store'] as Map<String, dynamic>),
    discountType:
        _$enumDecodeNullable(_$DiscountTypeEnumMap, json['discount_type']),
    offer: (json['offer'] as num)?.toDouble(),
    textCouponCode: json['text_coupon_code'] as String,
    categories: (json['categories'] as List)?.map((e) => e as String)?.toList(),
    textCouponUrl: json['text_coupon_url'] as String,
    state: _$enumDecodeNullable(_$CouponStateEnumMap, json['state']) ??
        CouponState.active,
    currency: json['currency'] as String,
  );
}

Map<String, dynamic> _$CouponToJson(Coupon instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('coupon_id', instance.couponId);
  writeNotNull('store', instance.store?.toJson());
  writeNotNull('offer', instance.offer);
  writeNotNull('desc', instance.desc);
  writeNotNull('currency', instance.currency);
  writeNotNull('expiring_date', instance.expiringTimeStamp);
  writeNotNull('discount_type', _$DiscountTypeEnumMap[instance.discountType]);
  writeNotNull('categories', instance.categories);
  writeNotNull('is_text_coupon', instance.isTextCoupon);
  writeNotNull('text_coupon_code', instance.textCouponCode);
  writeNotNull('text_coupon_url', instance.textCouponUrl);
  writeNotNull('qr_code_url', instance.qrCodeUrl);
  writeNotNull('state', _$CouponStateEnumMap[instance.state]);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$DiscountTypeEnumMap = {
  DiscountType.voucher: 'voucher',
  DiscountType.percentage: 'percentage',
};

const _$CouponStateEnumMap = {
  CouponState.active: 'active',
  CouponState.used: 'used',
  CouponState.inactive: 'inactive',
};

QrPayload _$QrPayloadFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'exp', 'text']);
  return QrPayload(
    json['id'] as String,
    json['exp'] as int,
    json['text'] as String,
  );
}

Map<String, dynamic> _$QrPayloadToJson(QrPayload instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('exp', instance.exp);
  writeNotNull('text', instance.text);
  return val;
}
