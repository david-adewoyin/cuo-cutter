import 'package:cuo_cutter/components/routes.dart';
import 'package:cuo_cutter/screens/dashboard/create_coupon.dart';
import 'package:cuo_cutter/screens/dashboard/dashboard.dart';
import 'package:cuo_cutter/screens/list.dart';
import 'package:cuo_cutter/screens/qr_scanner/qr_scanner.dart';
import 'package:cuo_cutter/screens/search.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:cuo_cutter/components/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  ValueNotifier<TabController> _tabController;
  ValueNotifier<Color> _color;
  List<Widget> pages;
  @override
  void initState() {
    var _t = TabController(vsync: this, length: 4);
    _color = ValueNotifier(backgroundDark);
    _tabController = ValueNotifier(_t);
    pages = [
      ListCoupons(),
      SearchPage(),
      CameraApp(),
      UserDashboard(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _color,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: value,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _tabController.value.index == 3 &&
                  Storage.instance.isUserLoggedIn()
              ? Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: primaryColor),
                  //   padding: EdgeInsets.all(10),
                  child: IconButton(
                    tooltip: "create coupon",
                    iconSize: 32,
                    onPressed: () {
                      return Navigator.maybeOf(context)
                          .push(slideRouteFromButtom(CreateCouponPage()));
                    },
                    icon: Icon(Icons.add),
                    color: Colors.black,
                  ),
                )
              : null,
          body: child,
          bottomNavigationBar:
              Custom(controllerNotifer: _tabController, colorNotifier: _color),
        );
      },
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController.value,
        children: [...pages],
      ),
    );
  }
}

class Custom extends StatefulWidget {
  final ValueNotifier<TabController> controllerNotifer;
  final ValueNotifier<Color> colorNotifier;

  Custom({this.controllerNotifer, this.colorNotifier});

  @override
  _CustomState createState() => _CustomState();
}

class _CustomState extends State<Custom> {
  final ValueNotifier<bool> showAddBtnOnNotifer = ValueNotifier(false);

  _CustomState();
  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      showAddBtnOnNotifer: showAddBtnOnNotifer,
      backgroundColor: backgroundVariant3Color,
      unselectedItemColor: Colors.grey.shade500,
      iconSize: 26,
      selectedLabelStyle: GoogleFonts.josefinSans(),
      unselectedLabelStyle: GoogleFonts.josefinSans(),
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.controllerNotifer.value.index,
      selectedItemColor: Colors.white,
      onTap: (value) {
        setState(() {
          widget.controllerNotifer.value.index = value;
          if (widget.controllerNotifer.value.index == 3 &&
              Storage.instance.isUserLoggedIn()) {
            setState(() {
              showAddBtnOnNotifer.value = true;
            });
          } else {
            setState(() {
              showAddBtnOnNotifer.value = false;
            });
          }
          if (value == 3) {
            widget.colorNotifier.value = backgroundVariant3Color;
          } else {
            widget.colorNotifier.value = backgroundDark;
          }
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "search",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code),
          label: "scan coupon",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "dashboard",
        ),
      ],
    );
  }
}
