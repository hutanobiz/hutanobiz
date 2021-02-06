import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({this.appLogoText});

  final String appLogoText;

  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage("images/hutano-logo.png");
    Image image = Image(
      image: assetImage,
      height: 43.0,
      width: 135.0,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        image,
        SizedBox(height: 12.0),
        appLogoText != null ? Text(appLogoText) : Container()
      ],
    );
  }
}
