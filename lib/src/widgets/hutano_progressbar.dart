import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: colorYellow,
          height: 45,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 20,
                child: Image.asset(
                  FileConstants.icLogoBlack,
                  height: 35,
                  width: 35,
                ),
              ),
              Positioned(
                child: Text(
                  'STEPS ${_getStepText(progressSteps)} OF 4',
                  style: TextStyle(
                      fontSize: fontSize15,
                      color: colorBlack,
                      fontWeight: fontWeightBold),
                ),
              )
            ],
          ),
        ),
        _buildProgressbar(progressSteps, context),
      ],
    );
  }

  String _getStepText(steps) {
    switch (steps) {
      case HutanoProgressSteps.one:
        return "1";
      case HutanoProgressSteps.two:
        return "2";
      case HutanoProgressSteps.three:
        return "3";
      case HutanoProgressSteps.four:
        return "4";
    }
  }

  Widget _buildProgressbar(HutanoProgressSteps steps, context) {
    switch (steps) {
      case HutanoProgressSteps.one:
        return _buildStepOne(context);

      case HutanoProgressSteps.two:
        return _buildStepTwo(context);

      case HutanoProgressSteps.three:
        return _buildStepThree(context);
      case HutanoProgressSteps.four:
        return _buildStepFour(context);
    }
  }

  Widget _buildStepOne(context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilledIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildBlankIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildBlankIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildBlankIconButton(context),
        ],
      ),
    );
  }

  Widget _buildStepTwo(context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilledIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildFilledIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildBlankIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildBlankIconButton(context),
        ],
      ),
    );
  }

  Widget _buildStepThree(context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilledIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildFilledIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildFilledIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildBlankIconButton(context),
        ],
      ),
    );
  }

  Widget _buildStepFour(context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilledIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildFilledIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildFilledIconButton(context),
          SizedBox(
            width: spacing5,
          ),
          _buildFilledIconButton(context),
        ],
      ),
    );
  }

  Widget _buildFilledIconButton(context) {
    return Container(
        width: MediaQuery.of(context).size.width / 4.2,
        height: 12,
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(
              width: 1.0, color: primaryColor, style: BorderStyle.solid),
          color: primaryColor,
        ));
  }

  Widget _buildBlankIconButton(context) {
    return Container(
        width: MediaQuery.of(context).size.width / 4.2,
        height: 12,
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(
              width: 1.0,
              color: primaryColor.withOpacity(0.1),
              style: BorderStyle.solid),
          color: primaryColor.withOpacity(0.1),
        ));
  }
}
