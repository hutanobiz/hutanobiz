import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/dimens.dart';

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
    return _buildProgressbar(progressSteps);
  }

  Widget _buildProgressbar(HutanoProgressSteps steps) {
    switch (steps) {
      case HutanoProgressSteps.one:
        return _buildStepOne();

      case HutanoProgressSteps.two:
        return _buildStepTwo();

      case HutanoProgressSteps.three:
        return _buildStepThree();
      case HutanoProgressSteps.four:
        return _buildStepFour();
    }
  }

  Widget _buildStepOne() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilledIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildBlankIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildBlankIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildBlankIconButton(),
        ],
      ),
    );
  }

  Widget _buildStepTwo() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilledIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildFilledIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildBlankIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildBlankIconButton(),
        ],
      ),
    );
  }

  Widget _buildStepThree() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilledIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildFilledIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildFilledIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildBlankIconButton(),
        ],
      ),
    );
  }

  Widget _buildStepFour() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilledIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildFilledIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildFilledIconButton(),
          SizedBox(
            width: spacing10,
          ),
          _buildFilledIconButton(),
        ],
      ),
    );
  }

  Widget _buildFilledIconButton() {
    return Container(
        width: spacing61,
        height: spacing8,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              width: 1.0, color: primaryColor, style: BorderStyle.solid),
          color: primaryColor,
        ));
  }

  Widget _buildBlankIconButton() {
    return Container(
        width: spacing61,
        height: spacing8,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              width: 1.0, color: primaryColor, style: BorderStyle.solid),
          color: Colors.white,
        ));
  }
}
