import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/widgets/controller.dart';
import '../../../../utils/dialog_utils.dart';
import '../../../../utils/enum_utils.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../widgets/hutano_button.dart';
import '../../../../widgets/hutano_header.dart';
import '../../../../widgets/hutano_header_info.dart';
import '../../../../widgets/hutano_pin_input.dart';
import '../../forgotpassword/model/req_reset_password.dart';
import '../otp_call.dart';
import 'verification_model.dart';

class OtpVerification extends StatefulWidget {
  final VerificationModel verificationModel;

  OtpVerification({this.verificationModel});

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _otpController = TextEditingController();
  bool _enableButton = false;
  ApiBaseHelper api = ApiBaseHelper();

  _onButtonClick() async {
    final _screenType = widget.verificationModel.verificationScreen;
    if (_screenType == VerificationScreen.resetPassword) {
      _resetPassword();
    } else if (_screenType == VerificationScreen.resetPin) {
      _resetPin();
    } else if (_screenType == VerificationScreen.registration) {
      _register();
    } else {}
  }

  _resetPassword() async {
    ProgressDialogUtils.showProgressDialog(context);
    final otp = _otpController.text.trim().toString();
    final request = ReqResetPassword(
      step: 2,
      phoneNumber: widget.verificationModel.phone == null
          ? null
          : widget.verificationModel.phone.rawNumber(),
      email: widget.verificationModel.email,
      verificationCode: otp.toString(),
      // mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      await api.resetPassword(request);
      ProgressDialogUtils.dismissProgressDialog();
      final args = {
        ArgumentConstant.verificationModel: widget.verificationModel,
      };
      Navigator.of(context)
          .pushReplacementNamed(Routes.resetPasswordRoute, arguments: args);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _resetPin() async {
    ProgressDialogUtils.showProgressDialog(context);
    final otp = _otpController.text.trim().toString();
    final request = ReqResetPassword(
      step: 2,
      phoneNumber: widget.verificationModel.phone == null
          ? null
          : widget.verificationModel.phone.rawNumber(),
      email: widget.verificationModel.email,
      verificationCode: otp,
      // mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      await api.resetPin(request);
      ProgressDialogUtils.dismissProgressDialog();

      Navigator.of(context)
          .pushReplacementNamed(Routes.routeResetPin, arguments: {
        ArgumentConstant.verificationModel: widget.verificationModel,
      });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _register() async {
    ProgressDialogUtils.showProgressDialog(context);
    final otp = _otpController.text.trim().toString();
    final request = {
      "step": "2",
      "type": "1",
      "isAgreeTermsAndCondition": "1",
      "phoneNumber": widget.verificationModel.phone.rawNumber().toString(),
      "verificationCode": otp.toString(),
      "mobileCountryCode": widget.verificationModel.countryCode.toString(),
    };
    try {
      await api.register(request);
      ProgressDialogUtils.dismissProgressDialog();
//Todo
      Navigator.of(context).pushReplacementNamed(Routes.registerRoute,
          arguments: RegisterArguments(
              widget.verificationModel.phone.rawNumber(), false));
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _resendCode() async {
    final _screenType = widget.verificationModel.verificationScreen;
    if (_screenType == VerificationScreen.resetPassword) {
      _resendResetPasswordApi();
    } else if (_screenType == VerificationScreen.resetPin) {
      _resendResetPinApi();
    } else if (_screenType == VerificationScreen.registration) {
      _resendRegistrationApi();
    } else {}
  }

  _resendResetPasswordApi() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqResetPassword(
      step: 4,
      phoneNumber: widget.verificationModel.phone == null
          ? null
          : widget.verificationModel.phone.rawNumber(),
      email: widget.verificationModel.email,
      // mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      var res = await api.resetPassword(request);
      ProgressDialogUtils.dismissProgressDialog();
      Widgets.showToast(res.response);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _resendResetPinApi() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqResetPassword(
      step: 4,
      phoneNumber: widget.verificationModel.phone == null
          ? null
          : widget.verificationModel.phone.rawNumber(),
      email: widget.verificationModel.email,
      // mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      var res = await api.resetPin(request);
      ProgressDialogUtils.dismissProgressDialog();
      Widgets.showToast(res.response);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _resendRegistrationApi() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = {
//        loginData["phoneNumber"] = cleanedPhoneNumber;
// //             loginData["type"] = "1";
//       "step": 4,
      "type": "1",
      // "isAgreeTermsAndCondition": 1,
      "phoneNumber": widget.verificationModel.phone.rawNumber().toString(),
      // "mobileCountryCode": widget.verificationModel.countryCode.toString(),
    };
    try {
      var res = await api.resendPhoneOtp(context, request);
      ProgressDialogUtils.dismissProgressDialog();
      Widgets.showToast(
          'A 6-digit verification number has been re-sent to your phone.');
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _callRegsitrationApi() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = {
      "step": "1",
      "type": "1",
      "phoneNumber": widget.verificationModel.phone.rawNumber().toString(),
      "mobileCountryCode": widget.verificationModel.countryCode.toString(),
      "isAgreeTermsAndCondition": "1"
    };
    try {
      var res = await api.otpOnCall(request);
      ProgressDialogUtils.dismissProgressDialog();
      Widgets.showToast(res.response);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                HutanoHeader(
                  headerInfo: _buildHeader(context),
                ),
                _buildOtp(context),
                HutanoButton(
                  margin: 10,
                  onPressed: _enableButton ? _onButtonClick : null,
                  label: Strings.verify,
                ),
                SizedBox(
                  height: 20,
                ),
                _buildResend(context),
                SizedBox(
                  height: 20,
                ),
                if (widget.verificationModel.verificationScreen ==
                    VerificationScreen.registration)
                  OtpCall(onCall: _callRegsitrationApi)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtp(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: HutanoPinInput(
        pinCount: 6,
        controller: _otpController,
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

  Widget _buildResend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Strings.msgCodeNotRecieved,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.colorBlack,
          ),
        ),
        RawMaterialButton(
          constraints: BoxConstraints(),
          padding: EdgeInsets.all(0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: _resendCode,
          child: Text(
            Strings.resend,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.accentColor,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HutanoHeaderInfo(
          title: Strings.verifyCode,
          subTitle: Strings.msgOtpReceived,
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          _getLabel(),
          style: TextStyle(fontSize: 13),
        )
      ],
    );
  }

  String _getLabel() {
    final _model = widget.verificationModel;
    if (_model.verificationType == VerificationType.email) {
      return _model.email;
    } else {
      return '${_model.countryCode} ${_model.phone}';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }
}
