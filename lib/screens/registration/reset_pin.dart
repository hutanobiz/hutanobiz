import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/size_config.dart';

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
  final VerificationModel? verificationModel;

  const ResetPin({Key? key, this.verificationModel}) : super(key: key);
  @override
  _ResetPinState createState() => _ResetPinState();
}

class _ResetPinState extends State<ResetPin> {
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _enableButton = false;

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
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text(Localization.of(context)!
              .errorPasswordNotMatch
              .format(["PIN", "PIN"]))));

      return;
    }
    ProgressDialogUtils.showProgressDialog(context);
    final request = ReqResetPassword(
      step: 7,
      phoneNumber: widget.verificationModel!.phone!.rawNumber(),
      email: widget.verificationModel!.email,
      pin: _confirmPinController.text.toString(),
      // mobileCountryCode: widget.verificationModel.countryCode,
    );
    try {
      await ApiManager().resetPinStep3(request);
      ProgressDialogUtils.dismissProgressDialog();

      DialogUtils.showOkCancelAlertDialog(
          context: context,
          message:
              Localization.of(context)!.passwordResetSuccess.format(["PIN"]),
          isCancelEnable: false,
          okButtonTitle: Localization.of(context)!.ok,
          okButtonAction: () {
            Navigator.of(context).pushReplacementNamed(
              Routes.loginPin,
            );
          });
      setBool(PreferenceKey.setPin, true);
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                HutanoHeader(
                  headerInfo: HutanoHeaderInfo(
                    title: Localization.of(context)!.resetPin,
                    subTitle: Localization.of(context)!.msgResetPin,
                  ),
                ),
                _buildPinInput(context, Localization.of(context)!.newPin,
                    _newPinController, _onNewPinChange),
                _buildPinInput(context, Localization.of(context)!.confirmNewPin,
                    _confirmPinController, _onConfirmPinChange),
                SizedBox(
                  height: spacing20,
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
      label: Localization.of(context)!.update,
      margin: spacing10,
      onPressed: _enableButton ? _onUpdateClick : null,
    );
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
            width: SizeConfig.screenWidth! / 1.7,
            onChanged: function,
          )
        ],
      ),
    );
  }
}
