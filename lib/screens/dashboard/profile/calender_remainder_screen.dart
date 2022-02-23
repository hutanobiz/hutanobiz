import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/appointment_list_widget.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarReminderScreen extends StatefulWidget {
  CalendarReminderScreen({Key key, this.profileData}) : super(key: key);
  var profileData;

  @override
  _CalendarReminderScreenState createState() => _CalendarReminderScreenState();
}

class _CalendarReminderScreenState extends State<CalendarReminderScreen> {
  ApiBaseHelper api = new ApiBaseHelper();

  bool isLoading = false;
  ValueNotifier<List<dynamic>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;
  Future<dynamic> _requestsFuture;
  ApiBaseHelper _api = ApiBaseHelper();
  var kEvents;
  var _activeAppointmentsList = [];
  var newMap;
  bool isInitialLoad = true;

  void appointmentsFuture() {
    SharedPref().getToken().then((token) {
      setState(() {
        _requestsFuture = _api.userAppointments(token, LatLng(0, 0));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    appointmentsFuture();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<dynamic> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime start, DateTime end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackgroundNew(
          addHeader: true,
          title: "",
          padding: EdgeInsets.only(bottom: 0),
          isAddBack: true,
          isAddAppBar: true,
          addBottomArrows: false,
          isLoading: isLoading,
          child: FutureBuilder<dynamic>(
            future: _requestsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: new CustomLoader(),
                );
              } else if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                if (snapshot.data is String) {
                  return Center(
                    child: Text('No appointments.'),
                  );
                } else {
                  if (isInitialLoad) {
                    _activeAppointmentsList.clear();
                    _activeAppointmentsList
                        .addAll(snapshot.data["ondemandAppointments"]);
                    _activeAppointmentsList
                        .addAll(snapshot.data["presentRequest"]);
                    _activeAppointmentsList
                        .addAll(snapshot.data["pastRequest"]);
                    _activeAppointmentsList
                        .addAll(snapshot.data['onDemandPastRequest']);

                    newMap = groupBy(_activeAppointmentsList, (dynamic item) {
                      DateTime dd = DateTime.utc(
                              DateTime.parse(item['date']).year,
                              DateTime.parse(item['date']).month,
                              DateTime.parse(item['date']).day,
                              int.parse(item['fromTime'].split(':')[0]),
                              int.parse(item['fromTime'].split(':')[1]))
                          .toLocal();
                      return DateTime(dd.year, dd.month, dd.day);
                    });

                    kEvents = LinkedHashMap<DateTime, List<dynamic>>(
                      equals: isSameDay,
                      hashCode: getHashCode,
                    )..addAll(newMap);
                    _selectedDay = _focusedDay;
                    _selectedEvents =
                        ValueNotifier(_getEventsForDay(_selectedDay));
                    isInitialLoad = false;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TableCalendar<dynamic>(
                          firstDay: kFirstDay,
                          lastDay: kLastDay,
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          rangeStartDay: _rangeStart,
                          rangeEndDay: _rangeEnd,
                          calendarFormat: _calendarFormat,
                          onHeaderTapped: (focusedDay) {
                            showDatePicker(
                                context: context,
                                initialDate: _selectedDay,
                                firstDate: kFirstDay,
                                lastDate: kLastDay,
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                      data: ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: AppColors.goldenTainoi,
                                          onPrimary: Colors.white,
                                          surface: AppColors.goldenTainoi,
                                          onSurface: AppColors.windsor,
                                        ),
                                        dialogBackgroundColor: Colors.white,
                                      ),
                                      child: child);
                                }).then((value) {
                              _onDaySelected(value, _focusedDay);
                            });
                          },
                          rangeSelectionMode: _rangeSelectionMode,
                          eventLoader: _getEventsForDay,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, day, events) =>
                                events.length > 0
                                    ? Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                right: 4, bottom: 4),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: AppColors.windsor),
                                            child: Text(
                                                events.length.toString(),
                                                style:
                                                    AppTextStyle.regularStyle(
                                                        fontSize: 12,
                                                        color: Colors.white))),
                                      )
                                    : SizedBox(),
                          ),
                          calendarStyle: CalendarStyle(
                            // Use `CalendarStyle` to customize the UI
                            rangeHighlightColor:
                                AppColors.goldenTainoi.withOpacity(.5),
                            selectedDecoration: BoxDecoration(
                                color: AppColors.goldenTainoi,
                                shape: BoxShape.circle),
                            rangeStartDecoration: BoxDecoration(
                                color: AppColors.goldenTainoi,
                                shape: BoxShape.circle),
                            rangeEndDecoration: BoxDecoration(
                                color: AppColors.goldenTainoi,
                                shape: BoxShape.circle),
                            todayDecoration: BoxDecoration(
                                color: AppColors.goldenTainoi.withOpacity(.7),
                                shape: BoxShape.circle),
                            outsideDaysVisible: false,
                          ),
                          onDaySelected: _onDaySelected,
                          onRangeSelected: _onRangeSelected,
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Appointments',
                          style: AppTextStyle.boldStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: ValueListenableBuilder<List<dynamic>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return _requestList(value[index], 1);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return Center(
                  child: CustomLoader(),
                );
              }
            },
          )),
    );
  }

  Widget quickLinks(String image, String text) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0xff8B8B8B).withOpacity(0.14),
              offset: Offset(0, 2),
              blurRadius: 20,
              spreadRadius: 1)
        ],
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Color(0xFF372786).withOpacity(0.12)),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          //   Image.asset(
          //   'images/forward_arrow_grey.png',
          //   height: 12,
          //   width: 12,
          //   color: Color(0xFF999AAE),
          // ),
          SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.windsor.withOpacity(0.85),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Widget _requestList(Map response, int listType) {
    String name = "---",
        avatar,
        averageRating = "---",
        professionalTitle = "---";

    if (response["averageRating"] != null) {
      averageRating = '${response["averageRating"]?.toStringAsFixed(1)}' +
          '(${response['totalRating']})';
    }

    if (response["doctor"] != null) {
      if (response["isOndemand"] == true) {
        name = (response["doctor"][0]["title"] ?? "---") +
                ' ' +
                response["doctor"][0]["fullName"] ??
            "---";
        avatar = response["doctor"][0]["avatar"].toString();
      } else {
        name = (response["doctor"]["title"] ?? "---") +
                ' ' +
                response["doctor"]["fullName"] ??
            "---";
        avatar = response["doctor"]["avatar"].toString();
      }
    }

    if (response["doctorData"] != null) {
      if (response["isOndemand"] == true) {
        if (response["doctorData"]["professionalTitle"].isNotEmpty) {
          professionalTitle = response["doctorData"]["professionalTitle"][0]
                      ["title"]
                  ?.toString() ??
              "---";
        }
        if (response["doctorData"]["education"].isNotEmpty) {
          name += ' ' +
                  response["doctorData"]["education"][0]["degree"]
                      ?.toString() ??
              "---";
        }
      } else {
        if (response["doctorData"][0]["professionalTitle"] != null) {
          professionalTitle = response["doctorData"][0]["professionalTitle"]
                      ["title"]
                  ?.toString() ??
              "---";
        }
        if (response["doctorData"][0]["education"].isNotEmpty) {
          name += ' ' +
                  response["doctorData"][0]["education"][0]["degree"]
                      ?.toString() ??
              "---";
        }
      }
    }

    return AppointmentListWidget(
        context: context,
        response: response,
        avatar: avatar,
        name: name,
        averageRating: averageRating,
        professionalTitle: professionalTitle,
        onTap: () {
          // if (response['type'] != 2) {
          Navigator.of(context).pushNamed(
            Routes.appointmentDetailScreen,
            arguments: response["_id"],
          );
          // } else {
          //   if (response["status"] == 4) {
          //     Navigator.of(context)
          //         .pushNamed(
          //           Routes.appointmentDetailScreen,
          //           arguments: response["_id"],
          //         )
          //         .whenComplete(() => appointmentsFuture(_userLocation));
          //   } else {
          //     Navigator.pushNamed(
          //             context, Routes.telemedicineTrackTreatmentScreen,
          //             arguments: response["_id"])
          //         .whenComplete(() => appointmentsFuture(_userLocation));
          //   }
          // }
        });
  }
}

// class Event {
//   final String title;

//   const Event(this.title);

//   @override
//   String toString() => title;
// }

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 3, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 3, kToday.month, kToday.day);
