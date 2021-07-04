import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_pin_input.dart';
import 'package:hutano/widgets/hutano_progressbar.dart';
import 'package:hutano/widgets/skip_later.dart';

import 'package:hutano/utils/extensions.dart';

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
                        // mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppHeader(
                            progressSteps: HutanoProgressSteps.one,
                            title: Strings.emailVerification,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            emailText,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.regularStyle(
                                color: AppColors.colorBlack2.withOpacity(0.85),
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          _buildVerificationCode(context),
                          SizedBox(
                            height: 20,
                          ),
                          _buildActivateEmailButton(context),
                          SizedBox(
                            height: 20,
                          ),
                          _buildResend(context),
                        ],
                      ),
                    ),
                    SkipLater(
                      onTap: _skipTaskNow,
                    ),
                    SizedBox(
                      height: 20,
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
          Strings.msgCodeNotRecieved,
          style: AppTextStyle.regularStyle(
            fontSize: 14,
            color: AppColors.colorBlack,
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
            Strings.resend,
            style: AppTextStyle.regularStyle(
              fontSize: 14,
              color: AppColors.accentColor,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildVerificationCode(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
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
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: HutanoButton(
        color: AppColors.colorOrange,
        iconSize: 30,
        label: Strings.verify,
        onPressed: _enableButton ? _activationEmail : null,
      ));

  _resendCode() async {
    try {
      Map<String, String> verifyEmail = Map();
      verifyEmail["email"] = email;
      verifyEmail['phoneNumber'] = phoneNumber;
      api.sendEmailOtp(context, verifyEmail).then((dynamic response) {
        DialogUtils.showAlertDialog(context, 'Otp sent on $email');
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
      Map<String, String> verifyEmail = Map();

      verifyEmail["email"] = email;
      verifyEmail["otp"] = _verificationCodeController.text;
      verifyEmail['phoneNumber'] = phoneNumber;

      api.verifyEmailOtp(context, verifyEmail).then((dynamic user) {
        ProgressDialogUtils.dismissProgressDialog();
        SharedPref().setBoolValue('isEmailVerified', true);
        Navigator.of(context)
            .pushReplacementNamed(Routes.emailVerificationComplete);
      });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, Strings.commonErrorMsg);
    }
  }

  _skipTaskNow() {
    Navigator.of(context).pushNamed(Routes.addPaymentOption);
  }
}
