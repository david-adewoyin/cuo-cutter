import 'package:flutter/material.dart';

const loaderBackgroundColor = Color(0xFF33333D);
const primaryColor = Color(0xFFFF6C87);
const secondaryColor = Color(0xFF9FA4FD);
const disabledColor = Color(0xFFF5F5F5);
const onDisabledColor = Color(0xFF98999E);
const primaryLessColor = Color(0xFFFFAABA);
const onErrorColor = Color(0xFFF4EFAE);
const onBackgroundColor = Color(0xFFFFFFFF);
const onBackgroundLesser = Color(0xFF98999E);
const whiteLesser = Color.fromRGBO(255, 255, 255, 0.8);
const onBackgroundLessColor = Color.fromRGBO(
  255,
  255,
  255,
  0.68,
);
const backgroundColor = Color(0xFF33333D);
const backgroundVariant1Color = Color.fromRGBO(59, 52, 63, 1);
const backgroundVariant2Color = Color(0xFF1C1C1E);
const backgroundVariant3Color = Color(0xFF1D1D22);
const backgroundDark = Color(0xFF121212);

const onboardColor = LinearGradient(
  colors: [
    Color(0xFF4E3744),
    Color(0xFF3A343F),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const errorAlertColor = Color(0xFFf4511d);
//Textstyle
const onErrorTextStyle = TextStyle(
  fontSize: 14,
  letterSpacing: 0.25,
  color: onErrorColor,
);

const h2 = TextStyle(
  fontSize: 60,
  fontWeight: FontWeight.bold,
  letterSpacing: -0.5,
);
const h3 = TextStyle(
  fontSize: 48,
  letterSpacing: 0,
);
const h4 = TextStyle(
  fontSize: 34,
  letterSpacing: 0.25,
);
const h5 = TextStyle(
  fontSize: 24,
  letterSpacing: 0,
);
const subtitle = TextStyle(
  fontSize: 16,
  letterSpacing: 0.15,
);
const overlay = TextStyle(
  fontSize: 14,
  letterSpacing: 0.5,
);
const button = TextStyle(
  fontSize: 14,
  letterSpacing: 1.25,
);

const body1 = TextStyle(
  fontSize: 16,
  letterSpacing: 0.5,
);

const body2 = TextStyle(
  fontSize: 14,
  letterSpacing: 0.25,
);

final couponThemeData = ThemeData(
  brightness: Brightness.dark,
  accentColor: secondaryColor,
  backgroundColor: backgroundDark,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white70,
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: body1.copyWith(color: Colors.black),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Color(0xFFf4511d),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: secondaryColor,
      onPrimary: Colors.black,
      padding: EdgeInsets.only(bottom: 15, top: 15, left: 142, right: 142),
    ),
  ),
);

final colorList = [
  Color(0xFF9FFDB4).withOpacity(0.5),
  Color(0xFFCDDC39),
  Color(0xFF80CBC4),
  Color(0xFFDCEDC8),
  Color(0xFF80CBC4),
  Color(0xFFF4EFAE).withOpacity(0.5),
  Color(0xFFF4AEAE).withOpacity(0.5),
  Color(0xFFFF6C87).withOpacity(0.5),
  Color(0xFFFFCDD2),
  Color(0xFFff80AB),
  Color(0xFFFFE0B2),
  Color(0xFFF8BBD0),
  Color(0xFFB39DDB),
  Color(0xFFE1BEE7),
  Color(0xFFBBDEFB),
  Color(0xFFC5CAE9),
  Color(0xFF82b3c9),
  Color(0xFFbbb5c3),
  Color(0xFFc0b3c2),
  Color(0xFFffffe5),
  Color(0xFFcbc693),
  Color(0xFFaebfbe),
  Color(0xFFcb9b8c),
  Color(0xFF9FA4ED),
  Color(0xFFFFCCBC),
  Color(0xFFF0F4C3),
];
