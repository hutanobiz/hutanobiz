import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/src/ui/add_insurance/upload_insurance_screen.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/utils/preference_key.dart';
import 'package:hutano/src/utils/preference_utils.dart';
import 'package:hutano/src/utils/size_config.dart';
import 'package:hutano/src/widgets/hutano_button.dart';
import 'package:hutano/src/widgets/text_with_image.dart';

import '../../utils/color_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/extensions.dart';
import '../../utils/localization/localization.dart';
import '../../widgets/hutano_header_info.dart';
import '../../widgets/hutano_textfield.dart';
import '../auth/register/model/res_insurance_list.dart';
import 'effective_date_picker.dart';
import 'insurance_picker.dart';
import 'model/req_add_insurace.dart';

class AddInsurance extends StatefulWidget {
  @override
  _AddInsuranceState createState() => _AddInsuranceState();
}

enum AddInsuranceError {
  insuranceCompany,
  insuranceMember,
  memberId,
  groupNumber,
  healthPlan,
  effectiveDate
}

class _AddInsuranceState extends State<AddInsurance> {
  final FocusNode _insuranceCompany = FocusNode();
  final FocusNode _insuranceMember = FocusNode();
  final FocusNode _memberId = FocusNode();
  final FocusNode _groupNumber = FocusNode();
  final FocusNode _healthPlan = FocusNode();
  final FocusNode _effectiveDate = FocusNode();

  String _insuranceCompanyError;
  String _insuranceMemberError;
  String _memberIdError;
  String _groupNumberError;
  String _healthPlanError;
  String _effectiveDateError;

  final _companyController = TextEditingController();
  final _memberController = TextEditingController();
  final _groupNumberController = TextEditingController();
  final _healthPlanController = TextEditingController();
  final _memberIdController = TextEditingController();
  final _effectiveDateController = TextEditingController();

  final _addInsuranceModel = ReqAddInsurance();

  final labelStyle = TextStyle(fontSize: fontSize14, color: colorGrey60);

  void _onDateSelected(String date) {
    print(date);
    _effectiveDateController.text = date;
    _addInsuranceModel.effectiveDate = date;
    showError(AddInsuranceError.effectiveDate.index);
  }

  Insurance _selectedInsurance;
  _onInsuranceSelected(int index) {
    FocusManager.instance.primaryFocus.unfocus();
    _companyController.text = _insuranceList[index].title;
    _addInsuranceModel.insuranceCompany = _insuranceList[index].sId;
    _selectedInsurance = _insuranceList[index];
    showError(AddInsuranceError.insuranceCompany.index);
  }

