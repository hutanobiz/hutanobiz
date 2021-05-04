import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/dashboard/appointments_screen.dart';
import 'package:hutano/screens/dashboard/dashboardScreen.dart';
import 'package:hutano/screens/dashboard/requests_appointments_screen.dart';
import 'package:hutano/screens/dashboard/setting.dart';

const kstripePublishKey = 'pk_test_LlxS6SLz0PrOm9IY9mxM0LHo006tjnSqWX';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.currentIndex = 0}) : super(key: key);
  int currentIndex;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    DashboardScreen(),
    AppointmentsScreen(),
    RequestAppointmentsScreen(),
    SettingScreen(),
  ];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  

  @override
  void initState() {
    
    _currentIndex = widget.currentIndex;
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: bottomnavigationBar(),
    );
  }

  Widget bottomnavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(14.0),
          topLeft: Radius.circular(14.0),
        ),
        border: Border.all(width: 0.5, color: Colors.grey[300]),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(14.0),
          topLeft: Radius.circular(14.0),
        ),
        child: BottomNavigationBar(
          onTap: onTabTapped,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.persian_indigo,
          unselectedItemColor: Colors.grey[400],
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("images/ic_home.png"),
              ),
              activeIcon: ImageIcon(
                AssetImage("images/ic_active_home.png"),
              ),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("images/ic_appointments.png"),
              ),
              activeIcon: ImageIcon(
                AssetImage("images/ic_active_appointments.png"),
              ),
              title: Text('Appointments'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              title: Text('Requests'),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("images/ic_settings.png"),
              ),
              activeIcon: ImageIcon(
                AssetImage("images/ic_active_settings.png"),
              ),
              title: Text('Settings'),
            )
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}


