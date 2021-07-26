import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/setup_pin/model/req_setup_pin.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/enum_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/size_config.dart';
import 'package:hutano/widgets/app_header.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_pin_input.dart';
import 'package:hutano/widgets/skip_later.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:hutano/utils/extensions.dart';

class SetupPin extends StatefulWidget {
  final SetupScreenFrom setupScreen;

  const SetupPin({Key key, this.setupScreen}) : super(key: key);

  @override
  _SetupPinState createState() => _SetupPinState();
}

class _SetupPinState extends State<SetupPin> {
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _enableButton = false;
  final LocalAuthentication auth = LocalAuthentication();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Future<void> _authenticate() async {
    try {
      var authenticated = await auth.authenticateWithBiometrics(
          localizedReason: Localization.of(context).labelAuthWithFingerPrint,
          useErrorDialogs: true);
      if (authenticated) {
        setBool(PreferenceKey.setPin, true);
        Navigator.of(context).pushReplacementNamed(Routes.addPaymentOption);
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        print(e.code);
      }
    }
  }

  void _onNewPinChange(pin) {
    print(pin);
    var isValidPin =
        pin.toString().isValidPin(context, _confirmPinController.text);
    updateButton(isValidPin);
  }

  void _onConfirmPinChange(pin) {
    var isValidPin = pin.toString().isValidPin(context, _newPinController.text);
    updateButton(isValidPin);
  }

  Widget _buildPinInput(BuildContext context, String label,
      TextEditingController controller, Function function) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize14,
                color: colorBlack2,
                fontWeight: FontWeight.w400,
                fontFamily: gilroyRegular,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          SizedBox(
            height: spacing10,
          ),
          HutanoPinInput(
            pinCount: 4,
            controller: controller,
            width: SizeConfig.screenWidth / 1.4,
            onChanged: function,
          )
        ],
      ),
    );
  }

  _buildFingerPrint(BuildContext context) => Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 0.5,
                      color: colorBlack2.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text('OR',
                      style: TextStyle(
                        color: colorBlack2.withOpacity(0.7),
                        fontSize: fontSize15,
                        fontWeight: FontWeight.w500,
                        fontFamily: gilroyMedium,
                        fontStyle: FontStyle.normal,
                      )),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: Container(
                      height: 0.5,
                      color: colorBlack2.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.center,
              child: Text('SETUP FINGER PRINT LOGIN',
                  style: TextStyle(
                    color: colorBlack2,
                    fontSize: fontSize17,
                    fontWeight: FontWeight.w500,
                    fontFamily: gilroyMedium,
                    fontStyle: FontStyle.normal,
                  )),
            ),
            SizedBox(
              height: 25,
            ),
            FlatButton(
              child: Image.asset(
                FileConstants.icFingerPrint,
                height: spacing60,
                width: spacing60,
              ),
              onPressed: _authenticate,
            ),
            SizedBox(
              height: 25,
            ),
            Align(
              alignment: Alignment.center,
              child: Text('Touch your finger print sensor',
                  style: TextStyle(
                    color: colorBlack2.withOpacity(0.7),
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w500,
                    fontFamily: gilroyMedium,
                    fontStyle: FontStyle.normal,
                  )),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      );

  Future<void> _onUpdateClick() async {
    if (_confirmPinController.text == _newPinController.text) {
      try {
        ProgressDialogUtils.showProgressDialog(context);
        await ApiManager()
            .setPin(ReqSetupPin(
                pin: _confirmPinController.text,
                id: getString(PreferenceKey.id)))
            .then((value) {
          ProgressDialogUtils.dismissProgressDialog();
          setBool(PreferenceKey.setPin, true);
          if (widget.setupScreen == SetupScreenFrom.login) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.homeMain,
              (Route<dynamic> route) => false,
            );
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //   Routes.dashboardScreen,
            //   (Route<dynamic> route) => false,
            //   arguments: 0,
            // );
          } else {
            Navigator.of(context).pushReplacementNamed(Routes.setPinComplete);
          }
        }).catchError((dynamic e) {
          ProgressDialogUtils.dismissProgressDialog();
          DialogUtils.showAlertDialog(context, e.response);
        });
      } on ErrorModel catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, e.response);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(Localization.of(context).confirmPinMessage)));
      /* DialogUtils.showAlertDialog(
          context, Localization.of(context).confirmPinMessage);*/
    }
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: spacing15, right: spacing15),
      child: HutanoButton(
        label: Localization.of(context).next,
        margin: spacing10,
        onPressed: _enableButton ? _onUpdateClick : null,
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
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppHeader(
                  title: Localization.of(context).fasterLogin,
                  subTitle: Localization.of(context).createPin,
                ),
                SizedBox(
                  height: 50,
                ),
                _buildPinInput(context, Localization.of(context).newPin,
                    _newPinController, _onNewPinChange),
                _buildPinInput(context, Localization.of(context).confirmNewPin,
                    _confirmPinController, _onConfirmPinChange),
                SizedBox(
                  height: spacing20,
                ),
                if (widget.setupScreen != SetupScreenFrom.login)
                  _buildFingerPrint(context),
                SizedBox(
                  height: spacing20,
                ),
                _buildButton(context),
                if (widget.setupScreen != SetupScreenFrom.login)
                  SkipLater(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.addPaymentOption);
                    },
                  ),
                SizedBox(
                  height: spacing50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
