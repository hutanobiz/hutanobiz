import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/round_success.dart';

class SetPinComplete extends StatefulWidget {
  @override
  _SetPinCompleteState createState() => _SetPinCompleteState();
}

class _SetPinCompleteState extends State<SetPinComplete> {
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
                title: "Set Pin",
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
    Navigator.of(context).pushReplacementNamed(Routes.addPaymentOption);
  }
}
