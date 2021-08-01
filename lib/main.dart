import 'package:camera/camera.dart';
import 'package:cuo_cutter/screens/getting_started/launch.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await Firebase.initializeApp();
  cameras = await availableCameras();

  runApp(
    MaterialApp(
      home: Scaffold(
        body: LaunchPage(),
      ),
      theme: couponThemeData,
      debugShowCheckedModeBanner: false,
    ),
  );
  // initialize the database
}
