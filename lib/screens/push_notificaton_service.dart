import 'dart:convert';
import 'dart:io';
import 'package:hutano/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initialise() async {
    configLocalNotification();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        String notificationType = Platform.isIOS
            ? message['notification_type'] ?? ""
            : message["data"]['notification_type'] ?? "";

        switch (notificationType) {
          case 'call':
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
                        ? message['appointmentId']
                        : message["data"]['appointmentId'];
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
          case 'call_join':
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
                    Navigator.of(navigatorContext).popAndPushNamed(
                        Routes.telemedicineTrackTreatmentScreen,
                        arguments: Platform.isIOS
                            ? message['appointmentId']
                            : message["data"]['appointmentId']);
                  } else {
                    Navigator.pop(navigatorContext);
                    Navigator.pushReplacementNamed(navigatorContext,
                        Routes.telemedicineTrackTreatmentScreen,
                        arguments: Platform.isIOS
                            ? message['appointmentId']
                            : message["data"]['appointmentId']);
                  }
                });
            break;
          default:
            showNotification(message);
        }
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        navigateUser(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.popUntil(
            navigatorContext, (Route<dynamic> route) => route is PageRoute);
        navigateUser(message);
      },
    );
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      print(payload);
      var data = jsonDecode(payload);
      navigateUser(data);
    });
  }

  navigateUser(message) {
    String notificationType = Platform.isIOS
        ? message['notification_type'] ?? ""
        : message["data"]['notification_type'] ?? "";

    switch (notificationType) {
      case 'call':
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message['appointmentId']
            : message["data"]['appointmentId'];
        Navigator.of(navigatorContext).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: appointment,
        );
        break;
      case 'call_join':
        Navigator.pushNamed(
          navigatorContext,
          Routes.telemedicineTrackTreatmentScreen,
          arguments: Platform.isIOS
              ? message['appointmentId']
              : message["data"]['appointmentId'],
        );
        break;
      case 'call-reminder':
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message['appointmentId']
            : message["data"]['appointmentId'];
        Navigator.of(navigatorContext).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: appointment,
        );
        break;

      case 'tracking':
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message['appointmentId']
            : message["data"]['appointmentId'];
        Navigator.of(navigatorContext).pushNamed(
          Routes.trackTreatmentScreen,
          arguments: Platform.isIOS
              ? message['appointmentType']
              : message["data"]['appointmentType'],
        );
        break;

      case 'request_status':
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message['appointmentId']
            : message["data"]['appointmentId'];
        Navigator.of(navigatorContext).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: appointment,
        );
        break;

      case 'treatment_summary':
        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message['appointmentId']
            : message["data"]['appointmentId'];
        Navigator.of(navigatorContext).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: appointment,
        );
        break;
      default:
        String isTrack = Platform.isIOS
            ? message['isTrack'] ?? "false"
            : message["data"]['isTrack'] ?? "false";

        Map appointment = {};
        appointment["_appointmentStatus"] = "1";
        appointment["id"] = Platform.isIOS
            ? message['appointmentId']
            : message["data"]['appointmentId'];

        if (isTrack == "true") {
          Navigator.of(navigatorContext).pushNamed(
            Routes.trackTreatmentScreen,
            arguments: Platform.isIOS
                ? message['appointmentType']
                : message["data"]['appointmentType'],
          );
        } else {
          Navigator.of(navigatorContext).pushNamed(
            Routes.appointmentDetailScreen,
            arguments: appointment,
          );
        }
    }
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'xyz.appening.hutano' : 'xyz.appening.hutano',
      'Hutano Patient',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        Platform.isAndroid
            ? message['notification']['title'].toString()
            : message['aps']['alert']['title'].toString(),
        Platform.isAndroid
            ? message['notification']['body'].toString()
            : message['aps']['alert']['body'].toString(),
        platformChannelSpecifics,
        payload: json.encode(message));
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    final dynamic notification = message['notification'];
  }
}
