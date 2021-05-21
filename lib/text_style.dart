

import 'package:flutter/material.dart';

import 'dimens.dart';

class AppTextStyle {
  const AppTextStyle._();

  static TextStyle heading1Style({
    Color color,
    double fontSize,
    FontWeight fontWeight,
    TextDecoration decoration,
  }) {
    return _textStyle(
      color: color,
      fontSize: fontSize ?? Dimens.fontSize26,
      fontWeight: fontWeight ?? FontWeight.w600,
      decoration: decoration,
    );
  }

  static TextStyle heading2Style({
    Color color,
    double fontSize,
    FontWeight fontWeight,
    TextDecoration decoration,
  }) {
    return _textStyle(
      color: color,
      fontSize: fontSize ?? Dimens.fontSize20,
      fontWeight: fontWeight ?? FontWeight.w600,
      decoration: decoration,
    );
  }

  static TextStyle mediumStyle({
    Color color,
    double fontSize,
    FontWeight fontWeight,
    TextDecoration decoration,
  }) {
    return _textStyle(
      color: color,
      fontSize: fontSize ?? Dimens.fontSize14,
      fontWeight: fontWeight ?? FontWeight.w500,
      decoration: decoration,
    );
  }

  static TextStyle semiBoldStyle({
    Color color,
    double fontSize,
    FontWeight fontWeight,
    TextDecoration decoration,
  }) {
    return _textStyle(
      color: color,
      fontSize: fontSize ?? Dimens.fontSize14,
      fontWeight: fontWeight ?? FontWeight.w600,
      decoration: decoration,
    );
  }

  static TextStyle boldStyle({
    Color color,
    double fontSize,
    FontWeight fontWeight,
    TextDecoration decoration,
  }) {
    return _textStyle(
      color: color,
      fontSize: fontSize ?? Dimens.fontSize22,
      fontWeight: fontWeight ?? FontWeight.w700,
      decoration: decoration,
    );
  }

  static TextStyle regularStyle({
    Color color,
    double fontSize,
    FontWeight fontWeight,
    TextDecoration decoration,
  }) {
    return _textStyle(
      color: color,
      fontSize: fontSize ?? Dimens.fontSize12,
      decoration: decoration,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  static TextStyle buttonTextStyle({
    Color color,
    double fontSize,
    FontWeight fontWeight,
    TextDecoration decoration,
  }) {
    return _textStyle(
      color: color,
      fontSize: fontSize ?? Dimens.fontSize16,
      fontWeight: fontWeight ?? FontWeight.w400,
      decoration: decoration,
    );
  }
}

TextStyle _textStyle({
  String fontFamily: 'Poppins',
  Color color: Colors.black,
  @required double fontSize,
  FontWeight fontWeight,
  TextDecoration decoration,
}) {
  return TextStyle(
    fontFamily: fontFamily,
    color: color,
    fontSize: fontSize,
    decoration: decoration,
    fontWeight: fontWeight,
  );
}
