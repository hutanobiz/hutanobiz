import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';

class AppointmentCompleteConfirmation extends StatelessWidget {
  final Map appointmentCompleteMap;

  const AppointmentCompleteConfirmation(
      {Key key, @required this.appointmentCompleteMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                    appointmentCompleteMap['type'] == '2'
                        ? "Telemedicine appointment with Dr. ${appointmentCompleteMap["name"]} is complete."
                        : appointmentCompleteMap['type'] == '1'
                            ? "Office Visit with Dr. ${appointmentCompleteMap["name"]} is complete"
                            : "Onsite Appointment with Dr. ${appointmentCompleteMap["name"]} is complete",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.midnight_express,
                    )),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(height: 15),
            Center(
              child: Text(
                // todo time
                appointmentCompleteMap.containsKey('_id')
                    ? ''
                    : appointmentCompleteMap["dateTime"],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.goldenTainoi,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 10),
            appointmentCompleteMap.containsKey('_id')
                ? SizedBox()
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.centerRight,
                            child: Image.asset(
                              "images/ic_address_grey.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: Text(
                            appointmentCompleteMap["address"],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Image.asset("images/ic_app_complete.png"),
              ),
            ),
            Center(
              child: Text("How was your experience?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.midnight_express,
                  )),
            ),
            SizedBox(height: 22),
            Center(
              child: ButtonTheme(
                  height: 55,
                  minWidth: 180,
                  child: FlatButton.icon(
                    icon: Image.asset(
                      "images/ic_app_rating.png",
                      height: 20,
                      width: 20,
                    ),
                    splashColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(14.0),
                      ),
                      side: BorderSide(
                        width: 1.0,
                        color: AppColors.windsor,
                      ),
                    ),
                    label: Text(
                      "Rate Doctor",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.windsor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.rateDoctorScreen,
                        arguments: "3",
                      );
                    },
                  )),
            ),
            SizedBox(height: 45),
            Center(
              child: ButtonTheme(
                  height: 50,
                  child: FlatButton.icon(
                    icon: Image.asset(
                      "images/ic_active_home.png",
                      height: 20,
                      width: 20,
                    ),
                    splashColor: Colors.grey[300],
                    color: AppColors.windsor.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(14.0),
                      ),
                    ),
                    label: Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.windsor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.dashboardScreen,
                          (Route<dynamic> route) => false);
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
