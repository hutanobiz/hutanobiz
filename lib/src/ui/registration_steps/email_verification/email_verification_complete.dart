import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/src/utils/navigation.dart';
import 'package:hutano/src/widgets/round_success.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_pin_input.dart';
import '../../../widgets/hutano_progressbar.dart';
import '../../../widgets/hutano_steps_header.dart';

class EmailVerifiCompleteScreen extends StatefulWidget {
  String code;

  EmailVerifiCompleteScreen(this.code);

  @override
  _EmailVerifiCompleteScreenState createState() =>
      _EmailVerifiCompleteScreenState();
}

class _EmailVerifiCompleteScreenState extends State<EmailVerifiCompleteScreen> {
  TextEditingController _codeController = TextEditingController();
  bool _enableButton = true;
  @override
  void initState() {
    super.initState();
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
            HutanoProgressBar(progressSteps: HutanoProgressSteps.one),
            HutanoHeader(
              headerInfo: HutanoHeaderInfo(
                title: Localization.of(context).emailVerification,
                subTitle: Localization.of(context).taskComplete,
                subTitleFontSize: fontSize15,
              ),
            ),
            Spacer(),
            RoundSuccess(),
            Spacer(),
            SizedBox(
              height: spacing30,
            ),
            _buildNextButton(context),
            SizedBox(
              height: spacing30,
            ),
          ],
        ))));
  }

  Widget _buildVerificationCode(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacing20),
      child: HutanoPinInput(
        pinCount: 6,
        controller: _codeController,
        width: MediaQuery.of(context).size.width,
        onChanged: (text) {
          if (text.length == 6) {
            setState(() {
              _enableButton = true;
            });
          } else {
            if (_enableButton) {
              setState(() {
                _enableButton = false;
              });
            }
          }
        },
      ),
    );
  }

  _buildNextButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing20, right: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.onlyLabel,
        color: colorYellow,
        iconSize: 20,
        label: Localization.of(context).next,
        onPressed: _enableButton ? _nextClick : null,
      ));

  _nextClick() {
    NavigationUtils.pushReplacement(context, routeSetupPin);
  }
}
