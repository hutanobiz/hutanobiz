import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/chat/chat_provider.dart';
import 'package:hutano/screens/chat/models/chat_data_model.dart';
import 'package:hutano/screens/chat/models/seach_doctor_data.dart';
import 'package:hutano/screens/chat/socket_class.dart';
import 'package:hutano/screens/chat/ui/OwnMessgaeCrad.dart';
import 'package:hutano/screens/chat/ui/ReplyCard.dart';
import 'package:hutano/utils/date_picker.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Chat extends StatefulWidget {
  Chat({Key key, this.appointment}) : super(key: key);
  SearchAppointment appointment;

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  bool sendButton = false;

  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
     Provider.of<ChatProvider>(context, listen: false).clearMessageList();
    getChatDetail();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  getChatDetail() async {
    var messageData = await ApiManager().getChatDetail(widget.appointment.sId);
    try {
      Provider.of<ChatProvider>(context, listen: false)
          .addAll(messageData.response.reversed.toList());
    } catch (e) {}
  }

  sendChatMessage() {
    sendMessage(Message(
        sender: widget.appointment.user,
        receiver: widget.appointment.doctor[0].sId,
        message: textEditingController.text,
        appointmentId: widget.appointment.sId));
  }

  sendMessage(Message message) {
    SocketClass().sendMessage(message);
    message.createdAt =
        formattedDate(DateTime.now(), "yyyy-MM-dd'T'HH:mm:ss.SSS'Z");
    setMessage(message);
  }

  Future<void> setMessage(Message message) async {
    Provider.of<ChatProvider>(context, listen: false).add(message);
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "",
        padding: const EdgeInsets.only(top: 0),
        isAddBack: false,
        addHeader: true,
        isBackRequired: true,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: Consumer<ChatProvider>(
                  builder: (context, todos, child) => ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    controller: scrollController,
                    itemCount: todos.messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == todos.messages.length) {
                        return Container(height: 70);
                      }
                      if (todos.messages[index].sender ==
                          widget.appointment.user) {
                        return OwnMessageCard(
                            message: todos.messages[index].message,
                            time: todos.messages[index].createdAt,
                            isLocalTime: todos.messages[index].updatedAt == null
                                ? true
                                : false);
                      } else {
                        return ReplyCard(
                            message: todos.messages[index].message,
                            time: todos.messages[index].createdAt,
                            isLocalTime: todos.messages[index].updatedAt == null
                                ? true
                                : false);
                      }
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.0),
                  ),
                  border: Border.all(color: Colors.grey[300]),
                ),
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textEditingController,
                        textAlignVertical: TextAlignVertical.top,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        onChanged: (value) {
                          if (value.length > 0) {
                            sendButton = true;
                          } else {
                            sendButton = false;
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 4, right: 2, left: 2, top: 4),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.goldenTainoi,
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (sendButton) {
                              sendChatMessage();
                              textEditingController.clear();
                              sendButton = false;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
