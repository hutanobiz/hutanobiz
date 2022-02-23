import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/loading_background_new.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.profileData}) : super(key: key);
  var profileData;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ApiBaseHelper api = new ApiBaseHelper();

  bool isLoading = false;

  String name = "---", email = "---", phone = "---", avatar;

  @override
  void initState() {
    super.initState();
    name = widget.profileData['fullName'].toString() ?? "---";
    email = widget.profileData['email'].toString() ?? "---";
    String phoneNumber = widget.profileData['phoneNumber']?.toString();
    phoneNumber = "(" +
        phoneNumber.substring(0, 3) +
        ") " +
        phoneNumber.substring(3, 6) +
        "-" +
        phoneNumber.substring(6, phoneNumber.length);
    phone = phoneNumber;
    avatar = widget.profileData['avatar'].toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: "",
        padding: EdgeInsets.only(bottom: 0),
        isAddBack: true,
        isAddAppBar: true,
        addBottomArrows: false,
        isLoading: isLoading,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 74.0,
                      height: 74.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey[300],
                        ),
                      ),
                      child: avatar == null || avatar == "null"
                          ? Image(
                              image: AssetImage('images/ic_profile.png'),
                              height: 74.0,
                              width: 74.0,
                            )
                          : ClipOval(
                              child: Image.network(
                                ApiBaseHelper.imageUrl + avatar,
                                width: 76.0,
                                height: 76.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Icon(
                              Icons.edit,
                              color: AppColors.goldenTainoi,
                              size: 14,
                            ),
                            Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  "Edit",
                                  style:
                                      TextStyle(color: AppColors.goldenTainoi),
                                )).onClick(
                                roundCorners: false,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.editProfileRoute,
                                    arguments: RegisterArguments(
                                      phone,
                                      false,
                                      isProfileUpdate: true,
                                    ),
                                  );
                                })
                          ],
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
                            Expanded(
                              child: Text(email,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54)),
                            ),
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
                            Text(phone,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54)),
                          ],
                        ),
                      ], crossAxisAlignment: CrossAxisAlignment.start),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: quickLinks(
                              'images/health_record.png', 'Health records')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.myMedicalDocuments,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: quickLinks('images/consultation_history.png',
                              'Consultation history')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.consultationHistoryScreen,
                          );
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: quickLinks('images/health_monitoring.png',
                              'Health monitoring')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.healthMonitoringScreen,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: quickLinks('images/calender_reminder.png',
                              'Calendar reminder')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.calendarReminderScreen,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget quickLinks(String image, String text) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0xff8B8B8B).withOpacity(0.14),
              offset: Offset(0, 2),
              blurRadius: 20,
              spreadRadius: 1)
        ],
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Color(0xFF372786).withOpacity(0.12)),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 48,
            width: 48,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.windsor.withOpacity(0.85),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
