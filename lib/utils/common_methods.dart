import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/app_constants.dart';
import 'package:hutano/utils/date_picker.dart';

import 'constants/constants.dart';
import 'constants/key_constant.dart';

void antiAgingNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeBreathingIssue, arguments: {
    ArgumentConstant.isAntiAgingKey: true,
    ArgumentConstant.isStomachKey: false,
    ArgumentConstant.isBreathingKey: false,
    ArgumentConstant.isHealthChestKey: false,
    ArgumentConstant.isImmunizationKey: false
  });
}

void stomachNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeBreathingIssue, arguments: {
    ArgumentConstant.isAntiAgingKey: false,
    ArgumentConstant.isStomachKey: true,
    ArgumentConstant.isBreathingKey: false,
    ArgumentConstant.isHealthChestKey: false,
    ArgumentConstant.isImmunizationKey: false
  });
}

void breathingNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeBreathingIssue, arguments: {
    ArgumentConstant.isAntiAgingKey: false,
    ArgumentConstant.isStomachKey: false,
    ArgumentConstant.isBreathingKey: true,
    ArgumentConstant.isHealthChestKey: false,
    ArgumentConstant.isImmunizationKey: false
  });
}

void healthAndChestNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeBreathingIssue, arguments: {
    ArgumentConstant.isAntiAgingKey: false,
    ArgumentConstant.isStomachKey: false,
    ArgumentConstant.isBreathingKey: false,
    ArgumentConstant.isHealthChestKey: true,
    ArgumentConstant.isImmunizationKey: false
  });
}

void abnormalNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: true,
    ArgumentConstant.isMaleHealthKey: false,
    ArgumentConstant.isFemaleHealthKey: false,
    ArgumentConstant.isWoundSkinKey: false,
    ArgumentConstant.isDentalCareKey: false,
    ArgumentConstant.isMoodMentalKey: false
  });
}

void maleHealthNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: false,
    ArgumentConstant.isMaleHealthKey: true,
    ArgumentConstant.isFemaleHealthKey: false,
    ArgumentConstant.isWoundSkinKey: false,
    ArgumentConstant.isDentalCareKey: false,
    ArgumentConstant.isMoodMentalKey: false
  });
}

void femaleHealthNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: false,
    ArgumentConstant.isMaleHealthKey: false,
    ArgumentConstant.isFemaleHealthKey: true,
    ArgumentConstant.isWoundSkinKey: false,
    ArgumentConstant.isDentalCareKey: false,
    ArgumentConstant.isMoodMentalKey: false
  });
}

void woundSkinNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: false,
    ArgumentConstant.isMaleHealthKey: false,
    ArgumentConstant.isFemaleHealthKey: false,
    ArgumentConstant.isWoundSkinKey: true,
    ArgumentConstant.isDentalCareKey: false,
    ArgumentConstant.isMoodMentalKey: false
  });
}

void dentalCareNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: false,
    ArgumentConstant.isMaleHealthKey: false,
    ArgumentConstant.isFemaleHealthKey: false,
    ArgumentConstant.isWoundSkinKey: false,
    ArgumentConstant.isDentalCareKey: true,
    ArgumentConstant.isMoodMentalKey: false
  });
}

Future<Null> openMaterialDatePicker(
    BuildContext context, TextEditingController controller, FocusNode focusNode,
    {bool isOnlyDate = false,
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
    Function onDateChanged,
    bool filledDate = false}) async {
  final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(DateTime.now().year - 70),
      lastDate: lastDate ?? DateTime(DateTime.now().year + 70),
      builder: (context, child) {
        return Theme(
          data:
              ThemeData(primaryColor: Colors.black, accentColor: Colors.green),
          child: child,
        );
      });
  if (pickedDate != null) {
    if (onDateChanged != null) {
      onDateChanged(pickedDate);
    }
    controller.text =
        formattedDate(pickedDate, AppConstants.vitalReviewsDateFormat);
    focusNode.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  } else {
    if (!filledDate) {
      if (isOnlyDate) {
        controller.text = DateTime.now().toString().substring(0, 10);
      } else {
        controller.text = DateTime.now().toString().substring(0, 19);
      }
    }
  }
}

Future<DateTime> openCupertinoDatePicker(
    BuildContext context, TextEditingController controller, FocusNode focusNode,
    {bool isTime = false,
    bool isOnlyDate = false,
    bool filledDate = false,
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
    Function onDateChanged}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: CupertinoDatePicker(
          use24hFormat: true,
          backgroundColor: Colors.white,
          onDateTimeChanged: (pickedDate) {
            if (pickedDate != null) {
              if (pickedDate != null) {
                onDateChanged(pickedDate);
              }
              controller.text = formattedDate(
                  pickedDate, AppConstants.vitalReviewsDateFormat);
              focusNode.unfocus();
              FocusScope.of(context).requestFocus(FocusNode());
            } else {
              if (!filledDate) {
                if (isOnlyDate) {
                  controller.text = DateTime.now().toString().substring(0, 10);
                } else {
                  controller.text = DateTime.now().toString().substring(0, 19);
                }
              }
            }
          },
          initialDateTime: initialDate ?? DateTime.now(),
          minimumDate: firstDate ?? DateTime(DateTime.now().year - 70),
          maximumDate: lastDate ?? DateTime(DateTime.now().year + 70),
          minuteInterval: 1,
          mode: isOnlyDate
              ? CupertinoDatePickerMode.date
              : isTime
                  ? CupertinoDatePickerMode.time
                  : CupertinoDatePickerMode.dateAndTime),
    ),
  );
}
