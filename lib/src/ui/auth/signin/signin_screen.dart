import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

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
import '../../../utils/preference_key.dart';
import '../../../utils/preference_utils.dart';
import '../../../utils/progress_dialog.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/custom_checkbox.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_phone_input.dart';
import '../../../widgets/hutano_textfield.dart';
import 'model/req_login.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _phoneController = TextEditingController();

  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final LocalAuthentication auth = LocalAuthentication();
  final GlobalKey<FormState> _key = GlobalKey();

  final GlobalKey<FormState> _keyPhone = GlobalKey();
  final GlobalKey<FormState> _keyPassword = GlobalKey();
  bool _enableButton = false;
  String selectedCountry = "+1";
  bool isRememberMe = false;
  bool isSecureField = true;

  @override
  void initState() {
    super.initState();
    if (getBool(PreferenceKey.isRemember)) {
      _phoneController =
          TextEditingController(text: getString(PreferenceKey.phone));
      selectedCountry = getString(PreferenceKey.flag);
      isRememberMe = getBool(PreferenceKey.isRemember);
    }
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                AppLogo(),
                Padding(
                  padding: EdgeInsets.only(left: spacing20, right: spacing20),
                  child: Column(
                    children: [
                      _getSignInTextField(),
                      SizedBox(height: spacing70),
                      _buildPhoneInput(context),
                      SizedBox(height: spacing30),
                      _buildPasswordField(context),
                      SizedBox(
                        height: spacing20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getRememberMeButton(),
                          _getForgotPasswordButton(),
                        ],
                      ),
                      SizedBox(height: spacing30),
                      _buildLoginButton(context),
                      _getAccountRegister(),
                      SizedBox(height: spacing40),
                    ],
                  ),
                )
//                  _buildBody(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateButton(bool isValid) {
    if (isValid) {
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
  }

  Widget _getSignInTextField() => Container(
        padding: const EdgeInsets.only(
            left: spacing20, right: spacing20, top: spacing10),
        child: Text(Localization.of(context).signInTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize14,
              color: colorBlack85,
            )),
      );

  Widget _buildPhoneInput(BuildContext context) {
    return Form(
      key: _keyPhone,
      autovalidate: true,
      child: Container(
        child: HutanoPhoneInput(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            intialSelection: selectedCountry,
            onFieldSubmitied: (_) {
              _phoneFocusNode.unfocus();
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            onValueChanged: (value) {
              setState(() {
                _keyPhone.currentState.validate();
              });
            },
            onCountryChanged: (cc) {
              setState(() {
                selectedCountry = cc.toString();
              });
            },
            validationMethod: (number) {
              return number.toString().isValidUSNumber(context);
            }),
      ),
    );
  }

  Widget _getForgotPasswordButton() => GestureDetector(
        onTap: () {
          NavigationUtils.push(context, routeForgotPassword, arguments: {
            ArgumentConstant.verificationScreen:
                VerificationScreen.resetPassword
          });
        },
        child: Text(
          Localization.of(context).forgotPassword,
          style: TextStyle(
              fontSize: fontSize12,
              color: colorPurple,
              fontWeight: fontWeightMedium),
        ),
      );

  Widget _getRememberMeButton() => Container(
        width: SizeConfig.screenWidth / 2,
        child: Row(
          children: <Widget>[
            CustomCheckBox(
              selected: isRememberMe,
              onSelect: (value) => setState(() {
                isRememberMe = value;
              }),
            ),
          ],
        ),
      );

  void _storeValue(String phoneNumber) async {
    if (_phoneController.text.isNotEmpty) {
      await setString(PreferenceKey.phone, _phoneController.text.trim());
      await setString(PreferenceKey.flag, selectedCountry);
      await setBool(PreferenceKey.isRemember, isRememberMe);
    }
  }

  Widget _getAccountRegister() => Container(
        child: FlatButton(
          padding: const EdgeInsets.all(spacing10),
          onPressed: _registerPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Localization.of(context).signIn,
                style: TextStyle(
                    fontSize: fontSize14,
                    color: Colors.black,
                    fontWeight: fontWeightRegular),
              ),
              Text(
                Localization.of(context).register,
                style: TextStyle(
                    fontSize: fontSize14,
                    color: colorYellow,
                    fontWeight: fontWeightRegular),
              ),
            ],
          ),
        ),
      );

  _buildPasswordField(BuildContext context) => Form(
        key: _keyPassword,
        autovalidate: false,
        child: HutanoTextField(
            labelText: Localization.of(context).password,
            isPasswordField: true,
            textInputAction: TextInputAction.done,
            prefixIcon: FileConstants.icLock,
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            textInputType: TextInputType.text,
            isSecureField: isSecureField,
            prefixheight: 15,
            prefixwidth: 15,
            onValueChanged: (value) {
              setState(() {
                _enableButton = _keyPhone.currentState.validate() &&
                    _keyPassword.currentState.validate();
              });
            },
            passwordTap: () {
              setState(() {
                isSecureField = !isSecureField;
              });
            },
            onFieldSubmitted: (_) {
              _passwordFocusNode.unfocus();
            },
            validationMethod: (value) {
              return value.toString().isValidPassword(context);
            }),
      );

  _buildLoginButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: spacing10),
      child: Align(
          alignment: Alignment.topRight,
          child: HutanoButton(
            label: Localization.of(context).logIn,
            onPressed: _enableButton ? _onLoginClick : null,
          )));

  void _registerPressed() {
    NavigationUtils.push(context, routeRegisterNumber);
  }

  Future<void> _onLoginClick() async {
    if (_keyPhone.currentState.validate() &&
        _keyPassword.currentState.validate()) {
      ProgressDialogUtils.showProgressDialog(context);
      var phonenumber = "${_phoneController.text.substring(1, 4)}"
          "${_phoneController.text.substring(6, 9)}"
          "${_phoneController.text.substring(10, 14)}";

      final req = ReqLogin(
          phoneNumber: phonenumber,
          password: _passwordController.text,
          mobileCountryCode: selectedCountry);
      try {
        await ApiManager().login(req).then((value) {
          ProgressDialogUtils.dismissProgressDialog();

          clear();
          if (isRememberMe) {
            _storeValue(phonenumber);
          } else {
            setBool(PreferenceKey.isRemember, isRememberMe);
          }

          setBool(PreferenceKey.perFormedSteps, true);
          setBool(
              PreferenceKey.isEmailVerified, value.response.isEmailVerified);
          setString(PreferenceKey.fullName, value.response.fullName);
          setString(PreferenceKey.id, value.response.sId);
          setString(PreferenceKey.tokens, value.response.tokens[0].token);
          setString(PreferenceKey.phone, value.response.phoneNumber.toString());
          setInt(PreferenceKey.gender, value.response.gender);
          if (value.response.pin == null && value.response.isEmailVerified) {
            NavigationUtils.push(context, routeSetupPin, arguments: {
              ArgumentConstant.setPinScreen: SetupScreenFrom.login
            });
          } else {
            NavigationUtils.pushReplacement(context, routeHome);
            if (value.response.pin != null) {
              setBool(PreferenceKey.setPin, true);
            }
          }
        });
      } on ErrorModel catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, e.response);
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(
            context, Localization.of(context).commonErrorMsg);
        print(e);
      }
    }
  }
}
