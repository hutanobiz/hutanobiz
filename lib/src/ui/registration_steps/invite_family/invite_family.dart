import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/src/utils/constants/key_constant.dart';
import 'package:hutano/src/utils/dialog_utils.dart';
import 'package:hutano/src/utils/enum_utils.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_progressbar.dart';
import '../../../widgets/hutano_steps_header.dart';
import '../../../widgets/hutano_textfield.dart';

class InviteFamilyScreen extends StatefulWidget {
  @override
  _InviteFamilyScreenState createState() => _InviteFamilyScreenState();
}

class _InviteFamilyScreenState extends State<InviteFamilyScreen> {
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _textFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();

  bool _enableButton = true;
  bool _isActionPerformed = false;
  final GlobalKey<FormState> _keyEmail = GlobalKey();
  final GlobalKey<FormState> _keyPhone = GlobalKey();
  final GlobalKey<FormState> _keyText = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
                key: _scaffoldKey,
                body: SingleChildScrollView(
                    child: Container(
                  margin: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      HutanoProgressBar(
                          progressSteps: HutanoProgressSteps.three),
                      HutanoHeader(
                        headerInfo: HutanoHeaderInfo(
                          title: Localization.of(context).inviteFamily,
                          subTitle:
                              Localization.of(context).inviteFamilyAndFriends,
                          subTitleFontSize: fontSize15,
                        ),
                        spacing: spacing20,
                      ),
                      Text(
                        Localization.of(context).step3of4,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: colorBlack,
                            fontWeight: fontWeightMedium,
                            fontSize: fontSize17),
                      ),
                      SizedBox(
                        height: spacing10,
                      ),
                      HutanoStepsHeader(
                        title: Localization.of(context).inviteFamilyAndFriends,
                        subTitle: Localization.of(context).assignPermisstion,
                        iconText: stepThree,
                        subTitlePadding:false
                      ),
                      SizedBox(
                        height: spacing20,
                      ),
                      _buildInviteByEmail(context),
                      SizedBox(
                        height: spacing10,
                      ),
                      Text(
                        Localization.of(context).or.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: colorBlack,
                            fontWeight: fontWeightMedium,
                            fontSize: fontSize12),
                      ),
                      SizedBox(
                        height: spacing10,
                      ),
                      _buildInviteByPhoneNumber(context),
                      SizedBox(
                        height: spacing10,
                      ),
                      Text(
                        Localization.of(context).or.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: colorBlack,
                            fontWeight: fontWeightMedium,
                            fontSize: fontSize12),
                      ),
                      SizedBox(
                        height: spacing10,
                      ),
                      _buildInviteByTextOrSms(context),
                      SizedBox(
                        height: spacing10,
                      ),
                      SizedBox(
                        height: spacing50,
                      ),
                      _buildNextButton(context),
                      SizedBox(
                        height: spacing20,
                      ),
                      _buildSkipTaskNowButton(context),
                      SizedBox(
                        height: spacing20,
                      ),
                    ],
                  ),
                )))));
  }

  Widget _buildInviteByEmail(BuildContext context) {
    return Form(
      key: _keyEmail,
      child: Container(
        margin: EdgeInsets.only(left: spacing20, right: spacing20),
        child: Padding(
          padding: EdgeInsets.only(left: spacing25, right: spacing25),
          child: HutanoTextField(
              labelText: Localization.of(context).inviteByEmail,
              hintText: Localization.of(context).enterEmailAddress,
              floatingBehaviour: FloatingLabelBehavior.always,
              prefixIcon: FileConstants.icUserBlue,
              prefixwidth: spacing15,
              prefixheight: spacing15,
              textInputType: TextInputType.text,
              focusNode: _emailFocus,
              controller: _emailController,
              labelTextStyle:
                  TextStyle(fontSize: fontSize15, color: colorPurple100),
              enabledBorderColor: colorPurple100,
              focusedBorderColor: colorPurple100,
              prefixPadding: EdgeInsets.only(right: spacing20, left: spacing20),
              onValueChanged: (value) {
                setState(() {
                  _keyText.currentState.reset();
                  _keyPhone.currentState.reset();
                  _phoneController.clear();
                  _textController.clear();
                  _keyEmail.currentState.validate();
                });
              },
              validationMethod: (email) =>
                  email.toString().isValidEmail(context)),
        ),
      ),
    );
  }

  Widget _buildInviteByPhoneNumber(BuildContext context) {
    return Form(
      key: _keyPhone,
      child: Container(
        margin: EdgeInsets.only(left: spacing20, right: spacing20),
        child: Padding(
          padding: EdgeInsets.only(left: spacing25, right: spacing25),
          child: HutanoTextField(
              labelText: Localization.of(context).searchAndInvite,
              hintText: Localization.of(context).enterPhoneNumber,
              prefixIcon: FileConstants.icPhone,
              floatingBehaviour: FloatingLabelBehavior.always,
              prefixheight: spacing15,
              prefixwidth: spacing15,
              focusNode: _phoneFocus,
              controller: _phoneController,
              focusedBorderColor: colorPurple100,
              enabledBorderColor: colorPurple100,
              prefixPadding: EdgeInsets.only(right: spacing20, left: spacing20),
              textInputType: TextInputType.number,
              labelTextStyle:
                  TextStyle(fontSize: fontSize15, color: colorPurple100),
              textInputFormatter: [LengthLimitingTextInputFormatter(10)],
              onValueChanged: (value) {
                setState(() {
                  _keyEmail.currentState.reset();
                  _keyText.currentState.reset();
                  _emailController.clear();
                  _textController.clear();
                  _keyPhone.currentState.validate();
                });
              },
              validationMethod: (number) =>
                  number.toString().isValidNumber(context)),
        ),
      ),
    );
  }

  Widget _buildInviteByTextOrSms(BuildContext context) {
    return Form(
      key: _keyText,
      child: Container(
        margin: EdgeInsets.only(left: spacing20, right: spacing20),
        child: Padding(
          padding: EdgeInsets.only(left: spacing25, right: spacing25),
          child: HutanoTextField(
              labelText: Localization.of(context).inviteByText,
              hintText: Localization.of(context).enterPhoneNumber,
              prefixIcon: FileConstants.icSms,
              controller: _textController,
              floatingBehaviour: FloatingLabelBehavior.always,
              labelTextStyle:
                  TextStyle(fontSize: fontSize15, color: colorPurple100),
              prefixwidth: spacing15,
              prefixheight: spacing15,
              textInputType: TextInputType.number,
              focusedBorderColor: colorPurple100,
              enabledBorderColor: colorPurple100,
              disableBorderColor: colorPurple100,
              textInputFormatter: [LengthLimitingTextInputFormatter(10)],
              onValueChanged: (value) {
                setState(() {
                  _keyEmail.currentState.reset();
                  _keyPhone.currentState.reset();
                  _emailController.clear();
                  _phoneController.clear();
                  _keyText.currentState.validate();
                });
              },
              prefixPadding: EdgeInsets.only(right: spacing20, left: spacing20),
              validationMethod: (number) =>
                  number.toString().isValidNumber(context)),
        ),
      ),
    );
  }

  _buildNextButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: spacing20, right: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        icon: FileConstants.icNext,
        color: colorDarkBlue,
        iconSize: 20,
        label: Localization.of(context).next.toUpperCase(),
        onPressed: _enableButton ? _nextScreen : null,
      ));

  _buildSkipTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(
          left: spacing20, right: spacing20, bottom: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        iconSize: spacing20,
        color: colorYellow,
        icon: FileConstants.icSkip,
        label: Localization.of(context).skipThisTask,
        onPressed: _skipTaskNow,
      ));

  _nextScreen() {
    if (_emailController.text.isNotEmpty) {
      if (_keyEmail.currentState.validate()) {
        final email = _emailController.text;
        _emailController.clear();
        _isActionPerformed = true;
        FocusManager.instance.primaryFocus.unfocus();
        Navigator.of(context).pushNamed( routeInviteByEmail, arguments: {
          ArgumentConstant.email: email,
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(Localization.of(context).msgEnterValidAddress)));
      }
    } else if (_phoneController.text.isNotEmpty) {
      if (_keyPhone.currentState.validate()) {
        final phone = _phoneController.text;
        _phoneController.clear();
        _isActionPerformed = true;
        FocusManager.instance.primaryFocus.unfocus();
        Navigator.of(context).pushNamed( routeSearch, arguments: {
          ArgumentConstant.number: phone,
          ArgumentConstant.searchScreen: SearchScreenFrom.inviteFamily
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(Localization.of(context).msgEnterValidMobile)));
      }
    } else if (_textController.text.isNotEmpty) {
      if (_keyText.currentState.validate()) {
        final smsNumber = _textController.text;
        _textController.clear();
        _isActionPerformed = true;
        FocusManager.instance.primaryFocus.unfocus();
        Navigator.of(context).pushNamed( routeInviteByText, arguments: {
          ArgumentConstant.sms: smsNumber,
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(Localization.of(context).msgEnterValidMobile)));
      }
    } else {
      if (_isActionPerformed) {
        Navigator.of(context).pushNamed( routeAddProvider);
      } else {
        DialogUtils.showAlertDialog(
            context, Localization.of(context).errorSelectOneOption);
      }
    }
  }

  void clearValue() {
    _textController.clear();
    _phoneController.clear();
    _emailController.clear();
  }

  _skipTaskNow() {
    Navigator.of(context).pushNamed( routeAddProvider);
  }
}
