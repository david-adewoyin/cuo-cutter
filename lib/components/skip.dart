import 'package:connectivity/connectivity.dart';
import 'package:cuo_cutter/screens/home.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:flutter/material.dart';

// returns a skip button
final skipToHomeButton = Builder(builder: (context) {
  return SafeArea(
    child: Align(
      alignment: Alignment(0.9, -0.95),
      child: TextButton(
        style: TextButton.styleFrom(),
        onPressed: () async {
          Storage.instance.setFreshAppInstall();
          var connectivityRes = await (Connectivity().checkConnectivity());
          if (connectivityRes != ConnectivityResult.mobile ||
              connectivityRes != ConnectivityResult.wifi) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: backgroundVariant3Color,
                  title: Text("check your internet connections"),
                );
              },
            );
          }
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return Home();
          }), (route) {
            return false;
          });
        },
        child: Text(
          "SKIP",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    ),
  );
});
