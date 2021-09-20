import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class CustomLoader extends StatefulWidget {
  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Positioned(
            child: Image(
              image: AssetImage("images/ic_hutano_logo.png"),
              height: 50.0,
              width: 50.0,
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 0,
              child: CircularProgressIndicator(
                color: AppColors.goldenTainoi,
              )),
        ],
      ),
    );
  }
}
