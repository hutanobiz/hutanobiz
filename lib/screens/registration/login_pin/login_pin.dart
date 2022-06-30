import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/login_pin/model/req_login_pin.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/enum_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/size_config.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

import '../../../utils/extensions.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_pin_input.dart';

class LoginPin extends StatefulWidget {
  String number = getString(PreferenceKey.phone);

  LoginPin();

  @override
  _LoginPinState createState() => _LoginPinState();
}

class _LoginPinState extends State<LoginPin> {
  final TextEditingController _otpController = TextEditingController();
  bool _enableButton = false;
  final TapGestureRecognizer _tapRecognizer = TapGestureRecognizer();
  final LocalAuthentication auth = LocalAuthentication();
  final _canCheckBiometrics = ValueNotifier<bool>(false);
  // final _availableBiometrics = ValueNotifier<List<BiometricType>>(null);
  String? deviceToken;
  dynamic primaryUser;
  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    initializeDateFormatting('en');
    SharedPref().getValue("deviceToken").then((value) {
      deviceToken = value;
    });

    primaryUser = json.decode(getString('primaryUser'));

    setBool(PreferenceKey.perFormedSteps, true);
    setBool(PreferenceKey.isEmailVerified, primaryUser['isEmailVerified']);
    setString(PreferenceKey.fullName, primaryUser['fullName']);
    setString(PreferenceKey.id, primaryUser['_id']);
    setString(PreferenceKey.tokens, getString('primaryUserToken'));
    setString(PreferenceKey.phone, primaryUser['phoneNumber'].toString());
    widget.number = primaryUser['phoneNumber'].toString();
    setInt(PreferenceKey.gender, primaryUser['gender']);
    setString('patientSocialHistory',
        jsonEncode(primaryUser['patientSocialHistory']));
    setString('selectedAccount', jsonEncode(primaryUser));
    setBool(PreferenceKey.intro, true);
    SharedPref().saveToken(getString('primaryUserToken'));
  }

  void _onForgotPinClick() =>
      Navigator.of(context).pushNamed(Routes.routeForgotPassword, arguments: {
        ArgumentConstant.verificationScreen: VerificationScreen.resetPin
      });

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    // List<BiometricType> availableBiometrics;

    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      // availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics.value = canCheckBiometrics;
      // _availableBiometrics.value = availableBiometrics;
    });
  }

  Future<void> _onLoginClick() async {
    final request = ReqLoginPin(
        phoneNumber: widget.number,
        deviceToken: deviceToken,
        pin: _otpController.text);
    ProgressDialogUtils.showProgressDialog(context);
    try {
      await ApiManager().loginPin(request).then((value) {
        try {
          ProgressDialogUtils.dismissProgressDialog();
          //TODO : Verify Code
          // Changing route to dashbaord
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //   Routes.dashboardScreen,
          //   (Route<dynamic> route) => false,
          //   arguments: 0,
          // );
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.homeMain,
            (Route<dynamic> route) => false,
          );
        } catch (e) {
          print(e);
        }
      });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response!);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(
          context, Localization.of(context)!.commonErrorMsg);
    }
  }

  void _onRegisterClick() =>
      Navigator.of(context).pushNamed(Routes.routeRegisterNumber);

  Widget _buildOtp(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(spacing10),
      child: HutanoPinInput(
        width: SizeConfig.screenWidth! / 1.7,
        pinCount: 4,
        controller: _otpController,
        onChanged: (text) {
          if (text.length == 4) {
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HutanoHeaderInfo(
          title: Localization.of(context)!.enterPin,
          subTitle:
              Localization.of(context)!.msgEnterPin.format([widget.number]),
        ),
      ],
    );
  }

  Future<void> _authenticate() async {
    try {
      var authenticated = await auth.authenticate(
          localizedReason: Localization.of(context)!.labelAuthWithFingerPrint,
          options: const AuthenticationOptions(
            useErrorDialogs: true,
          ));

      if (authenticated) {
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   Routes.dashboardScreen,
        //   (Route<dynamic> route) => false,
        //   arguments: 0,
        // );
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.homeMain,
          (Route<dynamic> route) => false,
        );
      }
    } on PlatformException catch (e) {
      // if (e.code == auth_error.notEnrolled) {
      print(e.code);
      // }
    }
  }

  _buildFingerPrint(BuildContext context) {
    return _canCheckBiometrics.value == true
        ? Container(
            child: FlatButton(
              child: Image.asset(
                FileConstants.icFingerPrint,
                height: spacing60,
                width: spacing60,
              ),
              onPressed: _authenticate,
            ),
          )
        : Container();
  }

  Widget _buildHeaderLabel(BuildContext context) {
    return Text(
      Localization.of(context)!.signInTitle,
      style: const TextStyle(color: colorBlack85, fontSize: fontSize13),
    );
  }

  Widget _buildForgotPin(BuildContext context) {
    return FlatButton(
      onPressed: _onForgotPinClick,
      child: Text(
        Localization.of(context)!.forgotPin,
        style: const TextStyle(color: colorPurple, fontSize: fontSize13),
      ),
    );
  }

  Widget _buildRegister(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: Localization.of(context)!.signIn,
              style: TextStyle(
                color: colorBlack,
                fontSize: fontSize14,
              )),
          TextSpan(
            text: Localization.of(context)!.register,
            style: TextStyle(color: colorYellow, fontSize: fontSize14),
            recognizer: _tapRecognizer..onTap = _onRegisterClick,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                HutanoHeader(
                  headerLabel: _buildHeaderLabel(context),
                  headerInfo: _buildHeader(context),
                  spacing: spacing20,
                ),
                _buildOtp(context),
                _buildForgotPin(context),
                SizedBox(
                  height: spacing20,
                ),
                HutanoButton(
                  margin: spacing10,
                  onPressed: _enableButton ? _onLoginClick : null,
                  label: Localization.of(context)!.logIn,
                ),
                SizedBox(
                  height: spacing30,
                ),
                //_buildRegister(context),
                SizedBox(
                  height: spacing40,
                ),
                _buildFingerPrint(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
    _tapRecognizer.dispose();
  }
}
