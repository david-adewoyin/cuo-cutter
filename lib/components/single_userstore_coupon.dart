import 'package:cuo_cutter/components/store_coupon_action.dart';
import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/screens/coupon_details.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:cuo_cutter/components/saved_coupon_action.dart';
import 'package:cuo_cutter/components/routes.dart';
import 'package:flutter/material.dart';

class SingleCouponFollow extends StatelessWidget {
  final Coupon coupon;
  final Color background;

  const SingleCouponFollow({
    Key key,
    this.coupon,
    this.background = const Color(0xFF212121),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(slideRouteFromButtom(
                  CouponDetails(
                    couponId: coupon.couponId,
                  ),
                ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: coupon.store.themeColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      coupon.desc,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 6,
                      style: body2.copyWith(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 5,
            bottom: 30,
            child: Container(
              child: Text(
                "Expires:",
                style: body2.copyWith(color: Colors.white60),
              ),
            ),
          ),
          Positioned(
            left: 5,
            bottom: 5,
            child: Container(
              child: Text(
                "${coupon.expiringDate}",
                style: overlay.copyWith(color: coupon.store.themeColor),
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Text(
                coupon.discountText,
                style: overlay.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          Align(
            child: Container(
              child: Align(
                alignment: const Alignment(1, -1),
                child: StoreCouponAction(
                  coupon: coupon,
                  color: Colors.black,
                  background: backgroundVariant1Color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
