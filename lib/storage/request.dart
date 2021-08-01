import 'package:cuo_cutter/models/coupon.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class EditStorePayload {
  final String name;
  final String tagline;
  final String address;

  EditStorePayload({this.name, this.tagline, this.address});
  Map<String, dynamic> toJson() => _$EditStorePayloadToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class CouponPayload {
  final String couponId;
  final String offer;
  final String desc;
  final String currency;
  final int creationTime;
  final bool singleUserUse;
  final String maxRedemption;
  final DiscountType discountType;
  final CouponPayloadAction action;

  CouponPayload(
      {this.couponId,
      this.offer,
      this.desc,
      this.currency,
      this.creationTime,
      this.singleUserUse,
      this.maxRedemption,
      this.discountType,
      this.action});
  Map<String, dynamic> toJson() => _$CouponPayloadToJson(this);
}

//the type sent to create coupons
@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class CreateCouponPayload {
  @JsonKey(name: "amount_off")
  final double amountOff;
  @JsonKey(name: "percentage_off")
  final double percentageOff;
  final String desc;
  final List<String> categories;
  final String currency;
  final DiscountType discountType;
  final int expiringDate;
//  final bool singleUserUse;
  final bool unlimitedRedemption;
  final int redemptionLimit;
  final bool isTextCoupon;
  final String webUrl;
  final action;

  CreateCouponPayload({
    this.amountOff,
    this.percentageOff,
    this.webUrl,
    @required this.desc,
    @required this.categories,
    @required this.currency,
    @required this.discountType,
    @required this.expiringDate,
    //  @required this.singleUserUse,
    @required this.unlimitedRedemption,
    @required this.redemptionLimit,
    this.action = "create",
    this.isTextCoupon = false,
  });

  Map<String, dynamic> toJson() => _$CreateCouponPayloadToJson(this);
}

enum CouponPayloadAction {
  @JsonKey(name: "delete")
  delete,
  @JsonKey(name: "create")
  create,
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class EmployeePayload {
  final String empId;
  final String email;
  final EmployeePayloadAction action;

  EmployeePayload({this.empId, this.email, this.action});
  Map<String, dynamic> toJson() => _$EmployeePayloadToJson(this);
}

enum EmployeePayloadAction {
  @JsonKey(name: "suspend")
  suspend,
  @JsonKey(name: "remove")
  remove,
  @JsonKey(name: "resume")
  resume,
  @JsonKey(name: "create")
  create
}
