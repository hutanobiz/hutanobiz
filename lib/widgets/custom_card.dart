import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final BorderSide borderStyle;
  final double borderRadius;
  final double elevation;
  const CustomCard(
      {Key key,
      @required this.child,
      this.margin,
      this.borderStyle,
      this.borderRadius = 14,
      this.elevation = 2})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          elevation: elevation,
          margin: margin ?? EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: borderStyle ?? BorderSide.none),
          child: child),
    );
  }
}
