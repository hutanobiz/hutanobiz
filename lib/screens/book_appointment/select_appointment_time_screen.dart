import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/schedule.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/scrolling_day_calendar_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class SelectAppointmentTimeScreen extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();

    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _selectedDate = DateTime.now();

    _dayDateMap["day"] = DateTime.now().weekday.toString();
    _dayDateMap["date"] = currentDate;
  }

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    _providerData = _container.getProviderData();

    _scheduleFuture = _apiBaseHelper.getScheduleList(
      _providerData["providerData"]["userId"]["_id"].toString(),
      _dayDateMap,
    );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList(),
        ),
        onForwardTap: () {
          if (_selectedDate != null && _selectedTiming != null) {
            _container.setAppointmentData("date", _selectedDate);
            _container.setAppointmentData("time", _selectedTiming);

            Navigator.of(context).pushNamed(Routes.appointmentForScreen);
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
      data: _providerData["providerData"],
      degree: _providerData["degree"].toString(),
      isOptionsShow: false,
    ));

    formWidget.add(SizedBox(height: 30.0));

    formWidget.add(ScrollingDayCalendar(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 14)),
      selectedDate: DateTime.now(),
      displayDateFormat: "EEEE, dd MMMM",
      onDateChange: (DateTime selectedDate) {
        _dayDateMap["day"] = selectedDate.weekday.toString();
        _dayDateMap["date"] =
            DateFormat("dd-MM-yyyy").format(selectedDate).toString();

        _selectedTiming = null;
        _container.appointmentData.clear();

        setState(() {
          _scheduleFuture = _apiBaseHelper.getScheduleList(
            _providerData["providerData"]["userId"]["_id"].toString(),
            _dayDateMap,
          );
        });

        _selectedDate = selectedDate;
      },
    ));

    formWidget.add(SizedBox(height: 30.0));

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

              _scheduleList.forEach((schedule) {
                int prefixValue =
                    int.parse(schedule.startTime.toString().substring(0, 2));

                if (prefixValue < 12) {
                  _morningList.add(schedule);
                } else if (12 <= prefixValue && prefixValue < 18) {
                  _afternoonList.add(schedule);
                } else if (prefixValue > 18) {
                  _eveningList.add(schedule);
                }
              });

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
              return Text("${snapshot.error}");
            }

            break;
        }
        return null;
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
                    return _slotWidget(index, list, list[index]);
                  })
              : Text("NO slots available"),
        )
      ],
    );
  }

  Widget _slotWidget(
      int index, List<Schedule> _scheduleList, Schedule schedule) {
    String timing = TimeOfDay(
            hour: int.parse(schedule.startTime.toString().substring(0, 2)),
            minute: int.parse(schedule.startTime.toString().substring(2)))
        .format(context)
        .toString()
        .toLowerCase();

    return InkWell(
      onTap: schedule.isBlock
          ? null
          : () {
              _morningList.forEach((f) => f.isSelected = false);
              _eveningList.forEach((f) => f.isSelected = false);
              _afternoonList.forEach((f) => f.isSelected = false);

              for (int i = 0; i < _scheduleList.length; i++) {
                if (i == index) {
                  setState(() {
                    _scheduleList[i].isSelected = true;
                  });
                } else {
                  setState(() {
                    _scheduleList[i].isSelected = false;
                  });
                }
              }

              _selectedTiming = schedule.startTime.toString();
            },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color:
              schedule.isBlock ? Colors.grey.withOpacity(0.05) : AppColors.snow,
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          border: Border.all(
              color: schedule.isBlock
                  ? Colors.grey.withOpacity(0.05)
                  : (schedule.isSelected
                      ? AppColors.windsor
                      : Colors.grey[300]),
              width: 0.5),
        ),
        child: Text(
          timing,
          style: TextStyle(
            color: schedule.isBlock
                ? Colors.grey.withOpacity(0.6)
                : AppColors.windsor,
          ),
        ),
      ),
    );
  }
}
