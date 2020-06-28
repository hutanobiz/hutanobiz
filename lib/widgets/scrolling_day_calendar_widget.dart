import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:intl/intl.dart';

typedef ScrollingDayCalendarBuilder = Widget Function(
  BuildContext context,
  DateTime startDate,
  DateTime endDate,
  DateTime selectedDate,
  Function onDateChange,
);

class ScrollingDayCalendar extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;
  final Function onDateChange;
  final List<int> scheduleDaysList;

  final String displayDateFormat;

  ScrollingDayCalendar({
    @required this.startDate,
    @required this.endDate,
    @required this.selectedDate,
    this.onDateChange,
    this.displayDateFormat,
    this.scheduleDaysList,
  });

  @override
  _ScrollingDayCalendarState createState() => _ScrollingDayCalendarState();
}

class _ScrollingDayCalendarState extends State<ScrollingDayCalendar> {
  DateTime _selectedDate;
  int _addDays = 1;
  List<int> scheduleDaysList = [1, 2, 3, 4, 5, 6, 7];
  bool isRightButtonEnable = true;
  bool isLeftButtonEnable = true;
  Color rightButtonColor = Colors.black;
  Color leftButtonColor = Colors.black;

  // int _initialDay = 1;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.selectedDate;

    // if (widget.scheduleDaysList != null && widget.scheduleDaysList.isNotEmpty) {
    //   scheduleDaysList = widget.scheduleDaysList;

    //   if (scheduleDaysList.length > 1) {
    //     scheduleDaysList.sort();
    //   }
    // }

    // DateTime newDate = widget.selectedDate;

    // while (true) {
    //   if (scheduleDaysList.contains(newDate.weekday)) {
    //     setState(() {
    //       _selectedDate = newDate;
    //     });

    //     break;
    //   } else {
    //     newDate = widget.selectedDate.add(
    //       Duration(days: _initialDay),
    //     );
    //     _initialDay++;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            minWidth: 20,
            onPressed: widget.startDate.isBefore(_selectedDate)
                // isLeftButtonEnable
                ? () {
                    // while (true) {
                    DateTime newDate = _selectedDate.subtract(
                      Duration(days: _addDays),
                    );

                    // if (widget.startDate.isBefore(newDate)) {
                    //   setState(() {
                    //     isLeftButtonEnable = true;
                    //     leftButtonColor = Colors.black;
                    //   });

                    // if (scheduleDaysList.contains(newDate.weekday)) {
                    setState(() {
                      _selectedDate = newDate;
                    });

                    widget.onDateChange(_selectedDate);
                    _addDays = 1;
                    //   break;
                    // } else {
                    //   _addDays++;
                    // }
                    // } else {
                    //   setState(() {
                    //     isLeftButtonEnable = false;
                    //     leftButtonColor = Colors.grey[300];
                    //   });

                    //   break;
                    // }
                    // }
                  }
                : null,
            child: Icon(
              Icons.arrow_back_ios,
              color: widget.startDate.isBefore(_selectedDate)
                  ? Colors.black
                  : Colors.grey[300],
              size: 12.0,
            ),
          ),
          SizedBox(width: 8.0),
          Image(
            width: 16.0,
            height: 16.0,
            image: AssetImage("images/ic_calendar.png"),
          ),
          SizedBox(width: 8.0),
          Text(
            DateFormat(widget.displayDateFormat != null
                    ? widget.displayDateFormat
                    : "dd/MM/yyyy")
                .format(_selectedDate),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15.0,
            ),
          ),
          SizedBox(width: 8.0),
          MaterialButton(
            minWidth: 20,
            onPressed: widget.endDate.isAfter(_selectedDate)
                // isRightButtonEnable
                ? () {
                    // while (true) {
                    DateTime newDate = _selectedDate.add(
                      Duration(days: _addDays),
                    );

                    // if (widget.endDate.isAfter(newDate)) {
                    //   setState(() {
                    //     isRightButtonEnable = true;
                    //     rightButtonColor = Colors.black;
                    //   });

                    // if (scheduleDaysList.contains(newDate.weekday)) {
                    setState(() {
                      _selectedDate = newDate;
                    });

                    widget.onDateChange(_selectedDate);
                    _addDays = 1;
                    //   break;
                    // } else {
                    //   _addDays++;
                    // }
                    // } else {
                    //   setState(() {
                    //     isRightButtonEnable = false;
                    //     rightButtonColor = Colors.grey[300];
                    //   });

                    //   break;
                    // }
                    // }
                  }
                : null,
            child: Icon(
              Icons.arrow_forward_ios,
              color: widget.endDate.isAfter(_selectedDate)
                  ? Colors.black
                  : Colors.grey[300],
              size: 12.0,
            ),
          ),
        ],
      ),
    ).onClick(onTap: () {
      showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(DateTime.now().year + 2),
      ).then((date) {
        if (date != null)
          setState(() {
            _selectedDate = date;
            widget.onDateChange(_selectedDate);
          });
      });
    });
  }
}
