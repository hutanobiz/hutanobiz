import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/round_success.dart';

class PinSetupSuccess extends StatelessWidget {
  _buildNextButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing20, right: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.onlyLabel,
        color: colorYellow,
        iconSize: 20,
        label: Localization.of(context)!.continueLabel,
        onPressed: () {
          _nextClick(context);
        },
      ));

  _nextClick(context) {
    Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
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
                title: Localization.of(context)!.newPinCreation,
                subTitle: Localization.of(context)!.taskComplete,
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
