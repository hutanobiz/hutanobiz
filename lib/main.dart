import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/familynetwork/add_family_member/add_family_member.dart';
import 'package:hutano/screens/familynetwork/add_family_member/family_provider.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/home_main.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/screens/payment/add_card_complete.dart';
import 'package:hutano/screens/payment/add_insruance_complete.dart';
import 'package:hutano/screens/payment/add_insurance.dart';
import 'package:hutano/screens/payment/add_new_card.dart';
import 'package:hutano/screens/payment/add_payment_option.dart';
import 'package:hutano/screens/providercicle/my_provider_network/my_provider_network.dart';
import 'package:hutano/screens/providercicle/provider_search/provider_search.dart';
import 'package:hutano/screens/registration/email_verification_complete.dart';
import 'package:hutano/screens/registration/invite_family/invite_family.dart';
import 'package:hutano/screens/registration/login_pin/login_pin.dart';
import 'package:hutano/screens/registration/onboarding.dart';
import 'package:hutano/screens/registration/verify_email_otp.dart';
import 'package:hutano/screens/registration/welcome_screen.dart';
import 'package:hutano/theme.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
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
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = LoginScreen();
  await Firebase.initializeApp();
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

  bool _result = await SharedPref().checkValue("token");
  bool isIntro = await SharedPref().getValue("isIntro") ?? false;
  bool skipStep = await SharedPref().getValue("skipStep") ?? false;
  bool performedStep = await SharedPref().getValue("perFormedSteps") ?? false;
  bool isSetupPin = await SharedPref().getValue("setPin") ?? false;

  if (!isIntro) {
    _defaultHome = OnBoardingPage();
  } else if (_result) {
    if (skipStep || performedStep) {
      if (isSetupPin) {
        _defaultHome = LoginPin();
      } else {
        _defaultHome = HomeMain();
      }
    } else if (!performedStep) {
      _defaultHome = WelcomeScreen();
    } else {
      _defaultHome = LoginScreen();
    }
  } else {
    _defaultHome = LoginScreen();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).whenComplete(() {
    runApp(MultiProvider(
      providers: [ListenableProvider(create: (_) => FamilyProvider())],
      child: InheritedContainer(
        child: MaterialApp(
          title: "Hutano",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          home: _defaultHome,
          onGenerateRoute: Routes.generateRoute,
          navigatorKey: navigatorKey,
        ),
      ),
    ));
  });
}
