import 'dart:convert';
import 'dart:io';

import 'package:cuo_cutter_app/main.dart';
import 'package:cuo_cutter_app/models/coupon.dart';
import 'package:cuo_cutter_app/screens/qr_scanner/util.dart';
import 'package:cuo_cutter_app/theme.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CameraController controller;
  AnimationController aniController;
  Future<void> _initCamera;
  bool _tourchOn = false;
  BarcodeDetector decoder;
  FirebaseVisionImage _image;
  final camera = cameras[cameras
      .indexWhere((cam) => cam.lensDirection == CameraLensDirection.back)];
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp],
    );

    decoder = FirebaseVision.instance.barcodeDetector();
    aniController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    aniController
      ..forward()
      ..repeat(reverse: true);

    initCamera();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
        // initCamera();
        return;
      }
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  initCamera() {
    controller = CameraController(
      camera,
      ResolutionPreset.low,
      enableAudio: false,
    );
    _initCamera = controller.initialize();
    _initCamera.then((_) async {
      controller.setZoomLevel(2);
      streamImages();
    });
  }

  streamImages() async {
    controller.startImageStream((image) async {
      var c = ScannerUtils.concatenatePlanes(image.planes);
      var d = ScannerUtils.buildMetaData(image);
      _image = FirebaseVisionImage.fromBytes(c, d);
      try {
        processBarCode(_image);
      } catch (e) {}
    });
  }

  processBarCode(FirebaseVisionImage image) async {
    final barcodes = await decoder.detectInImage(image);
    for (var barcode in barcodes) {
      var json = jsonDecode(barcode.rawValue);
      print(json);
      try {
        var qr = QrImage.fromJson(json);
        await controller.stopImageStream();

        if (DateTime.now().millisecondsSinceEpoch < qr.data.exp) {
          ScaffoldMessenger.maybeOf(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: errorAlertColor,
              content: Text(
                "Coupon has already expired",
                style: body1,
              ),
            ),
          );
          return;
        }

        showModalBottomSheet(
            context: context,
            builder: (context) {
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  color: backgroundVariant1Color,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.maybeOf(context).pop();
                          },
                        ),
                      ),
                      Text(
                        qr.data.text,
                        style: h4,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        Coupon.expiringDateFromStamp(qr.data.exp),
                        style: body1,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.all(10),
                            ),
                            onPressed: () {},
                            child: Text("Redeem Coupon"),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: primaryColor,
                              shape: null,
                            ),
                            onPressed: () {},
                            child: Text("Check Coupon State"),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              );
            });
      } catch (e) {
        print(e);
      }
    }
    return Future.error("Not valid");
  }

  detectInFile() async {
    controller.stopImageStream();
    ImagePicker picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    File file = File(imageFile.path);
    final image = FirebaseVisionImage.fromFile(file);
    processBarCode(image).catchError((value) {
      showDialog(
          context: _scaffoldKey.currentContext,
          builder: (context) {
            return AlertDialog(
              title: Text("Not a valid qr code"),
              content: Text("This is not a valid qr code"),
            );
          });
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    controller?.dispose();
    aniController?.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text("Scan Coupon"),
        ),
      ),
      body: Stack(children: [
        SizedBox.expand(
          child: FutureBuilder(
            future: _initCamera,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                /*     return ValueListenableBuilder(
                  valueListenable: null,
                  builder: (context, value, child) {
                    if
                  },
                ); */
                return Center(
                  child: CameraPreview(
                    controller,
                    child: SafeArea(
                      child: Container(
                        alignment: Alignment.center,
                        child: AnimatedBuilder(
                          animation: aniController,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: ScannerPainter(
                                  listenable: aniController,
                                  size: MediaQuery.of(context).size),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.image_rounded),
                onPressed: detectInFile,
              ),
              IconButton(
                icon: Icon(
                  _tourchOn ? Icons.flash_on : Icons.flash_off,
                ),
                onPressed: () {
                  if (controller != null) {
                    if (_tourchOn) {
                      controller.setFlashMode(FlashMode.off);
                    } else {
                      controller.setFlashMode(FlashMode.torch);
                    }
                    setState(() {
                      _tourchOn = !_tourchOn;
                    });
                  }
                },
              )
            ],
          ),
        )
      ]),
    );
  }
}

