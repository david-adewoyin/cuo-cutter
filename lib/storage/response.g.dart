// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleCouponResponse _$SingleCouponResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['coupon']);
  return SingleCouponResponse(
    coupon: json['coupon'] == null
        ? null
        : Coupon.fromJson(json['coupon'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SingleCouponResponseToJson(
    SingleCouponResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('coupon', instance.coupon?.toJson());
  return val;
}

EmployeesListResponse _$EmployeesListResponseFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['employees']);
  return EmployeesListResponse(
    employees: (json['employees'] as List)
        ?.map((e) =>
            e == null ? null : Employee.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EmployeesListResponseToJson(
    EmployeesListResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'employees', instance.employees?.map((e) => e?.toJson())?.toList());
  return val;
}

UserStoreCouponListResponse _$UserStoreCouponListResponseFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['coupons']);
  return UserStoreCouponListResponse(
    coupons: (json['coupons'] as List)
        ?.map((e) =>
            e == null ? null : Coupon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserStoreCouponListResponseToJson(
    UserStoreCouponListResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('coupons', instance.coupons?.map((e) => e?.toJson())?.toList());
  return val;
}

StoreResponse _$StoreResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['store']);
  return StoreResponse(
    json['store'] == null
        ? null
        : Store.fromJson(json['store'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StoreResponseToJson(StoreResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('store', instance.store?.toJson());
  return val;
}

StoreListResponse _$StoreListResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['stores']);
  return StoreListResponse(
    (json['stores'] as List)
        ?.map(
            (e) => e == null ? null : Store.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$StoreListResponseToJson(StoreListResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('stores', instance.stores?.map((e) => e?.toJson())?.toList());
  return val;
}

CategoriesResponse _$CategoriesResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['categories']);
  return CategoriesResponse(
    categories: (json['categories'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$CategoriesResponseToJson(CategoriesResponse instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };

CouponListResponse _$CouponListResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['last_coupon_time', 'last_coupon_id']);
  return CouponListResponse(
    coupons: (json['coupons'] as List)
        ?.map((e) =>
            e == null ? null : Coupon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..lastCouponTime = json['last_coupon_time'] as int
    ..lastCouponId = json['last_coupon_id'] as String;
}

Map<String, dynamic> _$CouponListResponseToJson(CouponListResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('last_coupon_time', instance.lastCouponTime);
  writeNotNull('last_coupon_id', instance.lastCouponId);
  writeNotNull('coupons', instance.coupons?.map((e) => e?.toJson())?.toList());
  return val;
}

ResponseError _$ResponseErrorFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['code', 'message', 'desc']);
  return ResponseError(
    code: json['code'] as int,
    message: json['message'] as String,
    desc: json['desc'] as String,
    field: json['field'] as String,
  );
}

Map<String, dynamic> _$ResponseErrorToJson(ResponseError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'desc': instance.desc,
      'field': instance.field,
    };
