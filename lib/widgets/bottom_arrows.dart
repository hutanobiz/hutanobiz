import 'package:flutter/material.dart';

import 'arrow_button.dart';

class BottomArrows extends StatelessWidget {
  BottomArrows({Key key, @required this.onForwardTap}) : super(key: key);

  final Function onForwardTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // ArrowButton(
          //   iconData: Icons.arrow_back,
          //   onTap: () => Navigator.pop(context),
          // ),
          Spacer(),
          ArrowButton(
            iconData: Icons.arrow_forward,
            onTap: onForwardTap,
          ),
        ],
      ),
    );
  }
}
