import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/main.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/chat/chat_provider.dart';
import 'package:hutano/screens/chat/models/chat_data_model.dart';
import 'package:hutano/screens/chat/models/seach_doctor_data.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketClass {
  Function? onMessgae;

  Socket socket = io(
      '${ApiBaseHelper.socket_url}?userId=${getString(PreferenceKey.id)}',
      <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
  void connect() {
    if (!socket.connected) {
      socket.connect();
    }
    socket.onConnect((data) {
      print("Connected");
      socket.on("receiveMessage", (msg) {
        print(msg);
        if (!isCurrentChatAppointment(
            Routes.chat, Message.fromJson(msg).appointmentId)) {
        } else {
          Provider.of<ChatProvider>(navigatorContext!, listen: false)
              .add(Message.fromJson(msg));
        }
      });
    });
    print(socket.connected);
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

  sendMessage(Message message) {
    socket.emitWithAck('sendMessage', message.toJson(), ack: (as) {
      print(as);
    });
  }
}
