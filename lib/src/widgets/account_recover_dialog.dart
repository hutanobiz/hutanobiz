import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/constants.dart';

showacountRecoverDialog(
  BuildContext context,
  String email, {
  Function onRecover,
  Function onCancel,
}) {
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
              SizedBox(
                height: 10,
              ),
              Text(
                "Account Setup",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorPurple100,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: gilroyBold,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                email,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorBlack2.withOpacity(0.85),
                    fontWeight: FontWeight.w400,
                    fontFamily: gilroyRegular,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text("is already registered",
                  style: const TextStyle(
                      color: colorLightBlack4,
                      fontWeight: FontWeight.w300,
                      fontFamily: gilroyLight,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  height: 50,
                  minWidth: 200,
                  color: colorPurple100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: colorPurple100)),
                  onPressed: () {
                    onRecover();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Recover Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: gilroyRegular,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        )),
                  )),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  onCancel();
                  yyDialog.dismiss();
                },
                child: Text("Cancel",
                    style: const TextStyle(
                        color: const Color(0xff2c2c2c),
                        fontWeight: FontWeight.w300,
                        fontFamily: "Gilroy",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    )
    ..show();
}
