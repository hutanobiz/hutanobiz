import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide MapType;
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

class Extensions {
  static String addressFormat(
    String address,
    String street,
    String city,
    dynamic state,
    String zipCode,
  ) {
    String addressName = ', ', stateCode = ', ';

    if (street != null && street != '') {
      addressName += street.toString().toLowerCase().contains('suite') ||
              street.toString().toLowerCase().contains('ste') ||
              street.toString().toLowerCase().contains('st')
          ? "Ste."
          : (!(street.toString().toLowerCase().contains('suite') ||
                  street.toString().toLowerCase().contains('ste'))
              ? ("Ste. " + street.toString())
              : street.toString());
    }

    if (state != null) {
      if (state is Map)
        stateCode += state["stateCode"]?.toString() ?? "";
      else
        stateCode += state;
    }

    return (address ?? "---") +
        ((addressName == null || addressName == ', ') ? "" : addressName) +
        ", " +
        (city ?? "") +
        (stateCode ?? '') +
        " " +
        (zipCode ?? "");
  }

  static String getDistance(dynamic distance) {
    String _distance;

    if (distance != null && distance != '0') {
      _distance = ((double.parse(distance.toString()) * 0.000621371)
              .toStringAsFixed(0)) +
          ' mi';

      if (_distance == '0 mi') {
        _distance = ((distance is double)
                ? distance.toStringAsFixed(0)
                : distance.toString()) +
            ' m';
      }
    } else {
      _distance = '0 mi';
    }

    return _distance;
  }

  static String getSortProfessionTitle(String professionTitle) {
    Map titleMap = {
      'Medical Doctor': ' MD',
      'Dentist': ' DT',
      'Chiropractor': ' CP',
      'Physical Therapist': ' PT'
    };
    String _titleSort;
    if (titleMap.containsKey(professionTitle)) {
      _titleSort = titleMap[professionTitle];
    } else {
      _titleSort = '';
    }
    return _titleSort;
  }
}

extension ImageIcon on String {
  imageIcon({double height, double width, Color color}) => Image.asset(
        "images/$this.png",
        height: height ?? 14.0,
        width: width ?? 14.0,
        color: color,
      );
}

extension FutureError<T> on Future<T> {
  Future<T> futureError(Function onError) =>
      this.timeout(const Duration(seconds: 10)).catchError(onError);
}

extension DebugLog on String {
  debugLog() {
    return debugPrint(
      "\n******************************* DebugLog *******************************\n" +
          " $this" +
          "\n******************************* DebugLog *******************************\n",
      wrapWidth: 1024,
    );
  }
}

extension InkWellTap on Widget {
  onClick({
    BuildContext context,
    String routeName,
    Function onTap,
    bool roundCorners = true,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: roundCorners
            ? BorderRadius.circular(14.0)
            : BorderRadius.circular(0.0),
        splashColor: Colors.grey[200],
        onTap: () {
          if (context != null && routeName != null)
            Navigator.of(context).pushNamed(routeName);

          if (onTap != null) {
            onTap();
          }
        },
        child: this,
      ),
    );
  }
}

extension TimeOfDayExt on String {
  timeOfDay(BuildContext context) {
    return TimeOfDay(
      hour: int.parse(
        "${this}".substring(0, 2),
      ),
      minute: int.parse(
        "${this}".substring(3),
      ),
    ).format(context).toString();
  }
}

