import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/widgets/app_header.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_textfield.dart';
import '../forgotpassword/model/req_reset_password.dart';
import '../otp_verification/model/verification_model.dart';

class ResetPassword extends StatefulWidget {
  final VerificationModel verificationModel;

  const ResetPassword({Key key, this.verificationModel}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiBaseHelper api = ApiBaseHelper();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _enableButton = false;
  bool isSecureField = true;
  bool isConfirmSecureField = true;

  Future<void> _onUpdateClick() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              Strings.errorPasswordNotMatch.format(["Password", "Password"]))));

      return;
    }
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqResetPassword(
      step: 3,
      phoneNumber: widget.verificationModel.phone,
      email: widget.verificationModel.email,
      password: _confirmPasswordController.text.toString(),
      // mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      await api.resetPassword(request);
      ProgressDialogUtils.dismissProgressDialog();

      Navigator.of(context).pushReplacementNamed(
        Routes.routeResetPasswordSuccess,
      );
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _key,
              autovalidate: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppHeader(
                      title: Strings.msgResetPassword,
                      subTitle: Strings.createNewPassowrd,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _buildNewPasswordField(),
                    SizedBox(
                      height: 20,
                    ),
                    _buildConfirmPasswordField(),
                    SizedBox(
                      height: 40,
                    ),
                    _buildButton(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewPasswordField() {
    return HutanoTextField(
        labelText: Strings.newPassword,
        prefixIcon: FileConstants.icLock,
        controller: _newPasswordController,
        focusNode: _newPasswordFocusNode,
        textInputType: TextInputType.text,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
        },
        textInputAction: TextInputAction.next,
        isPasswordField: true,
        prefixheight: 15,
        prefixwidth: 15,
        onValueChanged: (value) {
          setState(() {
            _enableButton = _key.currentState.validate();
          });
        },
        passwordTap: () {
          setState(() {
            isSecureField = !isSecureField;
          });
        },
        isSecureField: isSecureField,
        validationMethod: (value) => value.toString().isValidPassword(context));
  }

  Widget _buildConfirmPasswordField() {
    return HutanoTextField(
        labelText: Strings.confirmPassword,
        prefixIcon: FileConstants.icLock,
        controller: _confirmPasswordController,
        focusNode: _confirmPasswordFocusNode,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.done,
        isPasswordField: true,
        prefixheight: 15,
        prefixwidth: 15,
        onValueChanged: (value) {
          setState(() {
            _enableButton = _key.currentState.validate();
          });
        },
        passwordTap: () {
          setState(() {
            isConfirmSecureField = !isConfirmSecureField;
          });
        },
        isSecureField: isConfirmSecureField,
        validationMethod: (value) => value.toString().isValidPassword(context));
  }

  Widget _buildButton(BuildContext context) {
    return HutanoButton(
      label: Strings.update,
      margin: 0,
      onPressed: _enableButton ? _onUpdateClick : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _confirmPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
  }
}
