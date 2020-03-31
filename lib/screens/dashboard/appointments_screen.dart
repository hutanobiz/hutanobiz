import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white_smoke,
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
