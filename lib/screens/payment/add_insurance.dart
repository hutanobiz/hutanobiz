import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/payment/req_add_insurace.dart';
import 'package:hutano/screens/payment/res_insurance_list.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/dialog_utils.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_back_button.dart';
import 'package:hutano/widgets/custom_number_formatter.dart';
import 'package:hutano/widgets/effective_date_picker.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/hutano_header_info.dart';
import 'package:hutano/widgets/hutano_textfield.dart';
import 'package:hutano/widgets/insurance_picker.dart';
import 'package:hutano/widgets/text_with_image.dart';
import 'package:hutano/widgets/upload_insurance_screen.dart';

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

  final labelStyle = TextStyle(fontSize: 14, color: AppColors.colorGrey60);

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
  ApiBaseHelper api = ApiBaseHelper();
  String token;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SharedPref().getToken().then((value) {
        token = value;
        _getInsuranceList();
      });
    });
  }

  _getInsuranceList() async {
    try {
      var res = await api.insuraceList();
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
      SharedPref().getToken().then((value) {
        _addInsuranceModel.isPrimary =
            (widget.insuranceType == InsuranceType.primary);
        ProgressDialogUtils.showProgressDialog(context);
        api
            .addInsuranceDoc(token, _frontImage, _addInsuranceModel,
                backImage: _backImage)
            .then((value) {
          ProgressDialogUtils.dismissProgressDialog();

          if (widget.insuranceType == InsuranceType.primary) {
            setState(() {
              showSecondaryInsurance = true;
            });
            DialogUtils.showAlertDialog(
                context, "Insurance updated successfully",
                title: "");
          } else {
            Navigator.pushReplacementNamed(context, Routes.addInsuranceComplete);
          }
        }, onError: (e) {
          ProgressDialogUtils.dismissProgressDialog();
          DialogUtils.showAlertDialog(context, "${e.response}");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    height: 30,
                  ),
                  HutanoHeaderInfo(
                    showLogo: true,
                    title: Strings.welcome,
                    subTitle: (widget.insuranceType == InsuranceType.primary)
                        ? Strings.addInsurance
                        : Strings.addSecondaryInsurance,
                    subTitleFontSize: 15,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  // _getInsuranceCompany(),
                  TextWithImage(
                      size: 30,
                      textStyle: TextStyle(fontSize: 16),
                      label: Strings.labelHealthInsurance,
                      image: FileConstants.icInsuranceBlue),
                  SizedBox(
                    height: 12,
                  ),
                  InsuranceList(
                      controller: _companyController,
                      insuranceList: _insuranceList,
                      onInsuranceSelected: _onInsuranceSelected),
                  SizedBox(
                    height: 20,
                  ),
                  _getInsuredMember(),
                  SizedBox(
                    height: 20,
                  ),
                  _getMemberId(),
                  SizedBox(
                    height: 20,
                  ),
                  _getGroupNumber(),
                  SizedBox(
                    height: 20,
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
                      Strings.uploadInsuranceCardImage,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.colorBorder2,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  UploadInsuranceScreen(onUpload: _onUpload),
                  SizedBox(
                    height: 20,
                  ),
                  _buildCompleteTaskNowButton(context),
                  SizedBox(
                    height: 20,
                  ),
                  if (showSecondaryInsurance)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.addInsurance,
                            arguments: {
                              ArgumentConstant.argsinsuranceType:
                                  InsuranceType.secondary
                            });
                      },
                      child: Text(Strings.addSecondaryInsurance.toUpperCase(),
                          style: TextStyle(
                              color: AppColors.colorPurple100,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.center),
                    ),
                  SizedBox(
                    height: 15,
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
        color: AppColors.colorYellow,
        iconSize: 30,
        label: (widget.insuranceType == InsuranceType.primary)
            ? Strings.addInsurance
            : Strings.addSecondaryInsurance,
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
              labelColor: AppColors.colorBlack,
              iconSize: 20,
              color: Colors.transparent,
              icon: FileConstants.icSkipBlack,
              label: Strings.skipTasks,
              onPressed: _skipTaskNow,
            ),
            if (showSecondaryInsurance) ...[
              Spacer(),
              HutanoButton(
                width: 55,
                height: 55,
                color: AppColors.accentColor,
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

  _skipTaskNow() async {
    await SharedPref().setBoolValue('skipStep', true);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.welcome, (route) => false);
  }

  Widget _getInsuranceCompany() {
    return HutanoTextField(
        onValueChanged: (value) {
          _addInsuranceModel.insuranceCompany = value;
          setState(() {
            _insuranceCompanyError =
                value.toString().isBlank(context, Strings.errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _insuranceCompanyError,
        focusNode: _insuranceCompany,
        controller: _companyController,
        labelText: Strings.insuranceCompany,
        focusedBorderColor: AppColors.colorBlack20,
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
            _insuranceMemberError =
                value.toString().isBlank(context, Strings.errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _insuranceMemberError,
        focusNode: _insuranceMember,
        controller: _memberController,
        labelText: Strings.insuranceMemberName,
        focusedBorderColor: AppColors.colorBlack20,
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
            _memberIdError =
                value.toString().isBlank(context, Strings.errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _memberIdError,
        focusNode: _memberId,
        controller: _memberIdController,
        labelText: Strings.memberId,
        focusedBorderColor: AppColors.colorBlack20,
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
            _groupNumberError =
                value.toString().isBlank(context, Strings.errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _groupNumberError,
        focusNode: _groupNumber,
        controller: _groupNumberController,
        labelText: Strings.groupNumber,
        focusedBorderColor: AppColors.colorBlack20,
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
        width: MediaQuery.of(context).size.width / 2.4,
        focusedBorderColor: AppColors.colorBlack20,
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
            _healthPlanError =
                value.toString().isBlank(context, Strings.errorHealthInsurance);
          });
        },
        errorText: _healthPlanError,
        textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
        labelText: Strings.healthPlan,
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
          .isBlank(context, Strings.errorEnterField);
    }
    if (index >= 1) {
      _insuranceMemberError = _memberController.text
          .toString()
          .isBlank(context, Strings.errorEnterField);
    }
    if (index >= 2) {
      _memberIdError = _memberIdController.text
          .toString()
          .isBlank(context, Strings.errorEnterField);
    }

    if (index >= 3) {
      _groupNumberError = _groupNumberController.text
          .toString()
          .isBlank(context, Strings.errorEnterField);
    }

    if (index >= 4) {
      _healthPlanError = _healthPlanController.text
          .toString()
          .isBlank(context, Strings.errorEnterField);
    }

    if (index >= 5) {
      _effectiveDateError = _effectiveDateController.text
          .toString()
          .isBlank(context, Strings.errorEnterField);
    }

    setState(() {});
  }
}
