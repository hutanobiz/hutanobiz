import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/screens/payment/insurance_list.dart';
import 'package:hutano/src/ui/add_insurance/add_insruance.dart';
import 'package:hutano/src/ui/medical_history/payment_methods.dart';
import 'package:hutano/src/ui/onboarding/onboarding.dart';
import 'package:hutano/src/ui/registration_steps/invite_family/invite_family.dart';
import 'package:hutano/src/ui/registration_steps/payment/add_payment_option.dart';
import 'package:hutano/src/ui/registration_steps/payment/card_complete/add_card_complete.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'screens/home.dart';
import 'src/ui/auth/login_pin/login_pin.dart';
import 'src/ui/auth/signin/signin_screen.dart';
import 'src/ui/medical_history/provider/appoinment_provider.dart';
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
    var isIntro = getBool(PreferenceKey.intro, false);
    // return AddInsurance();
    // return AddPaymentScreen();
    // return AddCardComplete();
    return InviteFamilyScreen();
    if (!isIntro) {
      return OnBoardingPage();
    }
    // Map _insuranceMap = {};
    // _insuranceMap['isPayment'] = false;
    // _insuranceMap['isFromRegister'] = true;

    // return InsuranceListScreen(insuranceMap: _insuranceMap);

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
