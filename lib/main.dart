import 'dart:async';

import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'screens/home.dart';
import 'src/ui/auth/login_pin/login_pin.dart';
import 'src/ui/auth/register/model/referral_code.dart';
import 'src/ui/auth/signin/signin_screen.dart';
import 'src/ui/medical_history/provider/appoinment_provider.dart';
import 'src/ui/onboarding/onboarding.dart';
import 'src/ui/registration_steps/payment/provider/credit_card_provider.dart';
import 'src/ui/welcome/welcome_screen.dart';
import 'src/utils/localization/localization.dart';
import 'src/utils/preference_key.dart';
import 'src/utils/preference_utils.dart';
import 'theme.dart';
import 'widgets/inherited_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
  FlutterBranchSdk.validateSDKIntegration();
  listnerData();
}

listnerData() {
  StreamSubscription<Map> streamSubscription =
      FlutterBranchSdk.initSession().listen((data) {
    if (data.containsKey("referralCode")) {
      Referral().referralCode = data["referralCode"];
      print('Custom string: ${data["custom_string"]}');
    }
  }, onError: (error) {
    PlatformException platformException = error as PlatformException;
    print(
        'InitSession error: ${platformException.code} - ${platformException.message}');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: colorYellow100 //or set color with: Color(0xFF0000FF)
    // ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreditCardProvider()),
        ChangeNotifierProvider(create: (_) => SymptomsInfoProvider())
      ],
      child: InheritedContainer(
        child: MaterialApp(
          title: 'Hutano',
          theme: AppTheme.theme,
          builder: (context, child) {
            return MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
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
    var isIntro = getBool(PreferenceKey.intro, false);
 

    if (!isIntro) {
      return OnBoardingPage();
    }
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
