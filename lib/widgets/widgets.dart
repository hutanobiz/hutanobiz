import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hutano/colors.dart';

class Widgets {
  static void showSnackBar(
      GlobalKey<ScaffoldState> _scaffoldKey, Widget value, int duration) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(duration: new Duration(seconds: duration), content: value));
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.indigo,
    );
  }

  static void showErrorDialog({
    @required BuildContext context,
    String title,
    @required String description,
    String buttonText,
    Function onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => Platform.isIOS
          ? CupertinoAlertDialog(
              title: Text(title ?? "Alert"),
              content: Text(description),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: onPressed ??
                      () {
                        Navigator.of(context).pop();
                      },
                  isDefaultAction: true,
                  child: Text(
                    buttonText ?? "Ok",
                    style: TextStyle(
                      color: AppColors.windsor,
                    ),
                  ),
                ),
              ],
            )
          : AlertDialog(
              title: Text(title ?? "Error"),
              content: Text(description),
              actions: <Widget>[
                FlatButton(
                  onPressed: onPressed ??
                      () {
                        Navigator.of(context).pop();
                      },
                  child: Text(
                    buttonText ?? "Ok",
                    style: TextStyle(
                      color: AppColors.windsor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  static void showConfirmationDialog({
    @required BuildContext context,
    String title,
    @required String description,
    String leftText,
    Function onLeftPressed,
    String rightText,
    Function onRightPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => Platform.isIOS
          ? CupertinoAlertDialog(
              title: Text(title ?? ""),
              content: Text(description),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: onLeftPressed ??
                      () {
                        Navigator.of(context).pop();
                      },
                  isDefaultAction: true,
                  child: Text(
                    leftText ?? "Yes",
                    style: TextStyle(
                      color: AppColors.windsor,
                    ),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: onRightPressed ??
                      () {
                        Navigator.of(context).pop();
                      },
                  isDefaultAction: true,
                  child: Text(
                    rightText ?? "No",
                    style: TextStyle(
                      color: AppColors.windsor,
                    ),
                  ),
                ),
              ],
            )
          : AlertDialog(
              title: Text(title ?? "Are You Sure"),
              content: Text(description),
              actions: <Widget>[
                FlatButton(
                  onPressed: onLeftPressed ??
                      () {
                        Navigator.of(context).pop();
                      },
                  child: Text(
                    leftText ?? "Yes",
                    style: TextStyle(
                      color: AppColors.windsor,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: onRightPressed ??
                      () {
                        Navigator.of(context).pop();
                      },
                  child: Text(
                    rightText ?? "No",
                    style: TextStyle(
                      color: AppColors.windsor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  static void showAlertDialog(
      BuildContext context, String title, String message, Function onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed();
            },
          ),
        ],
      ),
    );
  }

  static Future uploadBottomSheet(BuildContext context, Widget child) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: child,
          ),
        );
      },
    );
  }

  static SizedBox sizedBox({@required double height}) {
    return SizedBox(height: height);
  }
}
