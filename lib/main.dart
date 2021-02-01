import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/models/medicalHistory.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/medical_history.dart';
import 'package:hutano/screens/dashboard/dashboardScreen.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/src/ui/auth/login_pin/login_pin.dart';
import 'package:hutano/src/ui/auth/signin/signin_screen.dart';
import 'package:hutano/src/ui/medical_history/my_medical_history.dart';
import 'package:hutano/src/ui/medical_history/provider/appoinment_provider.dart';
import 'package:hutano/src/ui/registration_steps/add_provider/add_provider.dart';
import 'package:hutano/src/ui/registration_steps/home/home.dart';
import 'package:hutano/src/ui/registration_steps/payment/provider/credit_card_provider.dart';
import 'package:hutano/src/ui/welcome/welcome_screen.dart';
import 'package:hutano/src/utils/localization/localization.dart';
import 'package:hutano/src/utils/navigation.dart';
import 'package:hutano/src/utils/preference_key.dart';
import 'package:hutano/src/utils/preference_utils.dart';
import 'package:hutano/src/utils/size_config.dart';
import 'package:hutano/theme.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());

  // bool _result = await SharedPref().checkValue("token");
  // if (_result) {
  //   _defaultHome = HomeScreen();
  // }

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]).whenComplete(() {
  //   runApp(
  //     InheritedContainer(
  //       child: MaterialApp(
  //         title: "Flutter Home",
  //         debugShowCheckedModeBanner: false,
  //         theme: AppTheme.theme,
  //         home: _defaultHome,
  //         onGenerateRoute: Routes.generateRoute,
  //         navigatorKey: navigatorKey,
  //       ),
  //     ),
  //   );
  // });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreditCardProvider()),
        ChangeNotifierProvider(create: (_) => SymptomsInfoProvider())
      ],
      child: InheritedContainer(
        child: MaterialApp(
          title: 'Hutano',
          theme: AppTheme.theme,
          // theme: ThemeData(
          //   primarySwatch: Colors.indigo,
          //   fontFamily: 'Gilroy',
          //   pageTransitionsTheme: PageTransitionsTheme(builders: {
          //     TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          //   }),
          // ),
          // initialRoute: routeLaunch,
          onGenerateRoute: Routes.generateRoute,
          navigatorKey: navigatorKey,
          home: _gotoNextScreen(context),
          // onGenerateRoute: NavigationUtils.generateRoute,
          localizationsDelegates: [
            const MyLocalizationsDelegate(),
            CountryLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''),
            const Locale('it'),
            const Locale('fr'),
            const Locale('es'),
            const Locale('de'),
            const Locale('pt'),
          ],
        ),
      ),
    );
  }

  Widget _gotoNextScreen(context) {
    
    var emailVerified = getBool(PreferenceKey.isEmailVerified, false);
    var phone = getString(PreferenceKey.phone);
    var token = getString(PreferenceKey.tokens);
    var skipStep = getBool(PreferenceKey.skipStep, false);
    var performedStep = getBool(PreferenceKey.perFormedSteps, false);
    var isSetupPin = getBool(PreferenceKey.setPin, false);


    if (token.isNotEmpty) {
      if (skipStep || performedStep) {
        if (isSetupPin) {
          return LoginPin();
        } else {
          return HomeScreen();
        }
      } else if (!performedStep) {
        return WelcomeScreen();
      } else {
        return SignInScreen();
      }
    } else {
      return SignInScreen();
    }
  }
}
