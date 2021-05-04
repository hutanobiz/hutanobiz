import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/home_main.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/theme.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';

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
