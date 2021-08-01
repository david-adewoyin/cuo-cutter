import 'package:cuo_cutter/screens/qr_scanner/qr_scanner.dart';
import 'package:cuo_cutter/theme.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class QRFab extends StatefulWidget {
  const QRFab({
    Key key,
  }) : super(key: key);

  @override
  _QRFabState createState() => _QRFabState();
}

class _QRFabState extends State<QRFab> {
  FirebaseVisionImage visionImage;

  final BarcodeDetector barcodeDetector =
      FirebaseVision.instance.barcodeDetector();

  _onpressed() async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return CameraApp();
      }),
    );
  }

  @override
  void dispose() {
    barcodeDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryLessColor,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        height: 70,
        width: 70,
        child: Center(
          child: SizedBox(
              height: 65,
              width: 65,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 32,
                  onPressed: _onpressed,
                  icon: Icon(
                    Icons.qr_code,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
