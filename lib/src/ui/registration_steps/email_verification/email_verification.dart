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
import 'package:hutano/src/widgets/app_header.dart';
import 'package:hutano/src/widgets/skip_later.dart';
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
                body: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppHeader(
                    progressSteps: HutanoProgressSteps.one,
                    title: Localization.of(context).emailVerification,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    Localization.of(context)
                        .enterActivationCode
                        .format([getString(PreferenceKey.email, "")]),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: colorBlack2.withOpacity(0.85),
                        fontFamily: gilroyRegular,
                        fontSize: fontSize14),
                  ),
                  SizedBox(
                    height: spacing30,
                  ),
                  _buildVerificationCode(context),
                  SizedBox(
                    height: spacing20,
                  ),
                  _buildActivateEmailButton(context),
                  SizedBox(
                    height: spacing20,
                  ),
                  _buildResend(context),
                ],
              ),
            ),
            Spacer(),
            SkipLater(
              onTap: _skipTaskNow,
            ),
            SizedBox(
              height: spacing20,
            ),
          ],
        ))));
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
        color: colorOrange,
        iconSize: spacing30,
        label: Localization.of(context).verify,
        onPressed: _enableButton ? _activationEmail : null,
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
        ProgressDialogUtils.dismissProgressDialog();
        setBool(PreferenceKey.isEmailVerified, true);
        Navigator.of(context)
            .pushReplacementNamed(routeEmailVerificationComplete);
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
    Navigator.of(context).pushNamed(routeAddPaymentOption);
  }
}
