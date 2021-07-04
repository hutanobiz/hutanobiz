import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/widgets/controller.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_phone_input.dart';
import '../../../widgets/hutano_textfield.dart';
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
  ApiBaseHelper api = ApiBaseHelper();

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
      var res = await api.resetPassword(model);
      ProgressDialogUtils.dismissProgressDialog();
      Widgets.showToast(res.response);
      final args = {
        ArgumentConstant.verificationModel: VerificationModel(
            verificationType: verificationType,
            email: model.email,
            phone: model.phoneNumber,
            countryCode: _countryCode,
            verificationScreen: widget.verificationScreen),
      };
      Navigator.of(context)
          .pushNamed(Routes.routePinVerification, arguments: args);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _callResetPinApi(model, verificationType) async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await api.resetPin(model);
      ProgressDialogUtils.dismissProgressDialog();
      Widgets.showToast(res.response);
      final args = {
        ArgumentConstant.verificationModel: VerificationModel(
            verificationType: verificationType,
            email: model.email,
            phone: _phoneController.text,
            countryCode: _countryCode,
            verificationScreen: widget.verificationScreen),
      };
      Navigator.of(context)
          .pushNamed(Routes.routePinVerification, arguments: args);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  void _onLoginBackClick() {
    Navigator.of(context)
        .pushReplacementNamed(Routes.loginRoute, arguments: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colorWhite,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          Strings.or,
                        ),
                      ),
                    ),
                    Form(
                      key: _emailKey,
                      child: _buildEmailField(context),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    _buildSubmitButton(context),
                    SizedBox(
                      height: 20,
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
            height: 20,
            width: 20,
          ),
          SizedBox(
            width: 7,
          ),
          Text(
            Strings.msgReturnLogin,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.colorPurple,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return HutanoTextField(
        width: MediaQuery.of(context).size.width,
        labelText: Strings.emailAddress,
        prefixIcon: FileConstants.icMail,
        prefixwidth: 20,
        prefixheight: 20,
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
      width: MediaQuery.of(context).size.width,
      onPressed: _enableButton ? _onSubmitClick : null,
      label: Strings.confirm,
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
        validationMethod: (number) =>
            number.toString().isValidUSNumber(context));
  }

  _getTitle() {
    return widget.verificationScreen == VerificationScreen.resetPassword
        ? Strings.forgotPassword
        : Strings.forgotPin;
  }

  _getSubTitle() {
    return widget.verificationScreen == VerificationScreen.resetPassword
        ? Strings.msgForgotPin.format(["Password"])
        : Strings.msgForgotPin.format(["PIN"]);
  }
}
