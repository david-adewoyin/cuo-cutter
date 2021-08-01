// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditStorePayload _$EditStorePayloadFromJson(Map<String, dynamic> json) {
  return EditStorePayload(
    name: json['name'] as String,
    tagline: json['tagline'] as String,
    address: json['address'] as String,
  );
}

Map<String, dynamic> _$EditStorePayloadToJson(EditStorePayload instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('tagline', instance.tagline);
  writeNotNull('address', instance.address);
  return val;
}

CouponPayload _$CouponPayloadFromJson(Map<String, dynamic> json) {
  return CouponPayload(
    couponId: json['coupon_id'] as String,
    offer: json['offer'] as String,
    desc: json['desc'] as String,
    currency: json['currency'] as String,
    creationTime: json['creation_time'] as int,
    singleUserUse: json['single_user_use'] as bool,
    maxRedemption: json['max_redemption'] as String,
    discountType:
        _$enumDecodeNullable(_$DiscountTypeEnumMap, json['discount_type']),
    action: _$enumDecodeNullable(_$CouponPayloadActionEnumMap, json['action']),
  );
}

Map<String, dynamic> _$CouponPayloadToJson(CouponPayload instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('coupon_id', instance.couponId);
  writeNotNull('offer', instance.offer);
  writeNotNull('desc', instance.desc);
  writeNotNull('currency', instance.currency);
  writeNotNull('creation_time', instance.creationTime);
  writeNotNull('single_user_use', instance.singleUserUse);
  writeNotNull('max_redemption', instance.maxRedemption);
  writeNotNull('discount_type', _$DiscountTypeEnumMap[instance.discountType]);
  writeNotNull('action', _$CouponPayloadActionEnumMap[instance.action]);
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
  DiscountType.amount_off: 'amount_off',
  DiscountType.percentageOff: 'percentageOff',
};

const _$CouponPayloadActionEnumMap = {
  CouponPayloadAction.delete: 'delete',
  CouponPayloadAction.create: 'create',
};

CreateCouponPayload _$CreateCouponPayloadFromJson(Map<String, dynamic> json) {
  return CreateCouponPayload(
    amountOff: (json['amount_off'] as num)?.toDouble(),
    percentageOff: (json['percentage_off'] as num)?.toDouble(),
    webUrl: json['web_url'] as String,
    desc: json['desc'] as String,
    categories: (json['categories'] as List)?.map((e) => e as String)?.toList(),
    currency: json['currency'] as String,
    discountType:
        _$enumDecodeNullable(_$DiscountTypeEnumMap, json['discount_type']),
    expiringDate: json['expiring_date'] as int,
    unlimitedRedemption: json['unlimited_redemption'] as bool,
    redemptionLimit: json['redemption_limit'] as int,
    action: json['action'],
    isTextCoupon: json['is_text_coupon'] as bool,
  );
}

Map<String, dynamic> _$CreateCouponPayloadToJson(CreateCouponPayload instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('amount_off', instance.amountOff);
  writeNotNull('percentage_off', instance.percentageOff);
  writeNotNull('desc', instance.desc);
  writeNotNull('categories', instance.categories);
  writeNotNull('currency', instance.currency);
  writeNotNull('discount_type', _$DiscountTypeEnumMap[instance.discountType]);
  writeNotNull('expiring_date', instance.expiringDate);
  writeNotNull('unlimited_redemption', instance.unlimitedRedemption);
  writeNotNull('redemption_limit', instance.redemptionLimit);
  writeNotNull('is_text_coupon', instance.isTextCoupon);
  writeNotNull('web_url', instance.webUrl);
  writeNotNull('action', instance.action);
  return val;
}

EmployeePayload _$EmployeePayloadFromJson(Map<String, dynamic> json) {
  return EmployeePayload(
    empId: json['emp_id'] as String,
    email: json['email'] as String,
    action:
        _$enumDecodeNullable(_$EmployeePayloadActionEnumMap, json['action']),
  );
}

Map<String, dynamic> _$EmployeePayloadToJson(EmployeePayload instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('emp_id', instance.empId);
  writeNotNull('email', instance.email);
  writeNotNull('action', _$EmployeePayloadActionEnumMap[instance.action]);
  return val;
}

const _$EmployeePayloadActionEnumMap = {
  EmployeePayloadAction.suspend: 'suspend',
  EmployeePayloadAction.remove: 'remove',
  EmployeePayloadAction.resume: 'resume',
  EmployeePayloadAction.create: 'create',
};
