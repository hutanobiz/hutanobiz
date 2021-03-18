import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class AppTheme {
  static ThemeData get theme {
    final themeData = ThemeData.light();
    final textTheme = themeData.textTheme;
    final body1 =
        textTheme.bodyText2.copyWith(decorationColor: Colors.transparent);

    return ThemeData.light().copyWith(
      
      brightness: Brightness.light,
      primaryColor: AppColors.goldenTainoi,
      accentColor: AppColors.accentColor,
      buttonColor: Colors.white,
      textSelectionColor: Colors.cyan[100],
      toggleableActiveColor: Colors.cyan[300],
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.cyan[300],
      ),
      // textTheme: textTheme.copyWith(
      //   bodyText2: body1,
      // ),
      textTheme: textTheme.apply(
        fontFamily: "Gilroy",
      )
    );
  }
}
