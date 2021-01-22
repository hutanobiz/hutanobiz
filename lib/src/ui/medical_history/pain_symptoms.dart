import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../apis/appoinment_service.dart';
import '../../apis/error_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/file_constants.dart';
import '../../utils/constants/key_constant.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/dimens.dart';
import '../../utils/localization/localization.dart';
import '../../utils/navigation.dart';
import '../../utils/progress_dialog.dart';
import '../../widgets/ht_progressbar.dart';
import '../../widgets/hutano_button.dart';
import '../../widgets/hutano_checkbox.dart';
import 'human_body/human_body.dart';
import 'provider/appoinment_provider.dart';

class PainSymptoms extends StatefulWidget {
  final int selectedBodyTypeIndex;
  final String selectedBodyPart;

  const PainSymptoms(
      {@required this.selectedBodyTypeIndex, this.selectedBodyPart});
  @override
  _PainSymptomsState createState() => _PainSymptomsState();
}

class _PainSymptomsState extends State<PainSymptoms> {
  int _currentStepIndex = 1;
  String _selectedBodyPart;
  String _selectedPainDesc;
  String _selectedPainTime;
  int _selectedPainTimeNumber;
  double _painIntensity = 0;
  String _selectedPainCondition;

  GlobalKey silderKey = GlobalKey();
  final _yearfocusnode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, _getSymptoms);
    super.initState();
  }

  void _getSymptoms() {
    final bodySide =
        Provider.of<SymptomsInfoProvider>(context, listen: false).getBodySide();
    final bodyType =
        Provider.of<SymptomsInfoProvider>(context, listen: false).bodyType;

    final request = {'bodySide': bodySide, 'bodyType': bodyType};
    ProgressDialogUtils.showProgressDialog(context);
    AppoinmentService().getSymtoms(request).then((value) {
      ProgressDialogUtils.dismissProgressDialog();
      Provider.of<SymptomsInfoProvider>(context, listen: false)
          .setSymptomsList(value.symptoms);

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _selectedBodyPart = widget.selectedBodyPart;
          _currentStepIndex++;
        });
      });
    }, onError: (e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        DialogUtils.showAlertDialog(context, e.response);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSteps() => SingleChildScrollView(
        controller: _scrollController,
        padding:
            EdgeInsets.symmetric(horizontal: spacing15, vertical: spacing15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      if (_currentStepIndex > 0) _buildStepOne(),
                      SizedBox(height: spacing15),
                      if (_currentStepIndex > 1) _buildStepTwo(),
                      SizedBox(height: spacing15),
                      if (_currentStepIndex > 2) _buildStepThree(),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: HumanBody(
                      initialData:true,
                      bodyImage: Provider.of<SymptomsInfoProvider>(context,
                              listen: false)
                          .bodySide,
                      isClickable: false,
                      bodyPartSelected: (bodyPart) {
                        setState(() {
                          _selectedBodyPart = bodyPart;
                        });

                        if (_currentStepIndex <= 1) {
                          setState(() {
                            _currentStepIndex++;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (_currentStepIndex > 3) _buildStepFour(),
            SizedBox(height: spacing15),
            if (_currentStepIndex > 4) _buildStepFive(),
          ],
        ),
      );

  Widget _buildStepOne() => Row(
        children: [
          HutanoCheckBox(
              isChecked: true, onValueChange: null),
          SizedBox(width: spacing15),
          Expanded(
            child: Text(
              "Where is your pain ?",
              style: TextStyle(
                  fontSize: fontSize10, fontWeight: fontWeightSemiBold),
            ),
          )
        ],
      );

  Widget _buildStepTwo() {
    var list = Provider.of<SymptomsInfoProvider>(context, listen: false)
        .getSymptomsByBodyPart(_selectedBodyPart);
    var symptomslist = <Widget>[];
    for (var symptom in list) {
      symptomslist.add(_buildDescPainButton(symptom));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HutanoCheckBox(
            isChecked: _selectedPainDesc != null, onValueChange: null),
        SizedBox(width: spacing15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing5),
                child: Text(
                  "Describe the pain",
                  style: TextStyle(
                      fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                ),
              ),
              ...symptomslist
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescPainButton(String title) => _buildButton(
        title,
        _selectedPainDesc,
        () {
          _selectedPainDesc = null;
          setState(() {
            _selectedPainDesc = title;
          });
          if (_currentStepIndex <= 2) {
            setState(() {
              _currentStepIndex++;
            });
          }
        },
        _currentStepIndex <= 2,
      );

  Widget _buildStepThree() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HutanoCheckBox(
              isChecked: (_selectedPainTimeNumber != null &&
                  _selectedPainTime != null),
              onValueChange: null),
          SizedBox(width: spacing15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing5),
                  child: Text(
                    "How long?",
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
            Future.delayed(Duration(milliseconds: 250), () {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
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
          HutanoCheckBox(isChecked: true, onValueChange: null),
          SizedBox(width: spacing15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing5),
                  child: Text(
                    "I would rate the intensity as",
                    style: TextStyle(
                        fontSize: fontSize10, fontWeight: fontWeightSemiBold),
                  ),
                ),
                _buildSlider()
              ],
            ),
          ),
        ],
      );

  Widget _buildSlider() => Stack(
        children: [
          Positioned(
            top: 0,
            right: 15,
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: spacing5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: Colors.black,
                  width: 0.2,
                ),
              ),
              child: Text(
                "${_painIntensity ~/ 10}/10",
                style: TextStyle(
                  fontSize: fontSize12,
                  fontWeight: fontWeightMedium,
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 15,
            child: Text(
              "10",
              style: TextStyle(
                fontSize: fontSize12,
                fontWeight: fontWeightMedium,
              ),
            ),
          ),
          Positioned(
            left: 17,
            bottom: 15,
            child: Text(
              "0",
              style: TextStyle(
                fontSize: fontSize12,
                fontWeight: fontWeightMedium,
              ),
            ),
          ),
          Builder(builder: (context) {
            final box =
                silderKey.currentContext?.findRenderObject() as RenderBox;
            final pos = box?.localToGlobal(Offset.zero);
            return Positioned(
              bottom: 0,
              left: (pos?.dx ?? 0) - 42,
              child: Text(
                "${_painIntensity ~/ 10}",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize12,
                  fontWeight: fontWeightMedium,
                ),
              ),
            );
          }),
          FlutterSlider(
            ignoreSteps: [
              FlutterSliderIgnoreSteps(from: 1, to: 9),
              FlutterSliderIgnoreSteps(from: 11, to: 19),
              FlutterSliderIgnoreSteps(from: 21, to: 29),
              FlutterSliderIgnoreSteps(from: 31, to: 39),
              FlutterSliderIgnoreSteps(from: 41, to: 49),
              FlutterSliderIgnoreSteps(from: 51, to: 59),
              FlutterSliderIgnoreSteps(from: 61, to: 69),
              FlutterSliderIgnoreSteps(from: 71, to: 79),
              FlutterSliderIgnoreSteps(from: 81, to: 89),
              FlutterSliderIgnoreSteps(from: 91, to: 99),
            ],
            onDragCompleted: (s, _, index) {
              if (_currentStepIndex <= 4) {
                setState(() {
                  _currentStepIndex++;
                });
              }
              Future.delayed(Duration(milliseconds: 250), () {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              });
            },
            touchSize: 30,
            disabled: (_currentStepIndex > 4),
            selectByTap: false,
            jump: false,
            values: [_painIntensity],
            trackBar: FlutterSliderTrackBar(
              activeDisabledTrackBarColor: accentColor,
              inactiveTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: colorGreyBackground,
              ),
              activeTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: accentColor,
              ),
            ),
            handler: FlutterSliderHandler(
              decoration: BoxDecoration(),
              child: Container(
                child: Container(
                  key: silderKey,
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: accentColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.4),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),
            ),
            tooltip: FlutterSliderTooltip(
              custom: (value) {
                var painintensity = getIntensityValue();
                return _buildButton(
                  painintensity,
                  painintensity,
                  () {},
                  _currentStepIndex <= 4,
                  width: 100,
                );
              },
              boxStyle: FlutterSliderTooltipBox(),
              direction: FlutterSliderTooltipDirection.top,
              alwaysShowTooltip: true,
            ),
            max: 100,
            min: 0,
            rangeSlider: false,
            onDragging: (_, lowerValue, __) {
              setState(() {
                _painIntensity = lowerValue;
              });
            },
          ),
        ],
      );

  String getIntensityValue() {
    switch (_painIntensity ~/ 10) {
      case 0:
        return "no pain";
        break;
      case 1:
        return "minimal";
        break;
      case 2:
        return "mild";
        break;
      case 3:
        return "uncomfortable";
        break;
      case 4:
        return "moderate";
        break;
      case 5:
        return "distracting";
        break;
      case 6:
        return "distressing";
        break;
      case 7:
        return "unmanageable";
        break;
      case 8:
        return "intense";
        break;
      case 9:
        return "severe";
        break;
      case 10:
        return "unable to move";
        break;
      default:
        return "no pain";
        break;
    }
  }

  Widget _buildStepFive() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HutanoCheckBox(
              isChecked: _selectedPainCondition != null, onValueChange: null),
          SizedBox(width: spacing15),
          Text(
            "Pain is",
            style:
                TextStyle(fontSize: fontSize10, fontWeight: fontWeightSemiBold),
          ),
          SizedBox(width: spacing10),
          _buildPainConditionButton("improving"),
          SizedBox(width: spacing5),
          _buildPainConditionButton("worsening"),
          SizedBox(width: spacing5),
          _buildPainConditionButton("staying the same"),
        ],
      );

  Widget _buildPainConditionButton(String title) => Expanded(
        child: _buildButton(
          title,
          _selectedPainCondition,
          () {
            setState(() {
              _selectedPainCondition = title;
            });
          },
          _currentStepIndex <= 5,
        ),
      );

  Widget _buildButton(
          String title, String selectedTitle, Function onTap, bool enabled,
          {double width = 100}) =>
      InkWell(
        // onTap: enabled ? onTap : () {},
        onTap: onTap,
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
          width: width,
          decoration: BoxDecoration(
              border: Border.all(color: colorDarkgrey2, width: 1),
              color: selectedTitle == title ? colorDarkgrey2 : colorGrey3),
        ),
      );

  Widget _buildBottomButtons() => Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(spacing20),
              child: Row(
                children: [
                  _buildBodyTypeButton(0, Localization.of(context).back),
                  SizedBox(width: spacing15),
                  _buildBodyTypeButton(1, Localization.of(context).front),
                  SizedBox(width: spacing15),
                  _buildBodyTypeButton(2, Localization.of(context).side),
                  SizedBox(width: spacing15),
                  _buildBodyTypeButton(3, Localization.of(context).allOver),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing20),
              child: Row(
                children: [
                  Expanded(
                    child: HutanoButton(
                      label: Localization.of(context).skip,
                      color: primaryColor,
                      onPressed: () {
                        Navigator.of(context).pushNamed(routeMedicineInformation);
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
                            if (_selectedBodyPart != null) {
                              setState(() {
                                _currentStepIndex++;
                              });
                            } else {
                              DialogUtils.showAlertDialog(context,
                                  "Please select one body part from body");
                            }
                            break;
                          case 2:
                            if (_selectedPainDesc != null) {
                              setState(() {
                                _currentStepIndex++;
                              });
                            } else {
                              DialogUtils.showAlertDialog(
                                context,
                                "Please describe pain by selecting any one option",
                              );
                            }
                            break;
                          case 3:
                            if (_selectedPainTimeNumber != null &&
                                _selectedPainTime != null) {
                              setState(() {
                                _currentStepIndex++;
                              });
                            } else {
                              DialogUtils.showAlertDialog(
                                context,
                                "Please select how long you are suffering from this pain",
                              );
                            }
                            break;
                          case 4:
                            setState(() {
                              _currentStepIndex++;
                            });
                            break;
                          case 5:
                            if (_selectedPainCondition != null) {
                              Provider.of<SymptomsInfoProvider>(context,
                                      listen: false)
                                  .setPainDetails(
                                bodypart: _selectedBodyPart,
                                bodyPartPain: _selectedPainDesc,
                                timeForpain: _selectedPainTime,
                                timeForpainNumber: _selectedPainTimeNumber,
                                painIntensity: _painIntensity.toInt(),
                                painCondition: _selectedPainCondition,
                              );
                              Navigator.of(context).pushNamed(routeSymptomsInformation,
                                  arguments: {
                                    ArgumentConstant.argSeletedSymptomsType: 0
                                  });
                            } else {
                              DialogUtils.showAlertDialog(
                                context,
                                "Please select pain condition",
                              );
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
            ),
          ],
        ),
      );

  Widget _buildBodyTypeButton(int index, String title) => Expanded(
        child: Stack(
          children: [
            Container(
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                    color: widget.selectedBodyTypeIndex == index
                        ? Colors.black
                        : primaryColor,
                    fontSize: fontSize12,
                    fontWeight: fontWeightMedium),
              ),
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                color: widget.selectedBodyTypeIndex == index
                    ? colorGrey2
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    width: 0.5,
                    color: widget.selectedBodyTypeIndex == index
                        ? primaryColor
                        : colorGrey),
              ),
            ),
            Positioned(
              bottom: spacing2,
              right: spacing7,
              child: Image.asset(
                widget.selectedBodyTypeIndex == index
                    ? FileConstants.icCheck
                    : FileConstants.icUncheckSquare,
                height: 13,
                width: 13,
              ),
            )
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
                  decoration: 0 == index
                      ? TextDecoration.underline
                      : TextDecoration.none),
            )
          ],
        ),
      );
}
