import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/email_verification/model/req_email.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/skip_later.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/constants/constants.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_pin_input.dart';
import '../../../widgets/hutano_progressbar.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _enableButton = false;
  bool _isComplete = false;
  String otp;
  String email;
  String phoneNumber;
  ApiBaseHelper api = ApiBaseHelper();
  Future<dynamic> _requestsFuture;

  @override
  void initState() {
    super.initState();
    SharedPref().getToken().then((token) {
      setState(() {
        _requestsFuture = api.profile(token, Map());
      });
    });
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
              body: FutureBuilder<dynamic>(
            future: _requestsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: new CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                email = snapshot.data['response']['email'].toString() ?? "---";
                phoneNumber =
                    snapshot.data['response']['phoneNumber']?.toString();
                String emailText;
                emailText = email.substring(0, email.length);

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
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
                    SkipLater(
                      onTap: _skipTaskNow,
                    ),
                    SizedBox(
                      height: spacing20,
                    ),
                  ],
                );
              } else {
                return Center(
                  child: new CircularProgressIndicator(),
                );
              }
            },
          )),
        ));
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
        controller: _verificationCodeController,
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
    ProgressDialogUtils.showProgressDialog(context);
    try {
      await ApiManager()
          .resendEmailOtp(ReqEmail(email: email, phoneNumber: phoneNumber))
          .then((value) {
        ProgressDialogUtils.dismissProgressDialog();
        Widgets.showToast("${value['response']} ${value['verificationCode']}");
      }).catchError((dynamic e) {
        ProgressDialogUtils.dismissProgressDialog();
        if (e is ErrorModel) {
          if (e.response != null) {
            DialogUtils.showAlertDialog(context, e.response);
          }
        }
      });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _activationEmail() async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      await ApiManager()
          .verifyEmailOtp(ReqEmail(
              email: email,
              phoneNumber: phoneNumber,
              otp: _verificationCodeController.text))
          .then((value) {
        ProgressDialogUtils.dismissProgressDialog();
        setBool(PreferenceKey.isEmailVerified, true);
        Navigator.of(context)
            .pushReplacementNamed(Routes.emailVerificationComplete);
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
    Navigator.of(context).pushNamed(Routes.addPaymentOption);
  }
}
