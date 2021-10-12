import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';

class DialogUtils {
  static void showAlertDialog(BuildContext context, String message,
      {String title}) {
    customDialog(context, message, title: title);
  }

  static customDialog(BuildContext context, String description,
      {Function onPressed,
      String leftText,
      String title,
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
                              onPressed();
                            },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "OK",
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

  static void showCustomDialog(
      {BuildContext context, String title, String message}) {
    showDialog(
      context: context,
      builder: (context) {
        return _showMaterialAlertDialog(context, message);
      },
    );
  }

  static void showOkCancelAlertDialog({
    BuildContext context,
    String message,
    String okButtonTitle,
    String cancelButtonTitle,
    Function cancelButtonAction,
    Function okButtonAction,
    bool isCancelEnable = true,
  }) {
    showDialog(
      barrierDismissible: isCancelEnable,
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return WillPopScope(
            onWillPop: () async => false,
            child: _showOkCancelCupertinoAlertDialog(
                context,
                message,
                okButtonTitle,
                cancelButtonTitle,
                okButtonAction,
                isCancelEnable,
                cancelButtonAction),
          );
        } else {
          return WillPopScope(
            onWillPop: () async => false,
            child: _showOkCancelMaterialAlertDialog(
                context,
                message,
                okButtonTitle,
                cancelButtonTitle,
                okButtonAction,
                isCancelEnable,
                cancelButtonAction),
          );
        }
      },
    );
  }

  static AlertDialog _showOkCancelMaterialAlertDialog(
      BuildContext context,
      String message,
      String okButtonTitle,
      String cancelButtonTitle,
      Function okButtonAction,
      bool isCancelEnable,
      Function cancelButtonAction) {
    return AlertDialog(
        title: Text(Strings.appName),
        content: Text(message),
        actions: isCancelEnable
            ? _okCancelActions(
                context: context,
                okButtonTitle: okButtonTitle,
                cancelButtonTitle: cancelButtonTitle,
                okButtonAction: okButtonAction,
                isCancelEnable: isCancelEnable,
                cancelButtonAction: cancelButtonAction,
              )
            : _okAction(
                context: context,
                okButtonAction: okButtonAction,
                okButtonTitle: okButtonTitle));
  }

  static CupertinoAlertDialog _showOkCancelCupertinoAlertDialog(
    BuildContext context,
    String message,
    String okButtonTitle,
    String cancelButtonTitle,
    Function okButtonAction,
    bool isCancelEnable,
    Function cancelButtonAction,
  ) {
    return CupertinoAlertDialog(
        title: Text(Strings.appName),
        content: Text(message),
        actions: isCancelEnable
            ? _okCancelActions(
                context: context,
                okButtonTitle: okButtonTitle,
                cancelButtonTitle: cancelButtonTitle,
                okButtonAction: okButtonAction,
                isCancelEnable: isCancelEnable,
                cancelButtonAction: cancelButtonAction,
              )
            : _okAction(
                context: context,
                okButtonAction: okButtonAction,
                okButtonTitle: okButtonTitle));
  }

  static List<Widget> _actions(BuildContext context) {
    return <Widget>[
      Platform.isIOS
          ? CupertinoDialogAction(
              child: Text(Strings.ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : FlatButton(
              child: Text(Strings.ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
    ];
  }

  static List<Widget> _okCancelActions({
    BuildContext context,
    String okButtonTitle,
    String cancelButtonTitle,
    Function okButtonAction,
    bool isCancelEnable,
    Function cancelButtonAction,
  }) {
    return <Widget>[
      cancelButtonTitle != null
          ? Platform.isIOS
              ? CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text(cancelButtonTitle),
                  onPressed: cancelButtonAction == null
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : () {
                          Navigator.of(context).pop();
                          cancelButtonAction();
                        },
                )
              : FlatButton(
                  child: Text(cancelButtonTitle),
                  onPressed: cancelButtonAction == null
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : () {
                          Navigator.of(context).pop();
                          cancelButtonAction();
                        },
                )
          : null,
      Platform.isIOS
          ? CupertinoDialogAction(
              child: Text(okButtonTitle),
              onPressed: () {
                Navigator.of(context).pop();
                okButtonAction();
              },
            )
          : FlatButton(
              child: Text(okButtonTitle),
              onPressed: () {
                Navigator.of(context).pop();
                okButtonAction();
              },
            ),
    ];
  }

  static List<Widget> _okAction(
      {BuildContext context, String okButtonTitle, Function okButtonAction}) {
    return <Widget>[
      Platform.isIOS
          ? CupertinoDialogAction(
              child: Text(okButtonTitle),
              onPressed: () {
                Navigator.of(context).pop();
                okButtonAction();
              },
            )
          : FlatButton(
              child: Text(okButtonTitle),
              onPressed: () {
                Navigator.of(context).pop();
                okButtonAction();
              },
            ),
    ];
  }

  static CupertinoAlertDialog _showCupertinoAlertDialog(
      BuildContext context, String message) {
    return CupertinoAlertDialog(
      title: Text(Strings.appName),
      content: Text(message),
      actions: _actions(context),
    );
  }

  static AlertDialog _showMaterialAlertDialog(
      BuildContext context, String message) {
    return AlertDialog(
      title: Text(Strings.appName),
      content: Text(message),
      actions: _actions(context),
    );
  }
}
