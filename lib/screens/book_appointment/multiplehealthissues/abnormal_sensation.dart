import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';

import 'package:hutano/utils/app_constants.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/common_methods.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/date_picker.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/hutano_textfield.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';

import 'model/associated_symptoms_model.dart';
import 'model/body_part_model.dart';
import 'model/describe_symptoms_model.dart';

//TODO STATIC TEXT WILL BE REMOVE AFTER API INTEGRATION

class AbnormalSensation extends StatefulWidget {
  final bool abnormal;
  final bool maleHealth;
  final bool femaleHealth;
  final bool woundSkin;
  final bool dentalCare;
  final bool hearingSight;
  AbnormalSensation(
      {this.abnormal = false,
      this.maleHealth = false,
      this.femaleHealth = false,
      this.woundSkin = false,
      this.dentalCare = false,
      this.hearingSight = false});
  @override
  _AbnormalSensationState createState() => _AbnormalSensationState();
}

class _AbnormalSensationState extends State<AbnormalSensation> {
  double _discomfortIntensity = 0;
  GlobalKey _rangeSliderKey = GlobalKey();
  List<DescribeSymptomsModel> _listOfSymptoms = [];
  List<BodyPartModel> _listOfBodyPart = [];
  TextEditingController _searchBodyPartController = TextEditingController();
  TextEditingController _sideController = TextEditingController();
  TextEditingController _searchSymptomsController = TextEditingController();
  FocusNode _searchBodyPartFocusNode = FocusNode();
  FocusNode _searchSymptomsFocusNode = FocusNode();
  FocusNode _sideFocusNode = FocusNode();
  List<BodyPartModel> _listOfSelectedDisease = [];
  List<AssociatedSymptomsModel> _listOfSelectedSymptoms = [];
  List<AssociatedSymptomsModel> _listOfAssociatedSymptoms = [];
  bool _isPregnant = false;
  String _periodDate = "";

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (!widget.woundSkin) {
        _listOfSymptoms.add(DescribeSymptomsModel("Sharp", false, 1));
        _listOfSymptoms.add(DescribeSymptomsModel("Throbbing", false, 2));
        _listOfSymptoms.add(DescribeSymptomsModel("Itching", false, 3));
        _listOfSymptoms.add(DescribeSymptomsModel("Cramping", false, 4));
      } else {
        _listOfSymptoms.add(DescribeSymptomsModel("Painful", false, 1));
        _listOfSymptoms.add(DescribeSymptomsModel("Tender", false, 2));
        _listOfSymptoms.add(DescribeSymptomsModel("Shooting", false, 3));
        _listOfSymptoms.add(DescribeSymptomsModel("Numb", false, 4));
      }
      _listOfBodyPart.add(BodyPartModel("Knee", true, [], false, ""));
      _listOfBodyPart.add(BodyPartModel("Arm muscle", false, [], false, ""));
      _listOfBodyPart.add(BodyPartModel("Spine", false, [], false, ""));
      _listOfAssociatedSymptoms
          .add(AssociatedSymptomsModel("Left arm weakness"));
      _listOfAssociatedSymptoms
          .add(AssociatedSymptomsModel("Inability to speak"));
      _listOfAssociatedSymptoms
          .add(AssociatedSymptomsModel("Left leg weakness"));
      setState(() {});
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
              // _nextScreenNavigation(context);
              Navigator.of(context).pushNamed(Routes.routeEffectAbility);
            },
            // isCameraVisible: true,
            // onCameraForTap: () {},
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _commonHeaderText(context, _getHeaderText()),
                  _buildSearchForBodyPart(context),
                  _currentDiseaseList(context),
                  SizedBox(height: spacing20),
                  _buildSearchForSymptoms(context),
                  _currentSymptomsList(context),
                  if (!widget.femaleHealth &&
                      !widget.maleHealth &&
                      !widget.dentalCare &&
                      !widget.hearingSight)
                    _commonHeaderText(context,
                        Localization.of(context).describeSymptomsHeader),
                  if (!widget.femaleHealth &&
                      !widget.maleHealth &&
                      !widget.dentalCare &&
                      !widget.hearingSight)
                    _symptomsList(context),
                  if (!widget.femaleHealth &&
                      !widget.maleHealth &&
                      !widget.dentalCare &&
                      !widget.hearingSight)
                    SizedBox(height: spacing20),
                  if (widget.femaleHealth) _pregnantListTileWidget(context),
                  if (widget.femaleHealth) _periodListTileWidget(context),
                  if (widget.femaleHealth) _periodDateText(context),
                  if (widget.femaleHealth) SizedBox(height: spacing10),
                  _commonHeaderText(
                      context, Localization.of(context).rateYourDiscomfort),
                  _rateDiscomfort(context)
                ],
              ),
            )));
  }

  String _getHeaderText() {
    if (widget.abnormal) {
      return Localization.of(context).abnormalSensationHeader;
    } else if (widget.maleHealth) {
      return Localization.of(context).maleHealthHeader;
    } else if (widget.femaleHealth) {
      return Localization.of(context).femaleHealthHeader;
    } else if (widget.woundSkin) {
      return Localization.of(context).woundOrSkinHeader;
    } else if (widget.dentalCare) {
      return Localization.of(context).dentalHealthHeader;
    } else if (widget.hearingSight) {
      return Localization.of(context).hearingAndSightHeader;
    } else {
      return "";
    }
  }

  String _getHintText() {
    if (widget.dentalCare || widget.hearingSight) {
      return Localization.of(context).whatIsTheProblemLabel;
    } else {
      return Localization.of(context).searchForBodyPart;
    }
  }

  Widget _commonHeaderText(BuildContext context, String header) => Padding(
      padding: EdgeInsets.symmetric(vertical: spacing20),
      child: Text(header,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold)));

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
              color: colorGreyBackground)),
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
                            offset: Offset(0, 2))
                      ])))),
      tooltip: FlutterSliderTooltip(
          custom: (value) {
            return _buildButton(value);
          },
          boxStyle: FlutterSliderTooltipBox(),
          direction: FlutterSliderTooltipDirection.top,
          alwaysShowTooltip: true),
      rangeSlider: false);

  Widget _buildButton(double value) => InkWell(
      child: Container(
          margin: EdgeInsets.only(top: spacing2),
          child: Text(_getTextValue(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(0xffFFC259),
                  fontWeight: fontWeightMedium,
                  fontSize: fontSize10)),
          alignment: Alignment.center,
          padding: EdgeInsets.all(spacing5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: colorBlack2)));

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
                hintText: _getHintText(),
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
        return Column(children: [
          PopupMenuButton(
            offset: Offset(300, 50),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              _popMenuCommonItem(
                  context, Localization.of(context).edit, FileConstants.icEdit),
              _popMenuCommonItem(context, Localization.of(context).remove,
                  FileConstants.icRemoveBlack)
            ],
            child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                    "${index + 1}. " + _listOfSelectedDisease[index].bodyPart,
                    style: TextStyle(
                        fontWeight: fontWeightMedium,
                        fontSize: fontSize14,
                        color: colorBlack2)),
                trailing: Icon(Icons.more_vert, color: colorBlack2)),
            onSelected: (value) {
              if (value == Localization.of(context).edit) {
                setState(() {
                  _listOfSelectedDisease[index].isItClicked = false;
                });
              } else {
                setState(() {
                  _listOfSelectedDisease.remove(_listOfSelectedDisease[index]);
                });
              }
            },
          ),
          if (_listOfSelectedDisease[index].hasInternalPart)
            if (!_listOfSelectedDisease[index].isItClicked)
              _buildDropDownBottomSheet(context, index)
        ]);
      });

  Widget _buildSearchForSymptoms(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: spacing2),
        height: 40,
        decoration: BoxDecoration(
            color: colorBlack2.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: _searchSymptomsController,
                focusNode: _searchSymptomsFocusNode,
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
                  hintText: Localization.of(context).associatedSymptomsLabel,
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
              return pattern.length > 0 ? await _getFilteredSymptomsList() : [];
            },
            errorBuilder: (_, object) {
              return Container();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion.symptom));
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                _listOfSelectedSymptoms
                    .add(AssociatedSymptomsModel(suggestion.symptom));
              });
              _searchSymptomsController.text = "";
            },
            hideOnError: true,
            hideSuggestionsOnKeyboardHide: true,
            hideOnEmpty: true),
      );

  Widget _currentSymptomsList(BuildContext context) => ListView.builder(
      shrinkWrap: true,
      itemCount: _listOfSelectedSymptoms.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(children: [
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
                    "${index + 1}. " + _listOfSelectedSymptoms[index].symptom,
                    style: TextStyle(
                        fontWeight: fontWeightMedium,
                        fontSize: fontSize14,
                        color: colorBlack2),
                  ),
                  trailing: Icon(Icons.more_vert, color: colorBlack2)),
              onSelected: (value) {
                if (value == Localization.of(context).edit) {
                } else {
                  setState(() {
                    _listOfSelectedSymptoms
                        .remove(_listOfSelectedSymptoms[index]);
                  });
                }
              })
        ]);
      });

  Widget _popMenuCommonItem(BuildContext context, String value, String image) =>
      PopupMenuItem<String>(
          value: value,
          textStyle: const TextStyle(
              color: colorBlack2,
              fontWeight: fontWeightRegular,
              fontSize: spacing12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset(image, height: 15, width: 15),
            SizedBox(width: spacing5),
            Text(value)
          ]));

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
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(_listOfSymptoms[index].symptom,
                          style: TextStyle(
                              fontSize: fontSize14,
                              fontWeight: fontWeightRegular,
                              color: _listOfSymptoms[index].isSelected
                                  ? Colors.white
                                  : AppColors.windsor)))
                  .onClick(onTap: () {
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

  _getFilteredSymptomsList() {
    return _listOfAssociatedSymptoms.where((element) => element.symptom
        .toLowerCase()
        .contains(_searchBodyPartController.text.toLowerCase()));
  }

  String _getTextValue(double value) {
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
              focusNode: _sideFocusNode,
              textInputType: TextInputType.text,
              suffixIcon: FileConstants.icDropDownArrow,
              suffixwidth: 5,
              suffixheight: 5,
              isFieldEnable: false,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              validationMethod: (value) {})));

  _openMaterialSidePickerSheet(
          BuildContext context, int index) =>
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero)),
          context: context,
          builder: (context) => Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Wrap(
                  children: <Widget>[_buildChooseSidePicker(context, index)])));

  _buildChooseSidePicker(BuildContext context, int index) =>
      Column(children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height / 4,
            child: ListView.builder(
                itemCount: _listOfSelectedDisease[index].sides.length,
                itemBuilder: (context, pos) {
                  return ListTile(
                      title: Text(
                          _listOfSelectedDisease[index].sides[pos].toString(),
                          style: TextStyle(
                              fontWeight: fontWeightMedium,
                              fontSize: fontSize14,
                              color: colorBlack2)),
                      onTap: () {
                        _sideController.text =
                            _listOfSelectedDisease[index].sides[pos].toString();
                        Navigator.pop(context);
                      });
                }))
      ]);

  Widget _pregnantListTileWidget(BuildContext context) => ListTile(
        dense: true,
        onTap: () {
          setState(() {
            _isPregnant = !_isPregnant;
          });
        },
        title: Text(Localization.of(context).pregnantLabel,
            style: TextStyle(
                color: colorBlack2,
                fontSize: fontSize14,
                fontWeight: fontWeightMedium)),
        trailing: _isPregnant
            ? Image.asset("images/checkedCheck.png", height: 24, width: 24)
            : Image.asset("images/uncheckedCheck.png", height: 24, width: 24),
      );

  Widget _periodListTileWidget(BuildContext context) => ListTile(
        dense: true,
        onTap: () async {
          await showCustomDatePicker(
                  context: context,
                  firstDate: DateTime(DateTime.now().year - 20,
                      DateTime.now().month, DateTime.now().day))
              .then((value) {
            if (value != null) {
              var date =
                  formattedDate(value, AppConstants.vitalReviewsDateFormat);
              setState(() {
                _periodDate = date.toString();
              });
            }
          });
        },
        title: Text(Localization.of(context).whenWasLastPeriodLabel,
            style: TextStyle(
                color: colorBlack2,
                fontSize: fontSize14,
                fontWeight: fontWeightMedium)),
        trailing: Image.asset(FileConstants.icCalendarGrey,
            color: AppColors.windsor, height: 24, width: 24),
      );

  Widget _periodDateText(BuildContext context) => _periodDate.isNotEmpty
      ? Padding(
          padding: const EdgeInsets.only(left: spacing16),
          child: Text("$_periodDate"),
        )
      : SizedBox();

  void _nextScreenNavigation(BuildContext context) {
    if (widget.abnormal) {
      if (Provider.of<HealthConditionProvider>(context, listen: false)
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
      } else {
        Navigator.pushNamed(context, Routes.routeEffectAbility);
      }
    } else if (widget.maleHealth) {
      if (Provider.of<HealthConditionProvider>(context, listen: false)
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
      } else {
        Navigator.pushNamed(context, Routes.routeEffectAbility);
      }
    } else if (widget.femaleHealth) {
      if (Provider.of<HealthConditionProvider>(context, listen: false)
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
      } else {
        Navigator.pushNamed(context, Routes.routeEffectAbility);
      }
    } else if (widget.woundSkin) {
      if (Provider.of<HealthConditionProvider>(context, listen: false)
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
      } else {
        Navigator.pushNamed(context, Routes.routeEffectAbility);
      }
    } else if (widget.dentalCare) {
      if (Provider.of<HealthConditionProvider>(context, listen: false)
          .healthConditions
          .contains(11)) {
        antiAgingNavigation(context);
      } else if (Provider.of<HealthConditionProvider>(context, listen: false)
          .healthConditions
          .contains(12)) {
        Navigator.pushNamed(context, Routes.routeImmunization);
      } else {
        Navigator.pushNamed(context, Routes.routeEffectAbility);
      }
    }
  }

  int getIssueIndex() {
    if (widget.abnormal) {
      return 4;
    } else if (widget.maleHealth) {
      return 6;
    } else if (widget.femaleHealth) {
      return 5;
    } else if (widget.woundSkin) {
      return 7;
    } else if (widget.dentalCare) {
      return 9;
    } else {
      return 1;
    }
  }
}
