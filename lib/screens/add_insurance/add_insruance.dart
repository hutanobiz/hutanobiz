import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/apis/api_constants.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
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
  InsuranceType? insuranceType;
  final bool? isFromSetting;

  AddInsurance(
      {Key? key,
      this.insuranceType = InsuranceType.primary,
      this.isFromSetting = false})
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

  String? _insuranceCompanyError;
  String? _insuranceMemberError;
  String? _memberIdError;
  String? _groupNumberError;
  String? _healthPlanError;
  String? _effectiveDateError;

  final _companyController = TextEditingController();
  final _memberController = TextEditingController();
  final _groupNumberController = TextEditingController();
  final _healthPlanController = TextEditingController();
  final _memberIdController = TextEditingController();
  final _effectiveDateController = TextEditingController();

  final _addInsuranceModel = ReqAddInsurance();

  File? _backImage;
  File? _frontImage;

  final labelStyle = TextStyle(fontSize: fontSize14, color: colorGrey60);

  void _onDateSelected(String date) {
    print(date);
    _effectiveDateController.text = date;
    _addInsuranceModel.effectiveDate = date;
    showError(AddInsuranceError.effectiveDate.index);
  }

  _onInsuranceSelected(String title, String id) {
    FocusManager.instance.primaryFocus!.unfocus();
    _companyController.text = title;
    _addInsuranceModel.insuranceCompany = id;
    showError(AddInsuranceError.insuranceCompany.index);
  }

  List<Insurance>? _insuranceList = [];
  List<Insurance>? myInsuranceList = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getInsuranceList();
      _getMyInsurance();
    });
  }

  _getInsuranceList() async {
    try {
      var res = await ApiManager().insuraceList();
      setState(() {
        _insuranceList = res.response;
        if (myInsuranceList!.isNotEmpty && _insuranceList!.isNotEmpty) {
          _insuranceList!.removeWhere((element) {
            return myInsuranceList!.any((item) => item.title == element.title);
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  _getMyInsurance() {
    ProgressDialogUtils.showProgressDialog(context);
    ApiManager().getPatientInsurance().then((value) {
      if (value.status == success) {
        ProgressDialogUtils.dismissProgressDialog();

        setState(() {
          myInsuranceList = value.response;
          if (myInsuranceList!.isNotEmpty &&
              myInsuranceList![0].sId != null &&
              widget.insuranceType == InsuranceType.primary) {
            Navigator.pushReplacementNamed(
                context, Routes.addInsuranceComplete);
          } else {
            if (myInsuranceList!.isNotEmpty && _insuranceList!.isNotEmpty) {
              _insuranceList!.removeWhere((element) {
                return myInsuranceList!
                    .any((item) => item.title == element.title);
              });
            }
          }
        });
      }
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        if (e.response != null) {
          ProgressDialogUtils.dismissProgressDialog();
          DialogUtils.showAlertDialog(context, e.response!);
        }
      }
    });
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
          .addInsuranceDoc(_frontImage!, _addInsuranceModel,
              backImage: _backImage)
          .then((value) {
        _frontImage = null;
        _backImage = null;
        _companyController.text = '';
        _memberController.text = '';
        _groupNumberController.text = '';
        _healthPlanController.text = '';
        _memberIdController.text = '';
        _effectiveDateController.text = '';
        widget.insuranceType = InsuranceType.secondary;

        ProgressDialogUtils.dismissProgressDialog();
        if (widget.isFromSetting!) {
          Navigator.pop(context);
        } else {
          Navigator.pushNamed(context, Routes.addInsuranceComplete);
        }
      }, onError: (e) {
        setState(() {
          showSecondaryInsurance = true;
        });

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
                    title: Localization.of(context)!.welcome,
                    subTitle: (widget.insuranceType == InsuranceType.primary)
                        ? Localization.of(context)!.addInsurance
                        : Localization.of(context)!.addSecondaryInsurance,
                    subTitleFontSize: fontSize15,
                  ),
                  SizedBox(
                    height: spacing40,
                  ),
                  TextWithImage(
                      size: spacing30,
                      textStyle: TextStyle(fontSize: fontSize16),
                      label: Localization.of(context)!.labelHealthInsurance,
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
                      Localization.of(context)!.uploadInsuranceCardImage,
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
                        Navigator.of(context)
                            .pushNamed(Routes.addInsurance, arguments: {
                          ArgumentConstant.argsinsuranceType:
                              InsuranceType.secondary,
                          ArgumentConstant.isFromSetting: widget.isFromSetting
                        });
                      },
                      child: Text(
                          Localization.of(context)!
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
            ? Localization.of(context)!.addInsurance
            : Localization.of(context)!.addSecondaryInsurance,
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
              label: Localization.of(context)!.skipTasks,
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
                          .pushNamed(Routes.addInsuranceComplete)
                      : Navigator.of(context).pushNamed(Routes.welcome);
                },
              )
            ],
          ],
        ),
      );

  _skipTaskNow() {
    Navigator.of(context).pushNamed(Routes.welcome);
    setBool(PreferenceKey.skipStep, true);
  }

  Widget _getInsuredMember() {
    return HutanoTextField(
        onValueChanged: (value) {
          _addInsuranceModel.insuranceMember = value;
          setState(() {
            _insuranceMemberError = value
                .toString()
                .isBlank(context, Localization.of(context)!.errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _insuranceMemberError,
        focusNode: _insuranceMember,
        controller: _memberController,
        labelText: Localization.of(context)!.insuranceMemberName,
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
                .isBlank(context, Localization.of(context)!.errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _memberIdError,
        focusNode: _memberId,
        controller: _memberIdController,
        labelText: Localization.of(context)!.memberId,
        focusedBorderColor: colorBlack20,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_groupNumber);
          showError(AddInsuranceError.memberId.index);
        },
        textInputFormatter: [
          // FilteringTextInputFormatter.digitsOnly,
          // CustomInputFormatter()
        ],
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next);
  }

  Widget _getGroupNumber() {
    return HutanoTextField(
        onValueChanged: (value) {
          _addInsuranceModel.groupNumber = value;
          setState(() {
            _groupNumberError = value
                .toString()
                .isBlank(context, Localization.of(context)!.errorEnterFirstName);
          });
        },
        labelTextStyle: labelStyle,
        errorText: _groupNumberError,
        focusNode: _groupNumber,
        controller: _groupNumberController,
        labelText: Localization.of(context)!.groupNumber,
        focusedBorderColor: colorBlack20,
        onFieldSubmitted: (s) {
          FocusScope.of(context).requestFocus(_healthPlan);
          showError(AddInsuranceError.groupNumber.index);
        },
        textInputFormatter: [
          // FilteringTextInputFormatter.digitsOnly,
          // CustomInputFormatter()
        ],
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.next);
  }

  Widget _getHealthPlan() {
    return HutanoTextField(
        labelTextStyle: labelStyle,
        width: SizeConfig.screenWidth! / 2.4,
        focusedBorderColor: colorBlack20,
        controller: _healthPlanController,
        focusNode: _healthPlan,
        textInputType: TextInputType.text,
        // maxLength: 6,
        onFieldTap: () {
          showError(AddInsuranceError.healthPlan.index);
        },
        onValueChanged: (value) {
          _addInsuranceModel.healthPlan = value;
          setState(() {
            _healthPlanError = value.toString().isBlank(
                context, Localization.of(context)!.errorHealthInsurance);
          });
        },
        errorText: _healthPlanError,
        textInputFormatter: [],
        labelText: Localization.of(context)!.healthPlan,
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
          .isBlank(context, Localization.of(context)!.errorEnterField);
    }
    if (index >= 1) {
      _insuranceMemberError = _memberController.text
          .toString()
          .isBlank(context, Localization.of(context)!.errorEnterField);
    }
    if (index >= 2) {
      _memberIdError = _memberIdController.text
          .toString()
          .isBlank(context, Localization.of(context)!.errorEnterField);
    }

    if (index >= 3) {
      _groupNumberError = _groupNumberController.text
          .toString()
          .isBlank(context, Localization.of(context)!.errorEnterField);
    }

    if (index >= 4) {
      _healthPlanError = _healthPlanController.text
          .toString()
          .isBlank(context, Localization.of(context)!.errorEnterField);
    }

    if (index >= 5) {
      _effectiveDateError = _effectiveDateController.text
          .toString()
          .isBlank(context, Localization.of(context)!.errorEnterField);
    }

    setState(() {});
  }
}
