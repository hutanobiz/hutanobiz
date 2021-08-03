import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/medical_history/model/req_medication_detail.dart';
import 'package:hutano/screens/medical_history/model/res_get_medication_detail.dart';
import 'package:hutano/screens/medical_history/model/res_medication_detail.dart';

import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../apis/appoinment_service.dart';
import '../../utils/color_utils.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/localization/localization.dart';
import '../../utils/preference_key.dart';
import '../../utils/preference_utils.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/hutano_button.dart';
import 'model/medicine_time_model.dart';
import 'model/req_create_appoinmet.dart';
import 'model/res_medicine.dart';
import 'provider/appoinment_provider.dart';

class MedicineInformation extends StatefulWidget {
  @override
  _MedicineInformationState createState() => _MedicineInformationState();
}

class _MedicineInformationState extends State<MedicineInformation> {
  int _currentStepIndex = 1;
  String _medicineDose;
  String _medicineDoseTime;
  final _searchController = TextEditingController();
  List<Medicine> medicines = [];
  List<String> selectedMedicines = [];
  List<String> selectedMedicinDose = [];
  List<String> selectedMedcineTime = [];
  List<MedicineTimeModel> _medicineTimeList = [];
  Medicine _selectedMedicine;
  bool isTookMedication = false;
  final _searchFocusNode = FocusNode();
  List<Medications> _getMedicineList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _getMedicationDetail(context, false);
      _medicineTimeList.add(MedicineTimeModel(
          Localization.of(context).onceADayDoseTime, false, 1));
      _medicineTimeList.add(MedicineTimeModel(
          Localization.of(context).threeTimeADayDoseTime, false, 2));
      _medicineTimeList.add(MedicineTimeModel(
          Localization.of(context).fourTimesADayDoseTime, false, 3));
      _medicineTimeList.add(MedicineTimeModel(
          Localization.of(context).asNeededDoseTime, false, 4));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void createAppoinment() {
    var medicalHisory =
        Provider.of<SymptomsInfoProvider>(context, listen: false)
            .diseases
            .map((e) => e.disease)
            .toList();
    var doctorid =
        Provider.of<SymptomsInfoProvider>(context, listen: false).doctorId;
    var userId =
        Provider.of<SymptomsInfoProvider>(context, listen: false).userId;
    var symtomsType =
        Provider.of<SymptomsInfoProvider>(context, listen: false).symtomsType;

    var firestTimeIssue =
        Provider.of<SymptomsInfoProvider>(context, listen: false)
            .firestTimeIssue;
    var hospitalizedBefore =
        Provider.of<SymptomsInfoProvider>(context, listen: false)
            .hospitalizedBefore;
    var hositalizedTime =
        Provider.of<SymptomsInfoProvider>(context, listen: false)
            .hositalizedTime;
    var hositalizedTimeNumber =
        Provider.of<SymptomsInfoProvider>(context, listen: false)
            .hositalizedTimeNumber;
    var diagnosticTest =
        Provider.of<SymptomsInfoProvider>(context, listen: false)
            .diagnosticTest;
    var diagnosticTests =
        Provider.of<SymptomsInfoProvider>(context, listen: false)
            .diagnosticTests;
    final bodySide =
        Provider.of<SymptomsInfoProvider>(context, listen: false).getBodySide();
    final bodyType =
        Provider.of<SymptomsInfoProvider>(context, listen: false).bodyType;
    List questions = <String>[];
    List answers = <String>[];
    questions.add("is this your first time seeking care for this issue?");
    answers.add(firestTimeIssue == true ? 'yes' : 'no');
    questions.add("Have you beed hospitalized for this condition?");
    answers.add(hospitalizedBefore == true ? 'yes' : 'no');
    if (hositalizedTime != null) {
      questions.add("How long ago?");
      answers.add("$hositalizedTimeNumber $hositalizedTime");
    }
    questions.add(
        "Have you have any diagnostic tests performed for this condition?");
    answers.add(diagnosticTest == true ? "yes" : 'no');
    if (diagnosticTest == true) {
      var ans = "";
      diagnosticTests.forEach((element) {
        ans = "$ans$element,";
      });
      questions.add("Types of diagnostic tests");
      answers.add("$hositalizedTimeNumber $hositalizedTime");
    }

    if (symtomsType == 0) {
      var bodypart =
          Provider.of<SymptomsInfoProvider>(context, listen: false).bodypart;
      var bodyPartPain =
          Provider.of<SymptomsInfoProvider>(context, listen: false)
              .bodyPartPain;
      var timeForpain =
          Provider.of<SymptomsInfoProvider>(context, listen: false).timeForpain;
      var timeForpainNumber =
          Provider.of<SymptomsInfoProvider>(context, listen: false)
              .timeForpainNumber;
      var painIntensity =
          Provider.of<SymptomsInfoProvider>(context, listen: false)
              .painIntensity;
      var painCondition =
          Provider.of<SymptomsInfoProvider>(context, listen: false)
              .painCondition;

      questions.add("where is your pain ?");
      answers.add(bodypart);
      questions.add("describe the pain");
      answers.add(bodyPartPain);
      questions.add("how long?");
      answers.add("$timeForpainNumber $timeForpain");
      questions.add("I would rate the intensity as");
      answers.add("$painIntensity");
      questions.add("pain is");
      answers.add("$painCondition");
      var req = ReqAppointment(
          doctorId: doctorid,
          userId: getString(PreferenceKey.id),
          medicalHistory: medicalHisory,
          bodySide: bodySide,
          bodyType: bodyType,
          questions: questions,
          answers: answers,
          drugnames: selectedMedicines,
          dosage: selectedMedicinDose,
          dosageTime: selectedMedcineTime);
      callCreateAppoinment(req);
    } else {
      var bodypart =
          Provider.of<SymptomsInfoProvider>(context, listen: false).bodypart;
      var bodyPartPain =
          Provider.of<SymptomsInfoProvider>(context, listen: false)
              .bodyPartPain;
      questions.add("where are your symptoms?");
      questions.add("describe symptoms");
      answers.add(bodypart);
      answers.add(bodyPartPain);
      var req = ReqAppointment(
          doctorId: doctorid,
          userId: getString(PreferenceKey.id),
          bodySide: bodySide,
          bodyType: bodyType,
          questions: questions,
          answers: answers,
          drugnames: selectedMedicines,
          dosage: selectedMedicinDose,
          dosageTime: selectedMedcineTime,
          medicalHistory: medicalHisory);
      callCreateAppoinment(req);
    }
  }

