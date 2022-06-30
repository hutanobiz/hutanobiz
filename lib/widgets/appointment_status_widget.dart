import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class AppointmentStatusWidget extends StatelessWidget {
  AppointmentStatusWidget({Key? key, required this.status}) : super(key: key);
  int? status;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: status == 2 || status == 6 || status == 7
              ? Colors.red.withOpacity(0.2)
              : status == 1 || status == 4
                  ? Colors.green.withOpacity(0.2)
                  : AppColors.goldenTainoi.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Text(
        status == 0
            ? 'Pending'
            : status == 1
                ? 'Accepted'
                : status == 2
                    ? "Rejected"
                    : status == 3
                        ? "Initiated"
                        : status == 4
                            ? "Completed"
                            : status == 5
                                ? "Incomplete"
                                : status == 6
                                    ? "Cancelled"
                                    : "Expired",
        style: TextStyle(
            color: status == 2 || status == 6 || status == 7
                ? Colors.red
                : status == 1 || status == 4
                    ? Colors.green
                    : AppColors.goldenTainoi,
            fontSize: 13,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
