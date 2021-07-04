import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/text_style.dart';

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
                style: AppTextStyle.boldStyle(
                  color: AppColors.colorPurple100,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                email,
                textAlign: TextAlign.center,
                style: AppTextStyle.regularStyle(
                    color: AppColors.colorBlack2.withOpacity(0.85),
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
                      color: AppColors.colorLightBlack4,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  height: 50,
                  minWidth: 200,
                  color: AppColors.colorPurple100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: AppColors.colorPurple100)),
                  onPressed: () {
                    onRecover();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Recover Account",
                        style: AppTextStyle.mediumStyle(
                          color: Colors.white,
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
