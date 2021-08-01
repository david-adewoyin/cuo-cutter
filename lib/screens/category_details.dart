import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:cuo_cutter/components/single_coupon.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CategoryPage extends StatefulWidget {
  final String categoryName;
  CategoryPage({Key key, @required this.categoryName}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _loading = false;
  Future<List<Coupon>> _categoryCouponsFuture;
  String _more = "Load More";
  List<Coupon> _coupons;
  bool _snackbarActive = false;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() {
    _categoryCouponsFuture = Storage.instance
        .fetchCategoryCoupons(categoryName: widget.categoryName);
  }

// fetch new coupons when the load more button is pressed;
  _loadMoreOnPressed() async {
    setState(() {
      _loading = true;
    });
    try {
      var coupons = await Storage.instance
          .fetchCategoryCoupons(categoryName: widget.categoryName);

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
          child: FutureBuilder<List<Coupon>>(
            future: _categoryCouponsFuture,
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
                    child: Text("Unable to fetch content"),
                  );
                }

                _coupons = snapshot.data;

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: BackButton(
                          color: primaryColor,
                        ),
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
                                widget.categoryName,
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
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
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: 20, left: 15, right: 15),
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Coupons",
                          style: subtitle.copyWith(color: Colors.white),
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
                print(snapshot.error);
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
                            _categoryCouponsFuture = _initData();
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
