import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/round_success.dart';


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
                title: Strings.emailVerification,
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

  _buildNextButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: HutanoButton(
        buttonType: HutanoButtonType.onlyLabel,
        color: AppColors.colorYellow,
        iconSize: 20,
        label: Strings.next,
        onPressed: _nextClick,
      ));

  _nextClick() {
    Navigator.of(context).pushReplacementNamed(Routes.setupPin);
  }
}
