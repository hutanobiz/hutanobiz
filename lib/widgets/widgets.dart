import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hutano/colors.dart';

import 'package:hutano/utils/extensions.dart';

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
      barrierDismissible: false,
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
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )
                      : isCongrats
                          ? Text(
                              'Congratulations!',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            )
                          : Text(
                              title ?? 'Message',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
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
                      fontFamily: 'Montserrat',
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
                      style: TextStyle(
                          fontFamily: 'Montserrat', color: Colors.white),
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

  static void showCallDialog(
      {@required BuildContext context,
      @required Function onEnterCall,
      onCancelCall,
      @required bool isRejoin}) {
    showDialog(
        context: context,
        builder: (context) {
          bool video = true;
          bool record = true;
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        )),
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          isRejoin ? 'Call request' : 'Call Setting',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: isRejoin ? 12 : 0,
                        ),
                        isRejoin
                            ? Text(
                                'Do you want to join call again?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              record
                                  ? 'images/checkedCheck.png'
                                  : 'images/uncheckedCheck.png',
                              height: 20,
                            ),
                            Text(
                              '  Record meeting',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ).onClick(onTap: () {
                          setState(() {
                            record = !record;
                          });
                        }),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                video
                                    ? Icon(
                                        Icons.radio_button_checked,
                                        color: Color(0xFF1E36BA),
                                      )
                                    : Icon(Icons.radio_button_unchecked,
                                        color: Colors.grey[300]),
                                Text(
                                  '  Video & Audio',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ).onClick(onTap: () {
                              setState(() {
                                video = true;
                              });
                            }),
                            Row(
                              children: [
                                video
                                    ? Icon(Icons.radio_button_unchecked,
                                        color: Colors.grey[300])
                                    : Icon(Icons.radio_button_checked,
                                        color: Color(0xFF1E36BA)),
                                Text(
                                  '  Audio Only',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ).onClick(onTap: () {
                              setState(() {
                                video = false;
                              });
                            }),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isRejoin
                                ? Expanded(
                                    child: OutlinedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0))),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: AppColors.goldenTainoi,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onPressed: () {
                                      onCancelCall();
                                    },
                                  ))
                                : SizedBox(width: 50),
                            SizedBox(width: isRejoin ? 12 : 0),
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColors.goldenTainoi),
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(horizontal: 16)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                ),
                                child: Text(
                                  isRejoin ? 'Join' : 'Enter call',
                                  style: TextStyle(
                                      color: AppColors.windsor,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  onEnterCall(record, video);
                                },
                              ),
                            ),
                            SizedBox(width: isRejoin ? 0 : 50),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
                    )),
              );
            },
          );
        });
  }
}
