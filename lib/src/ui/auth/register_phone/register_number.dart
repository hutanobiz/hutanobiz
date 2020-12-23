import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../apis/api_manager.dart';
import '../../../apis/error_model.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../utils/progress_dialog.dart';
import '../../../widgets/base_checkbox.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_phone_input.dart';
import '../../../widgets/toast.dart';
import '../otp_verification/model/verification_model.dart';
import 'model/req_register_number.dart';

class RegisterNumber extends StatefulWidget {
  @override
  _RegisterNumberState createState() => _RegisterNumberState();
}

class _RegisterNumberState extends State<RegisterNumber> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  bool _enableButton = false;
  bool _privacyPolicyChecked = false;
  String _countryCode = '+1';
  TapGestureRecognizer _termsAndConditionTap = new TapGestureRecognizer();
  TapGestureRecognizer _privacyPolicyTap = new TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _termsAndConditionTap
      ..onTap = () {
        _navigate();
      };
    _privacyPolicyTap
      ..onTap = () {
        _navigate();
      };
  }

  void _navigate() {
    NavigationUtils.push(context, routeWebView);
  }

  _onSubmitClick() async {
    var phone = _controller.text.trim().toString();

    ProgressDialogUtils.showProgressDialog(context);
    var request = ReqRegsiterNumber(
        isAgreeTermsAndCondition: 1,
        step: 1,
        type: 1,
        phoneNumber: phone.rawNumber(),
        mobileCountryCode: _countryCode);
    try {
      var res = await ApiManager().register(request);
      ProgressDialogUtils.dismissProgressDialog();
      showToast(res.response);
      final args = {
        ArgumentConstant.verificationModel: VerificationModel(
            verificationType: VerificationType.phone,
            email: null,
            phone: phone,
            countryCode: _countryCode,
            verificationScreen: VerificationScreen.registration),
      };
      NavigationUtils.push(context, routePinVerification, arguments: args);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  void enableButton() {
    setState(() {
      _enableButton = _key.currentState.validate() && _privacyPolicyChecked;
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
                  HutanoHeader(
                    headerInfo: HutanoHeaderInfo(
                      title: Localization.of(context).yourPhone,
                      subTitle: Localization.of(context).msgVerification,
                    ),
                  ),
                  _buildPhoneInput(),
                  _buildPrivacyPolicy(context),
                  _buildSubmitButton(),
                  _buildBottomLabels()
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

  Widget _buildPrivacyPolicy(context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: spacing10, horizontal: spacing20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: RichText(
              text: TextSpan(
                  text: Localization.of(context).privacyPolicy,
                  style: TextStyle(color: colorBlack85, fontSize: fontSize13),
                  children: [
                    TextSpan(
                        text: Localization.of(context).termsAndCondition,
                        recognizer: _termsAndConditionTap,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        )),
                    TextSpan(text: ' & '),
                    TextSpan(
                        text: Localization.of(context).privacyPolicyLabel,
                        recognizer: _privacyPolicyTap,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ))
                  ]),
            ),
          ),
          BaseCheckBox(
              activeColor: colorYellow,
              value: _privacyPolicyChecked,
              onChanged: (val) {
                setState(() {
                  _privacyPolicyChecked = val;
                  _enableButton = val &&
                      _controller.text.length > 0 &&
                      _key.currentState.validate();
                });
              })
        ],
      ),
    );
  }

  Widget _buildBottomLabels() {
    return Column(
      children: [
        SizedBox(height: spacing30),
        Text(Localization.of(context).helpSigningIn,
            style: const TextStyle(
              fontSize: fontSize13,
            )),
        SizedBox(height: spacing15),
        GestureDetector(
          onTap: _navigate,
          child: Text(Localization.of(context).dataSecurityStatement,
              style: const TextStyle(
                fontSize: fontSize12,
                color: colorBlack85,
              )),
        )
      ],
    );
  }
}
