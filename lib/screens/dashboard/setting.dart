import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
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

  bool _isLoading = false;

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
    _isLoading = true;

    SharedPref().getToken().then((token) {
      api.profile(token, Map()).then((dynamic response) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            if (response['response'] != null) {
              name = response['response']['fullName'].toString() ?? "---";
              email = response['response']['email'].toString() ?? "---";
              String phoneNumber =
                  response['response']['phoneNumber']?.toString();
              phoneNumber = "(" +
                  phoneNumber.substring(0, 3) +
                  ") " +
                  phoneNumber.substring(3, 6) +
                  "-" +
                  phoneNumber.substring(6, phoneNumber.length);
              phone = phoneNumber;
              avatar = response['response']['avatar'].toString();
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
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              ListView(
                physics: ClampingScrollPhysics(),
                children: getFormWidget(),
                padding: EdgeInsets.only(left: 0, right: 0, top: 0),
              ),
              _isLoading ? CircularLoader() : Container(),
            ],
          ),
        ),
      ),
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
              padding: const EdgeInsets.only(left: 20.0, top: 16.0),
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
                  "Notifications", "images/profile_notification.png", () {
                Navigator.pushNamed(context, Routes.activityNotification);
              }),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Divider(
                  color: Colors.grey[300],
                  height: 0,
                ),
              ),
              customListButton(
                "Update Medical History",
                "images/profile_update_medical.png",
                () {
                  var map = {};
                  map['isBottomButtonsShow'] = false;
                  map['isFromAppointment'] = false;
                  Navigator.of(context)
                      .pushNamed(Routes.updateMedicalHistory, arguments: map);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Divider(
                  color: Colors.grey[300],
                  height: 0,
                ),
              ),
              customListButton(
                "Payment Method",
                "images/profile_payment_method.png",
                () {
                  InheritedContainerState _container =
                      InheritedContainer.of(context);
                  _container.providerInsuranceList.clear();
                  Navigator.of(context).pushNamed(
                    Routes.paymentMethodScreen,
                    arguments: {'paymentType': 0},
                  );
                },
              ),
              customListButton(
                "Address",
                "images/profile_payment_method.png",
                () {
                  Navigator.of(context).pushNamed(
                    Routes.onsiteAddresses,
                    arguments: false,
                  );
                },
              ),
              customListButton(
                "My Medical Documents",
                "images/profile_payment_method.png",
                () {
                  Navigator.of(context).pushNamed(
                    Routes.myMedicalDocuments,
                  );
                },
              ),
              customListButton(
                "My Providers",
                "images/profile_payment_method.png",
                () {
                  Navigator.of(context).pushNamed(
                    Routes.myProviders,
                  );
                },
              ),
              customListButton(
                "Payment History",
                "images/profile_payment_method.png",
                () {
                  Navigator.of(context).pushNamed(Routes.paymentHistory);
                },
              ),
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

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
