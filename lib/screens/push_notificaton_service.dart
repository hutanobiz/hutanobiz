import 'dart:convert';
import 'dart:io';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  ApiBaseHelper api = ApiBaseHelper();

  Future initialise() async {
    configLocalNotification();

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        navigateUser(message);
      }
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("onMessage: $message");

        String notificationType = Platform.isIOS
            ? message.data['notification_type'] ?? ""
            : message.data['notification_type'] ?? "";

        switch (notificationType) {
          case 'call':
          case 'call_join':
            Widgets.showConfirmationDialog(
                context: navigatorContext,
                title: 'Call request',
                description: 'Do you want to join call again?',
                leftText: 'Cancel',
                onLeftPressed: () {
                  Navigator.pop(navigatorContext);
                },
                rightText: 'Join',
                onRightPressed: () async {
                  Map<Permission.Permission, Permission.PermissionStatus>
                      statuses = await [
                    Permission.Permission.camera,
                    Permission.Permission.microphone
                  ].request();
                  if ((statuses[Permission.Permission.camera].isGranted) &&
                      (statuses[Permission.Permission.microphone].isGranted)) {
                    var map = {};
                    map['_id'] = Platform.isIOS
                        ? message.data['appointmentId']
                        : message.data['appointmentId'];
                    map['name'] = "---";
                    map['address'] = 'a';
                    map['dateTime'] = 't';
                    map['video'] = true;
                    map['record'] = true;
                    return Navigator.of(navigatorContext)
                        .popAndPushNamed(Routes.callPage,
                            // arguments: profileMap["data"]["_id"],
                            arguments: map);
                  } else {
                    Widgets.showErrorialog(
                        context: navigatorContext,
                        description: 'Camera & Microphone permission Requied');
                  }
                });
            break;
          case 'ready_to_join':
            bool isCurrent(String routeName) {
              var isCurrent = false;
              Navigator.popUntil(navigatorContext, (route) {
                if (route.settings.name == routeName) {
                  isCurrent = true;
                }
                return true;
              });
              return isCurrent;
            }
            if (Platform.isIOS
                ? message.data['isUserJoin']
                : message.data['isUserJoin'] == "true") {
              // Navigator.pop(navigatorContext);
              Navigator.pushReplacementNamed(
                  navigatorContext, Routes.telemedicineTrackTreatmentScreen,
                  arguments: Platform.isIOS
                      ? message.data['appointmentId']
                      : message.data['appointmentId']);
            } else {
              Widgets.showConfirmationDialog(
                  context: navigatorContext,
                  title: 'Call request',
                  description: 'Do you want to enter to waiting room?',
                  leftText: 'Cancel',
                  onLeftPressed: () {
                    Navigator.pop(navigatorContext);
                  },
                  rightText: 'Waiting Room',
                  onRightPressed: () {
                    if (!isCurrent(Routes.telemedicineTrackTreatmentScreen)) {
                      SharedPref().getToken().then((token) {
                        var appointmentId = {};
                        appointmentId['appointmentId'] = Platform.isIOS
                            ? message.data['appointmentId']
                            : message.data['appointmentId'];
                        api
                            .patientAvailableForCall(token, appointmentId)
                            .then((value) {
                          Navigator.of(navigatorContext).popAndPushNamed(
                              Routes.telemedicineTrackTreatmentScreen,
                              arguments: Platform.isIOS
                                  ? message.data['appointmentId']
                                  : message.data['appointmentId']);
                        });
                      });
                    } else {
                      SharedPref().getToken().then((token) {
                        var appointmentId = {};
                        appointmentId['appointmentId'] = Platform.isIOS
                            ? message.data['appointmentId']
                            : message.data['appointmentId'];
                        api
                            .patientAvailableForCall(token, appointmentId)
                            .then((value) {
                          Navigator.pop(navigatorContext);
                          Navigator.pushReplacementNamed(navigatorContext,
                              Routes.telemedicineTrackTreatmentScreen,
                              arguments: Platform.isIOS
                                  ? message.data['appointmentId']
                                  : message.data['appointmentId']);
                        });
                      });
                    }
                  });
            }
            break;
          default:
            showNotification(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      navigateUser(message);
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      print(payload);
      var data = jsonDecode(payload);
      navigateUser(data);
    });
  }

  void showNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'xyz.appening.hutano' : 'xyz.appening.hutano',
      'Hutano Patient',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        Platform.isAndroid
            ? message.notification.title
            : message.notification.title,
        Platform.isAndroid
            ? message.notification.body
            : message.notification.body,
        platformChannelSpecifics,
        payload: json.encode(message));
  }

  navigateUser(RemoteMessage message) {
    String notificationType = Platform.isIOS
        ? message.data['notification_type'] ?? ""
        : message.data['notification_type'] ?? "";

    switch (notificationType) {
      case 'call':
      case 'call_join':
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message.data['appointmentId']
            : message.data['appointmentId'];
        Navigator.of(navigatorContext).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: appointment,
        );
        break;
      case 'ready_to_join':
        Navigator.pushNamed(
          navigatorContext,
          Routes.telemedicineTrackTreatmentScreen,
          arguments: Platform.isIOS
              ? message.data['appointmentId']
              : message.data['appointmentId'],
        );
        break;
      case 'call-reminder':
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message.data['appointmentId']
            : message.data['appointmentId'];
        Navigator.of(navigatorContext).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: appointment,
        );
        break;

      case 'tracking':
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message.data['appointmentId']
            : message.data['appointmentId'];
        Navigator.of(navigatorContext).pushNamed(
          Routes.trackTreatmentScreen,
          arguments: Platform.isIOS
              ? message.data['appointmentType']
              : message.data['appointmentType'],
        );
        break;

      case 'request_status':
        var appointmentType = Platform.isIOS
            ? message.data['appointmentType']
            : message.data['appointmentType'];
        if (appointmentType == "2") {
          Navigator.pushNamed(
            navigatorContext,
            Routes.telemedicineTrackTreatmentScreen,
            arguments: Platform.isIOS
                ? message.data['appointmentId']
                : message.data['appointmentId'],
          );
        } else {
          Map appointment = {};
          appointment["_appointmentStatus"] = "1";
          appointment["id"] = Platform.isIOS
              ? message.data['appointmentId']
              : message.data['appointmentId'];
          Navigator.of(navigatorContext).pushNamed(
            Routes.appointmentDetailScreen,
            arguments: appointment,
          );
        }
        break;

      case 'treatment_summary':
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message.data['appointmentId']
            : message.data['appointmentId'];
        Navigator.of(navigatorContext).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: appointment,
        );
        break;
      default:
        String isTrack = Platform.isIOS
            ? message.data['isTrack'] ?? "false"
            : message.data['isTrack'] ?? "false";

        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message.data['appointmentId']
            : message.data['appointmentId'];

        if (isTrack == "true") {
          Navigator.of(navigatorContext).pushNamed(
            Routes.trackTreatmentScreen,
            arguments: Platform.isIOS
                ? message.data['appointmentType']
                : message.data['appointmentType'],
          );
        } else {
          Navigator.of(navigatorContext).pushNamed(
            Routes.appointmentDetailScreen,
            arguments: appointment,
          );
        }
    }
  }
}
