import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/api/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/setup_pin/model/req_setup_pin.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/enum_utils.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
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
  ApiBaseHelper api = ApiBaseHelper();
  String userId, token;

  @override
  void initState() {
    super.initState();
    SharedPref().getToken().then((value) {
      token = value;
    });
    SharedPref().getValue('id').then((value) {
      userId = value;
    });
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

  Future<void> _authenticate() async {
    try {
      var authenticated = await auth.authenticate(
          localizedReason: Strings.labelAuthWithFingerPrint,
          useErrorDialogs: true);
      if (authenticated) {
        SharedPref().setBoolValue('setPin', true);
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
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyle.regularStyle(
                fontSize: 14,
                color: AppColors.colorBlack2,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          HutanoPinInput(
            pinCount: 4,
            controller: controller,
            width: MediaQuery.of(context).size.width / 1.4,
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
                      color: AppColors.colorBlack2.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text('OR',
                      style: AppTextStyle.mediumStyle(
                        color: AppColors.colorBlack2.withOpacity(0.7),
                        fontSize: 15,
                      )),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: Container(
                      height: 0.5,
                      color: AppColors.colorBlack2.withOpacity(0.3),
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
                  style: AppTextStyle.mediumStyle(
                    color: AppColors.colorBlack2,
                    fontSize: 17,
                  )),
            ),
            SizedBox(
              height: 25,
            ),
            FlatButton(
              child: Image.asset(
                FileConstants.icFingerPrint,
                height: 60,
                width: 60,
              ),
              onPressed: _authenticate,
            ),
            SizedBox(
              height: 25,
            ),
            Align(
              alignment: Alignment.center,
              child: Text('Touch your finger print sensor',
                  style: AppTextStyle.mediumStyle(
                    color: AppColors.colorBlack2.withOpacity(0.7),
                    fontSize: 12,
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
        await api
            .setPin(context, token,
                ReqSetupPin(pin: _confirmPinController.text, id: userId))
            .then((value) {
          ProgressDialogUtils.dismissProgressDialog();
          SharedPref().setBoolValue('setPin', true);
          if (widget.setupScreen == SetupScreenFrom.login) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.dashboardScreen,
              (Route<dynamic> route) => false,
              arguments: 0,
            );
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
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(Strings.confirmPinMessage)));
      /* DialogUtils.showAlertDialog(
          context, Strings.confirmPinMessage);*/
    }
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: HutanoButton(
        label: Strings.next,
        margin: 10,
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
                AppHeader(
                  title: Strings.fasterLogin,
                  subTitle: Strings.createPin,
                ),
                SizedBox(
                  height: 50,
                ),
                _buildPinInput(context, Strings.newPin, _newPinController,
                    _onNewPinChange),
                _buildPinInput(context, Strings.confirmNewPin,
                    _confirmPinController, _onConfirmPinChange),
                SizedBox(
                  height: 20,
                ),
                if (widget.setupScreen != SetupScreenFrom.login)
                  _buildFingerPrint(context),
                SizedBox(
                  height: 20,
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
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
