import 'package:flutter/material.dart';
import 'package:hutano/utils/shared_prefrences.dart';

import '../../routes.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Center(
          child: RaisedButton(
            child: Text("Logout"),
            onPressed: () {
              SharedPref().clearSharedPref();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.loginRoute, (Route<dynamic> route) => false);
            },
          ),
        ),
      ),
    );
  }
}