  List<Insurance> _insuranceList = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: spacing30,
                  ),
                  HutanoHeaderInfo(
                    showLogo: true,
                    title: Localization.of(context).welcome,
                    subTitle: Localization.of(context).addInsurance,
                    subTitleFontSize: fontSize15,
                  ),
                  SizedBox(
                    height: spacing40,
                  ),
                  // _getInsuranceCompany(),
                  TextWithImage(
                      size: spacing30,
                      textStyle: TextStyle(fontSize: fontSize16),
                      label: Localization.of(context).labelHealthInsurance,
                      image: FileConstants.icInsuranceBlue),
                  SizedBox(
                    height: spacing12,
                  ),
                  InsuranceList(
                      controller: _companyController,
                      insuranceList: _insuranceList,
                      onInsuranceSelected: _onInsuranceSelected),
                  SizedBox(
                    height: spacing20,
                  ),
                  _getInsuredMember(),
                  SizedBox(
                    height: spacing20,
                  ),
                  _getMemberId(),
                  SizedBox(
                    height: spacing20,
                  ),
                  _getGroupNumber(),
                  SizedBox(
                    height: spacing20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getHealthPlan(),
                      EffectiveDatePicker(
                          focusNode: _effectiveDate,
                          onDateSelected: _onDateSelected,
                          controller: _effectiveDateController),
                    ],
                  ),

                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Localization.of(context).uploadInsuranceCardImage,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: colorBorder2,
                        fontSize: fontSize13,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  UploadInsuranceScreen(),
                  SizedBox(
                    height: spacing20,
                  ),
                  _buildCompleteTaskNowButton(context),
                  SizedBox(
                    height: spacing20,
                  ),
                  _buildSkipTaskNowButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildCompleteTaskNowButton(BuildContext context) => HutanoButton(
        buttonType: HutanoButtonType.withIcon,
        isIconButton: true,
        icon: FileConstants.icDone,
        color: colorYellow,
        iconSize: spacing30,
        label: Localization.of(context).addInsurance,
        onPressed: () {},
      );

  _buildSkipTaskNowButton(BuildContext context) => Padding(
      padding: const EdgeInsets.only(
          left: spacing20, right: spacing20, bottom: spacing20),
      child: HutanoButton(
        buttonType: HutanoButtonType.withPrefixIcon,
        isIconButton: true,
        labelColor: colorBlack,
        iconSize: spacing20,
        color: Colors.transparent,
        icon: FileConstants.icSkipLater,
        label: Localization.of(context).skipTasks,
        onPressed: _skipTaskNow,
      ));

  _skipTaskNow() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(routeWelcomeScreen, (route) => false);
    setBool(PreferenceKey.skipStep, true);
  }

  Widget _getInsuranceCompany() {
    return HutanoTextField(
        onValueChanged: (value) {
          _addInsuranceModel.insuranceCompany = value;
          setState(() {
            _insuranceCompanyError = value
                .toString()
                .isBlank(context, Localization.of(context).errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _insuranceCompanyError,
        focusNode: _insuranceCompany,
        controller: _companyController,
        labelText: Localization.of(context).insuranceCompany,
        focusedBorderColor: colorBlack20,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_insuranceMember);
          showError(AddInsuranceError.insuranceCompany.index);
        },
        textInputFormatter: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
        ],
        textInputType: TextInputType.name,
        textInputAction: TextInputAction.next);
  }

  Widget _getInsuredMember() {
    return HutanoTextField(
        onValueChanged: (value) {
          _addInsuranceModel.insuranceMember = value;
          setState(() {
            _insuranceMemberError = value
                .toString()
                .isBlank(context, Localization.of(context).errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _insuranceMemberError,
        focusNode: _insuranceMember,
        controller: _memberController,
        labelText: Localization.of(context).insuranceMemberName,
        focusedBorderColor: colorBlack20,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_memberId);
          showError(AddInsuranceError.insuranceMember.index);
        },
        textInputFormatter: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
        ],
        textInputType: TextInputType.name,
        textInputAction: TextInputAction.next);
  }

  Widget _getMemberId() {
    return HutanoTextField(
        onValueChanged: (value) {
          _addInsuranceModel.memberId = value;
          setState(() {
            _memberIdError = value
                .toString()
                .isBlank(context, Localization.of(context).errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _memberIdError,
        focusNode: _memberId,
        controller: _memberIdController,
        labelText: Localization.of(context).memberId,
        focusedBorderColor: colorBlack20,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_groupNumber);
          showError(AddInsuranceError.memberId.index);
        },
        textInputFormatter: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
        ],
        textInputType: TextInputType.name,
        textInputAction: TextInputAction.next);
  }

  Widget _getGroupNumber() {
    return HutanoTextField(
        onValueChanged: (value) {
          _addInsuranceModel.groupNumber = value;
          setState(() {
            _groupNumberError = value
                .toString()
                .isBlank(context, Localization.of(context).errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _groupNumberError,
        focusNode: _groupNumber,
        controller: _groupNumberController,
        labelText: Localization.of(context).groupNumber,
        focusedBorderColor: colorBlack20,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_healthPlan);
          showError(AddInsuranceError.groupNumber.index);
        },
        textInputFormatter: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
        ],
        textInputType: TextInputType.name,
        textInputAction: TextInputAction.next);
  }

  Widget _getHealthPlan() {
    return HutanoTextField(
        labelTextStyle: labelStyle,
        width: SizeConfig.screenWidth / 2.4,
        focusedBorderColor: colorBlack20,
        controller: _healthPlanController,
        focusNode: _healthPlan,
        textInputType: TextInputType.number,
        maxLength: 6,
        onFieldTap: () {
          showError(AddInsuranceError.healthPlan.index);
        },
        onValueChanged: (value) {
          _addInsuranceModel.healthPlan = value;
          setState(() {
            _healthPlanError = value
                .toString()
                .isBlank(context, Localization.of(context).errorZipCode);
          });
        },
        errorText: _healthPlanError,
        textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
        labelText: Localization.of(context).healthPlan,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_effectiveDate);
          showError(AddInsuranceError.healthPlan.index);
        },
        textInputAction: TextInputAction.done);
  }

  // validate and show error if user skips field or navigate to next field
  void showError(int index) {
    if (index >= 0) {
      _insuranceCompanyError = _companyController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterFirstName);
    }
    if (index >= 1) {
      _insuranceMemberError = _memberIdController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterLastName);
    }
    if (index >= 2) {
      _memberIdError = _memberIdController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterLastName);
    }

    if (index >= 3) {
      _groupNumberError = _groupNumberController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterLastName);
    }

    if (index >= 4) {
      _healthPlanError = _healthPlanController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterAddress);
    }

    if (index >= 5) {
      _effectiveDateError = _effectiveDateController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterCity);
    }

    setState(() {});
  }
}
