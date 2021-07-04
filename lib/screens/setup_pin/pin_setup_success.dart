import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/round_success.dart';

class PinSetupSuccess extends StatelessWidget {
  _buildNextButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: HutanoButton(
        buttonType: HutanoButtonType.onlyLabel,
        color: AppColors.colorYellow,
        iconSize: 20,
        label: Strings.continueLabel,
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
                progressSteps: HutanoProgressSteps.one,
                title: Strings.newPinCreation,
                subTitle: Strings.taskComplete,
              ),
              Spacer(),
              RoundSuccess(),
              Spacer(),
              _buildNextButton(context),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
