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

  final String displayDateFormat;

  ScrollingDayCalendar({
    @required this.startDate,
    @required this.endDate,
    @required this.selectedDate,
    this.onDateChange,
    this.displayDateFormat,
  });

  @override
  _ScrollingDayCalendarState createState() => _ScrollingDayCalendarState();
}

class _ScrollingDayCalendarState extends State<ScrollingDayCalendar> {
  DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.selectedDate;

    super.initState();
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
            onPressed: _selectedDate.day != widget.startDate.day
                ? () {
                    DateTime newDate = _selectedDate.subtract(
                      Duration(days: 1),
                    );

                    setState(() {
                      _selectedDate = newDate;
                    });

                    widget.onDateChange(_selectedDate);
                  }
                : null,
            child: Icon(
              Icons.arrow_back_ios,
              color: _selectedDate.day != widget.startDate.day
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
            onPressed: _selectedDate.day != widget.endDate.day
                ? () {
                    DateTime newDate = _selectedDate.add(
                      Duration(days: 1),
                    );

                    setState(() {
                      _selectedDate = newDate;
                    });

                    widget.onDateChange(_selectedDate);
                  }
                : null,
            child: Icon(
              Icons.arrow_forward_ios,
              color: _selectedDate.day != widget.endDate.day
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
