import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/schedule.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/scrolling_day_calendar_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class SelectAppointmentTimeScreen extends StatefulWidget {
  final bool isEditDateTime;

  const SelectAppointmentTimeScreen({Key key, this.isEditDateTime})
      : super(key: key);

  @override
  _SelectAppointmentTimeScreenState createState() =>
      _SelectAppointmentTimeScreenState();
}

class _SelectAppointmentTimeScreenState
    extends State<SelectAppointmentTimeScreen> {
  Map _providerData;
  Future<List<Schedule>> _scheduleFuture;
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  Map _dayDateMap = Map();

  List<Schedule> _morningList = List();
  List<Schedule> _afternoonList = List();
  List<Schedule> _eveningList = List();

  List<Schedule> _scheduleList;
  InheritedContainerState _container;

  String _selectedTiming;
  DateTime _selectedDate;
  Map profileMap = new Map();
  String currentDate;
  String averageRating = "0";

  bool isEditDateTime = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditDateTime != null) {
      isEditDateTime = widget.isEditDateTime;
    }

    currentDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
    _selectedDate = DateTime.now();

    _dayDateMap["day"] = DateTime.now().weekday.toString();
    _dayDateMap["date"] = currentDate;
  }

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    _providerData = _container.getProviderData();
    Map _servicesMap = _container.selectServiceMap;

    _dayDateMap["status"] = _servicesMap["status"];

    if (_servicesMap["services"] != null) {
      List<Services> _servicesList = _servicesMap["services"];

      if (_servicesList.length > 0) {
        for (int i = 0; i < _servicesList.length; i++) {
          _dayDateMap["subService[${i.toString()}]"] =
              _servicesList[i].subServiceId;
        }
      }
    }

    if (_providerData["providerData"]["data"] != null) {
      averageRating =
          _providerData["providerData"]["averageRating"]?.toStringAsFixed(2) ??
              "0";

      _providerData["providerData"]["data"].map((f) {
        profileMap.addAll(f);
      }).toList();
    } else {
      profileMap = _providerData["providerData"];
      averageRating = profileMap["averageRating"]?.toStringAsFixed(2) ?? "0";
    }

    _scheduleFuture = _apiBaseHelper
        .getScheduleList(
          profileMap["userId"]["_id"].toString(),
          _dayDateMap,
        )
        .timeout(Duration(seconds: 10));

    _selectedTiming = null;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Select an Appointment Time",
        color: AppColors.snow,
        isAddBack: false,
        addBottomArrows: true,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 70.0),
          children: widgetList(),
        ),
        onForwardTap: () {
          if (_selectedDate != null && _selectedTiming != null) {
            _container.setAppointmentData("date", _selectedDate);
            _container.setAppointmentData("time", _selectedTiming);

            if (isEditDateTime) {
              Navigator.pop(context, _container.appointmentData);
            } else {
              Navigator.of(context).pushNamed(Routes.consentToTreatScreen);
            }
          } else {
            Widgets.showToast("Please select a timing");
          }
        },
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = new List();

    formWidget.add(ProviderWidget(
      data: profileMap,
      degree: _providerData["degree"].toString(),
      isOptionsShow: false,
      averageRating: averageRating,
    ));

    formWidget.add(ScrollingDayCalendar(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 14)),
      selectedDate: DateTime.now(),
      displayDateFormat: "EEEE, dd MMMM",
      onDateChange: (DateTime selectedDate) {
        _dayDateMap["day"] = selectedDate.weekday.toString();
        _dayDateMap["date"] =
            DateFormat("MM/dd/yyyy").format(selectedDate).toString();

        setState(() {
          _scheduleFuture = _apiBaseHelper
              .getScheduleList(
                profileMap["userId"]["_id"].toString(),
                _dayDateMap,
              )
              .futureError(
                (error) => error.toString().debugLog(),
              );
        });

        _selectedDate = selectedDate;
      },
    ));

    formWidget.add(SizedBox(height: 20.0));

    formWidget.add(_futureWidget());

    return formWidget;
  }

  Widget _futureWidget() {
    return FutureBuilder<List<Schedule>>(
      future: _scheduleFuture,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("NO data available");
            break;
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              _morningList.clear();
              _eveningList.clear();
              _afternoonList.clear();
              _scheduleList = snapshot.data;

              for (Schedule schedule in _scheduleList) {
                int prefixValue =
                    int.parse(schedule.startTime.toString().substring(0, 2));

                if (currentDate == _dayDateMap["date"]) {
                  if (DateTime.now().hour < prefixValue) {
                    if (prefixValue < 12) {
                      _morningList.add(schedule);
                    } else if (12 <= prefixValue && prefixValue < 18) {
                      _afternoonList.add(schedule);
                    } else {
                      _eveningList.add(schedule);
                    }
                  }
                } else {
                  if (prefixValue < 12) {
                    _morningList.add(schedule);
                  } else if (12 <= prefixValue && prefixValue < 18) {
                    _afternoonList.add(schedule);
                  } else {
                    _eveningList.add(schedule);
                  }
                }
              }

              return Column(
                children: <Widget>[
                  _timingWidget("Morning", "ic_morning", _morningList),
                  SizedBox(height: 40.0),
                  _timingWidget("Afternoon", "ic_afternoon", _afternoonList),
                  SizedBox(height: 40.0),
                  _timingWidget("Evening", "ic_night", _eveningList),
                ],
              );
            } else if (snapshot.hasError) {
              snapshot.error.toString().debugLog();
              return Center(
                child: Text("NO slots available"),
              );
            }

            break;
        }
        return Container();
      },
    );
  }

  Widget _timingWidget(String timeType, String icon, List<Schedule> list) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 15.0,
              height: 18.0,
              image: AssetImage("images/$icon.png"),
            ),
            SizedBox(width: 9.0),
            Text(
              timeType,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6.0),
            Text(
              "${list.length.toString()} slots",
              style: TextStyle(
                fontSize: 11.0,
                color: AppColors.goldenTainoi,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 18.0),
        Container(
          height: 40.0,
          child: list.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return _slotWidget(list[index]);
                  },
                )
              : Text("NO slots available"),
        )
      ],
    );
  }

  Widget _slotWidget(Schedule currentSchedule) {
    String timing = TimeOfDay(
            hour:
                int.parse(currentSchedule.startTime.toString().substring(0, 2)),
            minute:
                int.parse(currentSchedule.startTime.toString().substring(3)))
        .format(context)
        .toString()
        .toLowerCase();

    return InkWell(
      onTap: currentSchedule.isBlock
          ? null
          : () {
              _scheduleList.forEach((f) => f.isSelected = false);

              setState(() {
                currentSchedule.isSelected = true;
              });

              _selectedTiming = currentSchedule.startTime.toString();
            },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: currentSchedule.isBlock
              ? Colors.grey.withOpacity(0.05)
              : currentSchedule.isSelected ? AppColors.windsor : AppColors.snow,
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          border: Border.all(
              color: currentSchedule.isBlock
                  ? Colors.grey.withOpacity(0.05)
                  : (currentSchedule.isSelected
                      ? AppColors.windsor
                      : Colors.grey[300]),
              width: 0.5),
        ),
        child: Text(
          timing,
          style: TextStyle(
            color: currentSchedule.isBlock
                ? Colors.grey.withOpacity(0.6)
                : currentSchedule.isSelected ? Colors.white : AppColors.windsor,
          ),
        ),
      ),
    );
  }
}
