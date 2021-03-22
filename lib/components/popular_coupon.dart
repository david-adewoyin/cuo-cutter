import 'package:cuo_cutter_app/components/listing_coupon_action.dart';
import 'package:cuo_cutter_app/models/coupon.dart';
import 'package:cuo_cutter_app/screens/coupon_details.dart';
import 'package:cuo_cutter_app/screens/store_details.dart';
import 'package:cuo_cutter_app/theme.dart';
import 'package:cuo_cutter_app/components/saved_coupon_action.dart';
import 'package:cuo_cutter_app/components/routes.dart';
import 'package:flutter/material.dart';

class PopularSingleCoupon extends StatelessWidget {
  final Coupon coupon;

  PopularSingleCoupon({
    this.coupon,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: primaryColor,
          onTap: () {
            Navigator.of(context).push(slideRouteFromButtom(
              CouponDetails(
                couponId: coupon.couponId,
              ),
            ));
          },
          child: Stack(
            children: [
              Container(
                width: 200,
                height: 330,
                child: Image.asset(
                  'assets/images/popular_overlay.png',
                  fit: BoxFit.cover,
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  height: 330,
                  width: 200,
                  decoration: BoxDecoration(
                    color: coupon.store.themeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    FittedBox(
                      child: Text(
                        coupon.discountText,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "discount",
                      textAlign: TextAlign.center,
                      style: subtitle,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    InkResponse(
                      splashColor: primaryLessColor,
                      radius: coupon.store.storeName.length * 7.0,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return StorePage(
                            storeId: coupon.store.storeId,
                          );
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          coupon.store.storeName,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      coupon.desc,
                      style: body2.copyWith(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              Positioned(
                //  alignment: Alignment.bottomCenter,
                bottom: 20,
                left: 15,
                right: 15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expires:",
                      textAlign: TextAlign.center,
                      style: body2,
                    ),
                    Text(
                      coupon.expiringDate.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: overlay,
                    ),
                  ],
                ),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  child: ListingCouponAction(
                    coupon: coupon,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
