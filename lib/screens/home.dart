import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/dashboard/appointments_screen.dart';
import 'package:hutano/screens/dashboard/dashboardScreen.dart';
import 'package:hutano/screens/dashboard/requests_appointments_screen.dart';
import 'package:hutano/screens/dashboard/setting.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
