import 'package:flutter/material.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/forgotpassword/model/req_reset_password.dart';
import 'package:hutano/screens/registration/otp_verification/model/verification_model.dart';
import 'package:hutano/screens/registration/register_phone/model/req_register_number.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import '../../../../utils/dialog_utils.dart';
import '../../../../utils/enum_utils.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../widgets/hutano_button.dart';
import '../../../../widgets/hutano_header.dart';
import '../../../../widgets/hutano_header_info.dart';
import '../../../../widgets/hutano_pin_input.dart';

class LinkVerification extends StatefulWidget {
  final dynamic userData;

  LinkVerification({this.userData});

  @override
  _LinkVerificationState createState() => _LinkVerificationState();
}

class _LinkVerificationState extends State<LinkVerification> {
  final TextEditingController _otpController = TextEditingController();
  bool _enableButton = false;

  _onButtonClick() async {
    verifyAddUserApi();
  }

  verifyAddUserApi() async {
    ProgressDialogUtils.showProgressDialog(context);
    final otp = _otpController.text.trim().toString();
    final request = {
      'verificationCode': otp,
      'phoneNumber': widget.userData['phoneNumber']
    };

    try {
      await ApiManager().veriyfyLinkAccountCode(request);
      ProgressDialogUtils.dismissProgressDialog();
      Widgets.showAppDialog(
          context: context,
          description: 'Account Added',
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.homeMain,
              (Route<dynamic> route) => false,
            );
          });
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    }
  }

  _resendCode() async {
    _resendAddUSerOtp();
  }

  _resendAddUSerOtp() async {
    ProgressDialogUtils.showProgressDialog(context);
    final request = {
      'relation': widget.userData['relation'],
      'phoneNumber': widget.userData['phoneNumber']
    }
        // mobileCountryCode: widget.verificationModel.countryCode,
        ;
    try {
      var res = await ApiManager().sendLinkAccountCode(request);
      ProgressDialogUtils.dismissProgressDialog();

      // Widgets.showToast(res.response);
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    CustomBackButton(),
                  ],
                ),
                HutanoHeader(
                  headerInfo: _buildHeader(context),
                ),
                _buildOtp(context),
                HutanoButton(
                  margin: spacing10,
                  onPressed: _enableButton ? _onButtonClick : null,
                  label: Localization.of(context).verify,
                ),
                SizedBox(
                  height: spacing20,
                ),
                _buildResend(context),
                SizedBox(
                  height: spacing20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtp(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacing10),
      child: HutanoPinInput(
        pinCount: 6,
        controller: _otpController,
        width: MediaQuery.of(context).size.width,
        onChanged: (text) {
          if (text.length == 6) {
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

  Widget _buildResend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Localization.of(context).msgCodeNotRecieved,
          style: TextStyle(
            fontSize: fontSize14,
            color: colorBlack,
          ),
        ),
        RawMaterialButton(
          constraints: BoxConstraints(),
          padding: EdgeInsets.all(0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: _resendCode,
          child: Text(
            Localization.of(context).resend,
            style: TextStyle(
              fontSize: fontSize14,
              color: accentColor,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HutanoHeaderInfo(
          title: Localization.of(context).verifyCode,
          subTitle: Localization.of(context).msgOtpReceived,
        ),
        SizedBox(
          height: spacing7,
        ),
        Text(
          widget.userData['phoneNumber'].toString(),
          style: TextStyle(fontSize: fontSize13),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _otpController.dispose();
  }
}
