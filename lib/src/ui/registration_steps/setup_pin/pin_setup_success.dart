import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/dimens.dart';
import 'package:hutano/src/utils/localization/localization.dart';
import 'package:hutano/src/widgets/app_header.dart';
import 'package:hutano/src/widgets/hutano_button.dart';
import 'package:hutano/src/widgets/hutano_progressbar.dart';
import 'package:hutano/src/widgets/round_success.dart';

class PinSetupSuccess extends StatelessWidget {
  _buildNextButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing20, right: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.onlyLabel,
        color: colorYellow,
        iconSize: 20,
        label: Localization.of(context).continueLabel,
        onPressed: () {
          _nextClick(context);
        },
      ));

  _nextClick(context) {
    Navigator.of(context).pushReplacementNamed(routeLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppHeader(
                progressSteps: HutanoProgressSteps.one,
                title: Localization.of(context).newPinCreation,
                subTitle: Localization.of(context).taskComplete,
              ),
              Spacer(),
              RoundSuccess(),
              Spacer(),
              _buildNextButton(context),
              SizedBox(
                height: spacing80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
