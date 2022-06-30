import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard(
      {Key? key,
      required this.message,
      required this.time,
      required this.isLocalTime})
      : super(key: key);
  final String? message;
  final String? time;
  final bool isLocalTime;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.grey[200],
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16))),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  message!,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 50,
                top: 0,
                bottom: 5,
              ),
              child: Text(
                isLocalTime
                    ? DateFormat('hh:mm a').format(DateTime.parse(time!))
                    : DateFormat('hh:mm a')
                        .format(DateTime.parse(time!).toLocal()),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
