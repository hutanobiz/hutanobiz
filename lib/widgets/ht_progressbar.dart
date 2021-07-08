import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';

import '../utils/color_utils.dart';

class HTProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentSteps;
  final double progressBarheight = 8;
  final double spacing;

  const HTProgressBar({
    @required this.totalSteps,
    @required this.currentSteps,
    this.spacing
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < totalSteps; i++)
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: spacing ?? spacing10),
              height: progressBarheight,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6),
                color: (i+1 <= currentSteps) ? primaryColor : colorGreyBackground,
              ),
            ),
          ),
      ],
    );
  }
}
