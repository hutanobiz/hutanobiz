import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final Widget appbar;
  final EdgeInsets padding;

  const CustomScaffold({Key key, this.child, this.padding, this.appbar})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.colorYellow,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 30),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: AppColors.colorYellow,
            child: SafeArea(child: appbar ?? Container()),
          ),
        ),
        body: Container(
          padding: padding ??
              EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 0),
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: AppColors.colorWhite,
          ),
          child: child,
        ));
  }
}
