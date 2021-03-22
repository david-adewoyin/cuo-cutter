import 'package:cuo_cutter_app/models/coupon.dart';
import 'package:cuo_cutter_app/storage/storage.dart';
import 'package:cuo_cutter_app/theme.dart';
import 'package:flutter/material.dart';

class StoreCouponAction extends StatefulWidget {
  final Color color;
  final Coupon coupon;
  final Color background;
  final ValueNotifier<Coupon> deleteIndexNotifier;
  const StoreCouponAction(
      {@required this.coupon,
      this.deleteIndexNotifier,
      this.color = Colors.black,
      this.background = backgroundVariant1Color});

  @override
  _StoreCouponActionState createState() => _StoreCouponActionState();
}

class _StoreCouponActionState extends State<StoreCouponAction> {
  Future<StoreCouponActions> showMoreMenu(Offset offset, BuildContext context) {
    return showMenu(
      color: widget.background,
      elevation: 3,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy - 10, 0, 0),
      context: context,
      items: [
        PopupMenuItem(
          value: StoreCouponActions.share,
          child: Row(
            children: [
              Icon(
                Icons.share,
                size: 20,
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
          value: StoreCouponActions.saveToGallery,
          child: Row(
            children: [
              Icon(
                Icons.download_sharp,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Save to gallery",
                style: body1,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: StoreCouponActions.delete,
          child: Row(
            children: [
              Icon(
                Icons.delete_forever,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Delete Coupon",
                style: body1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) async {
        var offset = details.globalPosition;
        var value = await showMoreMenu(offset, context);

        switch (value) {
          case StoreCouponActions.delete:
            Storage.instance
                .storeCouponAction(widget.coupon, value)
                .then((value) {
              ScaffoldMessenger.maybeOf(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  width: 400,
                  backgroundColor: Colors.white,
                  content: Row(
                    children: [
                      Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Coupon successfully deleted",
                        style: body2.copyWith(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              );

              widget.deleteIndexNotifier.value = widget.coupon;
            }).onError((error, stackTrace) {
              ScaffoldMessenger.maybeOf(context).showSnackBar(SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Unable to delete coupon",
                      style: body2.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ));
            });

            break;
          case StoreCouponActions.share:
            ScaffoldMessenger.maybeOf(context).showSnackBar(SnackBar(
              content: Text(
                "Unable to delete Coupon",
                style: body2,
              ),
            ));

            break;
          case StoreCouponActions.saveToGallery:
            break;
        }
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 30, bottom: 25, top: 10, right: 10),
        child: Icon(
          Icons.more_vert,
          color: widget.color,
        ),
      ),
    );
  }
}
