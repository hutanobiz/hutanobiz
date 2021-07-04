import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/shared_prefrences.dart';

import '../../utils/dialog_utils.dart';
import '../../utils/extensions.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_header.dart';
import '../../widgets/hutano_header_info.dart';
import '../../widgets/hutano_pin_input.dart';
import 'forgotpassword/model/req_reset_password.dart';
import 'otp_verification/model/verification_model.dart';

class ResetPin extends StatefulWidget {
  final VerificationModel verificationModel;

  const ResetPin({Key key, this.verificationModel}) : super(key: key);
  @override
  _ResetPinState createState() => _ResetPinState();
}

class _ResetPinState extends State<ResetPin> {
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _enableButton = false;
  ApiBaseHelper api = ApiBaseHelper();

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

  void _onUpdateClick() async {
    if (_newPinController.text != _confirmPinController.text) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(Strings.errorPasswordNotMatch.format(["PIN", "PIN"]))));

      return;
    }
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqResetPassword(
      step: 7,
      phoneNumber: widget.verificationModel.phone.rawNumber(),
      email: widget.verificationModel.email,
      pin: _confirmPinController.text.toString(),
      // mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      await api.resetPinStep3(request);
      ProgressDialogUtils.dismissProgressDialog();

      DialogUtils.showOkCancelAlertDialog(
          context: context,
          message: Strings.passwordResetSuccess.format(["PIN"]),
          isCancelEnable: false,
          okButtonTitle: Strings.ok,
          okButtonAction: () {
            Navigator.of(context).pushReplacementNamed(
              Routes.loginPin,
            );
          });
      SharedPref().setBoolValue('setPin', true);
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                HutanoHeader(
                  headerInfo: HutanoHeaderInfo(
                    title: Strings.resetPin,
                    subTitle: Strings.msgResetPin,
                  ),
                ),
                _buildPinInput(context, Strings.newPin, _newPinController,
                    _onNewPinChange),
                _buildPinInput(context, Strings.confirmNewPin,
                    _confirmPinController, _onConfirmPinChange),
                SizedBox(
                  height: 20,
                ),
                _buildButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return HutanoButton(
      label: Strings.update,
      margin: 10,
      onPressed: _enableButton ? _onUpdateClick : null,
    );
  }

  Widget _buildPinInput(BuildContext context, String label,
      TextEditingController controller, Function function) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          HutanoPinInput(
            pinCount: 4,
            controller: controller,
            width: MediaQuery.of(context).size.width / 1.7,
            onChanged: function,
          )
        ],
      ),
    );
  }
}
