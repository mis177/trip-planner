import 'package:flutter/material.dart';

final appTheme = ThemeData(
  appBarTheme: AppBarTheme(
    scrolledUnderElevation: 10.0,
    shadowColor: Colors.indigo[300],
    backgroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.white,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  //dialogTheme: DialogTheme(elevation: 10),
  useMaterial3: true,
);
