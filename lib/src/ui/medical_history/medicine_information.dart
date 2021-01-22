import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';
import '../../apis/appoinment_service.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../utils/preference_key.dart';
import '../../utils/preference_utils.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/ht_progressbar.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_checkbox.dart';
import 'model/req_create_appoinmet.dart';
import 'model/res_medicine.dart';
import 'provider/appoinment_provider.dart';

class MedicineInformation extends StatefulWidget {
  @override
  _MedicineInformationState createState() => _MedicineInformationState();
}

class _MedicineInformationState extends State<MedicineInformation> {
  int _currentStepIndex = 1;
  String _isTakingMedicine;
  String _medicineDose;
  String _medicineDoseTime;
  final _searchController = TextEditingController();
  List<Medicine> medicines = [];

  List<String> selectedMedicines = [];
  List<String> selectedMedicinDose = [];
  List<String> selectedMedcineTime = [];

  Medicine _selectedMedicine;

  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
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
          //TODO : Temp changing route
          Navigator.of(context).pushNamed(Routes.uploadImagesScreen);
          // Navigator.of(context).pushNamed(routeUploadSymptomsImages);
        },
      );
    }, onError: (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(
          context, "failed to create appoinment Please try again");
    });
  }

  void searchMedicine(String value) {
    AppoinmentService().searchMedicine(value).then((value) {
      setState(() {
        medicines = value.medicines;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: spacing10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing10),
              child: HTProgressBar(totalSteps: 5, currentSteps: 2),
            ),
            SizedBox(height: spacing10),
            _buildHeader(),
            Expanded(
              child: _buildSymptomsSteps(),
            ),
            Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
              child: _buildBottomButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSteps() => SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: spacing15, vertical: spacing15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentStepIndex > 0) _buildStepOne(),
            if (_currentStepIndex > 1 && _isTakingMedicine == "yes")
              _buildStepTwo(),
            Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom != 0.0,
              child: _buildsearchMedicineList(),
            ),
            Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
              child: _buildMedicineList(),
            ),
          ],
        ),
      );

  Widget _buildsearchMedicineList() => ListView.separated(
      padding: EdgeInsets.symmetric(vertical: spacing15),
      separatorBuilder: (context, index) {
        return SizedBox(height: spacing15);
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              _selectedMedicine = medicines[index];
              _searchController.text = _selectedMedicine.drugName;
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: accentColor, borderRadius: BorderRadius.circular(5)),
                child: Text(
                  '$index',
                  style: TextStyle(
                      fontSize: fontSize10,
                      color: Colors.white,
                      fontWeight: fontWeightSemiBold),
                ),
              ),
              SizedBox(width: spacing15),
              Expanded(
                child: Text(
                  medicines[index].drugName ?? '',
                  style: TextStyle(
                      fontWeight: fontWeightMedium,
                      fontSize: fontSize14,
                      color: colorDarkPurple),
                ),
              )
            ],
          ),
        );
      });

  Widget _buildStepOne() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HutanoCheckBox(
              isChecked: _isTakingMedicine != null, onValueChange: null),
          SizedBox(width: spacing15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing5),
                  child: Text(
                    "Do you take medications ?",
                    style: TextStyle(
                        fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                  ),
                ),
                _buildIsTakingMedicineButton("yes"),
                _buildIsTakingMedicineButton("no"),
              ],
            ),
          ),
        ],
      );

  Widget _buildIsTakingMedicineButton(String title) =>
      _buildButton(title, _isTakingMedicine, () {
        setState(() {
          _isTakingMedicine = title;
        });
        if (_currentStepIndex == 1 && _isTakingMedicine == 'yes') {
          setState(() {
            _currentStepIndex++;
          });
        }
        if (_isTakingMedicine == 'no') {
          //TODO : TEMP COMMENTING CREATE APPOINTMENT CODE
          // createAppoinment();
          Navigator.of(context).pushNamed(Routes.uploadImagesScreen);
          // Navigator.of(context).pushNamed( routeUploadSymptomsImages);
        }
      });

  Widget _buildStepTwo() => Column(
        children: [
          _buildSearchWidget(),
          _selectedMedicine != null ? _buildMedcineDose() : Container(),
        ],
      );

  Widget _buildSearchWidget() => Container(
        margin: EdgeInsets.only(top: spacing20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: spacing15),
              child: Image.asset(
                FileConstants.icSearch,
                height: 14,
                width: 14,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  searchMedicine(value);
                },
                style: TextStyle(
                    color: colorDarkPurple,
                    fontSize: fontSize14,
                    fontWeight: fontWeightMedium),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5),
                    border: InputBorder.none,
                    hintText: "Search Medicine",
                    hintStyle: TextStyle(color: colorGrey2)),
              ),
            ),
            InkWell(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _selectedMedicine = null;
                  _medicineDose = null;
                  _medicineDoseTime = null;
                });
                return;
                if (_selectedMedicine != null) {
                  if (_medicineDose == null || _medicineDoseTime == null) {
                    DialogUtils.showAlertDialog(
                        context, "please select dose and time");
                  } else {
                    selectedMedicines.add(_selectedMedicine.drugName);
                    selectedMedicinDose.add(_medicineDose);
                    selectedMedcineTime.add(_medicineDoseTime);
                    _searchFocusNode.unfocus();
                    _searchController.clear();
                    setState(() {
                      _selectedMedicine = null;
                      _medicineDose = null;
                      _medicineDoseTime = null;
                    });
                  }
                } else {
                  _searchController.clear();
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: spacing5),
                height: 30,
                width: 30,
                alignment: Alignment.center,
                child: Image.asset(
                  FileConstants.icCloseBlack,
                  height: 18,
                  width: 18,
                ),
              ),
            ),
          ],
        ),
        height: 42,
        decoration: BoxDecoration(
            color: colorGreyBackground, borderRadius: BorderRadius.circular(8)),
      );

  Widget _buildMedcineDose() {
    var doselist = <Widget>[];
    for (var d in _selectedMedicine?.dosage ?? []) {
      doselist.add(_buildDoseButton(d));
    }
    return Padding(
      padding: const EdgeInsets.only(top: spacing30, left: spacing5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dose",
            style:
                TextStyle(fontSize: fontSize14, fontWeight: fontWeightSemiBold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: spacing15),
            child: Column(
              children: doselist,
            ),
          ),
          SizedBox(width: spacing15),
          if (_medicineDose != null && _medicineDose != null)
            Column(
              children: [
                _buildDoseTimeButton("Once a day"),
                _buildDoseTimeButton("Twice a day"),
                _buildDoseTimeButton("three times a day"),
                _buildDoseTimeButton("four times a day"),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDoseButton(String title) =>
      _buildButton(title, _medicineDose, () {
        setState(() {
          _medicineDose = title;
          _medicineDoseTime = null;
        });
      });

  Widget _buildDoseTimeButton(String title) =>
      _buildButton(title, _medicineDoseTime, () {
        setState(() {
          _medicineDoseTime = title;
        });

        selectedMedicines.add(_selectedMedicine.drugName);
        selectedMedicinDose.add(_medicineDose);
        selectedMedcineTime.add(_medicineDoseTime);
        _searchFocusNode.unfocus();
        _searchController.clear();
        setState(() {
          _selectedMedicine = null;
          _medicineDose = null;
          _medicineDoseTime = null;
        });
      });

  Widget _buildMedicineList() => ListView.separated(
      padding: EdgeInsets.symmetric(vertical: spacing15),
      separatorBuilder: (context, index) {
        return SizedBox(height: spacing15);
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: selectedMedicines.length,
      itemBuilder: (context, index) {
        var name = selectedMedicines[index];
        var dose = selectedMedicinDose[index];
        var time = selectedMedcineTime[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: accentColor, borderRadius: BorderRadius.circular(5)),
              child: Text(
                '$index',
                style: TextStyle(
                    fontSize: fontSize10,
                    color: Colors.white,
                    fontWeight: fontWeightSemiBold),
              ),
            ),
            SizedBox(width: spacing15),
            Expanded(
                child: Text(
              "$name $dose $time",
              style: TextStyle(
                  fontWeight: fontWeightMedium,
                  fontSize: fontSize14,
                  color: colorDarkPurple),
            ))
          ],
        );
      });

  Widget _buildButton(String title, String selectedTitle, Function onTap) =>
      InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(top: spacing2),
          child: Text(
            title.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: selectedTitle == title
                    ? colorActiveBodyPart
                    : colorInactiveBodyPart,
                fontWeight: fontWeightMedium,
                fontSize: fontSize10),
          ),
          alignment: Alignment.center,
          height: 18,
          width: 100,
          decoration: BoxDecoration(
              border: Border.all(color: colorDarkgrey2, width: 1),
              color: selectedTitle == title
                  ? colorDarkgrey2
                  : colorGreyBackground),
        ),
      );

  Widget _buildBottomButtons() => Padding(
        padding: EdgeInsets.all(spacing20),
        child: Row(
          children: [
            // Expanded(
            //   child: HutanoButton(
            //     label: Localization.of(context).skip,
            //     color: primaryColor,
            //     onPressed: () {
            //       Navigator.of(context).pushNamed( routeUploadSymptomsImages);
            //     },
            //   ),
            // ),
            // SizedBox(width: spacing70),
            Expanded(
              child: HutanoButton(
                label: Localization.of(context).next,
                onPressed: () {
                  if (_currentStepIndex == 2) {
                    //TODO : TEMP CODE : Redirecting to upload image screen
                    Navigator.of(context).pushNamed(Routes.uploadImagesScreen);
                    //
                    // createAppoinment();
                    // Navigator.of(context).pushNamed( routeUploadSymptomsImages);
                  } else {
                    if (_currentStepIndex == 1 && _isTakingMedicine == 'yes') {
                      setState(() {
                        _currentStepIndex++;
                      });
                    } else {
                      //TODO : TEMP CODE : Redirecting to upload image screen
                      Navigator.of(context)
                          .pushNamed(Routes.uploadImagesScreen);
                          //
                      // createAppoinment();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildHeader() => Container(
        height: 74,
        decoration: BoxDecoration(
            color: colorGreyBackground,
            borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            _buildHeaderButton(0, FileConstants.icCreateFolder,
                Localization.of(context).painSymptoms),
            Container(
              width: 0.5,
              margin: EdgeInsets.symmetric(vertical: 20),
              height: double.maxFinite,
              color: Colors.black,
            ),
            _buildHeaderButton(1, FileConstants.icSadFace,
                Localization.of(context).generalizedSymptoms)
          ],
        ),
      );

  Widget _buildHeaderButton(int index, String iconName, String title) =>
      Expanded(
        child: Row(
          children: [
            SizedBox(width: spacing15),
            Image.asset(
              iconName,
              height: 20,
              width: 20,
            ),
            SizedBox(width: spacing5),
            Text(
              title,
              style: TextStyle(
                  color: index == 0 ? accentColor : colorGreen,
                  fontSize: fontSize12,
                  fontWeight: fontWeightMedium,
                  decoration:
                      Provider.of<SymptomsInfoProvider>(context, listen: false)
                                  .symtomsType ==
                              index
                          ? TextDecoration.underline
                          : TextDecoration.none),
            )
          ],
        ),
      );
}
