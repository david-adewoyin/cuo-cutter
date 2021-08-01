import 'dart:io';
import 'package:cuo_cutter/models/store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coupon.g.dart';

// DiscountType specify which type of discount is applied on a coupon

enum DiscountType {
  @JsonKey(name: "amount_off")
  amount_off,
  @JsonKey(name: "percentage_off")
  percentageOff,
}

enum CouponState {
  @JsonKey(name: "active")
  active,
  @JsonKey(name: "used")
  used,
  @JsonKey(name: "inactive")
  inactive
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)

// Coupon represent a redeemable discount at a physical or web store
@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class Coupon {
  @JsonKey(required: true)
  final String couponId;
  @JsonKey(required: true)
  final Store store;
  @JsonKey(name: "amount_off")
  final double amountOff;
  @JsonKey(name: "percentage_off")
  final double percentageOff;
  @JsonKey(required: true)
  final String desc;
  // currencyCode is only required if discountType is amount_off
  String currencyCode;
  final String discountText;
  @JsonKey(required: true, name: "expiring_at")
  final int expiringTimeStamp;
  @JsonKey(ignore: true)
  final String _expiringDate;
  @JsonKey(required: true)
  final DiscountType discountType;
  final List<String> categories;
  @JsonKey(defaultValue: false)
  final bool isTextCoupon;
  final String textCouponCode;
  final String textCouponUrl;
  @JsonKey(name: "qr_code_url")
  final String qrCodeUrl;
  @JsonKey(defaultValue: CouponState.active)
  final CouponState state;

  Coupon({
    this.couponId,
    this.isTextCoupon,
    this.qrCodeUrl,
    this.amountOff,
    this.percentageOff,
    @required this.desc,
    @required this.expiringTimeStamp,
    @required this.store,
    @required this.discountType,
    this.textCouponCode,
    this.categories,
    this.textCouponUrl,
    this.state,
    this.currencyCode,
  })  : _expiringDate = expiringDateFromStamp(expiringTimeStamp),
        discountText = _discountText(
          discountType,
          currencyCode: currencyCode,
          amountOff: amountOff,
          percentageOff: percentageOff,
        );

  String get expiringDate => _expiringDate;

  factory Coupon.fromJson(Map<String, dynamic> json) {
    var coupon = _$CouponFromJson(json);
    if (coupon.amountOff == null && coupon.percentageOff == null) {
      throw 'amount_off or percentage_off must be specified';
    }
    return coupon;
  }
  Map<String, dynamic> toJson() => _$CouponToJson(this);

  static String expiringDateFromStamp(int expiringDate) {
    var date = DateTime.fromMillisecondsSinceEpoch(expiringDate);
    var formattedDate = DateFormat.yMMMMd().format(date);
    return formattedDate;
  }

  static String _discountText(DiscountType type,
      {@required double amountOff,
      double percentageOff,
      @required String currencyCode}) {
    String text;
    if (type == DiscountType.percentageOff) {
      text = "-$percentageOff%";
      return text;
    }
    if (currencyCode == null) {
      text = "invalid coupon";
      return text;
    }
    try {
      final formatCurrency = new NumberFormat.simpleCurrency(
          locale: Platform.localeName, name: currencyCode.toUpperCase());
      var number = formatCurrency.format(amountOff);
      return "- $number";
    } catch (e) {
      return "-$currencyCode $amountOff";
    }
  }
}

class QrImage {
  final String sig;
  final QrPayload data;

  QrImage(this.sig, this.data);
  factory QrImage.fromJson(Map<String, dynamic> json) {
    var sig = json["sig"];
    var data = QrPayload.fromJson(json["data"]);
    if (sig == null || data == null) {
      throw "Invalid Coupon";
    }
    return QrImage(sig, data);
  }
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class QrPayload {
  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final int exp;
  @JsonKey(required: true)
  final String text;

  QrPayload(this.id, this.exp, this.text);
  factory QrPayload.fromJson(Map<String, dynamic> json) {
    var id = json["id"] as String;
    var text = json["text"] as String;
    var exp = json["exp"] as int;
    if (id == null || text == null || exp == null) {
      throw "Invalid Coupon";
    }
    return QrPayload(id, exp, text);
  }
  //    _$QrPayloadFromJson(json);
}
