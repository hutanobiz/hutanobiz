import 'package:flutter/material.dart';
import 'package:hutano/widgets/skip_later.dart';

import 'arrow_button.dart';

class BottomArrows extends StatelessWidget {
  BottomArrows({Key key, @required this.onForwardTap,this.isSkipLater = false,
      this.onSkipForTap}) : super(key: key);

  final Function onForwardTap;
  final bool isSkipLater;
  final Function onSkipForTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ArrowButton(
            iconData: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          if (isSkipLater) SkipLater(onTap: onSkipForTap),
          ArrowButton(
            iconData: Icons.arrow_forward,
            onTap: onForwardTap,
          ),
        ],
      ),
    );
  }
}

