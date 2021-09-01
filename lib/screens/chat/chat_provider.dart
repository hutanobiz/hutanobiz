import 'package:flutter/material.dart';
import 'package:hutano/screens/chat/models/chat_data_model.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider();

  List<Message> messages = [];

  void add(Message message) {
    if (messages.first.sId != message.sId) {
      messages.insert(0, message);
      notifyListeners();
    }
  }

  void addAll(List<Message> previousMessages) {
    messages.addAll(previousMessages);
    notifyListeners();
  }

  void clearMessageList() {
    messages.clear();
    notifyListeners();
  }

  List<Message> get players {
    return messages;
  }
}
