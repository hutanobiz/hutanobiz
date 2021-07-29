import 'package:flutter/material.dart';
import 'package:hutano/widgets/skip_later.dart';

import 'arrow_button.dart';

class BottomArrows extends StatelessWidget {
  BottomArrows(
      {Key key,
      @required this.onForwardTap,
      this.isSkipLater = false,
      this.isCameraVisible = false,
      this.onCameraForTap,
      this.onSkipForTap})
      : super(key: key);

  final Function onForwardTap;
  final bool isSkipLater;
  final Function onSkipForTap;
  final bool isCameraVisible;
  final Function onCameraForTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (isCameraVisible)
            ArrowButton(
              iconData: Icons.camera_alt,
              onTap: onCameraForTap,
            ),
          if (isSkipLater) SkipLater(onTap: onSkipForTap),
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
