import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/home_main.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/theme.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final navigatorContext = navigatorKey.currentContext;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = LoginScreen();

  bool _result = await SharedPref().checkValue("token");
  if (_result) {
    _defaultHome = HomeMain();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).whenComplete(() {
    runApp(
      InheritedContainer(
        child: MaterialApp(
          title: "Hutano",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          home: _defaultHome,
          onGenerateRoute: Routes.generateRoute,
          navigatorKey: navigatorKey,
        ),
      ),
    );
  });
}