  void callCreateAppoinment(ReqAppointment req) {
    ProgressDialogUtils.showProgressDialog(context);
    AppoinmentService().createAppounment(req).then((value) {
      ProgressDialogUtils.dismissProgressDialog();
      Provider.of<SymptomsInfoProvider>(context, listen: false)
          .setAppoinmentId(value.id);
      DialogUtils.showOkCancelAlertDialog(
        context: context,
        okButtonTitle: Localization.of(context).ok,
        message: "appointment created",
        isCancelEnable: false,
        okButtonAction: () {
          Navigator.of(context).pushNamed(Routes.routeAddPharmacy);
        },
      );
    }, onError: (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(
          context, "failed to create appoinment Please try again");
    });
  }

  void searchMedicine(String value) {
    ApiManager().searchMedicine(value).then((value) {
      setState(() {
        medicines = value.response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        padding: EdgeInsets.only(bottom: spacing20),
        addBottomArrows: true,
        onForwardTap: () {
          if (_currentStepIndex == 2) {
            if (_getMedicineList.isEmpty) {
              Widgets.showToast(Localization.of(context).addMedicationMsg);
            } else {
              List<String> _medicationList = [];
              _getMedicineList.forEach((element) {
                if (element.isSelected) {
                  _medicationList.add(element.sId);
                }
              });
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updateMedicationData(_medicationList);
              Navigator.of(context).pushNamed(Routes.routeAddPharmacy);
            }
          } else {
            if (_currentStepIndex == 1 && isTookMedication) {
              setState(() {
                _currentStepIndex = 2;
              });
            } else {
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .updateMedicationData([]);
              Navigator.of(context).pushNamed(Routes.routeAddPharmacy);
            }
          }
        },
        child: Column(
          children: [
            Expanded(
              child: _buildMedicationSteps(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationSteps(BuildContext context) => SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: spacing15, vertical: spacing15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentStepIndex > 0) _askAndSearchMedicationWidget(context),
            if (_currentStepIndex > 1 && isTookMedication)
              _medicationDetailWidget(),
            Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom != 0.0,
              child: _searchMedicineList(),
            ),
            Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
              child: _buildMedicineList(),
            ),
          ],
        ),
      );

  Widget _searchMedicineList() => ListView.separated(
      padding: EdgeInsets.only(bottom: spacing15),
      separatorBuilder: (context, index) {
        return SizedBox();
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        return StatefulBuilder(
            builder: (context, _setState) => CheckboxListTile(
                activeColor: colorYellow,
                contentPadding: EdgeInsets.all(0),
                title: Container(
                    child: Row(children: [
                  Expanded(
                    child: Text(
                      medicines[index].name ?? '',
                      style: const TextStyle(
                          color: colorBlack2,
                          fontSize: fontSize14,
                          fontWeight: fontWeightMedium),
                    ),
                  )
                ])),
                value: true,
                onChanged: (val) {
                  setState(() {
                    _selectedMedicine = medicines[index];
                    _searchController.text = _selectedMedicine.name;
                    _searchFocusNode.unfocus();
                  });
                }));
      });

  Widget _askAndSearchMedicationWidget(BuildContext context) => Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _takeAnyMedicines(context),
              SizedBox(height: spacing10),
              Row(children: [
                _yesButtonWidget(context),
                SizedBox(width: spacing15),
                _noButtonWidget(context),
              ]),
              SizedBox(height: spacing15),
              if (_currentStepIndex > 1 && isTookMedication)
                _searchAndMedicationWidget(context)
            ],
          ),
        ],
      );

  Widget _takeAnyMedicines(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing5, horizontal: spacing5),
        child: Text(
          Localization.of(context).doYouTakeMedication,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _yesButtonWidget(BuildContext context) => HutanoButton(
        label: Localization.of(context).yes,
        onPressed: () {
          setState(() {
            isTookMedication = true;
            _currentStepIndex = 2;
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: isTookMedication ? colorWhite : colorPurple100,
        color: isTookMedication ? colorPurple100 : colorWhite,
        height: 34,
      );

  Widget _noButtonWidget(BuildContext context) => HutanoButton(
        borderColor: colorGrey,
        label: Localization.of(context).no,
        onPressed: () {
          setState(() {
            isTookMedication = false;
            _currentStepIndex = 1;
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: !isTookMedication ? colorWhite : colorPurple100,
        color: !isTookMedication ? colorPurple100 : colorWhite,
        borderWidth: 1,
        height: 34,
      );

  Widget _searchAndMedicationWidget(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing15),
        child: Text(
          Localization.of(context).searchAndAddMedication,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _medicationDetailWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchWidget(),
          if (_selectedMedicine != null) _doseOfMedicineHeader(context),
          if (_selectedMedicine != null) _medicineDoseAndDosTime(context),
        ],
      );

  Widget _doseOfMedicineHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: spacing8, vertical: spacing15),
        child: Text(Localization.of(context).doseOfMedicine,
            style: TextStyle(
                color: colorBlack2,
                fontWeight: fontWeightMedium,
                fontSize: fontSize14)),
      );

  Widget _buildSearchWidget() => Container(
        margin: EdgeInsets.only(top: spacing10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  searchMedicine(value);
                },
                style: TextStyle(
                    color: colorBlack2,
                    fontSize: fontSize13,
                    fontWeight: fontWeightRegular),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5, left: 10),
                    border: InputBorder.none,
                    hintText: "Search Medicine",
                    hintStyle: TextStyle(color: colorGrey2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(spacing8),
              child: Icon(
                Icons.search,
                size: 25,
                color: colorBlack2,
              ),
            )
          ],
        ),
        height: 42,
        decoration: BoxDecoration(
            color: colorGreyBackground, borderRadius: BorderRadius.circular(8)),
      );

  Widget _medicineDoseAndDosTime(BuildContext context) {
    var doselist = <Widget>[];
    for (var d in _selectedMedicine?.dose ?? []) {
      doselist.add(_doseButtons(d));
    }
    return Column(
      children: [
        Row(children: doselist),
        if (_medicineDose != null && _medicineDose != null)
          SizedBox(width: spacing15),
        if (_medicineDose != null && _medicineDose != null)
          _frequencyOfDoseHeader(context),
        if (_medicineDose != null && _medicineDose != null)
          SizedBox(width: spacing15),
        if (_medicineDose != null && _medicineDose != null)
          _doseTimeList(context)
      ],
    );
  }

  Widget _doseButtons(String title) => Padding(
        padding: const EdgeInsets.only(left: spacing10),
        child: _doseWiseCommonButton(title, _medicineDose, () {
          setState(() {
            _medicineDose = title;
            _medicineDoseTime = null;
          });
        }),
      );

  Widget _doseWiseCommonButton(
          String title, String selectedTitle, Function onTap) =>
      HutanoButton(
        label: title,
        onPressed: onTap,
        buttonType: HutanoButtonType.onlyLabel,
        width: 80,
        labelColor: selectedTitle == title
            ? colorActiveBodyPart
            : colorInactiveBodyPart,
        color: selectedTitle == title ? colorPurple100 : colorGreyBackground,
        height: 34,
      );

  Widget _frequencyOfDoseHeader(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: spacing8, vertical: spacing25),
          child: Text(
            Localization.of(context).frequencyOfDosage,
            style: TextStyle(
                fontSize: fontSize14,
                fontWeight: fontWeightMedium,
                color: colorBlack2),
          ),
        ),
      );

  Widget _doseTimeList(BuildContext context) => Container(
        height: 200,
        padding: EdgeInsets.symmetric(horizontal: spacing10),
        child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _medicineTimeList.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: spacing15);
            },
            itemBuilder: (context, index) {
              int radioVal;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _medicineTimeList[index].timeLabel,
                    style: TextStyle(
                        fontWeight: fontWeightSemiBold,
                        fontSize: fontSize14,
                        color: colorBlack2),
                  ),
                  Radio(
                      activeColor: AppColors.persian_blue,
                      groupValue: radioVal,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: _medicineTimeList[index].index,
                      onChanged: (val) {
                        setState(() {
                          radioVal = _medicineTimeList[index].index;
                          _medicineDoseTime =
                              _medicineTimeList[index].timeLabel;
                        });
                        selectedMedicines.add(_selectedMedicine.name);
                        selectedMedicinDose.add(_medicineDose);
                        selectedMedcineTime.add(_medicineDoseTime);
                        final reqModel = ReqMedicationDetail(
                            dose: _medicineDose,
                            name: _selectedMedicine.name,
                            frequency: _medicineDoseTime,
                            prescriptionId: _selectedMedicine.sId);
                        _addMedicationDetailData(context, reqModel);
                      }),
                ],
              );
            }),
      );

  Widget _buildMedicineList() => ListView.separated(
      padding: EdgeInsets.symmetric(vertical: spacing15),
      separatorBuilder: (context, index) {
        return SizedBox(height: spacing15);
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _getMedicineList.length,
      itemBuilder: (context, index) {
        return ListTile(
          dense: true,
          title: Text(
            "${_getMedicineList[index].name} ${_getMedicineList[index].dose} ${_getMedicineList[index].frequency}",
            style: TextStyle(
                fontWeight: fontWeightMedium,
                fontSize: fontSize14,
                color: colorBlack2),
          ),
          trailing: _currentStepIndex == 2
              ? _getMedicineList[index].isSelected
                  ? Image.asset("images/checkedCheck.png",
                      height: 24, width: 24)
                  : Image.asset("images/uncheckedCheck.png",
                      height: 24, width: 24)
              : SizedBox(),
          leading: Container(
            height: 20,
            width: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.windsor,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                  fontSize: fontSize10,
                  color: Colors.white,
                  fontWeight: fontWeightSemiBold),
            ),
          ),
          onTap: () {
            setState(() => _getMedicineList[index].isSelected =
                !_getMedicineList[index].isSelected);
          },
        );
      });

  void _addMedicationDetailData(
      BuildContext context, ReqMedicationDetail reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().addMedicationDetail(reqModel).then(((result) {
      if (result is ResMedicationDetail) {
        ProgressDialogUtils.dismissProgressDialog();
        _searchFocusNode.unfocus();
        _searchController.clear();
        setState(() {
          _selectedMedicine = null;
          _medicineDose = null;
          _medicineDoseTime = null;
        });
        _getMedicationDetail(context, true);
      }
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }

  void _getMedicationDetail(
      BuildContext context, bool isFromAddMedicine) async {
    if (!isFromAddMedicine) ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().getMedicationDetails().then((result) {
      if (result is ResGetMedicationDetail) {
        result.response.toString().debugLog();
        setState(() {
          _getMedicineList = result.response.medications;
          _getMedicineList.forEach((element) {
            element.isSelected = false;
          });
        });
        if (!isFromAddMedicine) ProgressDialogUtils.dismissProgressDialog();
      }
    }).catchError((dynamic e) {
      if (!isFromAddMedicine) ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
