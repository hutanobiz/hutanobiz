import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/models/schedule.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/scrolling_day_calendar_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class SelectAppointmentTimeScreen extends StatefulWidget {
  final SelectDateTimeArguments?
      arguments; // fromScreen: 0-services,1-edit datetime,2-reschedule,3-followup Reschedule

  const SelectAppointmentTimeScreen({Key? key, this.arguments})
      : super(key: key);

  @override
  _SelectAppointmentTimeScreenState createState() =>
      _SelectAppointmentTimeScreenState();
}

class _SelectAppointmentTimeScreenState
    extends State<SelectAppointmentTimeScreen> {
  late Map _providerData;
  Future<List<Schedule>>? _scheduleFuture;
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  Map _dayDateMap = Map();
  String _timezone = 'Unknown';
  List<Schedule> _morningList = [];
  List<Schedule> _afternoonList = [];
  List<Schedule> _eveningList = [];

  List<Schedule>? _scheduleList;
  late InheritedContainerState _container;

  String? _selectedTiming;
  DateTime? _selectedDate, startDate;
  Map? profileMap = new Map();
  String? currentDate;
  String averageRating = "0";
  dynamic selectedAddress;
  bool firstLoad = true;
  bool isAutoNextDay = false;
  Future<dynamic>? _addressFuture;
  String providerId = '';
  List<int> _scheduleDaysList = [];
  int _initialDay = 1;
  DateTime? newDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    currentDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
    _selectedDate = DateTime.utc(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0, 0);

    _dayDateMap["day"] = DateTime.now().weekday.toString();
    _dayDateMap["date"] = currentDate;

    newDate = DateTime.utc(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0, 0);
    startDate = DateTime.utc(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0, 0);
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
    _providerData = _container.getProviderData();

    if (_providerData["providerData"]["data"] != null) {
      averageRating =
          _providerData["providerData"]["averageRating"]?.toStringAsFixed(1) ??
              "0";

      _providerData["providerData"]["data"].map((f) {
        profileMap!.addAll(f);
      }).toList();
    } else {
      profileMap = _providerData["providerData"];
      averageRating = profileMap!["averageRating"]?.toStringAsFixed(1) ?? "0";
    }

    if (profileMap!["userId"] != null && profileMap!["userId"] is Map) {
      providerId = profileMap!["userId"]["_id"].toString();
    } else if (profileMap!["User"] != null is Map) {
      providerId = profileMap!["User"][0]["_id"].toString();
    }

    if (_container.projectsResponse['serviceType'] == '1') {
      SharedPref().getToken().then((token) {
        setState(() {
          _addressFuture = _apiBaseHelper.getProviderAddress(token, providerId);
        });
      });
    }

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

    _getScheduleDaysList();
    _scheduleDaysList.sort();
    if (_scheduleDaysList.length > 0) {
      if (_scheduleDaysList.contains(DateTime.now().weekday)) {
        _dayDateMap["day"] = DateTime.now().weekday.toString();
        _dayDateMap["date"] = currentDate;
      } else {
        for (int i = 0; i < 7; i++) {
          if (_scheduleDaysList
              .contains(DateTime.now().add(Duration(days: i + 1)).weekday)) {
            _dayDateMap["day"] =
                DateTime.now().add(Duration(days: i + 1)).weekday.toString();
            _dayDateMap["date"] = DateFormat('MM/dd/yyyy')
                .format(DateTime.now().add(Duration(days: i + 1)));
            startDate = startDate!.add(Duration(days: i + 1));
            _selectedDate = startDate;
            break;
          }
        }
      }
    }
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    _dayDateMap["timezone"] = _timezone;
    _selectedDate.toString().debugLog();

    if (_container.projectsResponse['serviceType'] != '1') {
      if (mounted) {
        setState(() {});
      }
      isAutoNextDay = false;
      _scheduleFuture = _apiBaseHelper
          .getScheduleList(
            providerId,
            _dayDateMap,
          )
          .timeout(Duration(seconds: 10));

      _selectedTiming = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        color: AppColors.snow,
        isAddBack: false,
        addBottomArrows: true,
        onForwardTap: () {
          if (_selectedDate != null && _selectedTiming != null) {
            if (widget.arguments!.fromScreen == 2 ||
                widget.arguments!.fromScreen == 3) {
              setState(() {
                isLoading = true;
              });
              var map = {};
              map['appointmentId'] = widget.arguments!.appointmentId;
              map['date'] =
                  DateFormat("MM/dd/yyyy").format(_selectedDate!).toString();
              map['fromTime'] = _selectedTiming;

              SharedPref().getToken().then((token) {
                _apiBaseHelper.rescheduleAppointment(token, map).then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  if (widget.arguments!.fromScreen == 2) {
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
                        });
                  } else {
                    Navigator.pushNamed(context, Routes.paymentMethodScreen,
                        arguments: {
                          'paymentType': 3,
                          'appointmentId': widget.arguments!.appointmentId
                        });
                  }
                }).futureError((onError) {
                  setState(() {
                    isLoading = false;
                  });
                });
              });
            } else {
              _container.setAppointmentData("date", _selectedDate);
              _container.setAppointmentData("time", _selectedTiming);
              _container.setAppointmentData("isOndemand", '0');
              if (selectedAddress != null) {
                _container.setAppointmentData(
                    'officeId', selectedAddress['_id']);
                _container.setAppointmentData(
                    'selectedAddress', selectedAddress);
              }
              if (widget.arguments!.fromScreen == 1) {
                Navigator.pop(context, _container.appointmentData);
              } else {
                Navigator.of(context).pushNamed(Routes.consentToTreatScreen);
              }
            }
          } else {
            Widgets.showToast("Please select a time");
          }
        },
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 70.0),
          children:
              _scheduleDaysList.length > 0 ? widgetList() : noScheduleAdded(),
        ),
      ),
    );
  }

  void _getScheduleDaysList() {
    if (profileMap!['schedules'] != null &&
        profileMap!['schedules'].isNotEmpty) {
      List scheduleList = profileMap!['schedules'];

      for (dynamic schedule in scheduleList) {
        if (_container.projectsResponse['serviceType'] ==
            schedule['scheduleAppointmentType'].toString()) {
          if (schedule['scheduleType'].toString() == '1' ||
              schedule['scheduleType'].toString() == '2') {
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
  }

  onDemandWidget() {
    return _providerData["providerData"]["data"][0]
                ['ondemandavailabledoctor'] !=
            null
        ? _providerData["providerData"]["data"][0]['ondemandavailabledoctor']
                ['isOnline']
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                Localization.of(context)!.onDemandServiceLabel,
                                style: TextStyle(
                                    fontSize: fontSize14,
                                    fontWeight: fontWeightSemiBold),
                              ),
                            ),
                            SizedBox(width: spacing15),
                            Image.asset(FileConstants.icOnDemandService,
                                width: spacing15, height: spacing15)
                          ],
                        ),
                      ),
                      Text(Localization.of(context)!.activeLabel,
                          style: TextStyle(
                              fontSize: fontSize14,
                              fontWeight: fontWeightMedium,
                              color: Color(0xff44c963)))
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: spacing20, horizontal: spacing20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(14.0),
                      ),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(Localization.of(context)!.instantAppointmentLabel,
                            style: TextStyle(
                                color: colorPurple100,
                                fontSize: fontSize13,
                                fontWeight: fontWeightMedium)),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 12.0,
                        )
                      ],
                    ),
                  ).onClick(onTap: () {
                    _container.setAppointmentData("date", DateTime.now());
                    _container.setAppointmentData("time", '00:00');
                    _container.setAppointmentData("isOndemand", '1');
                    if (_container.projectsResponse['serviceType'].toString() ==
                        '1') {
                      if (selectedAddress != null) {
                        _container.setAppointmentData(
                            'officeId', selectedAddress['_id']);
                        _container.setAppointmentData(
                            'selectedAddress', selectedAddress);
                        if (widget.arguments!.fromScreen == 1) {
                          Navigator.pop(context, _container.appointmentData);
                        } else {
                          Navigator.of(context)
                              .pushNamed(Routes.consentToTreatScreen);
                        }
                      } else {
                        Widgets.showToast("Please select address");
                      }
                    } else {
                      if (widget.arguments!.fromScreen == 1) {
                        Navigator.pop(context, _container.appointmentData);
                      } else {
                        Navigator.of(context)
                            .pushNamed(Routes.consentToTreatScreen);
                      }
                    }
                  }),
                  SizedBox(height: 20)
                ],
              )
            : SizedBox()
        : SizedBox();
  }

  List<Widget> noScheduleAdded() {
    List<Widget> formWidget = [];

    formWidget.add(onDemandWidget());

    formWidget.add(SizedBox(height: 20.0));

    formWidget.add(Text('No Schedules added'));

    return formWidget;
  }

  List<Widget> widgetList() {
    String providerId = '';

    if (profileMap!["userId"] != null && profileMap!["userId"] is Map) {
      providerId = profileMap!["userId"]["_id"].toString();
    } else if (profileMap!["User"] != null is Map) {
      providerId = profileMap!["User"][0]["_id"].toString();
    }
    double servicesPrize = 0.0;
    if (_container.selectServiceMap['status'] == '1') {
      if (_container.selectServiceMap['services'].length > 0) {
        for (Services s in _container.selectServiceMap['services']) {
          servicesPrize += s.amount;
        }
      }
    }

    List<Widget> formWidget = [];

    formWidget.add(ProviderWidget(
      data: profileMap,
      selectedAppointment:
          _container.projectsResponse['serviceType'].toString(),
      servicesPrize: servicesPrize.toString(),
      isOptionsShow: false,
      averageRating: averageRating,
    ));

    formWidget.add(onDemandWidget());

    formWidget.add(
      _container.projectsResponse['serviceType'].toString() == '1'
          ? address()
          : SizedBox(),
    );

    formWidget.add(_container.projectsResponse['serviceType'].toString() == '1'
        ? SizedBox(
            height: 0,
          )
        : _futureWidget());

    return formWidget;
  }

  Widget _futureWidget() {
    return FutureBuilder<List<Schedule>>(
      future: _scheduleFuture,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CustomLoader(),
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              if (!isAutoNextDay) {
                _morningList.clear();
                _eveningList.clear();
                _afternoonList.clear();
                _scheduleList = snapshot.data;

                for (Schedule schedule in _scheduleList!) {
                  var fromTime = new DateTime.utc(
                      int.parse(_dayDateMap["date"].split('/')[2]),
                      int.parse(_dayDateMap["date"].split('/')[0]),
                      int.parse(_dayDateMap["date"].split('/')[1]),
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
                    } else if (DateTime.now().add(Duration(minutes: 30)).hour ==
                        prefixValue) {
                      if (DateTime.now().add(Duration(minutes: 30)).minute <
                          minuteValue) {
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
              }
              if (_morningList.isEmpty &&
                  _afternoonList.isEmpty &&
                  _eveningList.isEmpty) {
                callNextDayApi();
                isAutoNextDay = true;

                return Center(
                  child: CustomLoader(),
                );
              } else {
                _morningList.sort((a, b) => a.startTime.compareTo(b.startTime));
                _afternoonList
                    .sort((a, b) => a.startTime.compareTo(b.startTime));
                _eveningList.sort((a, b) => a.startTime.compareTo(b.startTime));

                return Column(
                  children: <Widget>[
                    ScrollingDayCalendar(
                      startDate: startDate,
                      endDate: DateTime(DateTime.now().year + 2),
                      selectedDate: _selectedDate,
                      displayDateFormat: "EEE, dd MMM",
                      scheduleDaysList: _scheduleDaysList,
                      onDateChange: (DateTime selectedDate) {
                        _dayDateMap["day"] = selectedDate.weekday.toString();
                        _dayDateMap["date"] = DateFormat("MM/dd/yyyy")
                            .format(selectedDate)
                            .toString();
                        _selectedDate = selectedDate;
                        _dayDateMap["timezone"] = _timezone;

                        setState(() {
                          isAutoNextDay = false;
                          _scheduleFuture = _apiBaseHelper
                              .getScheduleList(
                                providerId,
                                _dayDateMap,
                              )
                              .futureError(
                                (error) => error.toString().debugLog(),
                              );
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    _timingWidget("Morning", "ic_morning", _morningList),
                    SizedBox(height: 40.0),
                    _timingWidget("Afternoon", "ic_afternoon", _afternoonList),
                    SizedBox(height: 40.0),
                    _timingWidget("Evening", "ic_night", _eveningList),
                  ],
                );
              }
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

  callNextDayApi() {
    for (int i = 0; i < 7; i++) {
      if (_scheduleDaysList.contains(DateTime.utc(
              int.parse(_dayDateMap["date"].split('/')[2]),
              int.parse(_dayDateMap["date"].split('/')[0]),
              int.parse(_dayDateMap["date"].split('/')[1]))
          .add(Duration(days: i + 1))
          .weekday)) {
        _dayDateMap["day"] = DateTime.utc(
                int.parse(_dayDateMap["date"].split('/')[2]),
                int.parse(_dayDateMap["date"].split('/')[0]),
                int.parse(_dayDateMap["date"].split('/')[1]))
            .add(Duration(days: i + 1))
            .weekday
            .toString();
        _dayDateMap["date"] = DateFormat('MM/dd/yyyy').format(DateTime.utc(
                int.parse(_dayDateMap["date"].split('/')[2]),
                int.parse(_dayDateMap["date"].split('/')[0]),
                int.parse(_dayDateMap["date"].split('/')[1]))
            .add(Duration(days: i + 1)));
        startDate = startDate!.add(Duration(days: i + 1));
        _selectedDate = startDate;
        break;
      }
    }
    _dayDateMap["day"] = _selectedDate!.weekday.toString();
    _dayDateMap["date"] =
        DateFormat("MM/dd/yyyy").format(_selectedDate!).toString();
    _apiBaseHelper
        .getScheduleList(
      providerId,
      _dayDateMap,
    )
        .then((value) {
      _scheduleList = value;
      for (Schedule schedule in value) {
        var fromTime = new DateTime.utc(
            int.parse(_dayDateMap["date"].split('/')[2]),
            int.parse(_dayDateMap["date"].split('/')[0]),
            int.parse(_dayDateMap["date"].split('/')[1]),
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
          } else if (DateTime.now().add(Duration(minutes: 30)).hour ==
              prefixValue) {
            if (DateTime.now().add(Duration(minutes: 30)).minute <
                minuteValue) {
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
      // if (_morningList.isEmpty &&
      //     _afternoonList.isEmpty &&
      //     _eveningList.isEmpty) {
      //   callNextDayApi();

      //   return Center(
      //     child: CustomLoader(),
      //   );
      // } else {
      setState(() {
        _morningList.sort((a, b) => a.startTime.compareTo(b.startTime));
        _afternoonList.sort((a, b) => a.startTime.compareTo(b.startTime));
        _eveningList.sort((a, b) => a.startTime.compareTo(b.startTime));
      });
    }).futureError(
      (error) => error.toString().debugLog(),
    );
  }

  Widget address() {
    return FutureBuilder<dynamic>(
      future: _addressFuture,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
            break;
          case ConnectionState.waiting:
            return Center(
              child: CustomLoader(),
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return Container();
              }
              List? _addressList = snapshot.data;
              if (_addressList == null || _addressList.isEmpty) {
                return Container();
              } else {
                if (firstLoad) {
                  selectedAddress = _addressList.first;
                  _dayDateMap['officeId'] = selectedAddress['_id'];
                  isAutoNextDay = false;
                  _scheduleFuture = _apiBaseHelper.getScheduleList(
                    providerId,
                    _dayDateMap,
                  );

                  _selectedTiming = null;
                  firstLoad = false;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Which Office?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 12),
                    Container(
                      height: 100,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        itemCount: _addressList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAddress = _addressList[index];
                                _dayDateMap['officeId'] =
                                    selectedAddress['_id'];
                                isAutoNextDay = false;
                                _scheduleFuture =
                                    _apiBaseHelper.getScheduleList(
                                  providerId,
                                  _dayDateMap,
                                );

                                _selectedTiming = null;
                              });
                            },
                            child: Container(
                              width: 182,
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: selectedAddress == _addressList[index]
                                    ? AppColors.windsor.withOpacity(0.07)
                                    : Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14.0)),
                                border: Border.all(
                                    color:
                                        selectedAddress == _addressList[index]
                                            ? AppColors.windsor
                                            : Colors.grey[300]!,
                                    width: 0.5),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _addressList[index]['saveAs'] ?? "",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    _addressList[index]['address'] ?? "",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    (_addressList[index]['city'] ?? "") +
                                        ", " +
                                        (_addressList[index]['zipCode'] ?? ""),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 20,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _futureWidget()
                  ],
                );
              }
            } else if (snapshot.hasError) {
              return Container();
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
      onTap: currentSchedule.isBlock!
          ? null
          : () {
              _scheduleList!.forEach((f) => f.isSelected = false);

              currentSchedule.isSelected = true;
              _selectedTiming = currentSchedule.startTime.toString();
              setState(() {});
            },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: currentSchedule.isBlock!
              ? Colors.grey.withOpacity(0.05)
              : currentSchedule.isSelected
                  ? AppColors.goldenTainoi
                  : AppColors.snow,
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          border: Border.all(
              color: currentSchedule.isBlock!
                  ? Colors.grey.withOpacity(0.05)
                  : (currentSchedule.isSelected
                      ? AppColors.windsor
                      : Colors.grey[300]!),
              width: 0.5),
        ),
        child: Text(
          timing,
          style: TextStyle(
            color: currentSchedule.isBlock!
                ? Colors.grey.withOpacity(0.6)
                : currentSchedule.isSelected
                    ? AppColors.windsor
                    : AppColors.windsor,
          ),
        ),
      ),
    );
  }
}
