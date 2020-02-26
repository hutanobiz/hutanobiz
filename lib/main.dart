import 'package:flutter/material.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/theme.dart';
import 'package:hutano/utils/shared_prefrences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = LoginScreen();

  bool _result = await SharedPref().checkValue("token");
  if (_result) {
    _defaultHome = new HomeScreen();
  }

  runApp(
    MaterialApp(
      title: "Flutter Home",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: _defaultHome,
      onGenerateRoute: Routes.generateRoute,
    ),
  );
}
