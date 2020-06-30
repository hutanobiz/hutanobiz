import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:package_info/package_info.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingScreen> {
  ApiBaseHelper api = ApiBaseHelper();
  bool isEmailVerified = false;
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
              isEmailVerified =
                  response["response"]["isEmailVerified"] ?? false;
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
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: getFormWidget(),
              padding: EdgeInsets.only(left: 0, right: 0, top: 0),
            ),
            _isLoading ? CircularLoader() : Container(),
          ],
        ),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(
      isEmailVerified
          ? Container()
          : Container(
              width: MediaQuery.of(context).size.width,
              color: AppColors.windsor,
              padding: EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Email not verified.",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Text(
                    "Resend Verification Link",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ).onClick(onTap: () {
              setLoading(true);
              SharedPref().getToken().then((value) {
                Map map = {};
                map["step"] = "5";
                api.emailVerfication(value, map).whenComplete(() {
                  setLoading(false);
                  Widgets.showToast('Verification link sent successfully');
                }).futureError((error) => setLoading(false));
              });
            }),
    );

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
                              image: AssetImage('images/profile_user.png'),
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
                        Text(
                          name,
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
                            Text(email,
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
                            Text(phone,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54)),
                          ],
                        ),
                      ], crossAxisAlignment: CrossAxisAlignment.start),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
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
                    ).onClick(
                        roundCorners: false,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.registerRoute,
                            arguments: RegisterArguments(
                              phone,
                              false,
                              isProfileUpdate: true,
                            ),
                          ).whenComplete(() => getProfileData());
                        })
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
              customListButton(
                "Payment History",
                "images/profile_payment_history.png",
                () => Navigator.of(context).pushNamed(
                  Routes.savedCardsScreen,
                ),
              ),
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
                () => Navigator.of(context).pushNamed(
                  Routes.updateMedicalHistory,
                ),
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
                    arguments: false,
                  );
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
            onTap: () {
              SharedPref().clearSharedPref();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.loginRoute, (Route<dynamic> route) => false);
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
