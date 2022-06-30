import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_progressbar.dart';
import '../../../widgets/round_success.dart';

class EmailVerifiCompleteScreen extends StatefulWidget {
  EmailVerifiCompleteScreen();

  @override
  _EmailVerifiCompleteScreenState createState() =>
      _EmailVerifiCompleteScreenState();
}

class _EmailVerifiCompleteScreenState extends State<EmailVerifiCompleteScreen> {
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
                title: Localization.of(context)!.emailVerification,
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

  _buildNextButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing20, right: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.onlyLabel,
        color: colorYellow,
        iconSize: 20,
        label: Localization.of(context)!.next,
        onPressed: _nextClick,
      ));

  _nextClick() {
    Navigator.of(context).pushReplacementNamed(Routes.setupPin);
  }
}
