import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/models/store.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:cuo_cutter/components/single_coupon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class StorePage extends StatefulWidget {
  final String storeId;
  StorePage({Key key, @required this.storeId}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Store _store;
  bool _loading = false;
  Future<List<dynamic>> _storeFuture;
  String _more = "Load More";
  List<Coupon> _coupons;
  String _following = "follow";
  bool _snackbarActive = false;
  bool _followStore = false;

  @override
  void initState() {
    _storeFuture = _initData();
    super.initState();
  }

  Future<List<dynamic>> _initData() {
    var _sFuture = Storage.instance
        .fetchStoreDetails(storeid: widget.storeId)
        .then((value) {
      _store = value;
      print(value.storeName);
      print(_store.storeName);
      _followStore = value.following ?? false;
      if (_followStore) {
        _following = "following";
      } else {
        _following = "follow";
      }
    });
    var _cFuture = Storage.instance.fetchStoreCoupons(storeid: widget.storeId);
    return Future.wait([_sFuture, _cFuture]);
  }

// fetch new coupons when the load more button is pressed;
  _loadMoreOnPressed() async {
    setState(() {
      _loading = true;
    });
    try {
      var coupons =
          await Storage.instance.fetchStoreCoupons(storeid: widget.storeId);
      setState(() {
        _loading = false;
        if (coupons.isEmpty) {
          setState(() {
            _more = "No more coupons available";
            return;
          });
        }
        _coupons.addAll(coupons);
      });
    } catch (e) {
      setState(() {
        _loading = false;
        if (_snackbarActive == false) {
          ScaffoldMessenger.maybeOf(context)
              .showSnackBar(
                  SnackBar(content: Text("Unable to load more coupons")))
              .closed
              .then((value) => _snackbarActive = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: FutureBuilder(
            future: _storeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.7),
                    strokeWidth: 6,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("Store not found"),
                  );
                }
                // _store = snapshot.data[0];
                _coupons = snapshot.data[1];

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: BackButton(
                              color: primaryColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            alignment: Alignment.center,
                            child: Text(
                              _store.storeName,
                              style: h5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(0),
                      sliver: SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: _SliverAppBarDelegate(
                            child: Container(
                              color: Theme.of(context).backgroundColor,
                              alignment: Alignment.center,
                              child: Text(
                                _store.tagline,
                                style: body1.copyWith(fontSize: 18),
                              ),
                            ),
                            maxHeight: 50,
                            minHeight: 50),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            left: 50, right: 50, top: 10, bottom: 30),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_store.address?.isNotEmpty)
                              Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 20,
                              ),
                            if (_store.address?.isNotEmpty)
                              SizedBox(
                                child: Text(
                                  _store.address,
                                  textAlign: TextAlign.center,
                                  style: body2.copyWith(color: Colors.white70),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: primaryColor,
                            onTap: () async {
                              if (!_followStore) {
                                try {
                                  await Storage.instance.followStore(_store);
                                  setState(() {
                                    _following = "following";
                                  });
                                  _followStore = !_followStore;
                                } catch (e) {
                                  print(e);
                                  ScaffoldMessenger.maybeOf(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              "Unable to follow store,try again later")));
                                }
                              } else {
                                try {
                                  Storage.instance.unFollowStore(_store);
                                  setState(() {
                                    _following = "follow";
                                  });
                                  _followStore = !_followStore;
                                } catch (e) {
                                  print(e);
                                  ScaffoldMessenger.maybeOf(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              "Unable to process request, try again later")));
                                }
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  _following.toUpperCase(),
                                  style: overlay,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: 40, left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Coupons",
                                style: subtitle.copyWith(color: Colors.white70),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                "${_store.couponCount ?? ''} Coupons"
                                    .toUpperCase(),
                                style: overlay.copyWith(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          // crossAxisCount: 2,
                          maxCrossAxisExtent: 300,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 2 / 3,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return SingleCoupon(coupon: _coupons[index]);
                          },
                          childCount: _coupons.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 40, left: 50, right: 50),
                        child: _loading
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.7),
                                  strokeWidth: 4,
                                ),
                              )
                            : TextButton(
                                style: TextButton.styleFrom(
                                  primary: primaryColor,
                                ),
                                onPressed: _loadMoreOnPressed,
                                child: Text(
                                  "$_more",
                                  style: button,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {
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
                            _storeFuture = _initData();
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
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  _SliverAppBarDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child});

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    print(shrinkOffset);
    if (shrinkOffset == 0) {
      return SizedBox.expand(
        child: child,
      );
    }
    return Container(
      child: Stack(
        children: [
          child,
          Align(
            alignment: Alignment.topLeft,
            child: BackButton(
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
