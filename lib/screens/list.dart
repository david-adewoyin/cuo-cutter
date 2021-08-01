import 'package:connectivity/connectivity.dart';
import 'package:cuo_cutter/models/coupon.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:cuo_cutter/components/popular_coupon.dart';
import 'package:cuo_cutter/components/single_coupon.dart';
import 'package:flutter/material.dart';

class FilterCoupons extends StatefulWidget {
  final _FilterKeySet filterset;

  FilterCoupons({Key key, @required this.filterset}) : super(key: key);

  @override
  _FilterCouponsState createState() => _FilterCouponsState();
}

class _FilterCouponsState extends State<FilterCoupons> {
  _FilterKeySet filterset;
  List<PopularSingleCoupon> _popularListWidgets = [];
  List<SingleCoupon> _latestListWidget = [];
  Future<List<List<Coupon>>> _filterCouponsFuture;

  bool _loading = false;
  bool _display = true;
  String _more = "Load more";

  @override
  void initState() {
    filterset = widget.filterset;

// check if a cache response does not exists
    if (filterset.popularCoupons.isEmpty) {
      _filterCouponsFuture = _fetchData();
      return;
    }
    // returns the cache response if it already exists
    _filterCouponsFuture =
        Future.value([filterset.popularCoupons, filterset.latestCoupons]);

    super.initState();
  }

  Future<List<List<Coupon>>> _fetchData() async {
    filterset.popularCoupons =
        await Storage.instance.filterPopularList(filterset.filterName);
    filterset.latestCoupons =
        await Storage.instance.filterLatestList(filterset.filterName);
    return Future.value([filterset.popularCoupons, filterset.latestCoupons]);
  }

  // create the popular coupon widget
  List<PopularSingleCoupon> createPopularCoupons(List<Coupon> coupons) {
    List<PopularSingleCoupon> sc = [];
    for (var coupon in coupons) {
      var c = PopularSingleCoupon(
        coupon: coupon,
      );
      sc.add(c);
    }
    return sc;
  }

  // create the single coupon list
  List<SingleCoupon> createLatestCoupons(List<Coupon> coupons) {
    List<SingleCoupon> sc = [];
    for (var coupon in coupons) {
      var c = SingleCoupon(
        coupon: coupon,
      );
      sc.add(c);
    }
    return sc;
  }

// fetch new coupons when the load more button is pressed;
  Future<List<Coupon>> loadMoreCoupons() async {
    var coupons = await Storage.instance
        .fetchLatestCouponsBeforeIDAndTimeFiltered(
            filter: filterset.filterName);
    return coupons;
  }

  _loadMore() async {
    setState(() {
      _loading = true;
    });
    List<Coupon> coupons;
    coupons = await loadMoreCoupons().catchError((e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unable to load more coupons"),
        ),
      );
      List<Coupon> d = [];
      return d;
    });
    setState(() {
      _loading = false;
    });

    if (coupons.isNotEmpty) {
      setState(() {
        filterset.latestCoupons.addAll(coupons);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Coupon>>>(
      future: _filterCouponsFuture,
      builder: (context, snapshot) {
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
                  backgroundColor:
                      Theme.of(context).accentColor.withOpacity(0.7),
                  strokeWidth: 6,
                ),
              ),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return Container();
          }
          final popular = snapshot.data[0];
          final latest = snapshot.data[1];
          if (popular.isEmpty || latest.isEmpty) {
            setState(() {
              _display = false;
            });
          }

          _popularListWidgets = createPopularCoupons(popular);
          _latestListWidget = createLatestCoupons(latest);
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _display
                        ? Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Popular Coupons',
                              style: h5.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        // height: 300,
                        child: Row(
                          children: _popularListWidgets,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _display
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Latest Coupons",
                          style: h5.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  // crossAxisCount: 2,
                  maxCrossAxisExtent: 300,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2 / 3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _latestListWidget[index];
                  },
                  childCount: _latestListWidget.length,
                ),
              ),
              _display
                  ? SliverToBoxAdapter(
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
                                onPressed: _loadMore,
                                child: Text(
                                  "$_more",
                                  style: button,
                                ),
                              ),
                      ),
                    )
                  : SliverToBoxAdapter(),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class _FilterKeySet {
  List<Coupon> popularCoupons = [];
  List<Coupon> latestCoupons = [];
  final String filterName;
  PageController pageController;

  _FilterKeySet(
      {@required this.popularCoupons,
      @required this.latestCoupons,
      @required this.pageController,
      @required this.filterName});
}

class ListCoupons extends StatefulWidget {
  @override
  _ListCouponsState createState() => _ListCouponsState();
}

