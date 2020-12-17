import 'package:flutter/material.dart';
import 'package:hutano/screens/dashboard/appointments_screen.dart';
import 'package:hutano/screens/dashboard/requests_appointments_screen.dart';
import 'package:hutano/widgets/loading_background.dart';

import '../../colors.dart';

class AllAppointments extends StatefulWidget {
  @override
  _AllAppointmentsState createState() => _AllAppointmentsState();
}

class _AllAppointmentsState extends State<AllAppointments>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs;
  int _currentIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    tabs = ['Past Appointment', 'Request'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Appointments",
        isAddBack: false,
        color: Colors.white,
        child: Column(
          children: [
            TabBar(
              labelPadding: EdgeInsets.all(0),
              indicatorColor: Colors.transparent,
              controller: _tabController,
              tabs: _tabsHeader(),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: _tabsContent(),
            )
          ],
        ),
      ),
    );
  }

  _tabsContent() {
    if (_currentIndex == 0) {
      return AppointmentsScreen();
    } else if (_currentIndex == 1) {
      return RequestAppointmentsScreen();
    }
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
                        ? AppColors.goldenTainoi
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            ))
        .values
        .toList();
  }
}
