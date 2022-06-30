import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:intl/intl.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard(
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
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16))),
              color: AppColors.goldenTainoi,
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

              // Positioned(
              //   bottom: 4,
              //   right: 10,
              //   child: Row(
              //     children: [
              //       Text(
              //         time,
              //         style: TextStyle(
              //           fontSize: 13,
              //           color: Colors.grey[600],
              //         ),
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       // Icon(
              //       //   Icons.done_all,
              //       //   size: 20,
              //       // ),
              //     ],
              //   ),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 0,
                bottom: 0,
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