class ScannerPainter extends CustomPainter {
  final Animation listenable;
  final Color color;
  final Size size;

  ScannerPainter({this.listenable, this.size})
      : color = primaryColor.withAlpha((listenable.value * 255).toInt());

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double windowHalfWidth = 300 / 2;
    final double windowHalfHeight = 320 / 2;
    final short = 4;
    final long = 45;

    final paint = Paint()..color = color;
    final topLeftPath = Path();
    final topRightPath = Path();
    final bottomLeftPath = Path();
    final bottomRightPath = Path();

    var xleft = center.dx - windowHalfWidth;
    var xright = center.dx + windowHalfWidth;
    var ytop = center.dy - windowHalfHeight;
    var ybottom = center.dy + windowHalfHeight;

    final RRect windowRect = RRect.fromLTRBR(
      center.dx - windowHalfWidth,
      center.dy - windowHalfHeight,
      center.dx + windowHalfWidth,
      center.dy + windowHalfHeight,
      Radius.circular(2),
    );

// horizontal long
    topLeftPath.addRRect(
      RRect.fromLTRBAndCorners(
        xleft,
        ytop,
        xleft + long,
        ytop + short,
        bottomRight: Radius.circular(100),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(100),
      ),
    );

// vertical down
    topLeftPath.addRRect(
      RRect.fromLTRBAndCorners(
        xleft,
        ytop,
        xleft + short,
        ytop + long,
        bottomRight: Radius.circular(100),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(100),
      ),
    );

// horizontal long
    topRightPath.addRRect(
      RRect.fromLTRBAndCorners(
        xright - long,
        ytop,
        xright,
        ytop + short,
        bottomRight: Radius.circular(100),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(100),
      ),
    );
//vertical short
    topRightPath.addRRect(
      RRect.fromLTRBAndCorners(
        xright,
        ytop,
        xright - short,
        ytop + long,
        bottomRight: Radius.circular(100),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(100),
      ),
    );
// horizontal long
    bottomRightPath.addRRect(
      RRect.fromLTRBAndCorners(
        xright - long,
        ybottom - short,
        xright,
        ybottom,
        bottomRight: Radius.circular(100),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(100),
      ),
    );
//vertical short
    bottomLeftPath.addRRect(
      RRect.fromLTRBAndCorners(
        xleft,
        ybottom,
        xleft + short,
        ybottom - long,
        bottomRight: Radius.circular(100),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(100),
      ),
    );
// horizontal long
    bottomLeftPath.addRRect(
      RRect.fromLTRBAndCorners(
        xleft,
        ybottom - short,
        xleft + long,
        ybottom,
        bottomRight: Radius.circular(100),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(100),
      ),
    );
//vertical short
    bottomRightPath.addRRect(
      RRect.fromLTRBAndCorners(
        xright,
        ybottom,
        xright - short,
        ybottom - long,
        bottomRight: Radius.circular(100),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(100),
      ),
    );

    final RRect fullRect = RRect.fromLTRBR(
      center.dx - this.size.width,
      center.dy - this.size.height,
      center.dx + this.size.width,
      center.dy + this.size.height,
      Radius.circular(2),
    );
    canvas.drawDRRect(
        fullRect, windowRect, Paint()..color = Colors.black.withAlpha(100));

/*   canvas.drawRRect(
        windowRect,
        Paint()
          ..color = Colors.white10
          ..style = PaintingStyle.fill); */
    canvas.drawPath(topLeftPath, paint);
    canvas.drawPath(topRightPath, paint);
    canvas.drawPath(bottomLeftPath, paint);
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(ScannerPainter oldDelegate) {
    if (oldDelegate.color != color) {
      return true;
    }

    return false;
  }

  @override
  bool shouldRebuildSemantics(ScannerPainter oldDelegate) => false;
}
