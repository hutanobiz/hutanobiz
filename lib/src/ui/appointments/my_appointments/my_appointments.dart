import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/custom_scaffold.dart';
import 'appointment_list.dart';
import 'model/appointment_model.dart';
import 'model/res_appointment_list.dart';

class MyAppointments extends StatefulWidget {
  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs;
  int _currentIndex = 0;
  final List<ResAppointmentDetail> _appointmentList = [];
  List _apppointmentCount;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    tabs = ['Office', 'Video chat', 'Onsite'];
    _apppointmentCount = ['0', '0', '0'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  void updateAppointmentCount(count) {
    setState(() {
      _apppointmentCount[0] = count.toString();
    });
  }

  _tabsContent() {
    if (_currentIndex == 0) {
      return AppointmentList(updateAppointmentCount: updateAppointmentCount
          // appointmentList: _appointmentList,
          );
    } else if (_currentIndex == 1) {
      return Container();
    } else if (_currentIndex == 2) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Localization.of(context).myAppointments,
            style: TextStyle(
                fontSize: fontSize18,
                color: colorDarkPurple,
                fontWeight: fontWeightSemiBold),
          ),
          SizedBox(
            height: 30,
          ),
          TabBar(
            labelPadding: EdgeInsets.all(0),
            indicatorColor: Colors.transparent,
            controller: _tabController,
            
            tabs: _tabsHeader(),
          ),
          SizedBox(
            height: 30,
          ),
          _tabsContent(),
        ],
      ),
    );
  }

  List<Widget> _tabsHeader() {
    return tabs
        .asMap()
        .map((index, text) => MapEntry(
              index,
              Container(
                alignment: Alignment.center,
                height: 60,
                decoration: BoxDecoration(
                    color: _tabController.index == index
                        ? colorYellow
                        : colorWhite,
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorBlack),
                    ),
                    Text(
                      '${_apppointmentCount[index]} appt.',
                      style: TextStyle(
                          color: _tabController.index == index
                              ? colorWhite
                              : colorYellow),
                    )
                  ],
                ),
              ),
            ))
        .values
        .toList();
  }
}
