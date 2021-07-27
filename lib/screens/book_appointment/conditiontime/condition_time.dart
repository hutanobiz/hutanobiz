import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/common_res.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/book_appointment/conditiontime/model/common_time_model.dart';
import 'package:hutano/screens/book_appointment/conditiontime/model/req_treated_condition_time.dart';
import 'package:hutano/screens/book_appointment/multiplehealthissues/model/describe_symptoms_model.dart';
import 'package:hutano/utils/app_constants.dart';

import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_constants.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/loading_background_new.dart';

import '../../../colors.dart';
import '../../../routes.dart';

class ConditionTimeScreen extends StatefulWidget {
  final bool isForProblem;
  ConditionTimeScreen({this.isForProblem = false});
  @override
  _ConditionTimeScreenState createState() => _ConditionTimeScreenState();
}

class _ConditionTimeScreenState extends State<ConditionTimeScreen> {
  bool _isTreated = false;
  List<CommonTimeModel> _hoursList = [];
  List<CommonTimeModel> _daysList = [];
  List<CommonTimeModel> _weeksList = [];
  List<CommonTimeModel> _monthsList = [];
  List<CommonTimeModel> _yearsList = [];
  int totalHours = 23;
  int totalDays = 6;
  int totalWeeks = 3;
  int totalMonths = 11;
  int totalYears = DateTime.now().year;
  String _selectedHour = "0";
  String _selectedDay = "0";
  String _selectedWeek = "0";
  String _selectedMonth = "0";
  String _selectedYear = int.parse(getString(AppPreference.dobKey)
          .substring(getString(AppPreference.dobKey).length - 4))
      .toString();
  bool _isHourVisible = false,
      _isDayVisible = false,
      _isWeekVisible = false,
      _isMonthVisible = false,
      _isYearVisible = false;
  List<DescribeSymptomsModel> _listOfSymptoms = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      for (var i = 0; i < totalHours; i++) {
        _hoursList.add(CommonTimeModel("${i + 1}", false, i));
      }
      for (var i = 0; i < totalDays; i++) {
        _daysList.add(CommonTimeModel("${i + 1}", false, i));
      }
      for (var i = 0; i < totalWeeks; i++) {
        _weeksList.add(CommonTimeModel("${i + 1}", false, i));
      }
      for (var i = 0; i < totalMonths; i++) {
        _monthsList.add(CommonTimeModel("${i + 1}", false, i));
      }
      for (var i = int.parse(getString(AppPreference.dobKey)
              .substring(getString(AppPreference.dobKey).length - 4));
          i <= totalYears;
          i++) {
        _yearsList.add(CommonTimeModel("$i", false, i));
      }
      _listOfSymptoms.add(DescribeSymptomsModel("Improving", false, 1));
      _listOfSymptoms.add(DescribeSymptomsModel("Worsening", false, 2));
      _listOfSymptoms.add(DescribeSymptomsModel("Staying the same", false, 3));
      setState(() {
        if (widget.isForProblem) {
          _isTreated = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        resizeToAvoidBottomInset: false,
        body: LoadingBackgroundNew(
            title: "",
            addHeader: true,
            addBottomArrows: true,
            onForwardTap: () {
              if (_isTreated) {
                if (!widget.isForProblem) {
                  _onForwardButtonTap(context);
                } else {
                  //TODO API INTEGRATION IS PENDING
                  // Navigator.pushNamed(context, routeConditionTimeScreen,
                  //     arguments: {ArgumentConstant.isForProblemKey: false});
                }
              } else {
                // Navigator.of(context).pushNamed(Routes.allImagesTabsScreen);
              }
            },
            color: Colors.white,
            padding: EdgeInsets.only(left: spacing20, bottom: spacing70),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _treatedConditionHeader(
                      context,
                      widget.isForProblem
                          ? Localization.of(context).howLongHadProblemHeader
                          : Localization.of(context).treatedForCondition),
                  if (!widget.isForProblem) SizedBox(height: spacing10),
                  if (!widget.isForProblem)
                    Row(children: [
                      _yesButtonWidget(context),
                      SizedBox(width: spacing15),
                      _noButtonWidget(context),
                    ]),
                  if (!widget.isForProblem) _howLongAgoHeader(context),
                  _commonHeaderWidget(context,
                      Localization.of(context).hoursLabel, _isHourVisible),
                  if (_isHourVisible)
                    _horizontalSelectionWidget(
                        context, _hoursList, AppConstants.hours),
                  _commonHeaderWidget(context,
                      Localization.of(context).daysLabel, _isDayVisible),
                  if (_isDayVisible)
                    _horizontalSelectionWidget(
                        context, _daysList, AppConstants.days),
                  _commonHeaderWidget(context,
                      Localization.of(context).weeksLabel, _isWeekVisible),
                  if (_isWeekVisible)
                    _horizontalSelectionWidget(
                        context, _weeksList, AppConstants.weeks),
                  _commonHeaderWidget(context,
                      Localization.of(context).monthsLabel, _isMonthVisible),
                  if (_isMonthVisible)
                    _horizontalSelectionWidget(
                        context, _monthsList, AppConstants.monthsConst),
                  _commonHeaderWidget(context,
                      Localization.of(context).yearsLabel, _isYearVisible),
                  if (_isYearVisible)
                    _horizontalSelectionWidget(
                        context, _yearsList, AppConstants.years),
                  if (widget.isForProblem && _listOfSymptoms.isNotEmpty)
                    _treatedConditionHeader(
                        context, Localization.of(context).theProblemIsHeader),
                  if (widget.isForProblem) _symptomsList(context),
                ],
              ),
            )));
  }

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

  Widget _commonHeaderWidget(
          BuildContext context, String header, bool isSelected) =>
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
              updateVisibility(header);
            })
          : SizedBox();

  Widget _horizontalSelectionWidget(BuildContext context,
          List<CommonTimeModel> listOfItems, String labelTime) =>
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
                              updateSelectedValue(labelTime, element.value);
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

  void updateSelectedValue(String labelStr, String val) {
    setState(() {
      if (labelStr == AppConstants.hours) {
        _selectedHour = val;
      } else if (labelStr == AppConstants.days) {
        _selectedDay = val;
      } else if (labelStr == AppConstants.weeks) {
        _selectedWeek = val;
      } else if (labelStr == AppConstants.monthsConst) {
        _selectedMonth = val;
      } else if (labelStr == AppConstants.years) {
        _selectedYear = val;
      }
    });
  }

  void updateVisibility(String val) {
    setState(() {
      if (val == AppConstants.hours) {
        _isHourVisible = true;
        _isDayVisible = false;
        _isWeekVisible = false;
        _isMonthVisible = false;
        _isYearVisible = false;
      } else if (val == AppConstants.days) {
        _isHourVisible = false;
        _isDayVisible = true;
        _isWeekVisible = false;
        _isMonthVisible = false;
        _isYearVisible = false;
      } else if (val == AppConstants.weeks) {
        _isHourVisible = false;
        _isDayVisible = false;
        _isWeekVisible = true;
        _isMonthVisible = false;
        _isYearVisible = false;
      } else if (val == AppConstants.monthsConst) {
        _isHourVisible = false;
        _isDayVisible = false;
        _isWeekVisible = false;
        _isMonthVisible = true;
        _isYearVisible = false;
      } else if (val == AppConstants.years) {
        _isHourVisible = false;
        _isDayVisible = false;
        _isWeekVisible = false;
        _isMonthVisible = false;
        _isYearVisible = true;
      }
    });
  }

  void _onForwardButtonTap(BuildContext context) {
    List<LongAgo> agoList = [];
    agoList.add(LongAgo(
        hour: _selectedHour,
        day: _selectedDay,
        month: _selectedMonth,
        week: _selectedWeek,
        year: _selectedYear));
    final reqModel = ReqTreatedConditionTimeModel(
        flag: Localization.of(context).yes, longAgo: agoList);
    _addTreatedConditionTimeData(context, reqModel);
  }

  void _addTreatedConditionTimeData(
      BuildContext context, ReqTreatedConditionTimeModel reqModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager().addTreatedConditionTime(reqModel).then(((result) {
      if (result is CommonRes) {
        ProgressDialogUtils.dismissProgressDialog();
        if (widget.isForProblem) {
          Navigator.pushNamed(context, Routes.routeConditionTimeScreen,
              arguments: {ArgumentConstant.isForProblemKey: false});
        } else {
          // Navigator.of(context).pushNamed(Routes.allImagesTabsScreen);
        }
      }
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
