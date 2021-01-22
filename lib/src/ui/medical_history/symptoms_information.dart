import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/constants/key_constant.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../widgets/ht_progressbar.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_checkbox.dart';
import 'provider/appoinment_provider.dart';

class SymptomsInformation extends StatefulWidget {
  final int selectedSymtomsType;

  const SymptomsInformation({@required this.selectedSymtomsType});
  @override
  _SymptomsInformationState createState() => _SymptomsInformationState();
}

class _SymptomsInformationState extends State<SymptomsInformation> {
  int _currentStepIndex = 1;
  String _isFirstTimeIssue;
  String _isHospitalized;
  String _isDiagnostic;
  final _selectedDiagnosticTests = <String>[];
  final _yearfocusnode = FocusNode();

  String _selectedPainTime;
  int _selectedPainTimeNumber;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: spacing10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing10),
              child: HTProgressBar(totalSteps: 5, currentSteps: 3),
            ),
            SizedBox(height: spacing10),
            _buildHeader(),
            _buildSteps(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSteps() => Expanded(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding:
              EdgeInsets.symmetric(horizontal: spacing15, vertical: spacing15),
          child: Column(
            children: [
              if (_currentStepIndex > 0) _buildStepOne(),
              SizedBox(height: spacing15),
              if (_currentStepIndex > 1) _buildStepTwo(),
              SizedBox(height: spacing15),
              if (_currentStepIndex > 2 && _isHospitalized == "yes") ...[
                _buildStepThree(),
                SizedBox(height: spacing15),
              ],
              if (_currentStepIndex > 3) _buildStepFour(),
              SizedBox(height: spacing15),
              if (_currentStepIndex > 4) _buildStepFive(),
            ],
          ),
        ),
      );

  Widget _buildStepOne() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HutanoCheckBox(
              isChecked: _isFirstTimeIssue != null, onValueChange: null),
          SizedBox(width: spacing15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing5),
                  child: Text(
                    "Is this your first time seeking care for this issue?",
                    style: TextStyle(
                        fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                  ),
                ),
                _buildFirstTimeIssueButton("yes"),
                _buildFirstTimeIssueButton("no"),
              ],
            ),
          ),
        ],
      );

  Widget _buildFirstTimeIssueButton(String title) =>
      _buildButton(title, _isFirstTimeIssue, () {
        setState(() {
          _isFirstTimeIssue = title;
        });
        if (_currentStepIndex <= 1) {
          setState(() {
            _currentStepIndex++;
          });
        }
      }, _currentStepIndex <= 1);

  Widget _buildStepTwo() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HutanoCheckBox(
              isChecked: _isHospitalized != null, onValueChange: null),
          SizedBox(width: spacing15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing5),
                  child: Text(
                    "Have you been hospitalized for this condition?",
                    style: TextStyle(
                        fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                  ),
                ),
                _buildIsHopitalizedButton("yes"),
                _buildIsHopitalizedButton("no"),
              ],
            ),
          ),
        ],
      );

  Widget _buildIsHopitalizedButton(String title) =>
      _buildButton(title, _isHospitalized, () {
        setState(() {
          _isHospitalized = title;
        });

        if (_currentStepIndex <= 2) {
          if (_isHospitalized == "yes") {
            setState(() {
              _currentStepIndex++;
            });
          } else {
            setState(() {
              _currentStepIndex += 2;
            });
          }
        }
      }, _currentStepIndex <= 2);

  Widget _buildStepThree() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HutanoCheckBox(
              isChecked: (_selectedPainTime != null &&
                  _selectedPainTimeNumber != null),
              onValueChange: null),
          SizedBox(width: spacing15),
          SizedBox(
            width: screenSize.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing5),
                  child: Text(
                    "How long ago?",
                    style: TextStyle(
                        fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                  ),
                ),
                _buildTimeButton("hours", 1),
                _buildTimeButton("days", 2),
                _buildTimeButton("weeks", 3),
                _buildTimeButton("months", 4),
                _buildTimeButton("years", 5),
              ],
            ),
          ),
        ],
      );

  Widget _buildTimeButton(String title, int type) {
    var buttons = <Widget>[];
    switch (type) {
      case 1:
        for (var i = 1; i <= 23; i++) {
          buttons.add(_buildSqareButton(i));
        }
        break;
      case 2:
        for (var i = 1; i <= 6; i++) {
          buttons.add(_buildSqareButton(i));
        }
        break;
      case 3:
        for (var i = 1; i <= 3; i++) {
          buttons.add(_buildSqareButton(i));
        }
        break;
      case 4:
        for (var i = 1; i <= 11; i++) {
          buttons.add(_buildSqareButton(i));
        }
        break;
      case 5:
        buttons.add(KeyboardActions(
          autoScroll: false,
          config: KeyboardActionsConfig(actions: [
            KeyboardActionsItem(
                focusNode: _yearfocusnode,
                displayDoneButton: true,
                displayArrows: false),
          ]),
          child: TextField(
            focusNode: _yearfocusnode,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: fontSize12),
            decoration: InputDecoration(
              hintText: "Enter year",
            ),
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  _selectedPainTimeNumber = int.parse(value);
                } else {
                  _selectedPainTimeNumber = null;
                }
              });
            },
          ),
        ));
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildButton(
          title,
          _selectedPainTime,
          () {
            setState(() {
              _selectedPainTimeNumber = null;
              _selectedPainTime = title;
            });
          },
          _currentStepIndex <= 3,
        ),
        if (_selectedPainTime == title)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: spacing5),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: buttons,
            ),
          ),
      ],
    );
  }

  Widget _buildSqareButton(int title) => InkWell(
        onTap: () {
          setState(() {
            _selectedPainTimeNumber = title;
          });
          if (_currentStepIndex <= 3) {
            setState(() {
              _currentStepIndex++;
            });
          }
        },
        child: Container(
          margin: EdgeInsets.only(right: spacing2, top: spacing2),
          padding: EdgeInsets.symmetric(horizontal: spacing5),
          child: Text(
            title.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: fontWeightMedium,
                fontSize: fontSize16),
          ),
          height: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: colorDarkgrey2, width: 1),
              color: _selectedPainTimeNumber == title
                  ? colorDarkgrey2
                  : colorGrey3),
        ),
      );

  Widget _buildStepFour() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HutanoCheckBox(isChecked: _isDiagnostic != null, onValueChange: null),
          SizedBox(width: spacing15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing5),
                  child: Text(
                    "Have you have any diagnostic tests performed for this condition?",
                    style: TextStyle(
                        fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                  ),
                ),
                _buildIsDiagnosticButton("yes"),
                _buildIsDiagnosticButton("no"),
              ],
            ),
          ),
        ],
      );

  Widget _buildIsDiagnosticButton(String title) =>
      _buildButton(title, _isDiagnostic, () {
        setState(() {
          _isDiagnostic = title;
        });

        if (_currentStepIndex <= 4) {
          if (_isDiagnostic == "yes") {
            setState(() {
              _currentStepIndex++;
            });
            Future.delayed(Duration(milliseconds: 250), () {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            });
          } else {
            Provider.of<SymptomsInfoProvider>(context, listen: false)
                .setGeneralPainInfo(
                    firestTimeIssue: _isFirstTimeIssue == "yes",
                    hospitalizedBefore: _isHospitalized == "yes",
                    hositalizedTime: _selectedPainTime,
                    hositalizedTimeNumber: _selectedPainTimeNumber,
                    diagnosticTest: _isDiagnostic == "yes",
                    diagnosticTests: _selectedDiagnosticTests);
            Navigator.of(context).pushNamed( routeMedicineInformation, arguments: {
              ArgumentConstant.argSeletedSymptomsType:
                  widget.selectedSymtomsType
            });
          }
        }
      }, _currentStepIndex <= 4);

  Widget _buildStepFive() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HutanoCheckBox(
              isChecked: _selectedDiagnosticTests.isNotEmpty,
              onValueChange: null),
          SizedBox(width: spacing15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing5),
                  child: Text(
                    "Types of diagnostic tests",
                    style: TextStyle(
                        fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                  ),
                ),
                _buildDiagnosticTestButton("Labs"),
                _buildDiagnosticTestButton("X-Ray"),
                _buildDiagnosticTestButton("MRI"),
                _buildDiagnosticTestButton("Cat Scan"),
                _buildDiagnosticTestButton("Bone Scan"),
                _buildDiagnosticTestButton("EKG"),
              ],
            ),
          ),
        ],
      );

  Widget _buildDiagnosticTestButton(String title) {
    var isSelected = _selectedDiagnosticTests.contains(title);
    return InkWell(
      onTap: () {
        if (!isSelected) {
          _selectedDiagnosticTests.add(title);
        } else {
          _selectedDiagnosticTests.removeWhere((element) => element == title);
        }
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(top: spacing2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: fontWeightMedium,
                    fontSize: fontSize10),
              ),
            ),
            Image.asset(
              isSelected
                  ? FileConstants.icCheck
                  : FileConstants.icUncheckSquare,
              height: 13,
              width: 13,
            ),
          ],
        ),
        alignment: Alignment.center,
        height: 18,
        width: 100,
        decoration: BoxDecoration(
            border: Border.all(color: colorDarkgrey2, width: 1),
            color: _selectedDiagnosticTests.contains(title)
                ? colorDarkgrey2
                : colorGrey3),
      ),
    );
  }

  Widget _buildButton(
          String title, String selectedTitle, Function onTap, bool enabled) =>
      InkWell(
        onTap: enabled ? onTap : () {},
        child: Container(
          margin: EdgeInsets.only(top: spacing2),
          child: Text(
            title.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontWeight: fontWeightMedium,
                fontSize: fontSize10),
          ),
          alignment: Alignment.center,
          height: 18,
          width: 100,
          decoration: BoxDecoration(
              border: Border.all(color: colorDarkgrey2, width: 1),
              color: selectedTitle == title ? colorDarkgrey2 : colorGrey3),
        ),
      );

  Widget _buildBottomButtons() => Padding(
        padding: EdgeInsets.all(spacing20),
        child: Row(
          children: [
            Expanded(
              child: HutanoButton(
                label: Localization.of(context).skip,
                color: primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed( routeUploadSymptomsImages);
                },
              ),
            ),
            SizedBox(width: spacing70),
            Expanded(
              child: HutanoButton(
                label: Localization.of(context).next,
                onPressed: () {
                  switch (_currentStepIndex) {
                    case 1:
                      if (_isFirstTimeIssue != null) {
                        setState(() {
                          _currentStepIndex++;
                        });
                      } else {
                        DialogUtils.showAlertDialog(
                            context, "please answer the current question");
                      }
                      break;
                    case 2:
                      if (_isHospitalized != null) {
                        if (_isHospitalized == "yes") {
                          setState(() {
                            _currentStepIndex++;
                          });
                        } else {
                          setState(() {
                            _currentStepIndex += 2;
                          });
                        }
                      } else {
                        DialogUtils.showAlertDialog(
                            context, "please answer the current question");
                      }
                      break;
                    case 3:
                      if (_selectedPainTime != null &&
                          _selectedPainTimeNumber != null) {
                        setState(() {
                          _currentStepIndex++;
                        });
                      } else {
                        DialogUtils.showAlertDialog(
                            context, "please answer the current question");
                      }
                      break;
                    case 4:
                      if (_isDiagnostic != null) {
                        if (_isDiagnostic == "yes") {
                          setState(() {
                            _currentStepIndex++;
                          });
                        } else {
                          Provider.of<SymptomsInfoProvider>(context,
                                  listen: false)
                              .setGeneralPainInfo(
                                  firestTimeIssue: _isFirstTimeIssue == "yes",
                                  hospitalizedBefore: _isHospitalized == "yes",
                                  hositalizedTime: _selectedPainTime,
                                  hositalizedTimeNumber:
                                      _selectedPainTimeNumber,
                                  diagnosticTest: _isDiagnostic == "yes",
                                  diagnosticTests: _selectedDiagnosticTests);
                          Navigator.of(context).pushNamed( routeMedicineInformation, arguments: {
                            ArgumentConstant.argSeletedSymptomsType:
                                widget.selectedSymtomsType
                          });
                        }
                      } else {
                        DialogUtils.showAlertDialog(
                            context, "please answer the current question");
                      }
                      break;
                    case 5:
                      if (_selectedDiagnosticTests.isNotEmpty) {
                        Provider.of<SymptomsInfoProvider>(context,
                                listen: false)
                            .setGeneralPainInfo(
                                firestTimeIssue: _isFirstTimeIssue == "yes",
                                hospitalizedBefore: _isHospitalized == "yes",
                                hositalizedTime: _selectedPainTime,
                                hositalizedTimeNumber: _selectedPainTimeNumber,
                                diagnosticTest: _isDiagnostic == "yes",
                                diagnosticTests: _selectedDiagnosticTests);
                        Navigator.of(context).pushNamed( routeMedicineInformation,
                            arguments: {
                              ArgumentConstant.argSeletedSymptomsType:
                                  widget.selectedSymtomsType
                            });
                      } else {
                        DialogUtils.showAlertDialog(
                            context, "please select atleast one test");
                      }
                      break;
                    default:
                      break;
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
                  decoration: widget.selectedSymtomsType == index
                      ? TextDecoration.underline
                      : TextDecoration.none),
            )
          ],
        ),
      );
}
