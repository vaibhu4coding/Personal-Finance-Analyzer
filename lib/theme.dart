import 'package:flutter/material.dart';

MaterialColor PrimaryMaterialColor = MaterialColor(
  4289152479,
  <int, Color>{
    50: Color.fromRGBO(
      167,
      69,
      223,
      .1,
    ),
    100: Color.fromRGBO(
      167,
      69,
      223,
      .2,
    ),
    200: Color.fromRGBO(
      167,
      69,
      223,
      .3,
    ),
    300: Color.fromRGBO(
      167,
      69,
      223,
      .4,
    ),
    400: Color.fromRGBO(
      167,
      69,
      223,
      .5,
    ),
    500: Color.fromRGBO(
      167,
      69,
      223,
      .6,
    ),
    600: Color.fromRGBO(
      167,
      69,
      223,
      .7,
    ),
    700: Color.fromRGBO(
      167,
      69,
      223,
      .8,
    ),
    800: Color.fromRGBO(
      167,
      69,
      223,
      .9,
    ),
    900: Color.fromRGBO(
      167,
      69,
      223,
      1,
    ),
  },
);

ThemeData myTheme = ThemeData(
  fontFamily: "customFont",
  primaryColor: Color(0xffa745df),
  buttonColor: Color(0xffa745df),
  accentColor: Color(0xffa745df),
  primarySwatch: PrimaryMaterialColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        Color(0xffa745df),
      ),
    ),
  ),
);