extension StringExtension on String {
  String isValidEmail(BuildContext context) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);

    if (isEmpty) {
      return Strings.msgEnterAddress;
    } else if (!regex.hasMatch(trim())) {
      return Strings.msgEnterValidAddress;
    } else {
      return null;
    }
  }

  String isValidNumber(BuildContext context) {
    if (trim().isEmpty) {
      return Strings.msgEnterMobile;
    } else if (trim().length < 10) {
      return Strings.msgEnterValidMobile;
    } else {
      return null;
    }
  }

  static String placeholderPattern = '(\{\{([a-zA-Z0-9]+)\}\})';

  String format(List replacements) {
    var template = this;
    var regExp = RegExp(placeholderPattern);
    assert(regExp.allMatches(template).length == replacements.length,
        "Template and Replacements length are incompatible");

    for (var replacement in replacements) {
      template = template.replaceFirst(regExp, replacement.toString());
    }
    return template;
  }

  String getInitials() {
    var names = split(" ");
    var initials = "";
    var numWords = names.length;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0].toUpperCase()}';
    }
    return initials;
  }

  String getYearCount() {
    var parsedDate = DateTime.parse(this);
    var dur = DateTime.now().difference(parsedDate);
    return (dur.inDays / 365).floor().toString();
  }

  String isValidUSNumber(BuildContext context) {
    if (trim().isEmpty) {
      return Strings.msgEnterMobile;
    } else if (trim().length < 14) {
      return Strings.msgEnterValidMobile;
    } else {
      return null;
    }
  }

  static bool isPasswordValidate(String value) {
    var pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    var regex = RegExp(pattern);
    if (value.length == 0 || value.isEmpty) {
      return false;
    } else if (!regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }

  String isValidPassword(BuildContext context) {
    if (trim().isEmpty) {
      return Strings.errorPassword;
    } else if (trim().length < 6) {
      return Strings.errorValidPassword;
    } else {
      return null;
    }
  }

  bool isValidPin(BuildContext context, String target) {
    if (trim().isEmpty || target.isEmpty) {
      return false;
    } else if (trim().length < 4 || target.trim().length < 4) {
      return false;
    } else {
      return true;
    }
  }

  String isBlank(BuildContext context, String msg) {
    return trim().isEmpty ? msg : null;
  }

  String rawNumber() {
    return replaceAll(RegExp(r'[^\w]+'), '');
  }

  String getYear() {
    var parsedDate = DateTime.parse(this);
    return parsedDate.year.toString();
  }

  String getDate() {
    var parsedDate = DateTime.parse(this);
    initializeDateFormatting('en');
    return DateFormat('EEEE, d MMMM, hh:mm a')
        .format(parsedDate)
        .replaceAll('AM', 'am')
        .replaceAll('PM', 'PM');
  }

  String getUsFormatNumber() {
    return "(${substring(0, 3)}) ${substring(3, 6)}-${substring(6, length)}";
  }
}

extension StatusExt on String {
  appointmentStatus({bool isAddBackground = true}) {
    String status = "---";
    Color statusTextColor = Colors.lightGreen;
    Color backgroundColor = Colors.lightGreen.withOpacity(0.12);

    switch (this) {
      case "0":
        status = "Pending";
        statusTextColor = Colors.black.withOpacity(0.75);
        backgroundColor = Colors.black.withOpacity(0.08);
        break;
      case "1":
        status = "Accepted";
        statusTextColor = AppColors.atlantis;
        backgroundColor = AppColors.atlantis.withOpacity(0.12);
        break;
      case "2":
        status = "Rejected";
        statusTextColor = AppColors.alizarin_crimson;
        backgroundColor = AppColors.alizarin_crimson.withOpacity(0.12);
        break;
      case "3":
        status = "Initiated";
        statusTextColor = AppColors.koromiko;
        backgroundColor = AppColors.koromiko.withOpacity(0.12);
        break;
      case "4":
        status = "Completed";
        statusTextColor = AppColors.emerald;
        backgroundColor = AppColors.emerald.withOpacity(0.12);
        break;
      case "5":
      case "6":
        status = "Cancelled";
        statusTextColor = AppColors.alizarin_crimson;
        backgroundColor = AppColors.alizarin_crimson.withOpacity(0.12);
        break;
    }
    return isAddBackground
        ? Text(
            status,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: statusTextColor,
              backgroundColor: backgroundColor,
            ),
          )
        : Text(
            status,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: statusTextColor,
            ),
          );
  }
}

extension LaunchMaps on LatLng {
  void launchMaps() async {
    MapType mapType;
    if (Platform.isAndroid) {
      mapType = MapType.google;
    } else {
      mapType = MapType.apple;
    }

    await MapLauncher.launchMap(
      mapType: mapType,
      coords: Coords(this.latitude, this.longitude),
      title: "",
      description: "",
    );
  }
}

extension NextDay on int {
  String nextDay() {
    return DateFormat('EEEE')
        .format(DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + this))
        .toString();
  }
}

extension FormatDate on String {
  String formatDate({String dateFormat}) {
    return DateFormat(
      dateFormat ?? Strings.datePattern,
    ).format(DateTime.parse(this).toLocal()).toString();
  }
}
