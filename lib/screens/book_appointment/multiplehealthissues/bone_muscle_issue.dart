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
import 'package:hutano/screens/book_appointment/conditiontime/model/common_time_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/res_more_condition_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/model/problem_worst_better_model.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/model/req_selected_condition_model.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/model/res_selected_condition_model.dart';
import 'package:hutano/screens/medical_history/model/medicine_time_model.dart';
import 'package:hutano/utils/app_constants.dart';

import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/common_methods.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';

import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/hutano_button.dart';
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
  ScrollController _wholeBodyController = ScrollController();

  //Reason Problem Better & Worst
  TextEditingController _problemBetterController = TextEditingController();
  TextEditingController _problemWorstController = TextEditingController();
  FocusNode _problemBetterFocusNode = FocusNode();
  FocusNode _problemWorstFocusNode = FocusNode();
  List<ProblemWorstBetterModel> _problemBetterList = [];
  List<String> _selectedProblemBetterList = [];
  List<ProblemWorstBetterModel> _problemWorstList = [];
  List<String> _selectedProblemWorstList = [];
  List<ProblemWorstBetterModel> _tempProblemBetterList = [];
  List<ProblemWorstBetterModel> _tempProblemWorstList = [];

  //Ability
  List<MedicineTimeModel> _activityList = [];
  int radioVal;

  //Problem Condition Time
  bool _isTreated = false;
  List<CommonTimeModel> _proHoursList = [];
  List<CommonTimeModel> _proDaysList = [];
  List<CommonTimeModel> _proWeeksList = [];
  List<CommonTimeModel> _proMonthsList = [];
  List<CommonTimeModel> _proYearsList = [];
  int totalHours = 23;
  int totalDays = 6;
  int totalWeeks = 3;
  int totalMonths = 11;
  int totalYears = 7;
  bool _isProHourVisible = false,
      _isProDayVisible = false,
      _isProWeekVisible = false,
      _isProMonthVisible = false,
      _isProYearVisible = false;
  List<DescribeSymptomsModel> _listOfDescribeSymptoms = [];
  String _selectedProType = "0";
  String _selectedProValue = "0";

  //Treatment Condition Time
  List<CommonTimeModel> _hoursList = [];
  List<CommonTimeModel> _daysList = [];
  List<CommonTimeModel> _weeksList = [];
  List<CommonTimeModel> _monthsList = [];
  List<CommonTimeModel> _yearsList = [];
  bool _isHourVisible = false,
      _isDayVisible = false,
      _isWeekVisible = false,
      _isMonthVisible = false,
      _isYearVisible = false;
  String _selectedType = "0";
  String _selectedValue = "0";

  List<HealthCondition> _conditionList = [];
  bool _isPressedOnProblemImproving = false;
  ScrollController _listOfBetterController = ScrollController();
  ScrollController _listOfWorstController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _abilityList(context);
      _conditionTimeData(context);
      setState(() {});
      for (int i = 0;
          i <
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .listOfSelectedHealthIssues
                  .length;
          i++) {
        if (i ==
            Provider.of<HealthConditionProvider>(context, listen: false)
                .currentIndexOfIssue) {
          _getHealthConditionDetails(
              context,
              ReqSelectConditionModel(problemIds: [
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .listOfSelectedHealthIssues[i]
                    .sId
              ]));
        }
      }
    });
  }

  void _abilityList(BuildContext context) {
    _activityList.add(
        MedicineTimeModel(Localization.of(context).dayToDayActivity, false, 1));
    _activityList.add(MedicineTimeModel(
        Localization.of(context).difficultActivity, false, 2));
    _activityList.add(MedicineTimeModel(
        Localization.of(context).impossibleActivity, false, 3));
  }

  void _conditionTimeData(BuildContext context) {
    for (var i = 0; i < totalHours; i++) {
      _proHoursList.add(CommonTimeModel("${i + 1}", false, i));
      _hoursList.add(CommonTimeModel("${i + 1}", false, i));
    }
    for (var i = 0; i < totalDays; i++) {
      _proDaysList.add(CommonTimeModel("${i + 1}", false, i));
      _daysList.add(CommonTimeModel("${i + 1}", false, i));
    }
    for (var i = 0; i < totalWeeks; i++) {
      _proWeeksList.add(CommonTimeModel("${i + 1}", false, i));
      _weeksList.add(CommonTimeModel("${i + 1}", false, i));
    }
    for (var i = 0; i < totalMonths; i++) {
      _proMonthsList.add(CommonTimeModel("${i + 1}", false, i));
      _monthsList.add(CommonTimeModel("${i + 1}", false, i));
    }
    for (var i = 1; i <= totalYears; i++) {
      _proYearsList.add(CommonTimeModel("$i", false, i));
      _yearsList.add(CommonTimeModel("$i", false, i));
    }
    _listOfDescribeSymptoms.add(DescribeSymptomsModel(
        Localization.of(context).improvingProblem, false, 1));
    _listOfDescribeSymptoms.add(DescribeSymptomsModel(
        Localization.of(context).worseningProblem, false, 2));
    _listOfDescribeSymptoms.add(DescribeSymptomsModel(
        Localization.of(context).stayingSameProblem, false, 3));
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: WillPopScope(
          onWillPop: _resetAction,
          child: LoadingBackgroundNew(
              title: "",
              addHeader: true,
              padding: EdgeInsets.only(
                  left: spacing20,
                  right: spacing10,
                  bottom: MediaQuery.of(context).viewInsets.bottom == 0
                      ? spacing70
                      : 0),
              addBottomArrows: MediaQuery.of(context).viewInsets.bottom == 0,
              onForwardTap: () {
                _onForwardTap(context);
              },
              onUpperBackTap: () {
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .decrementCurrentIndex();
                Navigator.pop(context);
              },
              // isCameraVisible: MediaQuery.of(context).viewInsets.bottom == 0,
              // onCameraForTap: () {},
              child: SingleChildScrollView(
                controller: _wholeBodyController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _commonHeaderText(
                        context, widget.problemName ?? "Health Issue"),
                    _buildSearchForBodyPart(context),
                    _currentDiseaseList(context),
                    Container(),
                    _commonHeaderText(context,
                        Localization.of(context).describeSymptomsHeader),
                    _symptomsList(context),
                    _commonHeaderText(
                        context, Localization.of(context).rateYourPainHeader),
                    _rateDiscomfort(context),
                    //Problem Better & Worst
                    _commonSecondHeaderText(context,
                        Localization.of(context).makesYourProblemBetter),
                    _buildSearchForProblemBetter(context),
                    _problemBetterListView(context),
                    _buildSearchForProblemWorst(context),
                    _problemWorstListView(context),
                    //Ebility List
                    _headerView(context),
                    _activityEffectList(context),
                    //Problem Condition Time
                    _treatedConditionHeader(context,
                        Localization.of(context).howLongHadProblemHeader),
                    SizedBox(height: spacing10),
                    _commonProblemHeaderWidget(
                        context,
                        Localization.of(context).hoursLabel,
                        _isProHourVisible,
                        true),
                    if (_isProHourVisible)
                      _horizontalProblemSelectionWidget(
                          context, _proHoursList, AppConstants.hours, true),
                    _commonProblemHeaderWidget(
                        context,
                        Localization.of(context).daysLabel,
                        _isProDayVisible,
                        true),
                    if (_isProDayVisible)
                      _horizontalProblemSelectionWidget(
                          context, _proDaysList, AppConstants.days, true),
                    _commonProblemHeaderWidget(
                        context,
                        Localization.of(context).weeksLabel,
                        _isProWeekVisible,
                        true),
                    if (_isProWeekVisible)
                      _horizontalProblemSelectionWidget(
                          context, _proWeeksList, AppConstants.weeks, true),
                    _commonProblemHeaderWidget(
                        context,
                        Localization.of(context).monthsLabel,
                        _isProMonthVisible,
                        true),
                    if (_isProMonthVisible)
                      _horizontalProblemSelectionWidget(context, _proMonthsList,
                          AppConstants.monthsConst, true),
                    _commonProblemHeaderWidget(
                        context,
                        Localization.of(context).yearsLabel,
                        _isProYearVisible,
                        true),
                    if (_isProYearVisible)
                      _horizontalProblemSelectionWidget(
                          context, _proYearsList, AppConstants.years, true),
                    if (_listOfDescribeSymptoms.isNotEmpty)
                      _treatedConditionHeader(
                          context, Localization.of(context).theProblemIsHeader),
                    _describeSymptomsList(context),
                    //Treatment Condition Time
                    _treatedConditionHeader(
                        context, Localization.of(context).treatedForCondition),
                    SizedBox(height: spacing10),
                    Row(children: [
                      _yesButtonWidget(context),
                      SizedBox(width: spacing15),
                      _noButtonWidget(context),
                    ]),
                    _howLongAgoHeader(context),
                    _commonHeaderWidget(
                        context,
                        Localization.of(context).hoursLabel,
                        _isHourVisible,
                        false),
                    if (_isHourVisible)
                      _horizontalSelectionWidget(
                          context, _hoursList, AppConstants.hours, false),
                    _commonHeaderWidget(
                        context,
                        Localization.of(context).daysLabel,
                        _isDayVisible,
                        false),
                    if (_isDayVisible)
                      _horizontalSelectionWidget(
                          context, _daysList, AppConstants.days, false),
                    _commonHeaderWidget(
                        context,
                        Localization.of(context).weeksLabel,
                        _isWeekVisible,
                        false),
                    if (_isWeekVisible)
                      _horizontalSelectionWidget(
                          context, _weeksList, AppConstants.weeks, false),
                    _commonHeaderWidget(
                        context,
                        Localization.of(context).monthsLabel,
                        _isMonthVisible,
                        false),
                    if (_isMonthVisible)
                      _horizontalSelectionWidget(context, _monthsList,
                          AppConstants.monthsConst, false),
                    _commonHeaderWidget(
                        context,
                        Localization.of(context).yearsLabel,
                        _isYearVisible,
                        false),
                    if (_isYearVisible)
                      _horizontalSelectionWidget(
                          context, _yearsList, AppConstants.years, false),
                    if (!_isTreated) SizedBox(height: spacing50),
                  ],
                ),
              )),
        ));
  }

  Future<bool> _resetAction() async {
    Provider.of<HealthConditionProvider>(context, listen: false)
        .decrementCurrentIndex();
    Navigator.pop(context);
    return true;
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

  Widget _buildButton(double value, BuildContext context) => CircleAvatar(
        backgroundColor: colorBlack2,
        radius: 10,
        child: Text(
          _getTextValue(value, context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Color(0xffFFC259),
              fontWeight: fontWeightMedium,
              fontSize: fontSize12),
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

  Widget _symptomsList(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing10),
        child: Scrollbar(
            child: GridView.builder(
                itemCount: _listOfSymptoms.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 4,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: _listOfSymptoms[index].isSelected
                              ? AppColors.windsor
                              : Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          )),
                      child: Center(
                        child: Text(
                          _listOfSymptoms[index].symptom ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSize14,
                              fontWeight: fontWeightRegular,
                              color: _listOfSymptoms[index].isSelected
                                  ? Colors.white
                                  : AppColors.windsor),
                        ),
                      )).onClick(onTap: () {
                    setState(() {
                      _listOfSymptoms[index].isSelected =
                          !_listOfSymptoms[index].isSelected;
                    });
                  });
                })),
      );

  _getFilteredInsuranceList() {
    return _listOfBodyPart.where((element) => element.bodyPart
        .toLowerCase()
        .contains(_searchBodyPartController.text.toLowerCase()));
  }

  String _getTextValue(double value, BuildContext context) {
    if (value >= 0.0 && value < 4) {
      return value.toInt().toString();
    } else if (value >= 4 && value < 8) {
      return value.toInt().toString();
    } else {
      return value.toInt().toString();
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
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("Select Side",
                style: TextStyle(fontSize: 20, fontWeight: fontWeightSemiBold)),
          ),
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

  Widget _commonSecondHeaderText(BuildContext context, String header) =>
      Padding(
        padding: EdgeInsets.only(top: spacing10, bottom: spacing20),
        child: Text(
          header,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _buildSearchForProblemBetter(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: spacing2),
        height: 40,
        decoration: BoxDecoration(
            color: colorBlack2.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TextFormField(
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 1,
            minLines: 1,
            controller: _problemBetterController,
            textAlignVertical: TextAlignVertical.center,
            focusNode: _problemBetterFocusNode,
            onChanged: (value) {
              _getProblemBetterList(value, context);
            },
            decoration: InputDecoration(
                prefixIconConstraints: BoxConstraints(),
                isDense: true,
                prefixIcon: GestureDetector(
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.all(spacing8),
                        child: Image.asset(FileConstants.icSearchBlack,
                            color: colorBlack2, width: 20, height: 20))),
                hintText:
                    Localization.of(context).actuallyMakesYourProblemBetter,
                hintStyle: TextStyle(
                    color: colorBlack2,
                    fontSize: fontSize13,
                    fontWeight: fontWeightRegular),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none)),
      );

  _getProblemBetterList(String _searchText, BuildContext context) {
    List<ProblemWorstBetterModel> tempList = [];
    if (_searchText == null || _searchText.isEmpty) {
      tempList.addAll(_tempProblemBetterList);
    } else {
      List<ProblemWorstBetterModel> tempCondition = [];
      for (var item in _tempProblemBetterList) {
        if (item.reasonName != null) {
          if (item.reasonName
              .toLowerCase()
              .startsWith(_searchText.trim().toLowerCase())) {
            tempCondition.add(item);
          }
        }
      }
      if (tempCondition.isNotEmpty) {
        tempList.addAll(tempCondition);
      }
    }
    setState(() {
      _problemBetterList = tempList;
    });
  }

  _getProblemWorstList(String _searchText, BuildContext context) {
    List<ProblemWorstBetterModel> tempList = [];
    if (_searchText == null || _searchText.isEmpty) {
      tempList.addAll(_tempProblemWorstList);
    } else {
      List<ProblemWorstBetterModel> tempCondition = [];
      for (var item in _tempProblemWorstList) {
        if (item.reasonName != null) {
          if (item.reasonName
              .toLowerCase()
              .startsWith(_searchText.trim().toLowerCase())) {
            tempCondition.add(item);
          }
        }
      }
      if (tempCondition.isNotEmpty) {
        tempList.addAll(tempCondition);
      }
    }
    setState(() {
      _problemWorstList = tempList;
    });
  }

  Widget _problemBetterListView(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: spacing8, bottom: spacing8),
        child: Container(
          height: _problemBetterList.length > 4
              ? 200
              : _problemBetterList.length == 1
                  ? 50
                  : 100,
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _listOfBetterController,
            child: ListView.builder(
                controller: _listOfBetterController,
                shrinkWrap: true,
                itemCount: _problemBetterList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Text(_problemBetterList[index].reasonName,
                        style: TextStyle(
                            color: colorBlack2,
                            fontWeight: fontWeightSemiBold,
                            fontSize: fontSize14)),
                    trailing: _problemBetterList[index].isSelected
                        ? Image.asset("images/checkedCheck.png",
                            height: 24, width: 24)
                        : Image.asset("images/uncheckedCheck.png",
                            height: 24, width: 24),
                    onTap: () {
                      setState(() => _problemBetterList[index].isSelected =
                          !_problemBetterList[index].isSelected);
                    },
                  );
                }),
          ),
        ),
      );

  Widget _selectedProblemBetterListItems(BuildContext context) =>
      ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PopupMenuButton(
              offset: Offset(300, 50),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                _popMenuCommonItem(context, Localization.of(context).remove,
                    FileConstants.icRemoveBlack)
              ],
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "${index + 1}. " + _selectedProblemBetterList[index],
                  style: TextStyle(
                      fontWeight: fontWeightMedium,
                      fontSize: fontSize14,
                      color: colorBlack2),
                ),
                trailing: Icon(Icons.more_vert, color: colorBlack2),
              ),
              onSelected: (value) {
                setState(() {
                  _selectedProblemBetterList
                      .remove(_selectedProblemBetterList[index]);
                });
              },
            );
          },
          itemCount: _selectedProblemBetterList.length);

  Widget _buildSearchForProblemWorst(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: spacing2),
        height: 40,
        decoration: BoxDecoration(
            color: colorBlack2.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TextFormField(
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 1,
            minLines: 1,
            controller: _problemWorstController,
            textAlignVertical: TextAlignVertical.center,
            focusNode: _problemWorstFocusNode,
            onChanged: (value) {
              _getProblemWorstList(value, context);
            },
            decoration: InputDecoration(
                prefixIconConstraints: BoxConstraints(),
                isDense: true,
                prefixIcon: GestureDetector(
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.all(spacing8),
                        child: Image.asset(FileConstants.icSearchBlack,
                            color: colorBlack2, width: 20, height: 20))),
                hintText:
                    Localization.of(context).actuallyMakesYourProblemWorst,
                hintStyle: TextStyle(
                    color: colorBlack2,
                    fontSize: fontSize13,
                    fontWeight: fontWeightRegular),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none)),
      );

  Widget _problemWorstListView(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: spacing8, bottom: spacing8),
        child: Container(
          height: _problemWorstList.length > 4
              ? 200
              : _problemWorstList.length == 1
                  ? 50
                  : 100,
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _listOfWorstController,
            child: ListView.builder(
                controller: _listOfWorstController,
                shrinkWrap: true,
                itemCount: _problemWorstList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Row(children: [
                      Text(_problemWorstList[index].reasonName,
                          style: TextStyle(
                              color: colorBlack2,
                              fontWeight: fontWeightSemiBold,
                              fontSize: fontSize14))
                    ]),
                    trailing: _problemWorstList[index].isSelected
                        ? Image.asset("images/checkedCheck.png",
                            height: 24, width: 24)
                        : Image.asset("images/uncheckedCheck.png",
                            height: 24, width: 24),
                    onTap: () {
                      setState(() => _problemWorstList[index].isSelected =
                          !_problemWorstList[index].isSelected);
                    },
                  );
                }),
          ),
        ),
      );

  Widget _selectedProblemWorstListItems(BuildContext context) =>
      ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PopupMenuButton(
              offset: Offset(300, 50),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                _popMenuSecondCommonItem(
                    context,
                    Localization.of(context).remove,
                    FileConstants.icRemoveBlack)
              ],
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  "${index + 1}. " + _selectedProblemWorstList[index],
                  style: TextStyle(
                      fontWeight: fontWeightMedium,
                      fontSize: fontSize14,
                      color: colorBlack2),
                ),
                trailing: Icon(Icons.more_vert, color: colorBlack2),
              ),
              onSelected: (value) {
                setState(() {
                  _selectedProblemWorstList
                      .remove(_selectedProblemWorstList[index]);
                });
              },
            );
          },
          itemCount: _selectedProblemWorstList.length);

  Widget _popMenuSecondCommonItem(
          BuildContext context, String value, String image) =>
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

  Widget _headerView(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing20),
        child: Text(
          Localization.of(context).conditionAffectedHeader,
          style: TextStyle(
              color: Color(0xff0e1c2a),
              fontSize: fontSize16,
              fontWeight: fontWeightBold),
        ),
      );

  Widget _activityEffectList(BuildContext context) => ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return SizedBox(height: spacing15);
      },
      itemCount: _activityList.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _activityList[index].timeLabel,
              style: TextStyle(
                  fontWeight: fontWeightRegular,
                  fontSize: fontSize14,
                  color: colorBlack2),
            ),
            Radio(
                activeColor: AppColors.persian_blue,
                groupValue: radioVal,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: _activityList[index].index,
                onChanged: (val) {
                  setState(() {
                    radioVal = val;
                  });
                  _activityList.forEach((element) {
                    if (element.index == radioVal) {
                      _activityList[index].isSelected = true;
                    } else {
                      _activityList[index].isSelected = false;
                    }
                  });
                }),
          ],
        );
      });

  Widget _treatedConditionHeader(BuildContext context, String header) =>
      Padding(
        padding: EdgeInsets.only(top: spacing20, bottom: spacing10),
        child: Text(
          header,
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
            _isTreated = true;
          });
          // _wholeBodyController
          //     .jumpTo(_wholeBodyController.position.maxScrollExtent);
          _wholeBodyController.animateTo(
              _wholeBodyController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease);
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: _isTreated ? colorWhite : colorPurple100,
        color: _isTreated ? colorPurple100 : colorWhite,
        height: 34,
      );

  Widget _noButtonWidget(BuildContext context) => HutanoButton(
        borderColor: colorGrey,
        label: Localization.of(context).no,
        onPressed: () {
          setState(() {
            _isTreated = false;
          });
        },
        buttonType: HutanoButtonType.onlyLabel,
        width: 65,
        labelColor: !_isTreated ? colorWhite : colorPurple100,
        color: !_isTreated ? colorPurple100 : colorWhite,
        borderWidth: 1,
        height: 34,
      );

  Widget _howLongAgoHeader(BuildContext context) => _isTreated
      ? Padding(
          padding: EdgeInsets.only(top: spacing20, bottom: spacing10),
          child: Text(
            Localization.of(context).howLongAgoHeader,
            style: TextStyle(
                color: Color(0xff0e1c2a),
                fontSize: fontSize16,
                fontWeight: fontWeightBold),
          ),
        )
      : SizedBox();

  Widget _commonProblemHeaderWidget(BuildContext context, String header,
          bool isSelected, bool isProblem) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: spacing8),
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: spacing15, vertical: spacing10),
            decoration: BoxDecoration(
                color: isSelected ? AppColors.windsor : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                )),
            child: Text(
              header,
              style: TextStyle(
                  fontSize: fontSize14,
                  fontWeight: fontWeightRegular,
                  color: isSelected ? Colors.white : AppColors.windsor),
            )),
      ).onClick(onTap: () {
        if (isProblem) {
          updateVisibility(header, isProblem);
        } else {
          updateVisibility(header, isProblem);
        }
      });

  Widget _commonHeaderWidget(BuildContext context, String header,
          bool isSelected, bool isProblem) =>
      _isTreated
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: spacing8),
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: spacing15, vertical: spacing10),
                  decoration: BoxDecoration(
                      color: isSelected ? AppColors.windsor : Colors.white,
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                  child: Text(
                    header,
                    style: TextStyle(
                        fontSize: fontSize14,
                        fontWeight: fontWeightRegular,
                        color: isSelected ? Colors.white : AppColors.windsor),
                  )),
            ).onClick(onTap: () {
              if (isProblem) {
                updateVisibility(header, isProblem);
              } else {
                updateVisibility(header, isProblem);
              }
            })
          : SizedBox();

  Widget _horizontalProblemSelectionWidget(
          BuildContext context,
          List<CommonTimeModel> listOfItems,
          String labelTime,
          bool isForProblem) =>
      Padding(
        padding: const EdgeInsets.all(spacing8),
        child: Container(
          height: 40,
          child: ListView.separated(
              itemCount: listOfItems.length,
              separatorBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing5));
              },
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                    height: labelTime == AppConstants.years ? 50 : 40,
                    width: labelTime == AppConstants.years ? 50 : 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: listOfItems[index].isSelected
                            ? AppColors.windsor
                            : Colors.white,
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        )),
                    child: Text(
                      listOfItems[index].value,
                      style: TextStyle(
                          color: listOfItems[index].isSelected
                              ? Colors.white
                              : AppColors.windsor,
                          fontSize: fontSize14,
                          fontWeight: fontWeightRegular),
                    )).onClick(onTap: () {
                  setState(() {
                    listOfItems.forEach((element) {
                      if (element.index == listOfItems[index].index) {
                        element.isSelected = true;
                        if (isForProblem) {
                          updateSelectedValue(
                              labelTime, element.value, isForProblem);
                        } else {
                          updateSelectedValue(
                              labelTime, element.value, isForProblem);
                        }
                      } else {
                        element.isSelected = false;
                      }
                    });
                  });
                });
              }),
        ),
      );

  Widget _horizontalSelectionWidget(
          BuildContext context,
          List<CommonTimeModel> listOfItems,
          String labelTime,
          bool isForProblem) =>
      _isTreated
          ? Padding(
              padding: const EdgeInsets.all(spacing8),
              child: Container(
                height: 40,
                child: ListView.separated(
                    itemCount: listOfItems.length,
                    separatorBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: spacing5));
                    },
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                          height: labelTime == AppConstants.years ? 50 : 40,
                          width: labelTime == AppConstants.years ? 50 : 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: listOfItems[index].isSelected
                                  ? AppColors.windsor
                                  : Colors.white,
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              )),
                          child: Text(
                            listOfItems[index].value,
                            style: TextStyle(
                                color: listOfItems[index].isSelected
                                    ? Colors.white
                                    : AppColors.windsor,
                                fontSize: fontSize14,
                                fontWeight: fontWeightRegular),
                          )).onClick(onTap: () {
                        setState(() {
                          listOfItems.forEach((element) {
                            if (element.index == listOfItems[index].index) {
                              element.isSelected = true;
                              if (isForProblem) {
                                updateSelectedValue(
                                    labelTime, element.value, isForProblem);
                              } else {
                                updateSelectedValue(
                                    labelTime, element.value, isForProblem);
                              }
                            } else {
                              element.isSelected = false;
                            }
                          });
                        });
                      });
                    }),
              ),
            )
          : SizedBox();

  Widget _describeSymptomsList(BuildContext context) => Container(
        height: 40,
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(width: spacing20);
            },
            scrollDirection: Axis.horizontal,
            itemCount: _listOfDescribeSymptoms.length,
            itemBuilder: (context, index) {
              return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: spacing15, vertical: spacing10),
                      decoration: BoxDecoration(
                          color: _listOfDescribeSymptoms[index].isSelected
                              ? AppColors.windsor
                              : Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(_listOfDescribeSymptoms[index].symptom,
                          style: TextStyle(
                              fontSize: fontSize14,
                              fontWeight: fontWeightRegular,
                              color: _listOfDescribeSymptoms[index].isSelected
                                  ? Colors.white
                                  : AppColors.windsor)))
                  .onClick(onTap: () {
                setState(() {
                  _isPressedOnProblemImproving = true;
                  _listOfDescribeSymptoms.forEach((element) {
                    if (element.index == _listOfDescribeSymptoms[index].index) {
                      element.isSelected = true;
                    } else {
                      element.isSelected = false;
                    }
                  });
                });
              });
            }),
      );

  void updateSelectedValue(String labelStr, String val, bool isForProblem) {
    setState(() {
      if (labelStr == AppConstants.hours) {
        if (!isForProblem) {
          _selectedType = "1";
          _selectedValue = val;
        } else {
          _selectedProType = "1";
          _selectedProValue = val;
        }
      } else if (labelStr == AppConstants.days) {
        if (!isForProblem) {
          _selectedType = "2";
          _selectedValue = val;
        } else {
          _selectedProType = "2";
          _selectedProValue = val;
        }
      } else if (labelStr == AppConstants.weeks) {
        if (!isForProblem) {
          _selectedType = "3";
          _selectedValue = val;
        } else {
          _selectedProType = "3";
          _selectedProValue = val;
        }
      } else if (labelStr == AppConstants.monthsConst) {
        if (!isForProblem) {
          _selectedType = "4";
          _selectedValue = val;
        } else {
          _selectedProType = "4";
          _selectedProValue = val;
        }
      } else if (labelStr == AppConstants.years) {
        if (!isForProblem) {
          _selectedType = "5";
          _selectedValue = val;
        } else {
          _selectedProType = "5";
          _selectedProValue = val;
        }
      }
    });
  }

  void updateVisibility(String val, bool isProblem) {
    setState(() {
      if (val == AppConstants.hours) {
        if (isProblem) {
          _isProHourVisible = true;
          _isProDayVisible = false;
          _isProWeekVisible = false;
          _isProMonthVisible = false;
          _isProYearVisible = false;
          _resetValues(val, isProblem);
        } else {
          _isHourVisible = true;
          _isDayVisible = false;
          _isWeekVisible = false;
          _isMonthVisible = false;
          _isYearVisible = false;
          _resetValues(val, isProblem);
        }
      } else if (val == AppConstants.days) {
        if (isProblem) {
          _isProHourVisible = false;
          _isProDayVisible = true;
          _isProWeekVisible = false;
          _isProMonthVisible = false;
          _isProYearVisible = false;
          _resetValues(val, isProblem);
        } else {
          _isHourVisible = false;
          _isDayVisible = true;
          _isWeekVisible = false;
          _isMonthVisible = false;
          _isYearVisible = false;
          _resetValues(val, isProblem);
        }
      } else if (val == AppConstants.weeks) {
        if (isProblem) {
          _isProHourVisible = false;
          _isProDayVisible = false;
          _isProWeekVisible = true;
          _isProMonthVisible = false;
          _isProYearVisible = false;
          _resetValues(val, isProblem);
        } else {
          _isHourVisible = false;
          _isDayVisible = false;
          _isWeekVisible = true;
          _isMonthVisible = false;
          _isYearVisible = false;
          _resetValues(val, isProblem);
        }
      } else if (val == AppConstants.monthsConst) {
        if (isProblem) {
          _isProHourVisible = false;
          _isProDayVisible = false;
          _isProWeekVisible = false;
          _isProMonthVisible = true;
          _isProYearVisible = false;
          _resetValues(val, isProblem);
        } else {
          _isHourVisible = false;
          _isDayVisible = false;
          _isWeekVisible = false;
          _isMonthVisible = true;
          _isYearVisible = false;
          _resetValues(val, isProblem);
        }
      } else if (val == AppConstants.years) {
        if (isProblem) {
          _isProHourVisible = false;
          _isProDayVisible = false;
          _isProWeekVisible = false;
          _isProMonthVisible = false;
          _isProYearVisible = true;
          _resetValues(val, isProblem);
        } else {
          _isHourVisible = false;
          _isDayVisible = false;
          _isWeekVisible = false;
          _isMonthVisible = false;
          _isYearVisible = true;
          _resetValues(val, isProblem);
        }
      }
    });
  }

  void _resetValues(String val, bool isProblem) {
    setState(() {
      if (isProblem) {
        _selectedProValue = "0";
      } else {
        _selectedValue = "0";
      }
      if (val == AppConstants.hours) {
        if (isProblem) {
          _proDaysList.forEach((element) {
            element.isSelected = false;
          });
          _proWeeksList.forEach((element) {
            element.isSelected = false;
          });
          _proMonthsList.forEach((element) {
            element.isSelected = false;
          });
          _proYearsList.forEach((element) {
            element.isSelected = false;
          });
        } else {
          _daysList.forEach((element) {
            element.isSelected = false;
          });
          _weeksList.forEach((element) {
            element.isSelected = false;
          });
          _monthsList.forEach((element) {
            element.isSelected = false;
          });
          _yearsList.forEach((element) {
            element.isSelected = false;
          });
        }
      } else if (val == AppConstants.days) {
        if (isProblem) {
          _proHoursList.forEach((element) {
            element.isSelected = false;
          });
          _proWeeksList.forEach((element) {
            element.isSelected = false;
          });
          _proMonthsList.forEach((element) {
            element.isSelected = false;
          });
          _proYearsList.forEach((element) {
            element.isSelected = false;
          });
        } else {
          _hoursList.forEach((element) {
            element.isSelected = false;
          });
          _weeksList.forEach((element) {
            element.isSelected = false;
          });
          _monthsList.forEach((element) {
            element.isSelected = false;
          });
          _yearsList.forEach((element) {
            element.isSelected = false;
          });
        }
      } else if (val == AppConstants.weeks) {
        if (isProblem) {
          _proHoursList.forEach((element) {
            element.isSelected = false;
          });
          _proDaysList.forEach((element) {
            element.isSelected = false;
          });
          _proMonthsList.forEach((element) {
            element.isSelected = false;
          });
          _proYearsList.forEach((element) {
            element.isSelected = false;
          });
        } else {
          _hoursList.forEach((element) {
            element.isSelected = false;
          });
          _daysList.forEach((element) {
            element.isSelected = false;
          });
          _monthsList.forEach((element) {
            element.isSelected = false;
          });
          _yearsList.forEach((element) {
            element.isSelected = false;
          });
        }
      } else if (val == AppConstants.monthsConst) {
        if (isProblem) {
          _proHoursList.forEach((element) {
            element.isSelected = false;
          });
          _proDaysList.forEach((element) {
            element.isSelected = false;
          });
          _proWeeksList.forEach((element) {
            element.isSelected = false;
          });
          _proYearsList.forEach((element) {
            element.isSelected = false;
          });
        } else {
          _hoursList.forEach((element) {
            element.isSelected = false;
          });
          _daysList.forEach((element) {
            element.isSelected = false;
          });
          _weeksList.forEach((element) {
            element.isSelected = false;
          });
          _yearsList.forEach((element) {
            element.isSelected = false;
          });
        }
      } else if (val == AppConstants.years) {
        if (isProblem) {
          _proHoursList.forEach((element) {
            element.isSelected = false;
          });
          _proDaysList.forEach((element) {
            element.isSelected = false;
          });
          _proWeeksList.forEach((element) {
            element.isSelected = false;
          });
          _proMonthsList.forEach((element) {
            element.isSelected = false;
          });
        } else {
          _hoursList.forEach((element) {
            element.isSelected = false;
          });
          _daysList.forEach((element) {
            element.isSelected = false;
          });
          _weeksList.forEach((element) {
            element.isSelected = false;
          });
          _monthsList.forEach((element) {
            element.isSelected = false;
          });
        }
      }
    });
  }

  void _getHealthConditionDetails(
      BuildContext context, ReqSelectConditionModel reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().getHealthConditionDetails(reqModel).then(((result) {
      if (result is ResSelectConditionModel) {
        setState(() {
          result.response[0].problemBetter.forEach((element) {
            _problemBetterList.add(ProblemWorstBetterModel(element, false));
          });
          result.response[0].problemBetter.forEach((element) {
            _tempProblemBetterList.add(ProblemWorstBetterModel(element, false));
          });
          result.response[0].problemWorst.forEach((element) {
            _problemWorstList.add(ProblemWorstBetterModel(element, false));
          });
          result.response[0].problemWorst.forEach((element) {
            _tempProblemWorstList.add(ProblemWorstBetterModel(element, false));
          });
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
        _getAllHealthConditions(context);
      }
    })).catchError((dynamic e) {
      _getAllHealthConditions(context);
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
        return 'All Over';
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
    } else if (side == "Front") {
      return "4";
    } else {
      return "5";
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
    _selectedProblemWorstList = [];
    _problemWorstList.forEach((element) {
      if (element.isSelected) {
        _selectedProblemWorstList.add(element.reasonName);
      }
    });
    _selectedProblemBetterList = [];
    _problemBetterList.forEach((element) {
      if (element.isSelected) {
        _selectedProblemBetterList.add(element.reasonName);
      }
    });
    Problems model = Problems(
      problemId: widget.problemId,
      image: widget.problemImage,
      name: widget.problemName,
      bodyPart: bodyPartWithSide,
      problemRating: _discomfortIntensity.toInt(),
      symptoms: selectedSymptoms,
      dailyActivity: radioVal != null ? radioVal.toString() : "",
      problemBetter: _selectedProblemBetterList,
      problemWorst: _selectedProblemWorstList,
      isProblemImproving: "",
      isTreatmentReceived: _isTreated ? "1" : "0",
      problemFacingTimeSpan: _selectedProValue != "0"
          ? ProblemFacingTimeSpan(
              type: _selectedProType, period: _selectedProValue)
          : ProblemFacingTimeSpan(type: "", period: ""),
      treatmentReceived: !_isTreated
          ? ProblemFacingTimeSpan(type: "", period: "")
          : _selectedValue != "0"
              ? ProblemFacingTimeSpan(
                  type: _selectedType, period: _selectedValue)
              : ProblemFacingTimeSpan(type: "", period: ""),
    );
    _listOfDescribeSymptoms.forEach((element) {
      if (element.index == 1) {
        if (element.isSelected) {
          if (_isPressedOnProblemImproving) {
            model.isProblemImproving = "0";
          }
        }
      } else if (element.index == 2) {
        if (element.isSelected) {
          if (_isPressedOnProblemImproving) {
            model.isProblemImproving = "1";
          }
        }
      } else if (element.index == 3) {
        if (element.isSelected) {
          if (_isPressedOnProblemImproving) {
            model.isProblemImproving = "2";
          }
        }
      }
    });
    List<Problems> finalProblems =
        Provider.of<HealthConditionProvider>(context, listen: false)
            .allHealthIssuesData;
    finalProblems.add(model);
    finalProblems.forEach((element) {
      element.problemBetter.toString().debugLog();
      element.problemWorst.toString().debugLog();
    });
    Provider.of<HealthConditionProvider>(context, listen: false)
        .updateAllHealthIssuesData(finalProblems);
    if (Provider.of<HealthConditionProvider>(context, listen: false)
            .currentIndexOfIssue ==
        Provider.of<HealthConditionProvider>(context, listen: false)
                .listOfSelectedHealthIssues
                .length -
            1) {
      Navigator.of(context).pushNamed(Routes.allImagesTabsScreen);
    } else {
      Provider.of<HealthConditionProvider>(context, listen: false)
          .incrementCurrentIndex();
      for (int i = 0;
          i <
              Provider.of<HealthConditionProvider>(context, listen: false)
                  .listOfSelectedHealthIssues
                  .length;
          i++) {
        if (i ==
            Provider.of<HealthConditionProvider>(context, listen: false)
                .currentIndexOfIssue) {
          Navigator.of(context)
              .pushNamed(Routes.routeBoneAndMuscle, arguments: {
            ArgumentConstant.problemIdKey:
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .listOfSelectedHealthIssues[i]
                    .sId,
            ArgumentConstant.problemNameKey:
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .listOfSelectedHealthIssues[i]
                    .name,
            ArgumentConstant.problemImageKey:
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .listOfSelectedHealthIssues[i]
                    .image
          });
        }
      }
    }
  }

  void _getAllHealthConditions(BuildContext context) async {
    await ApiManager().getMoreConditions().then((result) {
      ProgressDialogUtils.dismissProgressDialog();
      if (result is ResMoreConditionModel) {
        setState(() {
          _conditionList = result.response;
        });
      }
    }).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
