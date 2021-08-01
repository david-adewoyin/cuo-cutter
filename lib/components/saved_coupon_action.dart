import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:flutter/material.dart';

class SavedCouponAction extends StatelessWidget {
  final Color color;
  final Coupon coupon;
  final Color background;
  const SavedCouponAction(
      {@required this.coupon,
      this.color = Colors.black,
      this.background = backgroundVariant1Color});
  Future<SaveCouponActions> showMoreMenu(Offset offset, BuildContext context) {
    return showMenu(
      color: background,
      elevation: 3,
      position: RelativeRect.fromLTRB(
          offset.dx - 150, offset.dy + 15, 15000000000, 0),
      context: context,
      items: [
        PopupMenuItem(
          value: SaveCouponActions.saveToGallery,
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
          value: SaveCouponActions.remove,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.remove,
                size: 18,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "remove coupon",
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
        var action = await showMoreMenu(offset, context);
        switch (action) {
          case SaveCouponActions.remove:
            try {
              Storage.instance.savedCouponAction(coupon, action);

              ScaffoldMessenger.maybeOf(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.white,
                  content: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Coupon removed from favourite")
                    ],
                  )));
            } catch (e) {
              ScaffoldMessenger.maybeOf(context).showSnackBar(
                  SnackBar(content: Text("Unable to delete coupon")));
            }
            break;
          default:
            break;
        }
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 30, bottom: 25, top: 10, right: 10),
        child: Icon(
          Icons.more_vert,
          color: color,
        ),
      ),
    );
  }
}
