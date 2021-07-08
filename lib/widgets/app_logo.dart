import 'package:flutter/material.dart';
import 'package:hutano/utils/constants/file_constants.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({this.appLogoText});

  final String appLogoText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          FileConstants.icAppLogo,
          width: 150,
          height: 43.0,
        ),
        SizedBox(height: appLogoText != null ? 12.0 : 4),
        appLogoText != null ? Text(appLogoText) : Container()
      ],
    );
  }
}
