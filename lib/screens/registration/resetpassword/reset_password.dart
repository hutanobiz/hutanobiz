import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/app_header.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_textfield.dart';
import '../forgotpassword/model/req_reset_password.dart';
import '../otp_verification/model/verification_model.dart';

class ResetPassword extends StatefulWidget {
  final VerificationModel? verificationModel;

  const ResetPassword({Key? key, this.verificationModel}) : super(key: key);

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
  bool isSecureField = true;
  bool isConfirmSecureField = true;

  Future<void> _onUpdateClick() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text(Localization.of(context)!
              .errorPasswordNotMatch
              .format(["Password", "Password"]))));

      return;
    }
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqResetPassword(
      step: 3,
      phoneNumber: widget.verificationModel!.phone,
      email: widget.verificationModel!.email,
      password: _confirmPasswordController.text.toString(),
      // mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      await ApiManager().resetPasswordStep3(request);
      ProgressDialogUtils.dismissProgressDialog();

      Navigator.of(context).pushReplacementNamed(
        Routes.routeResetPasswordSuccess,
      );
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response!);
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
            padding: const EdgeInsets.symmetric(horizontal: spacing15),
            child: Form(
              key: _key,
              autovalidateMode:AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppHeader(
                      title: Localization.of(context)!.msgResetPassword,
                      subTitle: Localization.of(context)!.createNewPassowrd,
                    ),
                    SizedBox(
                      height: spacing30,
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
        labelText: Localization.of(context)!.newPassword,
        prefixIcon: FileConstants.icLock,
        controller: _newPasswordController,
        focusNode: _newPasswordFocusNode,
        textInputType: TextInputType.text,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
        },
        textInputAction: TextInputAction.next,
        isPasswordField: true,
        prefixheight: spacing15,
        prefixwidth: spacing15,
        onValueChanged: (value) {
          setState(() {
            _enableButton = _key.currentState!.validate();
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
        labelText: Localization.of(context)!.confirmPassword,
        prefixIcon: FileConstants.icLock,
        controller: _confirmPasswordController,
        focusNode: _confirmPasswordFocusNode,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.done,
        isPasswordField: true,
        prefixheight: spacing15,
        prefixwidth: spacing15,
        onValueChanged: (value) {
          setState(() {
            _enableButton = _key.currentState!.validate();
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
      label: Localization.of(context)!.update,
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
