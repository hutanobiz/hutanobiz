import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ui/auth/login_pin/login_pin.dart';
import 'ui/auth/signin/signin_screen.dart';
import 'ui/medical_history/provider/appoinment_provider.dart';
import 'ui/registration_steps/home/home.dart';
import 'ui/registration_steps/payment/provider/credit_card_provider.dart';
import 'ui/welcome/welcome_screen.dart';
import 'utils/localization/localization.dart';
import 'utils/navigation.dart';
import 'utils/preference_key.dart';
import 'utils/preference_utils.dart';

Future<void> mainDelegate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
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
      child: MaterialApp(
        title: 'Hutano',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'Gilroy',
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
        ),
        // initialRoute: routeLaunch,
        home: _gotoNextScreen(context),
        onGenerateRoute: NavigationUtils.generateRoute,
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
          return LoginPin(
          );
        } else {
          return Home();
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
