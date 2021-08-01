import 'package:cuo_cutter/components/listing_coupon_action.dart';
import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:cuo_cutter/components/saved_coupon_action.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';

class CouponDetails extends StatefulWidget {
  final String couponId;
  const CouponDetails({@required this.couponId});
  @override
  _CouponDetailsState createState() => _CouponDetailsState();
}

class _CouponDetailsState extends State<CouponDetails> {
  Coupon coupon;
  bool snackbarOpened = false;
  bool _imageLoadSuccess = true;
  Future<Coupon> _couponFuture;
  @override
  void initState() {
    _couponFuture = Storage.instance.fetchSingleCoupon(widget.couponId);
    super.initState();
  }

  _launchUrl(String url) async {
    try {
      await canLaunch(url);
    } catch (e) {
      print(e);
      ScaffoldMessenger.maybeOf(context).showSnackBar(
        SnackBar(
          content: Text("Unable to open webpage"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: FutureBuilder<Coupon>(
            future: _couponFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // check if snackbar is already opened
                if (!snackbarOpened) {
                  snackbarOpened = true;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.maybeOf(context)
                      .showSnackBar(
                          SnackBar(content: Text("Unable to display coupon")))
                      .closed
                      .then((value) {
                    snackbarOpened = false;
                  });
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(),
                        flex: 3,
                      ),
                      Text(
                        "Loading failed",
                        style: subtitle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            _couponFuture = Storage.instance
                                .fetchSingleCoupon(widget.couponId);
                          });
                        },
                        style: TextButton.styleFrom(
                            primary: secondaryColor,
                            padding: EdgeInsets.all(10),
                            backgroundColor: Colors.grey.shade900),
                        child: Text("RELOAD"),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 2,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("no coupon found"),
                  );
                }
                coupon = snapshot.data;
                //TODO
                /*      if (coupon.qrCodeUrl == null && coupon.textCouponCode == null) {
                  Navigator.maybeOf(context).pop();
                  if (!snackbarOpened) {
                    snackbarOpened = true;
                    ScaffoldMessenger.maybeOf(context).showSnackBar(
                        SnackBar(content: Text("Invalid Coupon")));
                  }
                } */
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment(-1, 1),
                        child: BackButton(
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FittedBox(
                          child: Text(
                            coupon.store.storeName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.josefinSans(
                              textStyle: h4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (coupon.store.tagline != null)
                        SizedBox(
                          height: 30,
                        ),
                      if (coupon.store.tagline != null)
                        Text(
                          coupon.store.tagline,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.josefinSans(
                            textStyle: subtitle.copyWith(
                              color: Color.fromRGBO(255, 255, 255, 0.8),
                              //  fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (coupon.store.tagline != null)
                        SizedBox(
                          height: 30,
                        )
                      else
                        SizedBox(
                          height: 20,
                        ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: primaryColor,
                          onTap: () {},
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_box_outlined,
                                  color: primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Follow".toUpperCase(),
                                  style: overlay,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        child: Text(
                          coupon.discountText,
                          style: GoogleFonts.josefinSans(
                            textStyle: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "discount",
                        style: GoogleFonts.josefinSans(
                            fontSize: 22, color: Colors.white70),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Stack(
                        children: [
                          //TODO
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.qr_code,
                              size: 192,
                            ),
                          ),

                          Container(
                            alignment: Alignment(0.7, 0),
                            child: ListingCouponAction(
                              coupon: coupon,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      if (coupon.qrCodeUrl != null)
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Material(
                                child: InkWell(
                                  onTap: () {
                                    if (!_imageLoadSuccess) {
                                      return;
                                    }
                                    Scaffold.maybeOf(context)
                                        .showBottomSheet((context) {
                                      return SizedBox.expand(
                                        child: Container(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(),
                                              ),
                                              Container(
                                                //  flex: 1,
                                                child:
                                                    FadeInImage.memoryNetwork(
                                                  placeholder:
                                                      kTransparentImage,
                                                  image: coupon.qrCodeUrl,
                                                  height: 300,
                                                  imageErrorBuilder:
                                                      (context, _, __) {
                                                    //    _qrCodeLoaded
                                                    print(coupon.qrCodeUrl);
                                                    print(coupon.qrCodeUrl);
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: Text(
                                                          "Unable to load Qr Code",
                                                          style: body1,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 150,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: primaryColor,
                                                ),
                                                child: IconButton(
                                                    splashColor:
                                                        primaryLessColor,
                                                    iconSize: 42,
                                                    color: Colors.white,
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.maybeOf(context)
                                                          .pop();
                                                    }),
                                              ),
                                              SizedBox(
                                                height: 100,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: coupon.qrCodeUrl,
                                    height: 200,
                                    imageErrorBuilder: (context, _, __) {
                                      _imageLoadSuccess = false;
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            "Unable to load Qr Code",
                                            style: body1,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment(0.7, 0),
                              child: ListingCouponAction(
                                coupon: coupon,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      Center(
                        //padding: const EdgeInsets.only(left: 100),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (coupon.textCouponUrl != null)
                              Text(coupon.textCouponCode),
                            if (coupon.textCouponUrl != null)
                              IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () async {
                                    try {
                                      await FlutterClipboard.copy(
                                          coupon.textCouponCode);
                                      ScaffoldMessenger.maybeOf(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.white,
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            "Coupon successfully copied",
                                            style: body1.copyWith(
                                                color: Colors.black),
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.maybeOf(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            "Unable to copy coupon code",
                                            style: body1,
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            if (coupon.textCouponUrl != null)
                              TextButton(
                                onPressed: _launchUrl(coupon.textCouponUrl),
                                child: Text("Go to item page"),
                              )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          coupon.desc,
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          style: GoogleFonts.josefinSans(
                            textStyle: body1.copyWith(
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "expires".toUpperCase(),
                        style: GoogleFonts.josefinSans(
                          textStyle: body2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${coupon.expiringDate}",
                        style: GoogleFonts.josefinSans(
                          textStyle: body2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(
                  backgroundColor:
                      Theme.of(context).accentColor.withOpacity(0.7),
                  strokeWidth: 6,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
