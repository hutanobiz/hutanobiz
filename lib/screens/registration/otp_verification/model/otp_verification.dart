import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/register_phone/model/req_register_number.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
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
      await ApiManager().resetPassword(request);
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
      await ApiManager().resetPin(request);
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
    final request = ReqRegsiterNumber(
      step: 2,
      type: 1,
      isAgreeTermsAndCondition: 1,
      phoneNumber: widget.verificationModel.phone.rawNumber(),
      verificationCode: otp,
      mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      await ApiManager().register(request);
      ProgressDialogUtils.dismissProgressDialog();

      Navigator.of(context)
          .pushReplacementNamed(Routes.routeRegister, arguments: {
        ArgumentConstant.number: widget.verificationModel.phone.rawNumber(),
        ArgumentConstant.countryCode: widget.verificationModel.countryCode
      });
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
      var res = await ApiManager().resetPassword(request);
      ProgressDialogUtils.dismissProgressDialog();
      // Widgets.showToast(res.response);
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
      var res = await ApiManager().resetPin(request);
      ProgressDialogUtils.dismissProgressDialog();
      // Widgets.showToast(res.response);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _resendRegistrationApi() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqRegsiterNumber(
      step: 4,
      type: 1,
      isAgreeTermsAndCondition: 1,
      phoneNumber: widget.verificationModel.phone.rawNumber(),
      mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      var res = await ApiManager().resendPhoneVerificationCode(request);
      ProgressDialogUtils.dismissProgressDialog();
      // Widgets.showToast(
      //     "Your Hutano code is: ${res.response['verificationCode']}. This code is expires in 10 minutes.");
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _callRegsitrationApi() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqRegsiterNumber(
        step: 1,
        type: 1,
        phoneNumber: widget.verificationModel.phone.rawNumber(),
        mobileCountryCode: widget.verificationModel.countryCode,
        isAgreeTermsAndCondition: 1);
    try {
      var res = await ApiManager().otpOnCall(request);
      ProgressDialogUtils.dismissProgressDialog();
      // Widgets.showToast(res.response);
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
                  margin: spacing10,
                  onPressed: _enableButton ? _onButtonClick : null,
                  label: Localization.of(context).verify,
                ),
                SizedBox(
                  height: spacing20,
                ),
                _buildResend(context),
                SizedBox(
                  height: spacing20,
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
      padding: EdgeInsets.all(spacing10),
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
          onPressed: _resendCode,
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HutanoHeaderInfo(
          title: Localization.of(context).verifyCode,
          subTitle: Localization.of(context).msgOtpReceived,
        ),
        SizedBox(
          height: spacing7,
        ),
        Text(
          _getLabel(),
          style: TextStyle(fontSize: fontSize13),
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
