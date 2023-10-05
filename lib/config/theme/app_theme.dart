import 'package:flutter/material.dart';

class AppTheme {
  static const poppinsRegular = 'Poppins-Regular';
  static const poppinsMedium = 'Poppins-Medium';
  static const poppinsSemiBold = 'Poppins-SemiBold';

  ThemeData getTheme(context) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xffF2F2F2),
    );
  }
}
