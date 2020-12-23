import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/src/apis/api_manager.dart';
import 'package:hutano/src/apis/error_model.dart';
import 'package:hutano/src/ui/registration_steps/email_verification/model/req_email.dart';
import 'package:hutano/src/utils/constants/key_constant.dart';
import 'package:hutano/src/utils/dialog_utils.dart';
import 'package:hutano/src/utils/preference_key.dart';
import 'package:hutano/src/utils/preference_utils.dart';
import 'package:hutano/src/utils/progress_dialog.dart';
import 'package:hutano/src/widgets/toast.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_pin_input.dart';
import '../../../widgets/hutano_progressbar.dart';
import '../../../widgets/hutano_steps_header.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _enableButton = false;
  bool _isComplete = false;

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
                subTitle: Localization.of(context).checkYourEmail,
                subTitleFontSize: fontSize15,
              ),
              spacing: 10,
            ),
            Text(
              Localization.of(context).stepOneofFour,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: colorBlack,
                  fontWeight: fontWeightMedium,
                  fontSize: fontSize17),
            ),
            SizedBox(
              height: spacing20,
            ),
            HutanoStepsHeader(
              title: Localization.of(context).activateEmail,
              iconText: stepOne,
            ),
            Text(
              Localization.of(context)
                  .enterActivationCode
                  .format([getString(PreferenceKey.email, "")]),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: colorLightGrey1,
                  fontWeight: fontWeightMedium,
                  fontSize: fontSize12),
            ),
            SizedBox(
              height: spacing30,
            ),
            _buildVerificationCode(context),
            SizedBox(
              height: spacing10,
            ),
            _buildResend(context),
            SizedBox(
              height: spacing70,
            ),
            _buildActivateEmailButton(context),
            SizedBox(
              height: spacing20,
            ),
            _buildSkipTaskNowButton(context),
            SizedBox(
              height: spacing20,
            ),
          ],
        )))));
  }

  Widget _buildResend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Localization.of(context).msgCodeNotRecieved,
          style: TextStyle(
            fontSize: fontSize14,
            color: colorBlack,
          ),
        ),
        RawMaterialButton(
          constraints: BoxConstraints(),
          padding: EdgeInsets.all(0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            _resendCode();
          },
          child: Text(
            Localization.of(context).resend,
            style: TextStyle(
              fontSize: fontSize14,
              color: accentColor,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildVerificationCode(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacing25),
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

  _buildActivateEmailButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing20, right: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        icon: FileConstants.icDone,
        color: colorDarkBlue,
        iconSize: spacing30,
        label: Localization.of(context).activateMail,
        onPressed: _enableButton ? _activationEmail : null,
      ));

  _buildSkipTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(
          left: spacing20, right: spacing20, bottom: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        iconSize: spacing20,
        color: colorYellow,
        icon: FileConstants.icSkip,
        label: Localization.of(context).skipTasks,
        onPressed: _skipTaskNow,
      ));

  _resendCode() async {
    try {
      await ApiManager().emailVerification(ReqEmail(step: 5)).then((value) {
        showToast(value.response);
      }).catchError((dynamic e) {
        if (e is ErrorModel) {
          if (e.response != null) {
            DialogUtils.showAlertDialog(context, e.response);
          }
        }
      });
    } on ErrorModel catch (e) {
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _activationEmail() async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      await ApiManager()
          .emailVerification(
              ReqEmail(step: 6, emailVerificationCode: _codeController.text))
          .then((value) {
        DialogUtils.showAlertDialog(context, value.response);
        ProgressDialogUtils.dismissProgressDialog();
        setBool(PreferenceKey.isEmailVerified, true);
        NavigationUtils.pushReplacement(context, routeEmailVerificationComplete,
            arguments: {
              ArgumentConstant.verifyCode: _codeController.text,
            });
      });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(
          context, Localization.of(context).commonErrorMsg);
    }
  }

  _skipTaskNow() {
    NavigationUtils.push(context, routeAddPaymentOption);
  }
}
