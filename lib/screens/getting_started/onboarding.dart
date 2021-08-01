import 'package:connectivity/connectivity.dart';
import 'package:cuo_cutter/screens/getting_started/login.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:cuo_cutter/components/skip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController controller;
  var currentPageNotifier = ValueNotifier<int>(0);
  @override
  void initState() {
    controller = PageController(
      initialPage: 0,
      keepPage: false,
    );

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value:
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              controller: controller,
              itemCount: 3,
              onPageChanged: (value) {
                setState(() {
                  currentPageNotifier.value = value;
                });
              },
              itemBuilder: (context, value) => builder(value),
            ),
            skipToHomeButton,
            Positioned(
              bottom: 80,
              child: Row(
                children: [
                  PageIndicator(
                    notifier: currentPageNotifier,
                    index: 0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  PageIndicator(
                    notifier: currentPageNotifier,
                    index: 1,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  PageIndicator(
                    notifier: currentPageNotifier,
                    index: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  builder(int index) {
    if (index > 2) {
      return;
    }
    var carouselImages = [
      'assets/images/man_sale.png',
      'assets/images/dashboard.png',
      'assets/images/save_time.png',
    ];

    return BuildCarouselPage(
      key: UniqueKey(),
      image: carouselImages[index],
    );
  }
}

class BuildCarouselPage extends StatelessWidget {
  final String image;
  const BuildCarouselPage({
    this.image,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(gradient: onboardColor),
      child: Column(
        children: [
          SizedBox(
            height: 500,

            //   color: Colors.orange[200],
            child: Padding(
              padding: EdgeInsets.only(top: 112, bottom: 81),
              child: Image.asset(image),
            ),
          ),
          Text(
            'Create your Coupons',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Use our free tool to create your coupons",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 72,
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
            child: Text(
              "Get Started".toUpperCase(),
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatefulWidget {
  final ValueNotifier notifier;
  final double index;
  PageIndicator({this.index, this.notifier});

  @override
  PageIndicatorState createState() => PageIndicatorState();
}

class PageIndicatorState extends State<PageIndicator> {
  @override
  Widget build(BuildContext context) {
    bool isActive = false;
    if (widget.index == widget.notifier.value) {
      isActive = true;
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? primaryColor : Colors.green[300],
      ),
    );
  }
}
