import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
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

  static void showErrorialog({
    @required BuildContext context,
    String title,
    @required String description,
    String buttonText,
    Function onPressed,
  }) {
    customDialog(context, title, description, buttonText, onPressed: onPressed);
    return;
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

  static void showErrorDialog({
    @required BuildContext context,
    String title,
    @required String description,
    String buttonText,
    Function onPressed,
  }) {
    customDialog(context, title, description, buttonText, onPressed: onPressed);
    return;
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
    customDialog(context, title ?? "Are You Sure", description, "",
        leftText: leftText,
        rightText: rightText,
        onLeftPressed: onLeftPressed,
        onRightPressed: onRightPressed,
        isConfirmationDialog: true);
    return;
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
    customDialog(context, title ?? "Alert", message, "",
        leftText: "Yes",
        rightText: "No",
        onLeftPressed: onPressed,
        isConfirmationDialog: true);
    return;
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

  static customDialog(
      BuildContext context, String title, String description, String buttonText,
      {Function onPressed,
      String leftText,
      Function onLeftPressed,
      String rightText,
      Function onRightPressed,
      bool isConfirmationDialog = false}) {
    var yyDialog = YYDialog();
    yyDialog.build(context)
      ..width = 300
      ..backgroundColor = Colors.transparent
      ..barrierDismissible = false
      ..widget(
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Text(
                  title ?? "Alert",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                isConfirmationDialog
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton(
                              color: AppColors.windsor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: AppColors.windsor)),
                              onPressed: () {
                                    yyDialog.dismiss();
                                    onLeftPressed();
                                  },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  leftText ?? "Yes",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              )),
                          FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: AppColors.windsor)),
                              onPressed: () {
                                yyDialog.dismiss();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  rightText ?? "No",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                              ))
                        ],
                      )
                    : FlatButton(
                        color: AppColors.windsor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: AppColors.windsor)),
                        onPressed: onPressed ??
                            () {
                              yyDialog.dismiss();
                            },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            buttonText ?? "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ))
              ],
            ),
          ),
        ),
      )
      ..show();
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
