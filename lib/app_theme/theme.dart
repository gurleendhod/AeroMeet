import 'package:aero_meet/constant/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aero_meet/constant/app_config.dart' as config;

class AppTheme {

  final lightTheme = ThemeData(
    fontFamily: 'NunitoSans',
    primaryColor: CustomColors().mainColor(1),
    iconTheme: IconThemeData(color: Colors.black),
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(color: CustomColors().mainColor(1)),
    accentColor: config.CustomColors().mainColor(1),
    focusColor: config.CustomColors().accentColor(1),
    hintColor: config.CustomColors().secondColor(1),
    textTheme: TextTheme(
      headline1:
          TextStyle(fontSize: 22.0, color: config.CustomColors().mainColor(1), fontWeight: FontWeight.w700,),
      headline2: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: config.CustomColors().mainColor(1)),
      headline3: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: config.CustomColors().mainColor(1)),
      headline4: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: config.CustomColors().mainColor(1)),
      headline5: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w300,
          color: config.CustomColors().mainColor(1)),
      subtitle1: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: config.CustomColors().secondColor(1)),
      subtitle2: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
          color: config.CustomColors().secondColor(1)),
      caption: TextStyle(fontSize: 12.0, color: config.CustomColors().accentColor(1)),
    ),
  );

  final darkTheme = ThemeData(
    fontFamily: 'NunitoSans',
    primaryColor: Color(0xFF252525),
    iconTheme: IconThemeData(color: Colors.white),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF2C2C2C),
    accentColor: config.CustomColors().mainDarkColor(1),
    hintColor: config.CustomColors().secondDarkColor(1),
    focusColor: config.CustomColors().accentDarkColor(1),
    textTheme: TextTheme(
      headline1:
          TextStyle(fontSize: 20.0, color: config.CustomColors().secondDarkColor(1)),
      headline2: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: config.CustomColors().secondDarkColor(1)),
      headline3: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: config.CustomColors().secondDarkColor(1)),
      headline4: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          color: config.CustomColors().mainDarkColor(1)),
      headline5: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w300,
          color: config.CustomColors().secondDarkColor(1)),
      subtitle1: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          color: config.CustomColors().secondDarkColor(1)),
      subtitle2: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: config.CustomColors().mainDarkColor(1)),
      caption: TextStyle(
          fontSize: 12.0, color: config.CustomColors().secondDarkColor(0.6)),
    ),
  );
}
