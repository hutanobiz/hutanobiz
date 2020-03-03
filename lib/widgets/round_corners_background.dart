import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class RoundCornerBackground extends StatelessWidget {
  RoundCornerBackground(
      {Key key, @required this.scaffoldKey, @required this.child})
      : super(key: key);

  final Widget child;
  final scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: AppColors.goldenTainoi,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(top: 51.0),
          decoration: BoxDecoration(
            color: AppColors.snow,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(22.0),
              topRight: const Radius.circular(22.0),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
