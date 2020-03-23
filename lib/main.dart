import 'package:flutter/material.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/dashboard/dashboardScreen.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/theme.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = LoginScreen();

  bool _result = await SharedPref().checkValue("token");
  if (_result) {
    _defaultHome = DashboardScreen();
  }

  runApp(
    InheritedContainer(
      child: MaterialApp(
        title: "Flutter Home",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: _defaultHome,
        onGenerateRoute: Routes.generateRoute,
      ),
    ),
  );
}
