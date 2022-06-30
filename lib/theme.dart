import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class AppTheme {
  static ThemeData get theme {
    final themeData = ThemeData.light();
    final textTheme = themeData.textTheme;
    final body1 = textTheme.bodyText2!.copyWith(
      decorationColor: Colors.transparent,
      fontFamily: 'Poppins',
    );

    return ThemeData.light().copyWith(
        brightness: Brightness.light,
        primaryColor: AppColors.goldenTainoi,
        // buttonColor: Colors.white,
        // textSelectionColor: Colors.cyan[100],
        toggleableActiveColor: Colors.cyan[300],
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.cyan[300],
        ),
        textTheme: textTheme.apply(
          fontFamily: "Poppins",
        ),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.windsor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[300]!,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: AppColors.accentColor));
  }
}
