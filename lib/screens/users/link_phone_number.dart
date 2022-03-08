import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/otp_verification/model/verification_model.dart';
import 'package:hutano/screens/registration/register_phone/model/req_register_number.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_phone_input.dart';

class LinkNumber extends StatefulWidget {
  @override
  _LinkNumberState createState() => _LinkNumberState();
}

class _LinkNumberState extends State<LinkNumber> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  bool _enableButton = false;
  String _countryCode = '+1';

  @override
  void initState() {
    super.initState();
  }

  _onSubmitClick() async {
    var phone = _controller.text.trim().toString();

    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().getAccountByPhoneNumber(phone.rawNumber());
      ProgressDialogUtils.dismissProgressDialog();
      Navigator.pushNamed(context, Routes.linkAccount,arguments: res);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  void enableButton() {
    setState(() {
      _enableButton = _key.currentState.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorWhite,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: _key,
            child: Container(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Row(
                    children: [
                      CustomBackButton(),
                    ],
                  ),
                  HutanoHeader(
                    headerInfo: HutanoHeaderInfo(
                      title: 'Enter Link Phone Number',
                      subTitle:
                          'A 6 digit verification will be sent via SMS \n to verify your phone number!',
                    ),
                  ),
                  _buildPhoneInput(),
                  _buildSubmitButton(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return HutanoButton(
      margin: spacing20,
      onPressed: _enableButton ? _onSubmitClick : null,
      label: Localization.of(context).next,
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      margin: EdgeInsets.all(spacing20),
      child: HutanoPhoneInput(
          controller: _controller,
          focusNode: _phoneFocus,
          onValueChanged: (text) {
            enableButton();
          },
          onCountryChanged: (cc) => _countryCode == cc,
          validationMethod: (number) =>
              number.toString().isValidUSNumber(context)),
    );
  }
}
