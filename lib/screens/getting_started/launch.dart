import 'package:cuo_cutter_app/screens/getting_started/onboarding.dart';
import 'package:cuo_cutter_app/screens/home.dart';
import 'package:cuo_cutter_app/storage/storage.dart';
import 'package:cuo_cutter_app/theme.dart';
import 'package:flutter/material.dart';

//Default lauchpage for the app
class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Future<bool> freshAppInstall =
      Storage.instance.isAppFreshInstalled().timeout(Duration(seconds: 2));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: freshAppInstall,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        // If an error occur navigate to home page
        if (snapshot.hasError) {
          Storage.instance.setFreshAppInstall();
          print("error in");
          // navigate to home page on error
          return Home();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // freshinstal == true navigate to onboardingPage
            if (snapshot.data) {
              return OnboardingPage();
            }

            return Home();
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: Image.asset(
                "assets/images/logo.png",
                height: 80,
                width: 80,
              ),
            ),
            color: loaderBackgroundColor,
          );
        }
        return Container(
          color: loaderBackgroundColor,
        );
      },
    );
  }
}
