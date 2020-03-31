import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  AppointmentsScreen({Key key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Center(
          child: Text("Appointments"),
        ),
      ),
    );
  }
}
