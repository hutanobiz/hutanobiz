import 'dart:convert';
import 'dart:math';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/video_call.dart';
import 'package:hutano/screens/appointments/virtualappointment/overlay_handler.dart';
import 'package:hutano/screens/appointments/virtualappointment/overlay_service.dart';
import 'package:hutano/screens/chat/models/seach_doctor_data.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;
import 'package:provider/provider.dart';

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
        .then((RemoteMessage? message) {
      if (message != null) {
        navigateUser(message);
      }
    });
    // await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("onMessage: $message");

        String notificationType = message.data['notification_type'] ?? "";

        switch (notificationType) {
          case 'call':
          case 'call_join':
            Widgets.showCallDialog(
                context: navigatorContext!,
                isRejoin: true,
                onEnterCall: (bool record, bool video) async {
                  Map<Permission.Permission, Permission.PermissionStatus>
                      statuses = await [
                    Permission.Permission.camera,
                    Permission.Permission.microphone
                  ].request();
                  if ((statuses[Permission.Permission.camera]!.isGranted) &&
                      (statuses[Permission.Permission.microphone]!.isGranted)) {
                    var map = {};
                    map['_id'] = message.data['appointmentId'];
                    map['video'] = video;
                    map['record'] = record;
                    Navigator.pop(navigatorContext!);
                      OverlayService().addVideosOverlay(
                        Provider.of<OverlayHandlerProvider>(navigatorContext!,
                                listen: false)
                            .videCallContext,
                        CallPage(channelName: map));
                    // Navigator.of(navigatorContext)
                    //     .pushReplacementNamed(Routes.callPage, arguments: map);
                  } else {
                    Widgets.showErrorialog(
                        context: navigatorContext!,
                        description: 'Camera & Microphone permission Requied');
                  }
                },
                onCancelCall: () {
                  Navigator.pop(navigatorContext!);
                });

            break;
            case 'hold_and_resume':
            if (!isCurrent(Routes.trackTelemedicineAppointment,
                message.data['appointmentId'])) {
              showNotification(message);
            } else {
              Navigator.of(navigatorContext!).pushReplacementNamed(
                Routes.trackTelemedicineAppointment,
                arguments: message.data['appointmentId'],
              );
              showNotification(message);
            }
            break;
          case 'ready_to_join':
            if (message.data['isUserJoin'] == "true") {
              if (!isCurrent(Routes.trackTelemedicineAppointment,
                  message.data['appointmentId'])) {
                // Navigator.of(navigatorContext).pushNamed(
                //   Routes.trackTelemedicineAppointment,
                //   arguments: message.data['appointmentId'],
                // );
                showNotification(message);
              } else {
                Navigator.of(navigatorContext!).pushReplacementNamed(
                  Routes.trackTelemedicineAppointment,
                  arguments: message.data['appointmentId'],
                );
                showNotification(message);
              }
            } else {
              if (!isCurrent(Routes.trackTelemedicineAppointment,
                  message.data['appointmentId'])) {
                Widgets.showConfirmationDialog(
                    context: navigatorContext,
                    title: 'Call request',
                    description: 'Do you want to enter to waiting room?',
                    leftText: 'Cancel',
                    onLeftPressed: () {
                      Navigator.pop(navigatorContext!);
                    },
                    rightText: 'Waiting Room',
                    onRightPressed: () {
                      // SharedPref().getToken().then((token) {
                      var appointmentId = {};
                      appointmentId['appointmentId'] =
                          message.data['appointmentId'];
                      api
                          .patientAvailableForCall(
                              "Bearer ${getString(PreferenceKey.tokens)}",
                              appointmentId)
                          .then((value) {
                        Navigator.pop(navigatorContext!);
                        Navigator.of(navigatorContext!).pushNamed(
                            Routes.trackTelemedicineAppointment,
                            arguments: message.data['appointmentId']);
                      });
                    });
                // });
                showNotification(message);
              } else {
                SharedPref().getToken().then((token) {
                  var appointmentId = {};
                  appointmentId['appointmentId'] =
                      message.data['appointmentId'];
                  api
                      .patientAvailableForCall(token, appointmentId)
                      .then((value) {
                    Navigator.of(navigatorContext!).pushReplacementNamed(
                      Routes.trackTelemedicineAppointment,
                      arguments: message.data['appointmentId'],
                    );
                  });
                });
                showNotification(message);
              }
            }
            break;
          case 'tracking':
            if (message.data['appointmentType'] == '1') {
              if (!isCurrent(Routes.trackOfficeAppointment,
                  message.data['appointmentId'])) {
                // Navigator.of(navigatorContext).pushNamed(
                //   Routes.trackOfficeAppointment,
                //   arguments: message.data['appointmentId'],
                // );
                showNotification(message);
              } else {
                Navigator.of(navigatorContext!).pushReplacementNamed(
                  Routes.trackOfficeAppointment,
                  arguments: message.data['appointmentId'],
                );
                showNotification(message);
              }
            } else if (message.data['appointmentType'] == '3') {
              if (!isCurrent(Routes.trackOnsiteAppointment,
                  message.data['appointmentId'])) {
                // Navigator.of(navigatorContext).pushNamed(
                //   Routes.trackOnsiteAppointment,
                //   arguments: message.data['appointmentId'],
                // );
                showNotification(message);
              } else {
                Navigator.of(navigatorContext!).pushReplacementNamed(
                  Routes.trackOnsiteAppointment,
                  arguments: message.data['appointmentId'],
                );
                showNotification(message);
              }
            } else {
              showNotification(message);
            }

            break;
          case 'treatment_summary':
            if (message.data['state'] == 'treatmentComplete') {
              if (message.data['appointmentType'] == '1') {
                if (!isCurrent(Routes.trackOfficeAppointment,
                    message.data['appointmentId'])) {
                  // Navigator.of(navigatorContext).pushNamed(
                  //   Routes.trackOfficeAppointment,
                  //   arguments: message.data['appointmentId'],
                  // );
                  showNotification(message);
                } else {
                  Navigator.of(navigatorContext!).pushReplacementNamed(
                    Routes.trackOfficeAppointment,
                    arguments: message.data['appointmentId'],
                  );
                  showNotification(message);
                }
              } else if (message.data['appointmentType'] == '3') {
                if (!isCurrent(Routes.trackOnsiteAppointment,
                    message.data['appointmentId'])) {
                  // Navigator.of(navigatorContext).pushNamed(
                  //   Routes.trackOnsiteAppointment,
                  //   arguments: message.data['appointmentId'],
                  // );
                  showNotification(message);
                } else {
                  Navigator.of(navigatorContext!).pushReplacementNamed(
                    Routes.trackOnsiteAppointment,
                    arguments: message.data['appointmentId'],
                  );
                  showNotification(message);
                }
              } else {
                showNotification(message);
              }
            } else {
              showNotification(message);
            }

            break;
          case 'chatNotification':
            if (!isCurrentChatAppointment(
                Routes.chat, message.data['appointmentId'])) {
              showNotification(message);
            } else {
              showNotification(message);
            }
            break;
          case 'follow_up_request':
            showNotification(message, id: 1);
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
        onSelectNotification: (String? payload) async {
      print(payload);
      RemoteMessage data = RemoteMessage(data: jsonDecode(payload!));
      navigateUser(data);
    });
  }

  void showNotification(RemoteMessage message, {int? id}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'xyz.appening.hutano',
      'Hutano Patient',
      channelDescription: 'your channel description',
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
        id ?? 0,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: json.encode(message.data));
  }

  navigateUser(RemoteMessage message) {
    String notificationType = message.data['notification_type'] ?? "";

    switch (notificationType) {
      case 'call':
      case 'call_join':
        Navigator.of(navigatorContext!).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: message.data['appointmentId'],
        );
        break;
         case 'hold_and_resume':
        if (!isCurrent(Routes.trackTelemedicineAppointment,
            message.data['appointmentId'])) {
          Navigator.pushNamed(
            navigatorContext!,
            Routes.trackTelemedicineAppointment,
            arguments: message.data['appointmentId'],
          );
        } else {
          Navigator.of(navigatorContext!).pushReplacementNamed(
            Routes.trackTelemedicineAppointment,
            arguments: message.data['appointmentId'],
          );
        }
        break;
      case 'ready_to_join':
        Navigator.pushNamed(
          navigatorContext!,
          Routes.trackTelemedicineAppointment,
          arguments: message.data['appointmentId'],
        );
        break;
      case 'call-reminder':
        Navigator.of(navigatorContext!).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: message.data['appointmentId'],
        );
        break;

      case 'tracking':
        if (message.data['appointmentType'] == '1') {
          if (!isCurrent(
              Routes.trackOfficeAppointment, message.data['appointmentId'])) {
            Navigator.of(navigatorContext!).pushNamed(
              Routes.trackOfficeAppointment,
              arguments: message.data['appointmentId'],
            );
          } else {
            Navigator.of(navigatorContext!).pushReplacementNamed(
              Routes.trackOfficeAppointment,
              arguments: message.data['appointmentId'],
            );
          }
        } else {
          if (!isCurrent(
              Routes.trackOnsiteAppointment, message.data['appointmentId'])) {
            Navigator.of(navigatorContext!).pushNamed(
              Routes.trackOnsiteAppointment,
              arguments: message.data['appointmentId'],
            );
          } else {
            Navigator.of(navigatorContext!).pushReplacementNamed(
              Routes.trackOnsiteAppointment,
              arguments: message.data['appointmentId'],
            );
          }
        }

        break;

      case 'request_status':
        Navigator.of(navigatorContext!).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: message.data['appointmentId'],
        );

        break;

      case 'treatment_summary':
        if (message.data['appointmentType'] == '1') {
          if (!isCurrent(
              Routes.trackOfficeAppointment, message.data['appointmentId'])) {
            Navigator.of(navigatorContext!).pushNamed(
              Routes.trackOfficeAppointment,
              arguments: message.data['appointmentId'],
            );
          } else {
            Navigator.of(navigatorContext!).pushReplacementNamed(
              Routes.trackOfficeAppointment,
              arguments: message.data['appointmentId'],
            );
          }
        } else if (message.data['appointmentType'] == '2') {
          Navigator.of(navigatorContext!).pushNamed(
            Routes.appointmentDetailScreen,
            arguments: message.data['appointmentId'],
          );
        } else {
          if (!isCurrent(
              Routes.trackOnsiteAppointment, message.data['appointmentId'])) {
            Navigator.of(navigatorContext!).pushNamed(
              Routes.trackOnsiteAppointment,
              arguments: message.data['appointmentId'],
            );
          } else {
            Navigator.of(navigatorContext!).pushReplacementNamed(
              Routes.trackOnsiteAppointment,
              arguments: message.data['appointmentId'],
            );
          }
        }
        break;
      case 'chatNotification':
        if (!isCurrentChatAppointment(
            Routes.chat, message.data['appointmentId'])) {
          SharedPref().getToken().then((token) {
            api
                .getChatAppointmentDetails(token, message.data['appointmentId'])
                .then((value) {
              Navigator.of(navigatorContext!).pushNamed(Routes.chat,
                  arguments: SearchAppointment.fromJson(value));
            });
          });
        } else {}

        break;

      case 'follow_up_request':
        Navigator.of(navigatorContext!).pushNamed(
          Routes.requestDetailScreen,
          arguments: message.data['appointmentId'],
        );
        break;

      default:
        Navigator.of(navigatorContext!).pushNamed(
          Routes.appointmentDetailScreen,
          arguments: message.data['appointmentId'],
        );
    }
  }

  bool isCurrent(String routeName, args) {
    bool isCurrent = false;
    Navigator.popUntil(navigatorContext!, (route) {
      if (route.settings.name == routeName) {
        if (route.settings.arguments == args) {
          isCurrent = true;
        }
      }
      return true;
    });
    return isCurrent;
  }

  bool isCurrentChatAppointment(String routeName, args) {
    bool isCurrent = false;
    Navigator.popUntil(navigatorContext!, (route) {
      if (route.settings.name == routeName) {
        SearchAppointment routeArg = route.settings.arguments as SearchAppointment;
        if (routeArg.sId == args) {
          isCurrent = true;
        }
      }
      return true;
    });
    return isCurrent;
  }
}
