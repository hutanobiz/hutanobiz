import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/model/req_selected_condition_model.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/model/res_selected_condition_model.dart';

import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/common_methods.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';

import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/hutano_textfield.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';

import 'model/body_part_model.dart';
import 'model/describe_symptoms_model.dart';

//TODO STATIC TEXT WILL BE REMOVE AFTER API INTEGRATION

class BoneMuscleIssue extends StatefulWidget {
  final String problemId;
  final String problemName;
  final String problemImage;
  BoneMuscleIssue({this.problemId, this.problemName, this.problemImage});
  @override
  _BoneMuscleIssueState createState() => _BoneMuscleIssueState();
}

class _BoneMuscleIssueState extends State<BoneMuscleIssue> {
  double _discomfortIntensity = 0;
  GlobalKey _rangeSliderKey = GlobalKey();
  List<DescribeSymptomsModel> _listOfSymptoms = [];
  List<BodyPartModel> _listOfBodyPart = [];
  TextEditingController _searchBodyPartController = TextEditingController();
  TextEditingController _sideController = TextEditingController();
  FocusNode _searchBodyPartFocusNode = FocusNode();
  List<BodyPartModel> _listOfSelectedDisease = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _getHealthConditionDetails(
          context, ReqSelectConditionModel(problemIds: [widget.problemId]));
    });
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
            title: "",
            addHeader: true,
            padding: EdgeInsets.only(
                left: spacing20, right: spacing10, bottom: spacing70),
            addBottomArrows: true,
            onForwardTap: () {
              _onForwardTap(context);
            },
            isCameraVisible: true,
            onCameraForTap: () {},
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _commonHeaderText(context,
                      Localization.of(context).boneAndMuscleIssueHeader),
                  _buildSearchForBodyPart(context),
                  _currentDiseaseList(context),
                  Container(),
                  _commonHeaderText(
                      context, Localization.of(context).describeSymptomsHeader),
                  _symptomsList(context),
                  _commonHeaderText(
                      context, Localization.of(context).rateYourPainHeader),
                  _rateDiscomfort(context)
                ],
              ),
            )));
  }

  Widget _commonHeaderText(BuildContext context, String header) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing20),
        child: Text(
          header,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _rateDiscomfort(BuildContext context) => FlutterSlider(
        values: [_discomfortIntensity],
        max: 10,
        min: 0,
        onDragging: (_, lowerValue, __) {
          setState(() {
            _discomfortIntensity = lowerValue;
          });
        },
        trackBar: FlutterSliderTrackBar(
          activeTrackBarHeight: 18,
          inactiveTrackBarHeight: 18,
          activeTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.sunglow,
              gradient: LinearGradient(
                  colors: [Color(0xffFFE18D), Color(0xffFFC700)])),
          inactiveTrackBar: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorGreyBackground,
          ),
        ),
        handler: FlutterSliderHandler(
          decoration: BoxDecoration(),
          child: Container(
            child: Container(
              key: _rangeSliderKey,
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
            return _buildButton(value, context);
          },
          boxStyle: FlutterSliderTooltipBox(),
          direction: FlutterSliderTooltipDirection.top,
          alwaysShowTooltip: true,
        ),
        rangeSlider: false,
      );

  Widget _buildButton(double value, BuildContext context) => InkWell(
        child: Container(
          margin: EdgeInsets.only(top: spacing2),
          child: Text(
            _getTextValue(value, context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Color(0xffFFC259),
                fontWeight: fontWeightMedium,
                fontSize: fontSize10),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(spacing5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: colorBlack2),
        ),
      );

  Widget _buildSearchForBodyPart(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: spacing2),
        height: 40,
        decoration: BoxDecoration(
            color: colorBlack2.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
              controller: _searchBodyPartController,
              focusNode: _searchBodyPartFocusNode,
              textInputAction: TextInputAction.next,
              maxLines: 1,
              onTap: () {},
              onChanged: (value) {},
              decoration: InputDecoration(
                prefixIconConstraints: BoxConstraints(),
                prefixIcon: GestureDetector(
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.all(spacing8),
                        child: Image.asset(FileConstants.icSearchBlack,
                            color: colorBlack2, width: 20, height: 20))),
                hintText: Localization.of(context).searchForBodyPart,
                isDense: true,
                hintStyle: TextStyle(
                    color: colorBlack2,
                    fontSize: fontSize13,
                    fontWeight: fontWeightRegular),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              )),
          suggestionsCallback: (pattern) async {
            return pattern.length > 0 ? await _getFilteredInsuranceList() : [];
          },
          errorBuilder: (_, object) {
            return Container();
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.bodyPart),
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (suggestion) {
            setState(() {
              _listOfSelectedDisease.add(BodyPartModel(
                  suggestion.bodyPart,
                  suggestion.hasInternalPart,
                  suggestion.sides,
                  suggestion.isItClicked,
                  ""));
            });
            _searchBodyPartController.text = "";
          },
          hideOnError: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
        ),
      );

  Widget _currentDiseaseList(BuildContext context) => ListView.builder(
      shrinkWrap: true,
      itemCount: _listOfSelectedDisease.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            PopupMenuButton(
              offset: Offset(300, 50),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                _popMenuCommonItem(context, Localization.of(context).edit,
                    FileConstants.icEdit),
                _popMenuCommonItem(context, Localization.of(context).remove,
                    FileConstants.icRemoveBlack)
              ],
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "${index + 1}. " +
                      _listOfSelectedDisease[index].selectedSide +
                      " ${_listOfSelectedDisease[index].bodyPart}",
                  style: TextStyle(
                      fontWeight: fontWeightMedium,
                      fontSize: fontSize14,
                      color: colorBlack2),
                ),
                trailing: Icon(Icons.more_vert, color: colorBlack2),
              ),
              onSelected: (value) {
                if (value == Localization.of(context).edit) {
                  setState(() {
                    _listOfSelectedDisease[index].isItClicked = false;
                    _sideController.text =
                        _listOfSelectedDisease[index].selectedSide;
                  });
                } else {
                  setState(() {
                    _listOfSelectedDisease
                        .remove(_listOfSelectedDisease[index]);
                  });
                }
              },
            ),
            if (_listOfSelectedDisease[index].hasInternalPart)
              if (!_listOfSelectedDisease[index].isItClicked)
                _buildDropDownBottomSheet(context, index),
          ],
        );
      });

  Widget _popMenuCommonItem(BuildContext context, String value, String image) =>
      PopupMenuItem<String>(
        value: value,
        textStyle: const TextStyle(
            color: colorBlack2,
            fontWeight: fontWeightRegular,
            fontSize: spacing12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 15,
              width: 15,
            ),
            SizedBox(
              width: spacing5,
            ),
            Text(value)
          ],
        ),
      );

  Widget _symptomsList(BuildContext context) => Container(
        height: 40,
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(width: spacing20);
            },
            scrollDirection: Axis.horizontal,
            itemCount: _listOfSymptoms.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: spacing15, vertical: spacing10),
                  decoration: BoxDecoration(
                      color: _listOfSymptoms[index].isSelected
                          ? AppColors.windsor
                          : Colors.white,
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                  child: Text(
                    _listOfSymptoms[index].symptom,
                    style: TextStyle(
                        fontSize: fontSize14,
                        fontWeight: fontWeightRegular,
                        color: _listOfSymptoms[index].isSelected
                            ? Colors.white
                            : AppColors.windsor),
                  )).onClick(onTap: () {
                setState(() {
                  _listOfSymptoms.forEach((element) {
                    if (element.index == _listOfSymptoms[index].index) {
                      element.isSelected = true;
                    } else {
                      element.isSelected = false;
                    }
                  });
                });
              });
            }),
      );

  _getFilteredInsuranceList() {
    return _listOfBodyPart.where((element) => element.bodyPart
        .toLowerCase()
        .contains(_searchBodyPartController.text.toLowerCase()));
  }

  String _getTextValue(double value, BuildContext context) {
    if (value >= 0.0 && value < 4) {
      return Localization.of(context).lowLabel;
    } else if (value >= 4 && value < 8) {
      return Localization.of(context).mediumLabel;
    } else {
      return Localization.of(context).highLabel;
    }
  }

  _buildDropDownBottomSheet(BuildContext context, int index) => Padding(
        padding: const EdgeInsets.all(spacing8),
        child: InkWell(
          onTap: () {
            _openMaterialSidePickerSheet(context, index);
          },
          child: HutanoTextField(
            hintText: Localization.of(context).selectSideLabel,
            textInputAction: TextInputAction.next,
            controller: _sideController,
            focusNode: FocusNode(),
            textInputType: TextInputType.text,
            suffixIcon: FileConstants.icDropDownArrow,
            suffixwidth: 5,
            suffixheight: 5,
            isFieldEnable: false,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            validationMethod: (value) {},
          ),
        ),
      );

  _openMaterialSidePickerSheet(BuildContext context, int index) =>
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
            ),
          ),
          context: context,
          builder: (context) => Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Wrap(
                  children: <Widget>[_buildChooseSidePicker(context, index)],
                ),
              ));

  _buildChooseSidePicker(BuildContext context, int index) => Column(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height / 4,
              child: ListView.builder(
                  itemCount: _listOfSelectedDisease[index].sides.length,
                  itemBuilder: (context, pos) {
                    return ListTile(
                      title: Text(
                        _getSideText(
                            _listOfSelectedDisease[index].sides[pos], context),
                        style: TextStyle(
                            fontWeight: fontWeightMedium,
                            fontSize: fontSize14,
                            color: colorBlack2),
                      ),
                      onTap: () {
                        _sideController.text = _getSideText(
                            _listOfSelectedDisease[index].sides[pos], context);
                        _listOfSelectedDisease[index].isItClicked = true;
                        _listOfSelectedDisease[index].selectedSide =
                            _getSideText(
                                _listOfSelectedDisease[index].sides[pos],
                                context);
                        setState(() {});
                        Navigator.pop(context);
                      },
                    );
                  })),
        ],
      );

  //TODO WILL USER AFTER MULTIPLE HEALTH ISSUES FEATURE ADDED
  void _nextScreenNavigation(BuildContext context) {
    if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(2)) {
      stomachNavigation(context);
    } else if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(3)) {
      breathingNavigation(context);
    } else if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(4)) {
      abnormalNavigation(context);
    } else if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(5)) {
      femaleHealthNavigation(context);
    } else if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(6)) {
      maleHealthNavigation(context);
    } else if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(7)) {
      woundSkinNavigation(context);
    } else if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(8)) {
      healthAndChestNavigation(context);
    } else if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(9)) {
      dentalCareNavigation(context);
    } else if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(11)) {
      antiAgingNavigation(context);
    } else if (Provider.of<HealthConditionProvider>(context, listen: false)
        .healthConditions
        .contains(12)) {
      Navigator.pushNamed(context, Routes.routeImmunization);
    }
  }

  void _getHealthConditionDetails(
      BuildContext context, ReqSelectConditionModel reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().getHealthConditionDetails(reqModel).then(((result) {
      if (result is ResSelectConditionModel) {
        ProgressDialogUtils.dismissProgressDialog();
        setState(() {
          int j = 1;
          result.response[0].bodyPart.forEach((element) {
            _listOfBodyPart.add(BodyPartModel(element.name,
                element.sides.isNotEmpty, element.sides, false, ""));
            j++;
          });
          int i = 1;
          result.response[0].symptoms.forEach((element) {
            _listOfSymptoms.add(DescribeSymptomsModel(element, false, i));
            i++;
          });
        });
      }
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }

  String _getSideText(int pos, BuildContext context) {
    switch (pos) {
      case 1:
        return Localization.of(context).leftSide;
        break;
      case 2:
        return Localization.of(context).rightSide;
        break;
      case 3:
        return Localization.of(context).backSide;
        break;
      case 4:
        return Localization.of(context).frontSide;
        break;
      default:
        return "";
        break;
    }
  }

  String _getSelectedSide(String side) {
    if (side == Localization.of(context).leftSide) {
      return "1";
    } else if (side == Localization.of(context).rightSide) {
      return "2";
    } else if (side == Localization.of(context).backSide) {
      return "3";
    } else {
      return "4";
    }
  }

  void _onForwardTap(BuildContext context) {
    List<BodyPartWithSide> bodyPartWithSide = [];
    _listOfSelectedDisease.forEach((element) {
      bodyPartWithSide.add(BodyPartWithSide(
          name: element.bodyPart,
          sides: _getSelectedSide(element.selectedSide)));
    });
    List<String> selectedSymptoms = [];
    _listOfSymptoms.forEach((element) {
      if (element.isSelected) {
        selectedSymptoms.add(element.symptom);
      }
    });
    Problems model = Problems(
        problemId: widget.problemId,
        image: widget.problemImage,
        name: widget.problemName,
        bodyPart: bodyPartWithSide,
        problemRating: _discomfortIntensity.toInt(),
        symptoms: selectedSymptoms);
    Provider.of<HealthConditionProvider>(context, listen: false)
        .updateProblemData(model);
    Navigator.of(context).pushNamed(Routes.routeConditionBetterWorst,
        arguments: {ArgumentConstant.problemIdKey: widget.problemId});
  }
}