class _ListCouponsState extends State<ListCoupons>
    with AutomaticKeepAliveClientMixin {
  Future<List<List<Coupon>>> _initialFuture;
  List<Widget> _filteredSearchItems = [];
  List<FilterCoupons> _filterWidgetsCoupons = [];
  ValueNotifier<int> _activeFilterItem;
  bool snackbarNotOpened = true;

  ScrollController _scrollcontroller;
  PageController _pageController;
  TextEditingController _textcontroller;
  bool _filterButtonActive = false;

  @override
  void initState() {
    _scrollcontroller = ScrollController();
    _pageController = PageController();
    _textcontroller = TextEditingController();
    _activeFilterItem = ValueNotifier(0);
    _initialFuture = Storage.instance.fetchInitialCoupons();
    super.initState();
  }

  @override
  void dispose() {
    _scrollcontroller?.dispose();
    _pageController?.dispose();
    _textcontroller?.dispose();
    _activeFilterItem?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  _filterMenuOnpressed() {
    setState(() {
      //if the list is  only containn the default "all" fetch filter categories and create items in the list
      if (_filteredSearchItems.length == 1) {
        var list = Storage.instance.topCategories();

        for (var i = 0; i < list.length; i++) {
          _filteredSearchItems.add(
            FilterItem(
                pageController: _pageController,
                text: list[i],
                index: i + 1,
                active: _activeFilterItem),
          );

          var fset = _FilterKeySet(
            popularCoupons: [],
            latestCoupons: [],
            pageController: _pageController,
            filterName: list[i],
          );

          _filterWidgetsCoupons.add(FilterCoupons(filterset: fset));
        }
      }
    });

    if (_scrollcontroller.hasClients) {
      _scrollcontroller.animateTo(0,
          curve: Curves.decelerate, duration: Duration(seconds: 1));
    }
    setState(() {
      _filterButtonActive = !_filterButtonActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: GestureDetector(
          onTap: () {
            if (_scrollcontroller.hasClients) {
              _scrollcontroller.animateTo(0,
                  curve: Curves.decelerate, duration: Duration(seconds: 1));
            }
          },
          child: Text(
            "Home",
            style: h5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _filterMenuOnpressed,
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: FutureBuilder<List<List<Coupon>>>(
            future: _initialFuture,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      backgroundColor:
                          Theme.of(context).accentColor.withOpacity(0.7),
                      strokeWidth: 6,
                      // valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(),
                          flex: 3,
                        ),
                        Icon(
                          Icons.error_outline,
                          size: 64,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Something went wrong",
                          style: body1.copyWith(
                              color: Colors.white.withAlpha(200)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Unable to currently load coupons",
                          style: body1.copyWith(color: Colors.white60),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () async {
                            var connect = Connectivity();
                            var res = await connect.checkConnectivity();

                            switch (res) {
                              case ConnectivityResult.none:
                                if (snackbarNotOpened) {
                                  snackbarNotOpened = false;
                                  ScaffoldMessenger.maybeOf(context)
                                      .showSnackBar(
                                        SnackBar(
                                          elevation: 0,
                                          content: Text(
                                              "Check your internet connection"),
                                        ),
                                      )
                                      .closed
                                      .then(
                                          (value) => snackbarNotOpened = true);
                                }
                                break;
                              default:
                                setState(
                                  () {
                                    _initialFuture =
                                        Storage.instance.fetchInitialCoupons();
                                  },
                                );
                            }
                          },
                          style: TextButton.styleFrom(
                            primary: secondaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            // backgroundColor: Colors.grey.shade900
                          ),
                          child: Text(
                            "Try again",
                            style: body2,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                          flex: 3,
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                final popular = snapshot.data[0];
                final latest = snapshot.data[1];

                if (_filterWidgetsCoupons.isEmpty) {
                  var fset = _FilterKeySet(
                      popularCoupons: popular,
                      latestCoupons: latest,
                      filterName: 'all',
                      pageController: _pageController);
                  _filteredSearchItems.add(
                    FilterItem(
                        pageController: _pageController,
                        text: "all",
                        index: 0,
                        active: _activeFilterItem),
                  );

                  _filterWidgetsCoupons.add(FilterCoupons(filterset: fset));
                }

                return NestedScrollView(
                  controller: _scrollcontroller,
                  headerSliverBuilder: (context, _) {
                    return _filterButtonActive
                        ? [
                            SliverToBoxAdapter(
                                child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: EdgeInsets.only(top: 5, bottom: 10),
                                child: Row(
                                  children: _filteredSearchItems,
                                ),
                              ),
                            ))
                          ]
                        : [SliverToBoxAdapter(child: SizedBox())];
                  },
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          pageSnapping: false,
                          itemBuilder: (context, index) {
                            return _filterWidgetsCoupons[
                                _activeFilterItem.value];
                          },
                          itemCount: _filterWidgetsCoupons.length,
                        ),
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

class FilterItem extends StatefulWidget {
  final ValueNotifier<int> active;
  final index;
  final String text;
  final PageController pageController;
  FilterItem(
      {@required this.text,
      @required this.index,
      @required this.active,
      @required this.pageController});
  @override
  _FilterItemState createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  Color _color;
  Color _background;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ValueListenableBuilder(
        valueListenable: widget.active,
        builder: (context, value, child) {
          if (widget.active.value == widget.index) {
            _background = Colors.white;

            widget.pageController?.jumpToPage(widget.index);

            _color = Colors.black87;
          } else {
            _background = backgroundVariant1Color;
            _color = Colors.white70;
          }
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: _background,
              onPrimary: _color,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            child: Text(
              widget.text,
            ),
            onPressed: () {
              widget.active.value = widget.index;
            },
          );
        },
      ),
    );
  }
}
