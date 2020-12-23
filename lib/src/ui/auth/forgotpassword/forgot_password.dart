import 'package:flutter/material.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../utils/progress_dialog.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_phone_input.dart';
import '../../../widgets/hutano_textfield.dart';
import '../../../widgets/toast.dart';
import '../otp_verification/model/verification_model.dart';
import 'model/req_reset_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VerificationScreen verificationScreen;

  const ForgotPasswordScreen(this.verificationScreen, {Key key})
      : super(key: key);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final GlobalKey<FormState> _numberKey = GlobalKey();
  final GlobalKey<FormState> _emailKey = GlobalKey();
  bool _enableButton = false;
  String _countryCode = '+1';

  void _onSubmitClick() async {
    final model = ReqResetPassword();
    final verificationType = _emailController.text.isNotEmpty
        ? VerificationType.email
        : VerificationType.phone;
    model.step = 1;
    if (verificationType == VerificationType.email) {
      model.email = _emailController.text;
    } else {
      model.phoneNumber = _phoneController.text.rawNumber();
    }

    if (widget.verificationScreen == VerificationScreen.resetPassword) {
      _callResetPasswordApi(model, verificationType);
    } else {
      _callResetPinApi(model, verificationType);
    }
  }

  _callResetPasswordApi(model, verificationType) async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().resetPassword(model);
      ProgressDialogUtils.dismissProgressDialog();
      showToast(res.response);
      final args = {
        ArgumentConstant.verificationModel: VerificationModel(
            verificationType: verificationType,
            email: model.email,
            phone: model.phoneNumber,
            countryCode: _countryCode,
            verificationScreen: widget.verificationScreen),
      };
      NavigationUtils.push(context, routePinVerification, arguments: args);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _callResetPinApi(model, verificationType) async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().resetPin(model);
      ProgressDialogUtils.dismissProgressDialog();
      showToast(res.response);
      final args = {
        ArgumentConstant.verificationModel: VerificationModel(
            verificationType: verificationType,
            email: model.email,
            phone: _phoneController.text,
            countryCode: _countryCode,
            verificationScreen: widget.verificationScreen),
      };
      NavigationUtils.push(context, routePinVerification, arguments: args);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  void _onLoginBackClick() {
    NavigationUtils.pushReplacement(context, routeLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorWhite,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing20),
                child: Column(
                  children: <Widget>[
                    HutanoHeader(
                      headerInfo: HutanoHeaderInfo(
                        title: _getTitle(),
                        subTitle: _getSubTitle(),
                      ),
                    ),
                    Form(
                      key: _numberKey,
                      child: _buildPhoneInput(context),
                    ),
                    SizedBox(
                      height: 25,
                      child: Center(
                        child: Text(
                          Localization.of(context).or,
                        ),
                      ),
                    ),
                    Form(
                      key: _emailKey,
                      child: _buildEmailField(context),
                    ),
                    SizedBox(
                      height: spacing50,
                    ),
                    _buildSubmitButton(context),
                    SizedBox(
                      height: spacing20,
                    ),
                    _buildLoginText(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return InkWell(
      onTap: _onLoginBackClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            FileConstants.icBack,
            height: spacing20,
            width: spacing20,
          ),
          SizedBox(
            width: spacing7,
          ),
          Text(
            Localization.of(context).msgReturnLogin,
            style: const TextStyle(
              fontSize: fontSize14,
              color: colorPurple,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return HutanoTextField(
        width: SizeConfig.screenWidth,
        labelText: Localization.of(context).emailAddress,
        prefixIcon: FileConstants.icMail,
        prefixwidth: spacing20,
        prefixheight: spacing20,
        focusNode: _emailFocus,
        controller: _emailController,
        onValueChanged: (value) {
          _numberKey.currentState.reset();
          _phoneController.text = "";
          final _validate = _emailKey.currentState.validate();
          setState(() {
            _enableButton = _validate;
          });
        },
        validationMethod: (email) => email.toString().isValidEmail(context));
  }

  Widget _buildSubmitButton(BuildContext context) {
    return HutanoButton(
      width: SizeConfig.screenWidth,
      onPressed: _enableButton ? _onSubmitClick : null,
      label: Localization.of(context).confirm,
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    return HutanoPhoneInput(
        controller: _phoneController,
        focusNode: _phoneFocus,
        onCountryChanged: (code) {
          _countryCode = code.toString();
        },
        onValueChanged: (text) {
          _emailKey.currentState.reset();
          _emailController.text = "";
          setState(() {
            _enableButton = _numberKey.currentState.validate();
          });
        },
        validationMethod: (number) => number.toString().isValidUSNumber(context));
  }

  _getTitle() {
    return widget.verificationScreen == VerificationScreen.resetPassword
        ? Localization.of(context).forgotPassword
        : Localization.of(context).forgotPin;
  }

  _getSubTitle() {
    return widget.verificationScreen == VerificationScreen.resetPassword
        ? Localization.of(context).msgForgotPin.format(["Password"])
        : Localization.of(context).msgForgotPin.format(["PIN"]);
  }
}
