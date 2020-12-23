import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/src/utils/constants/key_constant.dart';
import 'package:hutano/src/utils/navigation.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_header.dart';
import '../../../widgets/hutano_header_info.dart';
import '../../../widgets/hutano_progressbar.dart';
import '../../../widgets/hutano_steps_header.dart';
import '../../../widgets/hutano_textfield.dart';

class AddProvider extends StatefulWidget {
  @override
  _AddProviderState createState() => _AddProviderState();
}

class _AddProviderState extends State<AddProvider> {
  final FocusNode _nameFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();

  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  bool _enableButton = true;
  final GlobalKey<FormState> _key = GlobalKey();

  void _onProviderNameSearch() {}

  void _onProviderNumberSearch() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
                    child: Container(
          margin: EdgeInsets.all(spacing10),
          child: Column(
            children: [
              HutanoProgressBar(progressSteps: HutanoProgressSteps.four),
              HutanoHeader(
                headerInfo: HutanoHeaderInfo(
                  title: Localization.of(context).addProviders,
                  subTitleFontSize: fontSize15,
                ),
              ),
              Text(
                Localization.of(context).step4of4,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: colorBlack,
                    fontWeight: fontWeightMedium,
                    fontSize: fontSize17),
              ),
              HutanoStepsHeader(
                title: Localization.of(context).addProviderToNetwork,
                iconText: stepFour,
              ),
              SizedBox(
                height: spacing20,
              ),
              _buildSearchByName(context),
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing10),
                child: Text(Localization.of(context).or),
              ),
              _buildSearchByPhoneNumber(context),
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

  Widget _buildSearchByName(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: spacing20, right: spacing20),
      child: Padding(
        padding: EdgeInsets.only(left: spacing25, right: spacing25),
        child: HutanoTextField(
            labelText: Localization.of(context).searchByName,
            hintText: Localization.of(context).enterProviderName,
            floatingBehaviour: FloatingLabelBehavior.always,
            textInputType: TextInputType.text,
            focusNode: _nameFocus,
            controller: _nameController,
            suffixIcon: FileConstants.icSearchYellow,
            suffixIconClick: _onProviderNameSearch,
            suffixheight: spacing30,
            suffixwidth: spacing30,
            labelTextStyle:
                TextStyle(fontSize: fontSize11, color: colorPurple100),
            enabledBorderColor: colorPurple100,
            disableBorderColor: colorPurple100,
            focusedBorderColor: colorPurple100,
            prefixPadding: EdgeInsets.only(right: spacing20, left: spacing20),
            onValueChanged: (value) {
              _phoneController.text = "";
            },
            validationMethod: (email) =>
                email.toString().isValidEmail(context)),
      ),
    );
  }

  Widget _buildSearchByPhoneNumber(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: spacing20, right: spacing20),
      child: Padding(
        padding: EdgeInsets.only(left: spacing25, right: spacing25),
        child: HutanoTextField(
            labelText: Localization.of(context).searchByNumber,
            hintText: Localization.of(context).enterProviderNumber,
            floatingBehaviour: FloatingLabelBehavior.always,
            focusNode: _phoneFocus,
            controller: _phoneController,
            suffixIcon: FileConstants.icSearchYellow,
            suffixIconClick: _onProviderNumberSearch,
            suffixheight: spacing30,
            suffixwidth: spacing30,
            enabledBorderColor: colorPurple100,
            disableBorderColor: colorPurple100,
            focusedBorderColor: colorPurple100,
            prefixPadding: EdgeInsets.only(right: spacing20, left: spacing20),
            textInputType: TextInputType.number,
            labelTextStyle:
                TextStyle(fontSize: fontSize11, color: colorPurple100),
            onValueChanged: (value) {
              _nameController.text = "";
            },
            validationMethod: (email) =>
                email.toString().isValidNumber(context)),
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
        iconSize: 20,
        color: colorYellow,
        icon: FileConstants.icSkip,
        label: Localization.of(context).skipThisTask,
        onPressed: _skipTaskNow,
      ));

  _nextScreen() {
    FocusManager.instance.primaryFocus.unfocus();

    if (_phoneController.text.isNotEmpty) {
      NavigationUtils.pushAndRemoveUntil(context, routeHome,
          arguments: {ArgumentConstant.searchText: _phoneController.text});
    } else if (!_nameController.text.isEmpty) {
      NavigationUtils.pushAndRemoveUntil(context, routeHome,
          arguments: {ArgumentConstant.searchText: _nameController.text});
    } else {
      NavigationUtils.pushAndRemoveUntil(context, routeHome);
    }
  }

  _skipTaskNow() {
    NavigationUtils.pushAndRemoveUntil(
      context,
      routeHome,
    );
  }
}