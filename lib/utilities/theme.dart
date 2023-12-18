import 'package:flutter/material.dart';

final appTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 10.0,
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  dataTableTheme: const DataTableThemeData(
    columnSpacing: 5,

    //headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black26),
  ),

  //dialogTheme: DialogTheme(elevation: 10),
  useMaterial3: true,
);
