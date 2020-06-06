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
    RequestAppointmentsScreen(),
    SettingScreen(),
  ];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      setState(() {
        print(payload);
        var data = jsonDecode(payload);
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";// TODO: static status
        appointment["id"] = Platform.isIOS
            ? data['appointmentId']
            : data["data"]['appointmentId'];
        Navigator.of(context).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: appointment,
        );
      });
    });
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.example.hutano' : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'].toString(),
        message['notification']['body'].toString(),
        platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  void initState() {
    configLocalNotification();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        setState(() {
          Map appointment = {};
          appointment["_appointmentStatus"] = "1";
          appointment["id"] = message["data"]['appointmentId'];
          Navigator.of(context).pushNamed(
            Routes.appointmentDetailScreen,
            arguments: appointment,
          );
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        setState(() {
          Navigator.popUntil(
              context, (Route<dynamic> route) => route is PageRoute);
          Map appointment = {};
          appointment["_appointmentStatus"] = "1";
          appointment["id"] = message["data"]['appointmentId'];
          Navigator.of(context).pushNamed(
            Routes.appointmentDetailScreen,
            arguments: appointment,
          );
        });
      },
    );
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

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
