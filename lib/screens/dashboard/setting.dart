import 'package:flutter/material.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/shared_prefrences.dart';

import '../../colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
          child: ListView(
        children: getFormWidget(),
        padding: EdgeInsets.only(left: 0, right: 0, top: 0),
      )),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(
      Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                color: AppColors.goldenTainoi,
                borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(16.0),
                    bottomRight: const Radius.circular(16.0))),
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 30.0),
              child: Text(
                "My profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 60),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/profile_user.png'),
                      height: 74.0,
                      width: 74.0,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Joseph Mathew",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              "images/profile_email.png",
                              width: 14,
                              height: 12,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text("patient3@appening.xyz",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54)),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              "images/profile_phone.png",
                              width: 14,
                              height: 12,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text("8778787767",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54)),
                          ],
                        ),
                      ], crossAxisAlignment: CrossAxisAlignment.start),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: AppColors.goldenTainoi,
                            size: 14,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Edit",
                            style: TextStyle(color: AppColors.goldenTainoi),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    formWidget.add(SizedBox(
      height: 30,
    ));
    formWidget.add(Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.snow,
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              customListButton(
                  "Notifications", "images/profile_notification.png", () {}),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Divider(
                  color: Colors.grey[300],
                  height: 0,
                ),
              ),
              customListButton("Payment History",
                  "images/profile_payment_history.png", () {}),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Divider(
                  color: Colors.grey[300],
                  height: 0,
                ),
              ),
              customListButton("Update Medical History",
                  "images/profile_update_medical.png", () {}),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Divider(
                  color: Colors.grey[300],
                  height: 0,
                ),
              ),
              customListButton(
                  "Payment Method", "images/profile_payment_method.png", () {}),
            ],
          )),
    ));

    formWidget.add(Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.snow,
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          border: Border.all(color: Colors.grey[300]),
        ),
        child: Material(
          child: InkWell(
            onTap: () {
              SharedPref().clearSharedPref();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.loginRoute, (Route<dynamic> route) => false);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/logout.png",
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 10),
                Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 20.0),
        child: Align(
          alignment: Alignment.center,
          child: Text("ver-1.0.0",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54)),
        ),
      ),
    );

    return formWidget;
  }

  customListButton(String text, String image, Function onTap) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 52,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    image,
                    width: 16,
                    height: 18,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 14,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
