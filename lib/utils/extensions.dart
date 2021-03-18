import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide MapType;
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
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

    if (address != null) {
      addressName += address.toString().toLowerCase().contains('suite') ||
              address.toString().toLowerCase().contains('ste') ||
              address.toString().toLowerCase().contains('st')
          ? "Ste."
          : (!(address.toString().toLowerCase().contains('suite') ||
                  address.toString().toLowerCase().contains('ste'))
              ? ("Ste. " + address.toString())
              : address.toString());
    }

    if (state != null) {
      if (state is Map)
        stateCode += state["stateCode"]?.toString() ?? "";
      else
        stateCode += state;
    }

    return (street ?? "---") +
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

extension StringExtension on String {
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
}
