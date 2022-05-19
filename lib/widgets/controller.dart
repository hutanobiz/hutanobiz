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

  static void showErrorialog({
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

  static void showAppDialog(
      {@required BuildContext context,
      String title,
      @required String description,
      String buttonText,
      Function onPressed,
      bool isError = false,
      bool isCongrats = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          // child: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  )),
              height: 200,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  isError
                      ? Text(
                          'Opps!',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )
                      : isCongrats
                          ? Text(
                              'Congratulations!',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            )
                          : Text(
                              title ?? 'Message',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(
                      child: Text(
                    description ?? 'Description',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    )),
                    height: 40,
                    child: Text(
                      buttonText ?? 'Close',
                      style:
                          TextStyle(fontFamily: 'Poppins', color: Colors.white),
                    ),
                    onPressed: onPressed ??
                        () {
                          Navigator.pop(context);
                        },
                    color: AppColors.windsor,
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              )),
        );
      },
    );
  }

  static void showAccountAddedDialog({
    @required BuildContext context,
    Function onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          // child: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  )),
              height: 200,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset('assets/images/ic_success.png'),
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(
                      child: Text(
                    'Account Added',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    )),
                    height: 40,
                    child: Text(
                      'Done',
                      style:
                          TextStyle(fontFamily: 'Poppins', color: Colors.white),
                    ),
                    onPressed: onPressed ??
                        () {
                          Navigator.pop(context);
                        },
                    color: AppColors.windsor,
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              )),
        );
      },
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
              title: Text(title ?? "Are you sure?"),
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

  static void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text("Alert"),
        content: new Text(message),
        actions: [
          new RaisedButton(
            child: Text("close"),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop("Discard"),
          ),
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

  static Widget circularLoader(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
      ),
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}
