import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromRGBO(31, 95, 137, 1);
  static const Color secondary = Color.fromRGBO(42, 150, 178, 1);
  static const Color tertiary = Color.fromRGBO(92, 194, 199, 1);
  static const Color quaternary = Color.fromRGBO(166, 217, 212, 1);
  static const Color harp = Color.fromRGBO(241, 248, 244, 1);
  static const Color info = Color.fromRGBO(29, 94, 144, 1);
  static const Color success = Color.fromRGBO(50, 205, 50, 1);
  static const Color warning = Color.fromRGBO(255, 166, 0, 1);
  static const Color error = Color.fromRGBO(255, 51, 51, 1);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    // Color primario
    primaryColor: primary,
    // Scaffold Theme
    scaffoldBackgroundColor: Colors.white,
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: primary,
      toolbarTextStyle: TextStyle(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    // TextButton Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
      ),
    ),
    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      elevation: 5,
    ),
    // ElevatedButton Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
    ),
    // Input Decoration Theme
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primary,
      selectionColor: secondary,
      selectionHandleColor: primary,
    ),
    tabBarTheme: const TabBarTheme(
      indicatorColor: primary,
      unselectedLabelColor: Colors.grey,
      labelColor: primary,
      // labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    ),
    // Circular Progress Indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: Colors.white,
      dayStyle: TextStyle(color: Colors.black),
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: primary,
      headerForegroundColor: Colors.white,
      todayBackgroundColor: WidgetStatePropertyAll(primary),
      todayForegroundColor: WidgetStatePropertyAll(harp),
      dayOverlayColor: WidgetStatePropertyAll(primary),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
      selectedIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
    ),
    navigationDrawerTheme: const NavigationDrawerThemeData(
      backgroundColor: Colors.white,
      // elevation: 0,
      indicatorColor: tertiary,
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Color primario
    primaryColor: primary,
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
  );
}
