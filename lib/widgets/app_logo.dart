import 'package:flutter/cupertino.dart';

class AppLogo extends StatelessWidget {
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
      children: <Widget>[image, SizedBox(height: 12.0), Text("Please sign in to continue.")],
    );
  }
}
