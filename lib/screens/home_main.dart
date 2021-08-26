import 'package:flutter/material.dart';
import 'package:hutano/screens/chat/socket_class.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/push_notificaton_service.dart';

class HomeMain extends StatelessWidget {
  const HomeMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService();
    pushNotificationService.initialise();
    SocketClass().connect();
    return HomeScreen(currentIndex: 0);
  }
}