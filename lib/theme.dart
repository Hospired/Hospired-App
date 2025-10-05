import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static const Color primaryColor = Color.fromRGBO(35, 169, 214, 1);

  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      backgroundColor: HospiredColors.primary,
      surfaceTintColor: HospiredColors.gray,
      iconTheme: IconThemeData(color: HospiredColors.white),
      centerTitle: true,
      elevation: 4,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: HospiredColors.primary,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        padding: const EdgeInsets.all(0),
        textStyle: HospiredTextStyle.link1C2Medium,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: HospiredColors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: HospiredColors.lightGray,
        disabledForegroundColor: HospiredColors.nearWhite,
        backgroundColor: HospiredColors.primary,
        foregroundColor: HospiredColors.white,
        textStyle: HospiredTextStyle.primaryWithBackgroundButtonText,
        minimumSize: const Size(0, 48),
        side: const BorderSide(style: BorderStyle.none),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        surfaceTintColor: HospiredColors.white,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      iconTheme: WidgetStateProperty.all(
        const IconThemeData(color: HospiredColors.primary),
      ),
      indicatorColor: HospiredColors.primaryLight,
      backgroundColor: HospiredColors.nearWhite,
      surfaceTintColor: HospiredColors.nearWhite,
      labelTextStyle: WidgetStateProperty.all(HospiredTextStyle.labelButton),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
    ),
  );
}
