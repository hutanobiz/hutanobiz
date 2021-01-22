import 'package:flutter/material.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
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

  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _enableButton = false;

  Future<void> _onUpdateClick() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(Localization.of(context)
              .errorPasswordNotMatch
              .format(["Password", "Password"]))));

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
      await ApiManager().resetPasswordStep3(request);
      ProgressDialogUtils.dismissProgressDialog();

      DialogUtils.showOkCancelAlertDialog(
          context: context,
          message: Localization.of(context)
              .passwordResetSuccess
              .format(["Password"]),
          isCancelEnable: false,
          okButtonTitle: Localization.of(context).ok,
          okButtonAction: () {
            Navigator.of(context).pushReplacementNamed(
              routeLogin,
            );
          });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
    Navigator.of(context).pushNamedAndRemoveUntil(routeLogin,(route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacing15),
            child: Form(
              key: _key,
              autovalidate: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HutanoHeader(
                      headerInfo: HutanoHeaderInfo(
                          title: Localization.of(context).msgResetPassword,
                          subTitle: Localization.of(context).createNewPassowrd),
                    ),
                    _buildNewPasswordField(),
                    SizedBox(
                      height: spacing20,
                    ),
                    _buildConfirmPasswordField(),
                    SizedBox(
                      height: spacing40,
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
        labelText: Localization.of(context).newPassword,
        prefixIcon: FileConstants.icLock,
        controller: _newPasswordController,
        focusNode: _newPasswordFocusNode,
        textInputType: TextInputType.text,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
        },
        textInputAction: TextInputAction.next,
        isSecureField: true,
        isPasswordField: true,
        prefixheight: spacing15,
        prefixwidth: spacing15,
        onValueChanged: (value) {
          setState(() {
            _enableButton = _key.currentState.validate();
          });
        },
        validationMethod: (value) => value.toString().isValidPassword(context));
  }

  Widget _buildConfirmPasswordField() {
    return HutanoTextField(
        labelText: Localization.of(context).confirmPassword,
        prefixIcon: FileConstants.icLock,
        controller: _confirmPasswordController,
        focusNode: _confirmPasswordFocusNode,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.done,
        isSecureField: true,
        isPasswordField: true,
        prefixheight: spacing15,
        prefixwidth: spacing15,
        onValueChanged: (value) {
          setState(() {
            _enableButton = _key.currentState.validate();
          });
        },
        validationMethod: (value) => value.toString().isValidPassword(context));
  }

  Widget _buildButton(BuildContext context) {
    return HutanoButton(
      label: Localization.of(context).update,
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
