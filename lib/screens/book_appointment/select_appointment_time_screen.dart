import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/schedule.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/scrolling_day_calendar_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class SelectAppointmentTimeScreen extends StatefulWidget {
  final int fromScreen; //0-services,1-edit datetime,2-reschedule

  const SelectAppointmentTimeScreen({Key key, this.fromScreen = 0})
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
  String _timezone = 'Unknown';
  List<Schedule> _morningList = List();
  List<Schedule> _afternoonList = List();
  List<Schedule> _eveningList = List();

  List<Schedule> _scheduleList;
  InheritedContainerState _container;

  String _selectedTiming;
  DateTime _selectedDate, startDate;
  Map profileMap = new Map();
  String currentDate;
  String averageRating = "0";

  List<int> _scheduleDaysList = [];
  int _initialDay = 1;
  DateTime newDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // if (widget.isEditDateTime != null) {
    //   isEditDateTime = widget.isEditDateTime;
    // }

    currentDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
    _selectedDate = DateTime.now();

    _dayDateMap["day"] = DateTime.now().weekday.toString();
    _dayDateMap["date"] = currentDate;

    newDate = DateTime.now();
    // _initData();
  }

  // Future<void> _initData() async {
  //   try {
  //     _timezone = await FlutterNativeTimezone.getLocalTimezone();
  //   } catch (e) {
  //     print('Could not get the local timezone');
  //   }
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
    _providerData = _container.getProviderData();
    Map _servicesMap = _container.selectServiceMap;

    if (_container.projectsResponse != null) {
      _dayDateMap["appointmentType"] =
          _container.projectsResponse['serviceType']?.toString() ?? '0';
    }

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

    _getScheduleDaysList();
    _scheduleDaysList.sort();
    if (_scheduleDaysList.length > 0) {
      if (_scheduleDaysList.contains(DateTime.now().weekday)) {
        _dayDateMap["day"] = DateTime.now().weekday.toString();
        _dayDateMap["date"] = currentDate;
        startDate = DateTime.now();
      } else {
        for (int i = 0; i < 7; i++) {
          if (_scheduleDaysList
              .contains(DateTime.now().add(Duration(days: i + 1)).weekday)) {
            _dayDateMap["day"] =
                DateTime.now().add(Duration(days: i + 1)).weekday.toString();
            _dayDateMap["date"] = DateFormat('MM/dd/yyyy')
                .format(DateTime.now().add(Duration(days: i + 1)));
            startDate = DateTime.now().add(Duration(days: i + 1));
            break;
          }
        }
      }
      try {
        _timezone = await FlutterNativeTimezone.getLocalTimezone();
      } catch (e) {
        print('Could not get the local timezone');
      }
      if (mounted) {
        setState(() {});
      }
      _dayDateMap["timezone"] = _timezone;

      while (true) {
        if (_scheduleDaysList.contains(newDate.weekday)) {
          setState(() {
            _selectedDate = newDate;
          });

          break;
        } else {
          setState(() {
            newDate = _selectedDate.add(
              Duration(days: _initialDay),
            );
          });
          _initialDay++;
        }
      }
    }

    _selectedDate.toString().debugLog();

    String providerId = '';

    if (profileMap["userId"] != null && profileMap["userId"] is Map) {
      providerId = profileMap["userId"]["_id"].toString();
    } else if (profileMap["User"] != null is Map) {
      providerId = profileMap["User"][0]["_id"].toString();
    }

    _scheduleFuture = _apiBaseHelper
        .getScheduleList(
          providerId,
          _dayDateMap,
        )
        .timeout(Duration(seconds: 10));

    _selectedTiming = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        isLoading: isLoading,
        title: "Select an Appointment Time",
        color: AppColors.snow,
        isAddBack: widget.fromScreen == 2,
        addBottomArrows: false,
        addBackButton: widget.fromScreen == 2 ? false : true,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 70.0),
                children: _scheduleDaysList.length > 0
                    ? widgetList()
                    : noScheduleAdded(),
              ),
            ),
            Divider(height: 0.5),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                width: widget.fromScreen == 2
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width - 76.0,
                margin: const EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(
                    right: 0.0, left: widget.fromScreen == 2 ? 0 : 40.0),
                child: FancyButton(
                  title: widget.fromScreen == 2 ? "Reschedule" : "Book now",
                  onPressed: () {
                    if (_selectedDate != null && _selectedTiming != null) {
                      if (widget.fromScreen == 2) {
                        setState(() {
                          isLoading = true;
                        });
                        var map = {};
                        map['appointmentId'] =
                            _container.appointmentIdMap['appointmentId'];
                        map['date'] = DateFormat("MM/dd/yyyy")
                            .format(_selectedDate)
                            .toString();
                        map['fromTime'] = _selectedTiming;

                        SharedPref().getToken().then((token) {
                          _apiBaseHelper
                              .rescheduleAppointment(token, map)
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            Widgets.showAppDialog(
                                context: context,
                                description: 'Appointment Rescheduled',
                                isCongrats: true,
                                buttonText: 'Go To Appointment',
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      Routes.dashboardScreen,
                                      (Route<dynamic> route) => false,
                                      arguments: 1);
                                  // Map appointment = {};
                                  // appointment["_appointmentStatus"] = "1";
                                  // appointment["id"] = _container
                                  //     .appointmentIdMap['appointmentId'];
                                  // Navigator.of(context).pushNamed(
                                  //   Routes.appointmentDetailScreen,
                                  //   arguments: appointment,
                                  // );
                                });
                          }).futureError((onError) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        });
                      } else {
                        _container.setAppointmentData("date", _selectedDate);
                        _container.setAppointmentData("time", _selectedTiming);

                        if (widget.fromScreen == 1) {
                          Navigator.pop(context, _container.appointmentData);
                        } else {
                          Navigator.of(context)
                              .pushNamed(Routes.consentToTreatScreen);
                        }
                      }
                    } else {
                      Widgets.showToast("Please select a timing");
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getScheduleDaysList() {
    if (profileMap['schedules'] != null && profileMap['schedules'].isNotEmpty) {
      List scheduleList = profileMap['schedules'];

      for (dynamic schedule in scheduleList) {
        if (schedule['scheduleType'].toString() == '1') {
          if (schedule['day'] != null) {
            List _daysList = schedule["day"];

            for (dynamic days in _daysList) {
              if (!_scheduleDaysList.contains(int.parse(days.toString()))) {
                _scheduleDaysList.add(int.parse(days.toString()));
              }
            }
          }
        }
      }
    }
  }

  List<Widget> noScheduleAdded() {
    List<Widget> formWidget = new List();

    formWidget.add(SizedBox(height: 20.0));

    formWidget.add(Text('No Schedules added'));

    return formWidget;
  }

  List<Widget> widgetList() {
    String providerId = '';

    if (profileMap["userId"] != null && profileMap["userId"] is Map) {
      providerId = profileMap["userId"]["_id"].toString();
    } else if (profileMap["User"] != null is Map) {
      providerId = profileMap["User"][0]["_id"].toString();
    }

    List<Widget> formWidget = new List();

    formWidget.add(ProviderWidget(
      data: profileMap,
      selectedAppointment:
          _container.projectsResponse['serviceType'].toString(),
      isOptionsShow: false,
      averageRating: averageRating,
    ));

    formWidget.add(ScrollingDayCalendar(
      startDate: startDate,
      endDate: DateTime(DateTime.now().year + 2),
      selectedDate: DateTime.now(),
      displayDateFormat: "EEEE, dd MMMM",
      scheduleDaysList: _scheduleDaysList,
      onDateChange: (DateTime selectedDate) {
        _dayDateMap["day"] = selectedDate.weekday.toString();
        _dayDateMap["date"] =
            DateFormat("MM/dd/yyyy").format(selectedDate).toString();
        _dayDateMap["timezone"] = _timezone;

        setState(() {
          _scheduleFuture = _apiBaseHelper
              .getScheduleList(
                providerId,
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
                var fromTime = new DateTime.utc(
                    DateTime.now().year,
                    DateTime.now().month,
                    9,
                    int.parse(schedule.startTime.toString().split(':')[0]),
                    int.parse(schedule.startTime.toString().split(':')[1]));

                int prefixValue = fromTime.hour;
                int minuteValue = fromTime.minute;

                if (currentDate == _dayDateMap["date"]) {
                  if (DateTime.now().hour < prefixValue) {
                    if (prefixValue < 12) {
                      _morningList.add(schedule);
                    } else if (12 <= prefixValue && prefixValue < 18) {
                      _afternoonList.add(schedule);
                    } else {
                      _eveningList.add(schedule);
                    }
                  } else if (DateTime.now().hour == prefixValue) {
                    if (DateTime.now().minute < minuteValue) {
                      if (prefixValue < 12) {
                        _morningList.add(schedule);
                      } else if (12 <= prefixValue && prefixValue < 18) {
                        _afternoonList.add(schedule);
                      } else {
                        _eveningList.add(schedule);
                      }
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

              _morningList.sort((a, b) => a.startTime.compareTo(b.startTime));
              _afternoonList.sort((a, b) => a.startTime.compareTo(b.startTime));
              _eveningList.sort((a, b) => a.startTime.compareTo(b.startTime));

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
                child: Text("Unavailable"),
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
              "${list.length.toString()} available time slots",
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
              : Text("Unavailable"),
        )
      ],
    );
  }

  Widget _slotWidget(Schedule currentSchedule) {
    var fromTime = new DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        9,
        int.parse(currentSchedule.startTime.toString().split(':')[0]),
        int.parse(currentSchedule.startTime.toString().split(':')[1]));

    String timing = TimeOfDay(hour: fromTime.hour, minute: fromTime.minute)
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
              : currentSchedule.isSelected
                  ? AppColors.windsor
                  : AppColors.snow,
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
                : currentSchedule.isSelected
                    ? Colors.white
                    : AppColors.windsor,
          ),
        ),
      ),
    );
  }
}
