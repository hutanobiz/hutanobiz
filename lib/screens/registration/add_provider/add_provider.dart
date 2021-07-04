import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/file_constants.dart';
import '../../../utils/extensions.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/hutano_progressbar.dart';
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
          margin: EdgeInsets.all(0),
          child: Column(
            children: [
              
              AppHeader(
                progressSteps: HutanoProgressSteps.four,
                title: Strings.addProviders,
                subTitle: Strings.addProviderToNetwork,
              ),
              SizedBox(
                height: 20,
              ),
              _buildSearchByName(context),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(Strings.or),
              ),
              _buildSearchByPhoneNumber(context),
              SizedBox(
                height: 50,
              ),
              _buildNextButton(context),
              SizedBox(
                height: 20,
              ),
              _buildSkipTaskNowButton(context),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )))));
  }

  Widget _buildSearchByName(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Padding(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: HutanoTextField(
            labelText: Strings.searchByName,
            hintText: Strings.enterProviderName,
            floatingBehaviour: FloatingLabelBehavior.always,
            textInputType: TextInputType.text,
            focusNode: _nameFocus,
            controller: _nameController,
            suffixIcon: FileConstants.icSearchYellow,
            suffixIconClick: _onProviderNameSearch,
            suffixheight: 30,
            suffixwidth: 30,
            labelTextStyle:
                TextStyle(fontSize: 11, color: AppColors.colorPurple100),
            enabledBorderColor: AppColors.colorPurple100,
            disableBorderColor: AppColors.colorPurple100,
            focusedBorderColor: AppColors.colorPurple100,
            prefixPadding: EdgeInsets.only(right: 20, left: 20),
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
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Padding(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: HutanoTextField(
            labelText: Strings.searchByNumber,
            hintText: Strings.enterProviderNumber,
            floatingBehaviour: FloatingLabelBehavior.always,
            focusNode: _phoneFocus,
            controller: _phoneController,
            suffixIcon: FileConstants.icSearchYellow,
            suffixIconClick: _onProviderNumberSearch,
            suffixheight: 30,
            suffixwidth: 30,
            enabledBorderColor: AppColors.colorPurple100,
            disableBorderColor: AppColors.colorPurple100,
            focusedBorderColor: AppColors.colorPurple100,
            prefixPadding: EdgeInsets.only(right: 20, left: 20),
            textInputType: TextInputType.number,
            labelTextStyle:
                TextStyle(fontSize: 11, color: AppColors.colorPurple100),
            onValueChanged: (value) {
              _nameController.text = "";
            },
            validationMethod: (email) =>
                email.toString().isValidNumber(context)),
      ),
    );
  }

  _buildNextButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        icon: FileConstants.icNext,
        color: AppColors.colorDarkBlue,
        iconSize: 20,
        label: Strings.next.toUpperCase(),
        onPressed: _enableButton ? _nextScreen : null,
      ));

  _buildSkipTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(
          left: 20, right: 20, bottom: 20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        iconSize: 20,
        color: AppColors.colorYellow,
        icon: FileConstants.icSkip,
        label: Strings.skipThisTask,
        onPressed: _skipTaskNow,
      ));

  _nextScreen() {
    FocusManager.instance.primaryFocus.unfocus();

    //TODO : TEMPORARY CODE
    //Chaning route to dashboard screen from home
    if (_phoneController.text.isNotEmpty) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.dashboardScreen, (route) => false,arguments: 0);
      Navigator.of(context).pushNamed(Routes.dashboardSearchScreen,
          arguments: {'searchParam': _phoneController.text});
      // Navigator.of(context).pushNamedAndRemoveUntil(Routes.dashboardScreen, (route) => false,
      //     arguments: {ArgumentConstant.searchText: _phoneController.text});
    } else if (!_nameController.text.isEmpty) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.dashboardScreen, (route) => false,arguments: 0);
      Navigator.of(context).pushNamed(Routes.dashboardSearchScreen,
          arguments: {'searchParam': _nameController.text});
      // Navigator.of(context).pushNamedAndRemoveUntil(Routes.dashboardScreen, (route) => false,
      //     arguments: {ArgumentConstant.searchText: _nameController.text});
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.dashboardScreen, (route) => false,arguments: 0);
    }
  }

  _skipTaskNow() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.dashboardScreen, (route) => false,arguments: 0);
    // Navigator.of(context).pushNamed(Routes.dashboardSearchScreen,arguments: {'searchParam':'Test'});
  }
}
