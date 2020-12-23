import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/src/apis/api_manager.dart';
import 'package:hutano/src/apis/error_model.dart';
import 'package:hutano/src/ui/registration_steps/setup_pin/model/req_setup_pin.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/utils/dialog_utils.dart';
import 'package:hutano/src/utils/dimens.dart';
import 'package:hutano/src/utils/enum_utils.dart';
import 'package:hutano/src/utils/localization/localization.dart';
import 'package:hutano/src/utils/navigation.dart';
import 'package:hutano/src/utils/preference_key.dart';
import 'package:hutano/src/utils/preference_utils.dart';
import 'package:hutano/src/utils/progress_dialog.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

import '../../../utils/extensions.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_pin_input.dart';

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
        NavigationUtils.pushReplacement(context, routeAddPaymentOption);
        setBool(PreferenceKey.setPin, true);
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
          Text(
            label,
            style: TextStyle(fontSize: fontSize14),
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
        child: FlatButton(
          child: Image.asset(
            FileConstants.icFingerPrint,
            height: spacing40,
            width: spacing40,
          ),
          onPressed: _authenticate,
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
            NavigationUtils.pushReplacement(context, routeHome);
          } else {
            NavigationUtils.pushReplacement(context, routeAddPaymentOption);
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
        label: Localization.of(context).update,
        margin: spacing10,
        onPressed: _enableButton ? _onUpdateClick : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Column(
              children: [
                HutanoHeader(
                  headerInfo: HutanoHeaderInfo(
                    title: Localization.of(context).msgResetPin,
                  ),
                ),
                _buildPinInput(context, Localization.of(context).newPin,
                    _newPinController, _onNewPinChange),
                _buildPinInput(context, Localization.of(context).confirmNewPin,
                    _confirmPinController, _onConfirmPinChange),
                SizedBox(
                  height: spacing20,
                ),
                _buildButton(context),
                SizedBox(
                  height: spacing50,
                ),
                //_buildFingerPrint(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
