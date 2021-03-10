import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/color_utils.dart';
import '../utils/constants/file_constants.dart';
import '../utils/dimens.dart';

enum HutanoProgressSteps {
  one,
  two,
  three,
  four //no label
}

class HutanoProgressBar extends StatelessWidget {
  final HutanoProgressSteps progressSteps;

  const HutanoProgressBar(
      {Key key, this.progressSteps = HutanoProgressSteps.one})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: 18, child: _buildProgress(progressSteps, context));
  }

  _buildProgress(progressSteps, context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.all(5),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
                color:
                    index <= (progressSteps.index) ? colorYellow : colorLightYellow2,
                borderRadius: BorderRadius.circular(4)),
          );
        });
  }
}
