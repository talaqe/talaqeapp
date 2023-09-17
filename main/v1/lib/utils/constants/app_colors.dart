import 'package:talaqe/utils/helpers.dart';
import 'package:flutter/material.dart';

/// This file contains custom colors used throughout the app
class AppColors {
  static const Color primaryColor = Color(0xFF8701c8);
  static const Color secondaryColor = Color(0xFF6a20e9);
  static const Color tertiaryColor = Color(0xFFc580e6);
  static const Color color4 = Color(0xFFFFA873);
  static const Color color5 = Color(0xFFA079EC);
  static const Color alertColor = Color(0xFFF21D52);
  static const Color primaryFontColor = Color(0xFF777A95);
  static const Color secondaryFontColor = Color(0xFFA0A2B3);
  static final Color borderColor =
      AppColors.secondaryFontColor.withOpacity(0.2);
  static const Color backgroundColor = Color(0xFFF6F6F6);
  static const Color buttonPressedColor = Color(0xFF0D8A71);
  static const Color facebookBackgroundColor = Color(0xFF345287);

  /// Custom MaterialColor from Helper function
  static final MaterialColor primaryMaterialColor =
      Helper.generateMaterialColor(AppColors.primaryColor);
}
