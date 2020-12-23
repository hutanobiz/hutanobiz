import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/src/utils/navigation.dart';

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
                body: SingleChildScrollView(
                    child: Column(
          children: [
            HutanoProgressBar(progressSteps: HutanoProgressSteps.one),
            HutanoHeader(
              headerInfo: HutanoHeaderInfo(
                title: Localization.of(context).emailVerification,
                subTitle: Localization.of(context).complete,
                subTitleFontSize: fontSize15,
              ),
            ),
            SizedBox(
              height: spacing40,
            ),
            HutanoStepsHeader(
              isIcon: true,
              title: Localization.of(context).activateEmail,
              subTitle: Localization.of(context).taskComplete,
              iconText: stepOne,
              icon: FileConstants.icComplete,
              bgColor: Colors.transparent,
              iconSize: spacing50,
              borderColor: Colors.transparent,
              alignment: CrossAxisAlignment.center,
            ),
            SizedBox(
              height: spacing30,
            ),

         //   _buildVerificationCode(context),
            SizedBox(
              height: spacing50,
            ),
            _buildNextButton(context),
            SizedBox(
              height: spacing20,
            ),
          ],
        )))));
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
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        icon: FileConstants.icNext,
        color: colorDarkBlue,
        iconSize: 20,
        label: Localization.of(context).next,
        onPressed: _enableButton ? _nextClick : null,
      ));

  _nextClick() {
    NavigationUtils.pushReplacement(context, routeSetupPin);

  }
}
