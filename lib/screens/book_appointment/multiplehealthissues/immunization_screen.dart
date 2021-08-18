import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/loading_background_new.dart';

import 'model/associated_symptoms_model.dart';
import 'model/body_part_model.dart';

//TODO STATIC TEXT WILL BE REMOVE AFTER API INTEGRATION

class ImmunizationScreen extends StatefulWidget {
  @override
  _ImmunizationScreenState createState() => _ImmunizationScreenState();
}

class _ImmunizationScreenState extends State<ImmunizationScreen> {
  List<BodyPartModel> _listOfVaccines = [];
  TextEditingController _searchVaccineController = TextEditingController();
  TextEditingController _searchSymptomsController = TextEditingController();
  FocusNode _searchVaccineFocusNode = FocusNode();
  FocusNode _searchSymptomsFocusNode = FocusNode();
  List<BodyPartModel> _listOfSelectedVaccines = [];
  List<AssociatedSymptomsModel> _listOfSelectedSymptoms = [];
  List<AssociatedSymptomsModel> _listOfAssociatedSymptoms = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _listOfVaccines.add(BodyPartModel("Covid 19", true, [], false, ""));
      _listOfVaccines.add(BodyPartModel("Arm muscle", false, [], false, ""));
      _listOfVaccines.add(BodyPartModel("Spine", false, [], false, ""));
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
              Navigator.pushNamed(context,Routes. routeEffectAbility);
            },
            // isCameraVisible: true,
            // onCameraForTap: () {},
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _commonHeaderText(
                      context, Localization.of(context).immunizationLabel),
                  _buildSearchForVaccine(context),
                  _currentVaccineList(context),
                  SizedBox(height: spacing20),
                  _buildSearchForSymptoms(context),
                  _currentSymptomsList(context),
                ],
              ),
            )));
  }

  Widget _commonHeaderText(BuildContext context, String header) => Padding(
      padding: EdgeInsets.symmetric(vertical: spacing20),
      child: Text(header,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold)));

  Widget _buildSearchForVaccine(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: spacing2),
        height: 40,
        decoration: BoxDecoration(
            color: colorBlack2.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
              controller: _searchVaccineController,
              focusNode: _searchVaccineFocusNode,
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
                hintText: Localization.of(context).vaccineHint,
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
            return pattern.length > 0 ? await _getFilteredVaccineList() : [];
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
              _listOfSelectedVaccines.add(BodyPartModel(
                  suggestion.bodyPart,
                  suggestion.hasInternalPart,
                  suggestion.sides,
                  suggestion.isItClicked,
                  ""));
            });
            _searchVaccineController.text = "";
          },
          hideOnError: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
        ),
      );

  _getFilteredVaccineList() {
    return _listOfVaccines.where((element) => element.bodyPart
        .toLowerCase()
        .contains(_searchVaccineController.text.toLowerCase()));
  }

  Widget _currentVaccineList(BuildContext context) => ListView.builder(
      shrinkWrap: true,
      itemCount: _listOfSelectedVaccines.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    "${index + 1}. " + _listOfSelectedVaccines[index].bodyPart,
                    style: TextStyle(
                        fontWeight: fontWeightMedium,
                        fontSize: fontSize14,
                        color: colorBlack2)),
                trailing: Icon(Icons.more_vert, color: colorBlack2)),
            onSelected: (value) {
              if (value == Localization.of(context).edit) {
                setState(() {
                  _listOfSelectedVaccines[index].isItClicked = false;
                });
              } else {
                setState(() {
                  _listOfSelectedVaccines
                      .remove(_listOfSelectedVaccines[index]);
                });
              }
            },
          ),
          if (_listOfSelectedVaccines[index].hasInternalPart)
            _haveVaccinatedHeader(context),
          Row(children: [
            _yesButtonWidget(context, index),
            SizedBox(width: spacing15),
            _noButtonWidget(context, index),
          ]),
        ]);
      });

  Widget _haveVaccinatedHeader(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing20),
        child: Text(
          Localization.of(context).haveYouHadVaccineLabel,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _yesButtonWidget(BuildContext context, int index) => HutanoButton(
        label: Localization.of(context).yes,
        onPressed: () {
          setState(() {
            _listOfSelectedVaccines[index].isItClicked = true;
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: _listOfSelectedVaccines[index].isItClicked
            ? colorWhite
            : colorPurple100,
        color: _listOfSelectedVaccines[index].isItClicked
            ? colorPurple100
            : colorWhite,
        height: 34,
      );

  Widget _noButtonWidget(BuildContext context, int index) => HutanoButton(
        borderColor: colorGrey,
        label: Localization.of(context).no,
        onPressed: () {
          setState(() {
            _listOfSelectedVaccines[index].isItClicked = false;
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: !_listOfSelectedVaccines[index].isItClicked
            ? colorWhite
            : colorPurple100,
        color: !_listOfSelectedVaccines[index].isItClicked
            ? colorPurple100
            : colorWhite,
        borderWidth: 1,
        height: 34,
      );

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

  _getFilteredSymptomsList() {
    return _listOfAssociatedSymptoms.where((element) => element.symptom
        .toLowerCase()
        .contains(_searchVaccineController.text.toLowerCase()));
  }

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
}
