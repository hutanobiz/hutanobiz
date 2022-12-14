import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:intl/intl.dart';

class AvailableTimingsScreen extends StatefulWidget {
  @override
  _AvailableTimingsScreenState createState() => _AvailableTimingsScreenState();
}

class _AvailableTimingsScreenState extends State<AvailableTimingsScreen> {
  late Map _providerData;
  late InheritedContainerState _container;

  Map? profileMap = Map();

  String? mondayTimings,
      tuesdayTimings,
      wednesdayTimings,
      thursdayTimings,
      fridayTimings,
      saturdayTimings,
      sundayTimings;

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    _providerData = _container.getProviderData();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: "Schedule",
        color: Colors.white,
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        isAddBack: false,
        addBackButton: true,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 70.0),
          children: widgetList(),
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = [];
    String averageRating = "---";

    if (_providerData["providerData"] != null) {
      averageRating =
          _providerData["providerData"]['averageRating']?.toStringAsFixed(1) ??
              "0";

      if (_providerData["providerData"]["data"] != null) {
        if (_providerData["providerData"]["data"] is List) {
          _providerData["providerData"]["data"].map((f) {
            profileMap!.addAll(f);
          }).toList();
        } else {
          profileMap = _providerData["providerData"]["data"];
        }
      }
    }

    setTimings(profileMap!['schedules']);

    formWidget.add(ProviderWidget(
      data: profileMap,
      averageRating: averageRating,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      isOptionsShow: false,
    ));

    formWidget.add(SizedBox(height: 26));

    formWidget.add(_timingWidget(
        "Monday",
        mondayTimings != null && mondayTimings != ""
            ? mondayTimings!.substring(0, mondayTimings!.length - 1)
            : "Unavailable"));

    formWidget.add(_timingWidget(
        "Tuesday",
        tuesdayTimings != null && tuesdayTimings != ""
            ? tuesdayTimings!.substring(0, tuesdayTimings!.length - 1)
            : "Unavailable"));

    formWidget.add(_timingWidget(
        "Wednesday",
        wednesdayTimings != null && wednesdayTimings != ""
            ? wednesdayTimings!.substring(0, wednesdayTimings!.length - 1)
            : "Unavailable"));

    formWidget.add(_timingWidget(
        "Thursday",
        thursdayTimings != null && thursdayTimings != ""
            ? thursdayTimings!.substring(0, thursdayTimings!.length - 1)
            : "Unavailable"));

    formWidget.add(_timingWidget(
        "Friday",
        fridayTimings != null && fridayTimings != ""
            ? fridayTimings!.substring(0, fridayTimings!.length - 1)
            : "Unavailable"));

    formWidget.add(_timingWidget(
        "Saturday",
        saturdayTimings != null && saturdayTimings != ""
            ? saturdayTimings!.substring(0, saturdayTimings!.length - 1)
            : "Unavailable"));

    formWidget.add(_timingWidget(
        "Sunday",
        sundayTimings != null && sundayTimings != ""
            ? sundayTimings!.substring(0, sundayTimings!.length - 1)
            : "Unavailable"));

    return formWidget;
  }

  void setTimings(List? _scheduleList) {
    if (_scheduleList != null && _scheduleList.length > 0) {
      mondayTimings = "";
      tuesdayTimings = "";
      wednesdayTimings = "";
      thursdayTimings = "";
      fridayTimings = "";
      saturdayTimings = "";
      sundayTimings = "";

      int i = 0;
      int j = 0;

      while (i < _scheduleList.length) {
        List _scheduleDaysList = _scheduleList[i]["day"];
        if (j < _scheduleDaysList.length) {
          String day = _scheduleDaysList[j].toString();
          for (int ii = 0; ii < _scheduleList[i]['session'].length; ii++) {
            var fromTime = DateTime.utc(
                DateTime.now().year,
                DateTime.now().month,
                9,
                int.parse(_scheduleList[i]['session'][ii]['fromTime']
                    .toString()
                    .split(':')[0]),
                int.parse(_scheduleList[i]['session'][ii]['fromTime']
                    .toString()
                    .split(':')[1]));
            var toTime = DateTime.utc(
                DateTime.now().year,
                DateTime.now().month,
                9,
                int.parse(_scheduleList[i]['session'][ii]['toTime']
                    .toString()
                    .split(':')[0]),
                int.parse(_scheduleList[i]['session'][ii]['toTime']
                    .toString()
                    .split(':')[1]));

            String from = DateFormat('HH:mm').format(fromTime.toLocal());
            // '${fromTime.toLocal().hour}:${fromTime.toLocal().minute}';
            String to = DateFormat('HH:mm').format(toTime.toLocal());
            //'${toTime.toLocal().hour}:${toTime.toLocal().minute}';

            switch (day) {
              case "1":
                mondayTimings = mondayTimings! + from + " - " + to + "\n";
                break;
              case "2":
                tuesdayTimings = tuesdayTimings! + from + " - " + to + "\n";
                break;
              case "3":
                wednesdayTimings = wednesdayTimings! + from + " - " + to + "\n";
                break;
              case "4":
                thursdayTimings = thursdayTimings! + from + " - " + to + "\n";
                break;
              case "5":
                fridayTimings = fridayTimings! + from + " - " + to + "\n";
                break;
              case "6":
                saturdayTimings = saturdayTimings! + from + " - " + to + "\n";
                break;
              case "7":
                sundayTimings = sundayTimings! + from + " - " + to + "\n";
                break;
            }
          }
          j++;
        } else {
          i++;
          j = 0;
        }
      }
    }
  }

  Widget _timingWidget(String day, String timings) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: <Widget>[
              Text(
                day,
                style: TextStyle(
                  color: DateFormat("EEEE").format(DateTime.now()) == day
                      ? Colors.black
                      : Colors.black.withOpacity(0.40),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    timings,
                    style: TextStyle(
                      height: 1.5,
                      color: DateFormat("EEEE").format(DateTime.now()) == day
                          ? Colors.black
                          : Colors.black.withOpacity(0.40),
                      fontSize: DateFormat("EEEE").format(DateTime.now()) == day
                          ? 15
                          : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        divider(),
      ],
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.grey[100],
      thickness: 6.0,
    );
  }
}
