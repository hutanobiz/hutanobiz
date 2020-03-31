import 'package:flutter/material.dart';
import 'package:hutano/screens/dashboard/appointments.dart';
import 'package:hutano/screens/dashboard/setting.dart';

import '../../colors.dart';
import 'dashboardScreen.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DashboardScreen(),
    AppointmentsScreen(),
    SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.windsor,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("images/ic_home.png")),
            activeIcon: ImageIcon(AssetImage("images/ic_active_home.png")),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("images/ic_appointments.png")),
            activeIcon:
                ImageIcon(AssetImage("images/ic_active_appointments.png")),
            title: Text('Appointments'),
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/ic_settings.png")),
              activeIcon:
                  ImageIcon(AssetImage("images/ic_active_settings.png")),
              title: Text('Settings'))
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
