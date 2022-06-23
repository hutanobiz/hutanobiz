import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:package_info/package_info.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingScreen> {
  ApiBaseHelper api = ApiBaseHelper();
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  String name = "---", email = "---", phone = "---", avatar;
  var profileData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();

    getProfileData();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void getProfileData() {
    isLoading = true;

    SharedPref().getToken().then((token) {
      api.profile(token, Map()).then((dynamic response) {
        if (mounted) {
          setState(() {
            isLoading = false;
            if (response['response'] != null) {
              profileData = response['response'];
              name = response['response']['fullName'].toString() ?? "---";
              email = response['response']['email'].toString() ?? "---";
              avatar = response['response']['avatar'].toString();
              String phoneNumber =
                  response['response']['phoneNumber']?.toString();
              phoneNumber = "(" +
                  phoneNumber.substring(0, 3) +
                  ") " +
                  phoneNumber.substring(3, 6) +
                  "-" +
                  phoneNumber.substring(6, phoneNumber.length);
              phone = phoneNumber;
            }
          });
        }
      }).futureError((error) {
        setLoading(false);
        error.toString().debugLog();
      });
    }).futureError((error) {
      setLoading(false);
      error.toString().debugLog();
    });
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
        isAddBack: false,
        isAddAppBar: true,
        addBottomArrows: false,
        isBackRequired: false,
        isLoading: isLoading,
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: getFormWidget(),
          padding: EdgeInsets.only(left: 0, right: 0, top: 0),
        ),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
        child: Card(
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
                              style: TextStyle(color: AppColors.goldenTainoi),
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
                              ).whenComplete(() => getProfileData());
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
      ),
    );

    formWidget.add(SizedBox(
      height: 10,
    ));
    formWidget.add(
        // Padding(
        // padding: const EdgeInsets.only(left: 20.0, right: 20),
        // child:
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            // decoration: BoxDecoration(
            //   color: AppColors.snow,
            //   borderRadius: BorderRadius.all(Radius.circular(14.0)),
            //   border: Border.all(color: Colors.grey[300]),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: quickLinks(
                              'assets/images/profile_notification.png',
                              'Notifications')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.activityNotification,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: quickLinks('assets/images/consultation_history.png',
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
                        child: quickLinks(
                                'assets/images/health_record.png', 'Health records')
                            .onClick(onTap: () {
                      Navigator.of(context).pushNamed(
                        Routes.myMedicalDocuments,
                      );
                    })),
                    Expanded(
                      child: quickLinks('assets/images/health_monitoring.png',
                              'Health monitoring')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.healthMonitoringScreen,
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
                      child: quickLinks('assets/images/calender_reminder.png',
                              'Calendar reminder')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.calendarReminderScreen,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: quickLinks(
                              'assets/images/profile_payment_method.png',
                              'Payment Method')
                          .onClick(
                        onTap: () {
                          InheritedContainerState _container =
                              InheritedContainer.of(context);
                          _container.providerInsuranceList.clear();
                          Navigator.of(context).pushNamed(
                            Routes.paymentMethodScreen,
                            arguments: {'paymentType': 0},
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
                      child: quickLinks(
                              'assets/images/profile_address.png', 'Address')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.onsiteAddresses,
                            arguments: false,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: quickLinks('assets/images/profile_medical_doc.png',
                              'My Medical Documents')
                          .onClick(onTap: () {
                        Navigator.of(context).pushNamed(
                          Routes.myMedicalDocuments,
                        );
                      }),
                    )
                  ],
                ),
                // customListButton(
                //     "Notifications", "images/profile_notification.png", () {
                //   Navigator.pushNamed(context, Routes.activityNotification);
                // }),
                // Padding(
                //   padding: const EdgeInsets.only(left: 28.0),
                //   child: Divider(
                //     color: Colors.grey[300],
                //     height: 0,
                //   ),
                // ),
                // customListButton(
                //   "Profile",
                //   "images/profile_update_medical.png",
                //   () {
                //     Navigator.of(context)
                //         .pushNamed(Routes.profileScreen, arguments: profileData);
                //   },
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 28.0),
                //   child: Divider(
                //     color: Colors.grey[300],
                //     height: 0,
                //   ),
                // ),
                // customListButton(
                //   "Payment Method",
                //   "images/profile_payment_method.png",
                //   () {
                //     InheritedContainerState _container =
                //         InheritedContainer.of(context);
                //     _container.providerInsuranceList.clear();
                //     Navigator.of(context).pushNamed(
                //       Routes.paymentMethodScreen,
                //       arguments: {'paymentType': 0},
                //     );
                //   },
                // ),
                // customListButton(
                //   "Address",
                //   "images/profile_payment_method.png",
                //   () {
                //     Navigator.of(context).pushNamed(
                //       Routes.onsiteAddresses,
                //       arguments: false,
                //     );
                //   },
                // ),
                // customListButton(
                //   "My Medical Documents",
                //   "images/profile_payment_method.png",
                //   () {
                //     Navigator.of(context).pushNamed(
                //       Routes.myMedicalDocuments,
                //     );
                //   },
                // ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: quickLinks(
                              'assets/images/profile_my_medications.png',
                              'My Medications')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              Routes.routeMedicineInformation,
                              arguments: {
                                'isEdit': true,
                              });
                        },
                      ),
                    ),
                    Expanded(
                      child: quickLinks(
                              'assets/images/profile_social_history.png',
                              'Social History')
                          .onClick(onTap: () {
                        Navigator.of(context)
                            .pushNamed(Routes.socialHistory, arguments: {
                          'isEdit': true,
                          'socialHistory':
                              jsonDecode(getString('patientSocialHistory')),
                          'appointmentId': null
                        });
                      }),
                    )
                  ],
                ),
                // customListButton(
                //   "My Medications",
                //   "images/profile_payment_method.png",
                //   () {
                //     Navigator.of(context)
                //         .pushNamed(Routes.routeMedicineInformation, arguments: {
                //       'isEdit': true,
                //     });
                //   },
                // ),
                // customListButton(
                //   "Social History",
                //   "images/profile_payment_method.png",
                //   () {
                //     Navigator.of(context)
                //         .pushNamed(Routes.socialHistory, arguments: {
                //       'isEdit': true,
                //       'socialHistory':
                //           jsonDecode(getString('patientSocialHistory')),
                //       'appointmentId': null
                //     });
                //   },
                // ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: quickLinks(
                              'assets/images/profile_my_providers.png',
                              'My Providers')
                          .onClick(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.myProviders,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: quickLinks(
                        'assets/images/profile_payment_history.png',
                        "Payment History",
                      ).onClick(onTap: () {
                        Navigator.of(context).pushNamed(Routes.paymentHistory);
                      }),
                    )
                  ],
                ),
                // customListButton(
                //   "My Providers",
                //   "images/profile_payment_method.png",
                //   () {
                //     Navigator.of(context).pushNamed(
                //       Routes.myProviders,
                //     );
                //   },
                // ),
                // customListButton(
                //   "Payment History",
                //   "images/profile_payment_method.png",
                //   () {
                //     Navigator.of(context).pushNamed(Routes.paymentHistory);
                //   },
                //),
              ],
            )
            // )),
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
            onTap: () async {
              // setLoading(true);

              // String deviceToken = await SharedPref().getValue("deviceToken");
              String token = await SharedPref().getValue("token");

              // api.logOUt(token, deviceToken).then((v) {
              //   setLoading(false);

              //   if (v.toString().toLowerCase() == 'logout') {
              SharedPref().clearSharedPref();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.loginRoute, (Route<dynamic> route) => false,
                  arguments: false);
              //   } else {
              //     Widgets.showErrorDialog(
              //       context: context,
              //       description: v.toString(),
              //     );
              //   }
              // }).futureError((e) {
              //   setLoading(false);
              //   e.toString().debugLog();
              // });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                "ic_logout".imageIcon(
                  width: 16,
                  height: 16,
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
          child: Text("version: " + _packageInfo.version,
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
                      overflow: TextOverflow.ellipsis,
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
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.windsor.withOpacity(0.85),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setLoading(bool value) {
    setState(() => isLoading = value);
  }
}
