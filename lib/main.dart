import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hutano/apis/api_constants.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/virtualappointment/overlay_handler.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/chat/chat_provider.dart';
import 'package:hutano/screens/familynetwork/add_family_member/family_provider.dart';
import 'dart:io' as IO;
import 'dart:ui' as UI;
import 'package:hutano/screens/home_main.dart';
import 'package:hutano/screens/medical_history/provider/appoinment_provider.dart';
import 'package:hutano/screens/registration/login_pin/login_pin.dart';
import 'package:hutano/screens/registration/onboarding.dart';
import 'package:hutano/screens/registration/payment/provider/credit_card_provider.dart';
import 'package:hutano/screens/registration/signin/signin_screen.dart';
import 'package:hutano/screens/registration/welcome_screen.dart';
import 'package:hutano/screens/setup_pin/set_pin.dart';
import 'package:hutano/screens/users/linked_account_provider.dart';
import 'package:hutano/theme.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';


final navigatorKey = GlobalKey<NavigatorState>();
final navigatorContext = navigatorKey.currentContext;

// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'Hutano', // id
  'Hutano', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = kstripePublishKey;
  initializeDateFormatting();
  await init();
  Widget _defaultHome = SignInScreen();
  await Firebase.initializeApp();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // bool _result = await SharedPref().checkValue("token");
  // bool isIntro = await SharedPref().getValue("isIntro") ?? false;
  // bool skipStep = await SharedPref().getValue("skipStep") ?? false;
  // bool performedStep = await SharedPref().getValue("perFormedSteps") ?? false;
  // bool isSetupPin = await SharedPref().getValue("setPin") ?? false;

  var token = getString(PreferenceKey.tokens);
  var skipStep = getBool(PreferenceKey.skipStep, false);
  var performedStep = getBool(PreferenceKey.perFormedSteps, false);
  var isSetupPin = getBool(PreferenceKey.setPin, false);
  var isIntro = getBool(PreferenceKey.intro, false);
  if (!isIntro) {
    _defaultHome = OnBoardingPage();
  } else if (token.isNotEmpty) {
    if (skipStep || performedStep) {
      if (isSetupPin) {
        _defaultHome = LoginPin();
      } else {
        _defaultHome = HomeMain();
      }
    } else if (!performedStep) {
      _defaultHome = WelcomeScreen();
    } else {
      _defaultHome = SignInScreen();
    }
  } else {
    _defaultHome = SignInScreen();
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  final double devicePixelRatio = UI.window.devicePixelRatio;
  final UI.Size size = UI.window.physicalSize;
  final double width = size.width;
  final double height = size.height;
  List<DeviceOrientation> orientationList = [
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ];

  if (IO.Platform.isAndroid) {
    if (devicePixelRatio <= 2.5 && (width >= 1000 || height >= 1000)) {
      orientationList = [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft
      ];
    } else if (devicePixelRatio == 2.5 && (width >= 1920 || height >= 1920)) {
      orientationList = [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft
      ];
    } else {
      orientationList = [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ];
    }
  }
  SystemChrome.setPreferredOrientations(orientationList).whenComplete(() {
    runApp(MultiProvider(
      providers: [
        // ListenableProvider(create: (_) => FamilyProvider())
        ChangeNotifierProvider(create: (_) => CreditCardProvider()),
        ChangeNotifierProvider(create: (_) => SymptomsInfoProvider()),
        ListenableProvider(create: (_) => FamilyProvider()),
        ListenableProvider(create: (_) => HealthConditionProvider()),
        ListenableProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => LinkedAccountProvider()),
         ChangeNotifierProvider<OverlayHandlerProvider>(
          create: (_) => OverlayHandlerProvider(),)
      ],
      child: InheritedContainer(
        child: MaterialApp(
          title: "Hutano",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          home: _defaultHome,
          onGenerateRoute: Routes.generateRoute,
          navigatorKey: navigatorKey,
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
    ));
  });
}
