import 'package:cuo_cutter_app/components/single_saved_coupon.dart';
import 'package:cuo_cutter_app/components/store_coupon_action.dart';
import 'package:cuo_cutter_app/models/coupon.dart';
import 'package:cuo_cutter_app/models/store.dart';
import 'package:cuo_cutter_app/screens/dashboard/store_management.dart';
import 'package:cuo_cutter_app/screens/getting_started/login.dart';
import 'package:cuo_cutter_app/screens/store_details.dart';
import 'package:cuo_cutter_app/storage/storage.dart';
import 'package:cuo_cutter_app/theme.dart';
import 'package:cuo_cutter_app/components/single_userstore_coupon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

PageStorageKey mykey = new PageStorageKey("testkey");

class UserDashboard extends StatefulWidget {
  final ValueNotifier<Color> notifier;

  const UserDashboard({Key key, this.notifier}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<UserDashboard>
    with SingleTickerProviderStateMixin {
  final PageStorageBucket _bucket = PageStorageBucket();
  final PageStorageKey keyOne = PageStorageKey('pageOne');
  final PageStorageKey keyTwo = PageStorageKey('pageTwo');
  final PageStorageKey keyThree = PageStorageKey('pageThree');

  TabController _controller;
  ValueNotifier<bool> _isLoggedin;
  Store _store;

  @override
  void initState() {
    _isLoggedin = ValueNotifier(Storage.instance.isUserLoggedIn());
    if (_isLoggedin.value) {
      _controller = TabController(length: 3, vsync: this);
      _initStore();
      return;
    }
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  _initStore() async {
    _store = await Storage.instance.fetchUserStore();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _isLoggedin?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundDark,
        body: SafeArea(
          child: Container(
            child: ValueListenableBuilder<bool>(
              valueListenable: _isLoggedin,
              builder: (BuildContext context, isLoggedIn, Widget child) {
                return NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverAppBar(
                        backgroundColor: backgroundVariant3Color,
                        title: Container(
                          child: Material(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: primaryColor,
                              onTap: () {
                                // taje the user to store management if he is logged in
                                if (isLoggedIn) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return StoreManagementPage(
                                          store: _store,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  Navigator.maybeOf(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return LoginPage();
                                  }));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: Icon(Icons.person),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    isLoggedIn
                                        ? _store?.storeName ?? "Your Store"
                                        : "Create an account",
                                    style: body1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        pinned: true,
                        floating: true,
                        toolbarHeight: 90,
                        bottom: new TabBar(
                          indicatorColor: primaryColor,
                          tabs: [
                            if (isLoggedIn)
                              Tab(
                                child: Text(
                                  'Dashboard',
                                  style: body1,
                                ),
                              ),
                            Tab(
                              child: Text(
                                'Saved',
                                style: body1,
                              ),
                            ),
                            Tab(
                                child: Text(
                              'Following',
                              style: body1,
                            )),
                          ],
                          controller: _controller,
                        ),
                      )
                    ];
                  },
                  body: PageStorage(
                    bucket: _bucket,
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        if (isLoggedIn)
                          _CouponDashboard(
                            key: keyOne,
                          ),
                        _SavedCoupons(
                          key: keyTwo,
                        ),
                        _Following(
                          key: keyThree,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SavedCoupons extends StatefulWidget {
  _SavedCoupons({Key key}) : super(key: key);
  @override
  _SavedCouponsState createState() => _SavedCouponsState();
}

class _SavedCouponsState extends State<_SavedCoupons> {
  List<SingleSavedCoupon> _savedCouponsWidget = [];
  Future<List<Coupon>> _couponFuture;

  @override
  void initState() {
    _couponFuture = Storage.instance.fetchCouponsSaved();
    super.initState();
  }

  // create the single coupon list
  List<SingleSavedCoupon> createSavedCouponsWidget(List<Coupon> coupons) {
    List<SingleSavedCoupon> sc = [];
    for (var coupon in coupons) {
      var c = SingleSavedCoupon(
        coupon: coupon,
      );
      sc.add(c);
    }
    return sc;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Coupon>>(
      future: _couponFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return RefreshIndicator(
            onRefresh: () {
              setState(() {
                _couponFuture = Storage.instance.fetchCouponsSaved();
              });
              return _couponFuture;
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.center(Offset.zero).dy,
                alignment: Alignment.center,
                child: Text(
                  "Unable to fetch saved coupon",
                  style: body1,
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              ),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return RefreshIndicator(
              onRefresh: () {
                setState(() {
                  _couponFuture = Storage.instance.fetchCouponsSaved();
                });
                return _couponFuture;
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.center(Offset.zero).dy,
                  alignment: Alignment.center,
                  child: Text(
                    "You haven't saved a coupon",
                    style: body1,
                  ),
                ),
              ),
            );
          }
          final coupons = snapshot.data;
          _savedCouponsWidget = createSavedCouponsWidget(coupons);
          return RefreshIndicator(
            onRefresh: () {
              setState(() {
                _couponFuture = Storage.instance.fetchCouponsSaved();
              });
              return;
            },
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  // crossAxisCount: 2,
                  maxCrossAxisExtent: 300,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (context, index) {
                  return _savedCouponsWidget[index];
                },
                itemCount: _savedCouponsWidget.length,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class _Following extends StatefulWidget {
  _Following({Key key}) : super(key: key);

  @override
  __FollowingState createState() => __FollowingState();
}

class __FollowingState extends State<_Following> {
  List<Store> stores = [];
  Future<List<Store>> _storesFuture;
  List<SliverToBoxAdapter> _storeWidgets = [];

  @override
  void initState() {
    _storesFuture = Storage.instance.fetchStoresFollowed();
    super.initState();
  }

  List<SliverToBoxAdapter> createStoresFollowed(List<Store> stores) {
    List<SliverToBoxAdapter> _storesWid = [];

    for (var store in stores) {
      _storesWid.add(
        SliverToBoxAdapter(
          child: StoreDetails(
            store: store,
          ),
        ),
      );
    }
    return _storesWid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Store>>(
      future: _storesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return RefreshIndicator(
            onRefresh: () {
              setState(() {
                _storesFuture = Storage.instance.fetchStoresFollowed();
              });
              return _storesFuture;
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.center(Offset.zero).dy,
                child: Center(
                  child: Text(
                    "Unable to fetch data",
                    style: body1,
                  ),
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              ),
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return RefreshIndicator(
              onRefresh: () {
                setState(() {
                  _storesFuture = Storage.instance.fetchStoresFollowed();
                });
                return _storesFuture;
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.center(Offset.zero).dy,
                  child: Center(
                    child: Text(
                      "You haven't  followed any store",
                      style: body1,
                    ),
                  ),
                ),
              ),
            );
          }

          final stores = snapshot.data;
          _storeWidgets = createStoresFollowed(stores);
          return RefreshIndicator(
            onRefresh: () {
              setState(() {
                _storesFuture = Storage.instance.fetchStoresFollowed();
              });
              return _storesFuture;
            },
            child: Container(
              child: CustomScrollView(
                slivers: [..._storeWidgets],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}

class StoreDetails extends StatefulWidget {
  final Store store;

  const StoreDetails({
    Key key,
    @required this.store,
  }) : super(key: key);

  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  List<Coupon> _coupons = [];
  Future<List<Coupon>> _storeCouponsFuture;

  @override
  void initState() {
    _storeCouponsFuture =
        Storage.instance.fetchStoreCoupons(storeid: widget.store.storeId);
    super.initState();
  }

  List<Widget> construct(List<Coupon> coupons) {
    List<Widget> cWid = [];
    for (var coupon in coupons) {
      cWid.add(
        Container(
          height: 250,
          width: 200,
          padding: EdgeInsets.only(top: 20, right: 15),
          child: SingleCouponFollow(
            background: backgroundVariant1Color,
            coupon: coupon,
          ),
        ),
      );
    }
    return cWid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            //  topLeft: Radius.circular(10),
            //   bottomLeft: Radius.circular(10),
            ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.9,
            //   color: Colors.red,
            offset: Offset(0.5, 0.5),
          )
        ],
        color: Color(0xff212121),
      ),
      // margin: EdgeInsets.only(top: 20, left: 10, bottom: 20),
      margin: EdgeInsets.only(top: 20, bottom: 5),
      padding: EdgeInsets.only(left: 10, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              /*  CircleAvatar(
                maxRadius: 10,
                child: Icon(
                  Icons.store,
                ),
                backgroundColor: primaryColor,
              ), */

              Text(
                widget.store.storeName,
                style: body2.copyWith(fontSize: 15),
              ),
              Expanded(
                child: Container(),
                flex: 3,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return StorePage(
                      storeId: widget.store.storeId,
                    );
                  }));
                },
                child: Text(
                  "Go to Store",
                  style: body2,
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              child: FutureBuilder(
                  future: _storeCouponsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                        height: 80,
                        child: Text("Unable to load coupons", style: body1),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        _coupons = snapshot.data;
                        return Row(children: construct(_coupons));
                      }
                      return Container(
                        height: 80,
                        child: Text(
                          "Store does not have any coupons",
                          style: body1,
                        ),
                      );
                    }
                    return Container();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponDashboard extends StatefulWidget {
  _CouponDashboard({Key key}) : super(key: key);
  @override
  _CouponDashboardState createState() => _CouponDashboardState();
}

enum FilterShowState {
  today,
  week,
  month,
  all,
}

class _CouponDashboardState extends State<_CouponDashboard> {
  List<Widget> _couponsWidgets = [];
  List<Coupon> _coupons = [];
  FilterShowState _filterShow = FilterShowState.today;
  FilterShowState _filterCouponTime = FilterShowState.today;
  Future<List<Coupon>> _couponsFuture;
  Future<int> _totalRedeemedFuture;
  ValueNotifier<Coupon> _deleteIndexNotifier;
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    _couponsFuture = _fetchCouponsFilterTime("today");
    _totalRedeemedFuture =
        Storage.instance.fetchUserStoreCouponRedeemedCount(filter: "today");
    _registerListener();
  }

  _registerListener() {
    // remove the coupon if its deleted
    _deleteIndexNotifier = ValueNotifier(null);
    _deleteIndexNotifier.addListener(() {
      var index = _coupons.indexOf(_deleteIndexNotifier.value);
      setState(() {
        _couponsWidgets.removeAt(index);
        var c = _coupons.removeAt(index);
        print("deleting ${c.couponId}");
      });
      _couponsFuture = Future.value(_coupons);
    });
  }

  @override
  void dispose() {
    _deleteIndexNotifier?.dispose();
    super.dispose();
  }

  Future<List<Coupon>> _fetchCouponsFilterTime(String filter) async {
    return Storage.instance.fetchUserStoreCoupons(filter: filter);
  }

  _fetchTotalRedeemed(String filter) async {
    _totalRedeemedFuture =
        Storage.instance.fetchUserStoreCouponRedeemedCount(filter: filter);
  }

  @override
  String _getFilter(FilterShowState state) {
    switch (state) {
      case FilterShowState.today:
        return "today";
        break;
      case FilterShowState.week:
        return "week";
        break;
      case FilterShowState.month:
        return "month";
        break;
      case FilterShowState.all:
        return "all";
        break;
    }
  }

  Widget buildCouponTile(Coupon coupon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.only(bottom: 10, left: 5, top: 10),
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[700],
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            color: coupon.store.themeColor,
            height: 70,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coupon.store.storeName),
                SizedBox(
                  height: 10,
                ),
                Text(coupon.desc),
                SizedBox(
                  height: 0,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          StoreCouponAction(
            deleteIndexNotifier: _deleteIndexNotifier,
            coupon: coupon,
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 30,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(right: 250, left: 15),
            child: DropdownButton<FilterShowState>(
              underline: Container(),
              value: _filterShow,
              onChanged: (value) {
                setState(() {
                  _filterShow = value;
                });
                var filter = _getFilter(value);
                _fetchTotalRedeemed(filter);
              },
              items: [
                DropdownMenuItem(
                  child: Text(
                    "TODAY",
                    style: overlay,
                  ),
                  value: FilterShowState.today,
                ),
                DropdownMenuItem(
                  child: Text(
                    "THIS WEEK",
                    style: overlay,
                  ),
                  value: FilterShowState.week,
                ),
                DropdownMenuItem(
                  child: Text("THIS MONTH", style: overlay),
                  value: FilterShowState.month,
                ),
                DropdownMenuItem(
                  child: Text(
                    "ALL TIME",
                    style: overlay,
                  ),
                  value: FilterShowState.all,
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),

        SliverToBoxAdapter(
          child: FutureBuilder<int>(
              future: _totalRedeemedFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Unable to fetch data"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Text(
                    "Loading ...",
                    style: body1,
                  ));
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("No data found"),
                    );
                  }
                  var _total = snapshot.data;
                  return Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Total Redeemed: $_total Coupons",
                      style: body1,
                    ),
                  );
                }

                return Container();
              }),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Created Coupons",
                      style: body1,
                    ),
                  ),
                ),
                Container(
                  child: DropdownButton<FilterShowState>(
                    underline: Container(),
                    value: _filterCouponTime,
                    onChanged: (value) {
                      setState(() {
                        _filterCouponTime = value;
                      });
                      var filter = _getFilter(value);
                      _couponsFuture = _fetchCouponsFilterTime(filter);
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "TODAY",
                          style: overlay,
                        ),
                        value: FilterShowState.today,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "THIS WEEK",
                          style: overlay,
                        ),
                        value: FilterShowState.week,
                      ),
                      DropdownMenuItem(
                        child: Text("THIS MONTH", style: overlay),
                        value: FilterShowState.month,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "ALL TIME",
                          style: overlay,
                        ),
                        value: FilterShowState.all,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),

        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              child: FutureBuilder<List<Coupon>>(
                  future: _couponsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor:
                              Theme.of(context).accentColor.withOpacity(0.7),
                          strokeWidth: 4,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Unable to load coupons"));
                    }
                    if (snapshot.connectionState == ConnectionState.none) {
                      print("no data found");
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      print("Here nwo");
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text("No coupons found"),
                        );
                      }
                      print("Here now again");
                      var coupons = snapshot.data;

                      print(snapshot.data);
                      _coupons = coupons;
                      for (var coupon in coupons) {
                        _couponsWidgets.add(buildCouponTile(coupon));
                      }

                      return Column(
                        children: _couponsWidgets,
                      );
                    }

                    return Container();
                  }),
            )
          ]),
        ),

        //  ..._coupons,
      ],
    );
  }
}
