import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// This file contain theme data of the app and initial custom default widget
/// configurations
class AppThemeData {
  static final ThemeData appThemeData = ThemeData(
      // Set default font name
      fontFamily: 'Gilroy',
      primarySwatch: AppColors.primaryMaterialColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      // Setting all default textTheme based on design
      textTheme: const TextTheme(
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(
            fontSize: 24,
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(
            fontSize: 16,
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w400),
      ),
      // Set default TextField theme design
      inputDecorationTheme: InputDecorationTheme(
          isCollapsed: true,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintStyle: const TextStyle(color: AppColors.secondaryFontColor),
          border: UnderlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                  color: AppColors.secondaryFontColor.withOpacity(0.3))),
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                  color: AppColors.secondaryFontColor.withOpacity(0.3)))),
      // Set default appbar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 24,
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w600),
      ),
      popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          textStyle: TextStyle(
              color: AppColors.primaryFontColor,
              fontSize: 14,
              fontWeight: FontWeight.w400)),
      dividerColor: AppColors.secondaryFontColor.withOpacity(0.15),
      expansionTileTheme: const ExpansionTileThemeData(
          textColor: AppColors.primaryFontColor,
          iconColor: AppColors.primaryFontColor));
}
