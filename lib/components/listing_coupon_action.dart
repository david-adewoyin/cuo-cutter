import 'package:cuo_cutter_app/models/coupon.dart';
import 'package:cuo_cutter_app/storage/storage.dart';
import 'package:cuo_cutter_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListingCouponAction extends StatelessWidget {
  final Color color;
  final Coupon coupon;
  final Color background;
  const ListingCouponAction(
      {@required this.coupon,
      this.color = Colors.black,
      this.background = backgroundVariant1Color});
  Future<ListingCouponActions> showMoreMenu(
      Offset offset, BuildContext context) {
    return showMenu(
      color: background,
      elevation: 3,
      position: RelativeRect.fromLTRB(
          offset.dx - 150, offset.dy + 15, 15000000000, 0),
      context: context,
      items: [
        PopupMenuItem(
          value: ListingCouponActions.share,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.share,
                size: 18,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "share",
                style: body1,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ListingCouponActions.saveToGallery,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download_sharp,
                size: 18,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Save to gallery",
                style: body1,
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: ListingCouponActions.addToFavourite,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                size: 18,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "add to favourite",
                style: body1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) async {
        var offset = details.globalPosition;
        var value = await showMoreMenu(offset, context);
        switch (value) {
          case ListingCouponActions.addToFavourite:
            try {
              await Storage.instance.couponAction(coupon, value);
              ScaffoldMessenger.maybeOf(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 1),
                backgroundColor: Colors.white,
                content: Row(
                  children: [
                    Text(
                      "Coupon successfully added",
                    ),
                  ],
                ),
              ));
            } catch (e) {
              ScaffoldMessenger.maybeOf(context).showSnackBar(SnackBar(
                  content: Text(
                "Unable to save coupon,try again later",
              )));
            }
            break;
          case ListingCouponActions.saveToGallery:
            Storage.instance.couponAction(coupon, value);
            break;
          case ListingCouponActions.share:
            Storage.instance.couponAction(coupon, value);
            break;
        }
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 30, bottom: 35, top: 10, right: 10),
        child: Icon(
          Icons.more_vert,
          color: color,
        ),
      ),
    );
  }
}
