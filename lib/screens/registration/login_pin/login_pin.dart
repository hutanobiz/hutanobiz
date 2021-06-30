import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/login_pin/model/req_login_pin.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/enum_utils.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

import '../../../utils/extensions.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_pin_input.dart';

class LoginPin extends StatefulWidget {
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
  final _availableBiometrics = ValueNotifier<List<BiometricType>>(null);
  String number;
  ApiBaseHelper api = ApiBaseHelper();

  @override
  void initState() {
    super.initState();
    SharedPref().getValue('phoneNumber').then((value) {
      setState(() {
        number = value;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => {_checkBiometrics()});
    initializeDateFormatting('en');
  }

  void _onForgotPinClick() =>
      Navigator.of(context).pushNamed(Routes.routeForgotPassword, arguments: {
        ArgumentConstant.verificationScreen: VerificationScreen.resetPin
      });

  Future<void> _checkBiometrics() async {
    var check = false;
    List<BiometricType> availableBiometrics;
    try {
      check = await auth.canCheckBiometrics;
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics.value = check;
      _availableBiometrics.value = availableBiometrics;
      print("Length" + availableBiometrics.length.toString());
    });
  }

  Future<void> _onLoginClick() async {
    final request = ReqLoginPin(phoneNumber: number, pin: _otpController.text);
    ProgressDialogUtils.showProgressDialog(context);

    await api.loginPin(request).then((value) {
      ProgressDialogUtils.dismissProgressDialog();
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.dashboardScreen,
        (Route<dynamic> route) => false,
        arguments: 0,
      );
    });
  }

  void _onRegisterClick() =>
      Navigator.of(context).pushNamed(Routes.registerEmailRoute);

  Widget _buildOtp(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: HutanoPinInput(
        width: MediaQuery.of(context).size.width / 1.7,
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
          title: Strings.enterPin,
          subTitle: Strings.msgEnterPin.format([number]),
        ),
      ],
    );
  }

  Future<void> _authenticate() async {
    try {
      var authenticated = await auth.authenticate(
          localizedReason: Strings.labelAuthWithFingerPrint,
          useErrorDialogs: true);
      if (authenticated) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.dashboardScreen,
          (Route<dynamic> route) => false,
          arguments: 0,
        );
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        print(e.code);
      }
    }
  }

  _buildFingerPrint(BuildContext context) {
    return _canCheckBiometrics.value == true &&
            _availableBiometrics.value.contains(BiometricType.fingerprint)
        ? Container(
            child: FlatButton(
              child: Image.asset(
                FileConstants.icFingerPrint,
                height: 60,
                width: 60,
              ),
              onPressed: _authenticate,
            ),
          )
        : Container();
  }

  Widget _buildHeaderLabel(BuildContext context) {
    return Text(
      Strings.signInTitle,
      style: TextStyle(color: AppColors.colorBlack85, fontSize: 13),
    );
  }

  Widget _buildForgotPin(BuildContext context) {
    return FlatButton(
      onPressed: _onForgotPinClick,
      child: Text(
        Strings.forgotPin,
        style: TextStyle(color: AppColors.colorPurple, fontSize: 13),
      ),
    );
  }

  Widget _buildRegister(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: Strings.signIn,
              style: TextStyle(
                color: AppColors.colorBlack,
                fontSize: 14,
              )),
          TextSpan(
            text: Strings.register,
            style: TextStyle(color: AppColors.colorYellow, fontSize: 14),
            recognizer: _tapRecognizer..onTap = _onRegisterClick,
          )
        ],
      ),
    );
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
                  headerLabel: _buildHeaderLabel(context),
                  headerInfo: _buildHeader(context),
                  spacing: 20,
                ),
                _buildOtp(context),
                _buildForgotPin(context),
                SizedBox(
                  height: 20,
                ),
                HutanoButton(
                  margin: 10,
                  onPressed: _enableButton ? _onLoginClick : null,
                  label: Strings.logIn,
                ),
                SizedBox(
                  height: 30,
                ),
                //_buildRegister(context),
                SizedBox(
                  height: 40,
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
