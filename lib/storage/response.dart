import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/models/store.dart';
import 'package:cuo_cutter/models/user_store.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class SingleCouponResponse {
  @JsonKey(required: true)
  final Coupon coupon;
  SingleCouponResponse({this.coupon});

  factory SingleCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$SingleCouponResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SingleCouponResponseToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class EmployeesListResponse {
  @JsonKey(required: true, name: "employees")
  final List<Employee> employees;
  EmployeesListResponse({this.employees});

  factory EmployeesListResponse.fromJson(Map<String, dynamic> json) =>
      _$EmployeesListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeesListResponseToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class UserStoreCouponListResponse {
  @JsonKey(required: true)
  List<Coupon> coupons;
  UserStoreCouponListResponse({this.coupons});

  factory UserStoreCouponListResponse.fromJson(Map<String, dynamic> json) =>
      _$UserStoreCouponListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserStoreCouponListResponseToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class StoreResponse {
  @JsonKey(required: true)
  final Store store;
  StoreResponse(this.store);
  factory StoreResponse.fromJson(Map<String, dynamic> json) =>
      _$StoreResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StoreResponseToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class StoreListResponse {
  @JsonKey(required: true)
  final List<Store> stores;
  StoreListResponse(this.stores);
  factory StoreListResponse.fromJson(Map<String, dynamic> json) =>
      _$StoreListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StoreListResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoriesResponse {
  @JsonKey(required: true)
  final List<String> categories;
  CategoriesResponse({this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class CouponListResponse {
  @JsonKey(required: true)
  int lastCouponTime;
  @JsonKey(required: true)
  String lastCouponId;
  @JsonKey(required: true)
  CouponListResponse({this.coupons});
  List<Coupon> coupons;

  factory CouponListResponse.fromJson(Map<String, dynamic> json) =>
      _$CouponListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CouponListResponseToJson(this);
}

//ResponseError is used to contruct errors relating to user
@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ResponseError {
  @JsonKey(required: true)
  int code;
  @JsonKey(required: true)
  String message;
  @JsonKey(required: true)
  String desc;
  String field;
  ResponseError(
      {@required this.code,
      @required this.message,
      @required this.desc,
      this.field});

  factory ResponseError.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseErrorToJson(this);
}
