import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Widgets {
  static void showSnackBar(
      GlobalKey<ScaffoldState> _scaffoldKey, String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.indigo,
    );
  }

  static void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Alert"),
        content: new Text("My alert message"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new FlatButton(
              child: Text("close"),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop("Discard"),
            ),
          )
        ],
      ),
    );
  }

  static void checkBox(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Alert"),
        content: new Text("My alert message"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new FlatButton(
              child: Text("close"),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop("Discard"),
            ),
          )
        ],
      ),
    );
  }

  static SizedBox sizedBox({@required double height}) {
    return SizedBox(height: height);
  }
}
