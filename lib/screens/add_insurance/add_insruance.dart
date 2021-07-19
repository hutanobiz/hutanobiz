import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/add_insurance/effective_date_picker.dart';
import 'package:hutano/screens/add_insurance/model/req_add_insurace.dart';
import 'package:hutano/screens/add_insurance/upload_insurance_screen.dart';
import 'package:hutano/screens/registration/register/model/res_insurance_list.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/size_config.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/custom_number_formatter.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_header_info.dart';
import 'package:hutano/widgets/hutano_textfield.dart';
import 'package:hutano/widgets/insurance_picker.dart';
import 'package:hutano/widgets/text_with_image.dart';

enum AddInsuranceError {
  insuranceCompany,
  insuranceMember,
  memberId,
  groupNumber,
  healthPlan,
  effectiveDate
}
enum InsuranceType { primary, secondary }

class AddInsurance extends StatefulWidget {
  final InsuranceType insuranceType;

  const AddInsurance({Key key, this.insuranceType = InsuranceType.primary})
      : super(key: key);
  @override
  _AddInsuranceState createState() => _AddInsuranceState();
}

class _AddInsuranceState extends State<AddInsurance> {
  final FocusNode _insuranceCompany = FocusNode();
  final FocusNode _insuranceMember = FocusNode();
  final FocusNode _memberId = FocusNode();
  final FocusNode _groupNumber = FocusNode();
  final FocusNode _healthPlan = FocusNode();
  final FocusNode _effectiveDate = FocusNode();

  bool _enableButton = false;
  bool showSecondaryInsurance = false;

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

  File _backImage;
  File _frontImage;

  final labelStyle = TextStyle(fontSize: fontSize14, color: colorGrey60);

  void _onDateSelected(String date) {
    print(date);
    _effectiveDateController.text = date;
    _addInsuranceModel.effectiveDate = date;
    showError(AddInsuranceError.effectiveDate.index);
  }

  Insurance _selectedInsurance;
  _onInsuranceSelected(String title, String id) {
    FocusManager.instance.primaryFocus.unfocus();
    _companyController.text = title;
    _addInsuranceModel.insuranceCompany = id;
    // _selectedInsurance = _insuranceList[index];
    showError(AddInsuranceError.insuranceCompany.index);
  }

  List<Insurance> _insuranceList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getInsuranceList();
    });
  }

  _getInsuranceList() async {
    try {
      var res = await ApiManager().insuraceList();
      setState(() {
        _insuranceList = res.response;
      });
    } catch (e) {
      print(e);
    }
  }

  validateField() {
    if (_companyController.text.isNotEmpty &&
        _memberController.text.isNotEmpty &&
        _groupNumberController.text.isNotEmpty &&
        _healthPlanController.text.isNotEmpty &&
        _memberIdController.text.isNotEmpty &&
        _effectiveDateController.text.isNotEmpty) {
      _enableButton = true;
      return;
    }
    _enableButton = false;
  }

  _onUpload(frontImage, backImage) {
    setState(() {
      _backImage = backImage;
      _frontImage = frontImage;
    });
  }

  void uploadInsuranceData() {
    if (_frontImage == null) {
      DialogUtils.showAlertDialog(context, "Please select front image");
    } else {
      _addInsuranceModel.isPrimary =
          (widget.insuranceType == InsuranceType.primary);
      ProgressDialogUtils.showProgressDialog(context);
      ApiManager()
          .addInsuranceDoc(_frontImage, _addInsuranceModel,
              backImage: _backImage)
          .then((value) {
        ProgressDialogUtils.dismissProgressDialog();
        Navigator.pushReplacementNamed(context, Routes.addInsuranceComplete);
      }, onError: (e) {
        ProgressDialogUtils.dismissProgressDialog();
        DialogUtils.showAlertDialog(context, "${e.response}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    validateField();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.insuranceType == InsuranceType.secondary)
                    Align(
                        alignment: Alignment.centerLeft,
                        child: CustomBackButton()),
                  SizedBox(
                    height: spacing30,
                  ),
                  HutanoHeaderInfo(
                    showLogo: true,
                    title: Localization.of(context).welcome,
                    subTitle: (widget.insuranceType == InsuranceType.primary)
                        ? Localization.of(context).addInsurance
                        : Localization.of(context).addSecondaryInsurance,
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
                  UploadInsuranceScreen(onUpload: _onUpload),
                  SizedBox(
                    height: spacing20,
                  ),
                  _buildCompleteTaskNowButton(context),
                  SizedBox(
                    height: spacing20,
                  ),
                  if (showSecondaryInsurance)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            Routes.addInsurance,
                            arguments: {
                              ArgumentConstant.argsinsuranceType:
                                  InsuranceType.secondary
                            });
                      },
                      child: Text(
                          Localization.of(context)
                              .addSecondaryInsurance
                              .toUpperCase(),
                          style: const TextStyle(
                              color: colorPurple100,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.center),
                    ),
                  SizedBox(
                    height: spacing15,
                  ),
                  if (widget.insuranceType == InsuranceType.primary)
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
        label: (widget.insuranceType == InsuranceType.primary)
            ? Localization.of(context).addInsurance
            : Localization.of(context).addSecondaryInsurance,
        onPressed: _enableButton ? uploadInsuranceData : null,
      );

  _buildSkipTaskNowButton(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HutanoButton(
              buttonType: HutanoButtonType.withPrefixIcon,
              isIconButton: true,
              labelColor: colorBlack,
              iconSize: spacing20,
              color: Colors.transparent,
              icon: FileConstants.icSkipBlack,
              label: Localization.of(context).skipTasks,
              onPressed: _skipTaskNow,
            ),
            if (showSecondaryInsurance) ...[
              Spacer(),
              HutanoButton(
                width: 55,
                height: 55,
                color: accentColor,
                iconSize: 20,
                buttonType: HutanoButtonType.onlyIcon,
                icon: FileConstants.icForward,
                onPressed: () {
                  (widget.insuranceType == InsuranceType.primary)
                      ? Navigator.of(context)
                          .pushReplacementNamed(Routes.addInsuranceComplete)
                      : Navigator.of(context)
                          .pushReplacementNamed(Routes.welcome);
                },
              )
            ],
          ],
        ),
      );

  _skipTaskNow() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.welcome, (route) => false);
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
          FilteringTextInputFormatter.digitsOnly,
          CustomInputFormatter()
        ],
        textInputType: TextInputType.number,
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
          FilteringTextInputFormatter.digitsOnly,
          CustomInputFormatter()
        ],
        textInputType: TextInputType.number,
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
            _healthPlanError = value.toString().isBlank(
                context, Localization.of(context).errorHealthInsurance);
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
          .isBlank(context, Localization.of(context).errorEnterField);
    }
    if (index >= 1) {
      _insuranceMemberError = _memberController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterField);
    }
    if (index >= 2) {
      _memberIdError = _memberIdController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterField);
    }

    if (index >= 3) {
      _groupNumberError = _groupNumberController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterField);
    }

    if (index >= 4) {
      _healthPlanError = _healthPlanController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterField);
    }

    if (index >= 5) {
      _effectiveDateError = _effectiveDateController.text
          .toString()
          .isBlank(context, Localization.of(context).errorEnterField);
    }

    setState(() {});
  }
}
