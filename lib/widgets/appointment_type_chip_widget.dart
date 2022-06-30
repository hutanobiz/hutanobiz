import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class AppointmentTypeChipWidget extends StatelessWidget {
  const AppointmentTypeChipWidget({
    Key? key,
    required this.appointmentType,
  }) : super(key: key);

  final int? appointmentType;

  @override
  Widget build(BuildContext context) {
    String appointmentTypeString;
    switch (appointmentType) {
      case 1:
        appointmentTypeString = "Office Appt.";
        break;
      case 2:
        appointmentTypeString = "Video Appt.";
        break;
      default:
        appointmentTypeString = "Onsite Appt.";
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Text(
        appointmentTypeString,
        style: TextStyle(
          fontSize: 12.0,
          color: AppColors.goldenTainoii,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
