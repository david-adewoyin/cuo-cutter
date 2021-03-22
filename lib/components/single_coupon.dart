import 'package:cuo_cutter_app/components/listing_coupon_action.dart';
import 'package:cuo_cutter_app/models/coupon.dart';
import 'package:cuo_cutter_app/screens/coupon_details.dart';
import 'package:cuo_cutter_app/screens/store_details.dart';
import 'package:cuo_cutter_app/theme.dart';
import 'package:cuo_cutter_app/components/routes.dart';
import 'package:flutter/material.dart';

class SingleCoupon extends StatelessWidget {
  final Coupon coupon;
  final Color background;

  const SingleCoupon({
    Key key,
    this.coupon,
    this.background = const Color(0xFF212121),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.only(left: 0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: coupon.store.themeColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: SizedBox(
                      height: 112,
                      child: Align(
                        alignment: const Alignment(1, -1),
                        child: ListingCouponAction(
                          coupon: coupon,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              splashColor: primaryColor,
                              radius: coupon.store.storeName.length * 8.0,
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return StorePage(
                                    storeId: coupon.store.storeId,
                                  );
                                }));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 20, top: 20),
                                child: Text(
                                  coupon.store.storeName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 0,
                            right: 0,
                            child: Text(
                              coupon.desc,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: body2.copyWith(color: Colors.white70),
                            ),
                          ),
                          Align(
                            alignment: const Alignment(-1, 0.6),
                            child: Text(
                              "Expires:",
                              style: body2.copyWith(color: Colors.white60),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                coupon.expiringDate,
                                style: overlay.copyWith(
                                    color: coupon.store.themeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 90,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                coupon.discountText,
                style: overlay.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
