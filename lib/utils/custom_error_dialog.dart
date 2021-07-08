import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/color_utils.dart';

class CustomErrorDialog {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: _showCupertinoAlertDialog(context, message));
      },
    );
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

  static void showOkCancelErrorDialog({
    BuildContext context,
    String message,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: _showOkCancelCupertinoAlertDialog(context, message));
      },
    );
  }

  static CupertinoAlertDialog _showOkCancelCupertinoAlertDialog(
    BuildContext context,
    String message,
  ) {
    return CupertinoAlertDialog(
        title: Text(Strings.oops),
        content: Text(message),
        actions: _okAction(
            context: context,
            okButtonTitle: Strings.ok));
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
      CupertinoDialogAction(
        child: Text(
          okButtonTitle,
          style: TextStyle(color: colorLightGreen),
        ),
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
