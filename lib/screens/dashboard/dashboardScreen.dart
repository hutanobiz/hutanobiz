import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/dashboard/location_dialog/location_dailog.dart';
import 'package:hutano/src/apis/api_constants.dart';
import 'package:hutano/src/apis/api_manager.dart';
import 'package:hutano/src/apis/error_model.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/utils/dialog_utils.dart';
import 'package:hutano/src/utils/progress_dialog.dart';
import 'package:hutano/src/utils/size_config.dart';
import 'package:hutano/src/widgets/blue_button.dart';
import 'package:hutano/src/widgets/common_header.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:location/location.dart';
import 'package:share/share.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiBaseHelper _api = new ApiBaseHelper();
  bool isEmailVerified = false;

  String _currentddress;

  EdgeInsetsGeometry _edgeInsetsGeometry =
      const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0);

  LatLng _latLng = new LatLng(0.00, 0.00);

  bool _isLocLoading = false;

  InheritedContainerState conatiner;
  List _topSpecialtiesList = [];

  bool _isLoading = false;
  List<String> _topProvidersList = [
    'Office Care',
    'Video Chat',
    'Onsite Visit'
  ];

  var _miles = "10";
  int hutanoCash = 0;

  Future<List<dynamic>> _myDoctorsFuture;
  Future<List<dynamic>> _specialtiesFuture;
  Future<List<dynamic>> _professionalTitleFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      initPlatformState();
    });

    _professionalTitleFuture = _api.getProfessionalTitle();
    _specialtiesFuture = _api.getSpecialties();
    _initLocationDialog();
    _getHutanoCash();
  }

  _initLocationDialog() async {
    await LocationDialog().init();
    setState(() {
      _miles = LocationDialog().radius;
    });
  }

  @override
  void didChangeDependencies() {
    conatiner = InheritedContainer.of(context);
    SharedPref().getValue("isEmailVerified").then((value) {
      if (value == null || value == false) {
        SharedPref().getToken().then((value) {
          _api.profile(value, Map()).then((value) {
            setState(() {
              isEmailVerified = value["response"]["isEmailVerified"] ?? false;
              SharedPref().setBoolValue("isEmailVerified",
                  value["response"]["isEmailVerified"] ?? false);
            });
          });
        });
      } else {
        setState(() {
          isEmailVerified = value;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CommonHeader(
                  backgroundColor: colorYellow100,
                ),
                Padding(
                  padding: _edgeInsetsGeometry,
                  child: adressBar(),
                ),
                Padding(
                  padding: _edgeInsetsGeometry,
                  child: searchBar(),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: colorGreyBorder, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x148b8b8b),
                            offset: Offset(0, 2),
                            blurRadius: 30,
                            spreadRadius: 0)
                      ],
                      color: colorWhite),
                  margin: _edgeInsetsGeometry,
                  child: _showInsuranceSwitch(),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(22.0),
                        topRight: const Radius.circular(22.0),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'What are you looking for?',
                            style: TextStyle(
                                color: colorBlack2,
                                fontWeight: FontWeight.w700,
                                fontFamily: gilroyBold,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                          ),
                        ),
                        topProviderWidget(),
                        professionalTitleWidget(),
                        myDoctorsWidget(),
                        specialtiesWidget(),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Refer and Earn',
                            style: TextStyle(
                                color: colorBlack2,
                                fontWeight: FontWeight.w700,
                                fontFamily: gilroyBold,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                          ),
                        ),
                        _referAndEarn(),
                        _inviteFreinds()
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _isLoading ? CircularLoader() : Container(),
          ],
        ),
      ),
    );
  }

  void _inviteMember() async {
    ProgressDialogUtils.showProgressDialog(context);
    try {
      var res = await ApiManager().inviteMember();
      ProgressDialogUtils.dismissProgressDialog();
      Share.share(res.response.url);
    } on ErrorModel catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      ProgressDialogUtils.dismissProgressDialog();
    }
  }

  _getHutanoCash() {
    ApiManager().getHutanoCash().then((value) {
      if (value.status == success) {
        setState(() {
          hutanoCash = value.response;
        });
      }
    }).catchError((dynamic e) {
      if (e is ErrorModel) {
        if (e.response != null) {
          DialogUtils.showAlertDialog(context, e.response);
        }
      }
    });
  }

  _inviteFreinds() {
    return InkWell(
      onTap: () {
        _inviteMember();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              FileConstants.icInvitePoints,
              height: 40,
              width: 40,
            ),
            SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Invite Friends",
                    style: const TextStyle(
                        color: colorBlack2,
                        fontWeight: FontWeight.w600,
                        fontFamily: gilroySemiBold,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Earn more points".toUpperCase(),
                        style: const TextStyle(
                            color: colorDarkBlue3,
                            fontWeight: FontWeight.w500,
                            fontFamily: gilroyMedium,
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15.0,
                      color: colorDarkBlue3,
                    )
                  ],
                )
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: colorGreyBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
                color: const Color(0x148b8b8b),
                offset: Offset(0, 2),
                blurRadius: 30,
                spreadRadius: 0)
          ],
          color: colorWhite,
        ),
      ),
    );
  }

  _points() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                FileConstants.icStarPoints,
                height: 25,
                width: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Text(hutanoCash.toString(),
                  style: const TextStyle(
                      color: colorBlack2,
                      fontWeight: FontWeight.w500,
                      fontFamily: gilroyMedium,
                      fontStyle: FontStyle.normal,
                      fontSize: 26.0),
                  textAlign: TextAlign.left),
              Spacer(),
              Image.asset(
                FileConstants.icInfoCircle,
                height: 25,
                width: 25,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text("STAR BALANCE",
              style: const TextStyle(
                  color: colorBlack2,
                  fontWeight: FontWeight.w500,
                  fontFamily: gilroyMedium,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left)
        ],
      ),
    );
  }

  Widget _referAndEarn() {
    return Container(
      margin: _edgeInsetsGeometry,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _points(),
          Divider(
            color: colorWhite,
            thickness: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Image.asset(
                    FileConstants.icReferPoints,
                    height: 70,
                    width: 70,
                  ),
                  Spacer(),
                  BlueButton(
                    onPress: () async {},
                    title: 'Redeem Points',
                  )
                ],
              ))
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: colorLightBlue2.withOpacity(0.6),
              offset: Offset(0, 2),
              blurRadius: 30,
              spreadRadius: 0)
        ],
        color: const Color(0xffe7e5ff),
      ),
    );
  }

  Widget _showInsuranceSwitch() {
    return Row(
      children: [
        SizedBox(
          width: 4,
        ),
        Image.asset(
          FileConstants.icInsuranceBlue,
          height: 20,
          width: 20,
        ),
        SizedBox(
          width: 7,
        ),
        Text("Show providers who take my insurance",
            maxLines: 2,
            softWrap: true,
            style: const TextStyle(
                color: colorBlack2,
                fontWeight: FontWeight.w500,
                fontFamily: gilroyMedium,
                fontStyle: FontStyle.normal,
                fontSize: 13.0),
            textAlign: TextAlign.left),
        Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Transform.scale(
            scale: 0.6,
            child: CupertinoSwitch(
              activeColor: colorYellow100,
              value: false,
              onChanged: (newValue) {},
            ),
          ),
        )
      ],
    );
  }

  Widget adressBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image(
          width: 15.0,
          height: 18.0,
          image: AssetImage("images/ic_location.png"),
        ),
        SizedBox(width: 10),
        _isLocLoading
            ? Expanded(
                child: Center(
                  child: CustomLoader(),
                ),
              )
            : InkWell(
                onTap: () async {
                  var locationRes =
                      await LocationDialog().showLocationDialog(true, context);
                  print(LocationDialog().radius);
                  var latlng = LocationDialog().latLng;
                  if (latlng != null) {
                    getLocationAddress(latlng.latitude, latlng.longitude);
                  }
                  setState(() {
                    _miles = LocationDialog().radius;
                  });
                  // _navigateToMap(context);
                },
                child: Row(
                  children: <Widget>[
                    _currentddress != null && _currentddress.length > 45
                        ? Text(
                            _currentddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.midnight_express,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            _currentddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.midnight_express,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    _currentddress.length > 45
                        ? Container()
                        : SizedBox(width: 5),
                    Text(
                      '\u2022',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.midnight_express,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' Within ${_miles} miles',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.midnight_express,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    Image(
                      width: 8.0,
                      height: 4.0,
                      image: AssetImage("images/ic_arrow_down.png"),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget searchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 6.0),
        InkWell(
          onTap: () {
            conatiner.projectsResponse.clear();
            Navigator.of(context).pushNamed(
              Routes.dashboardSearchScreen,
              arguments: _topSpecialtiesList,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(12.0, 15.0, 14.0, 14.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                  scale: 2,
                  image: AssetImage(FileConstants.icSearchBlack),
                  alignment: Alignment(0.9, 0.0)),
              color: colorBlack2.withOpacity(0.06),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  8.0,
                ),
              ),
            ),
            child: Text(
              "Search for providers by name or specialty",
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget topProviderWidget() {
    return Container(
      height: 150,
      width: 143,
      margin: const EdgeInsets.only(top: 20, bottom: 30),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 13),
        scrollDirection: Axis.horizontal,
        itemCount: _topProvidersList.length,
        itemBuilder: (context, index) {
          String appointmentType = _topProvidersList[index];
          return Container(
            height: 150,
            width: 143,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey[100]),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: Image(
                      image: AssetImage(
                        appointmentType.toLowerCase().contains('office')
                            ? 'images/office_appointment.png'
                            : (appointmentType.toLowerCase().contains('vide')
                                ? 'images/video_chat_appointment.png'
                                : 'images/onsite_appointment.png'),
                      ),
                      width: 143,
                      height: 106.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    appointmentType,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onTap: () {
                conatiner.projectsResponse.clear();
                conatiner.setProjectsResponse(
                    "serviceType", (index + 1).toString());

                Navigator.pushNamed(context, Routes.allTitlesSpecialtesScreen);
              },
            ),
          );
        },
      ),
    );
  }

  Widget myDoctorsWidget() {
    return FutureBuilder<List<dynamic>>(
      future: _myDoctorsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _myDoctorsList = snapshot.data;

          if (_myDoctorsList == null || _myDoctorsList.isEmpty) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'My Providers',
                  style: TextStyle(
                    color: colorBlack2,
                    fontWeight: FontWeight.w700,
                    fontFamily: gilroyBold,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                height: 175,
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 13),
                  scrollDirection: Axis.horizontal,
                  itemCount: _myDoctorsList.length,
                  itemBuilder: (context, index) {
                    if (_myDoctorsList == null || _myDoctorsList.isEmpty) {
                      return Text('No my doctors available');
                    }

                    String professionalTitle = '---';

                    dynamic doctor = _myDoctorsList[index]['doctorData'];
                    dynamic subServices = _myDoctorsList[index]['subServices'];
                    dynamic doctorData = doctor['userId'];

                    String avatar = doctorData['avatar']?.toString();

                    Map _appointentTypeMap = {};

                    _appointentTypeMap["isOfficeEnabled"] =
                        doctor["isOfficeEnabled"];
                    _appointentTypeMap["isVideoChatEnabled"] =
                        doctor["isVideoChatEnabled"];
                    _appointentTypeMap["isOnsiteEnabled"] =
                        doctor["isOnsiteEnabled"];

                    if (doctor['professionalTitle'] != null) {
                      professionalTitle =
                          doctor['professionalTitle']['title']?.toString() ??
                              '---';
                    }

                    return Container(
                      height: 173,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[100]),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(12),
                              width: 72.0,
                              height: 72.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: avatar == null || avatar == "null"
                                  ? Image(
                                      image:
                                          AssetImage('images/profile_user.png'),
                                      height: 72.0,
                                      width: 72.0,
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        ApiBaseHelper.imageUrl + avatar,
                                        width: 72.0,
                                        height: 72.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Text(
                              (doctorData['title']?.toString() ?? 'Dr.') +
                                  ' ' +
                                  (doctorData['fullName']?.toString() ?? '---'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3, bottom: 6),
                              child: Text(
                                professionalTitle ?? '---',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              width: 160,
                              height: 36,
                              padding: const EdgeInsets.only(top: 9.0),
                              child: FlatButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                color: AppColors.persian_indigo,
                                splashColor: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(13.0),
                                    bottomLeft: Radius.circular(13.0),
                                  ),
                                ),
                                child: Text(
                                  "Book Appointment",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  doctor['distance'] =
                                      _myDoctorsList[index]['distance'];
                                  conatiner.providerResponse.clear();
                                  conatiner.setProviderData(
                                    "providerData",
                                    doctor,
                                  );

                                  conatiner.setProviderData(
                                      "subServices", subServices);

                                  Navigator.of(context).pushNamed(
                                    Routes.appointmentTypeScreen,
                                    arguments: _appointentTypeMap,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          conatiner.setProviderId(doctorData["_id"]);
                          Navigator.of(context)
                              .pushNamed(Routes.providerProfileScreen);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CustomLoader(),
          ),
        );
      },
    );
  }

  Widget professionalTitleWidget() {
    return FutureBuilder<List<dynamic>>(
      future: _professionalTitleFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _professionalTitleList = snapshot.data;

          if (_professionalTitleList == null ||
              _professionalTitleList.isEmpty) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Speciality Care',
                  style: TextStyle(
                      color: colorBlack2,
                      fontWeight: FontWeight.w700,
                      fontFamily: gilroyBold,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                ),
              ),
              Container(
                height: 132,
                margin: const EdgeInsets.only(top: 20, bottom: 25),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 13),
                  scrollDirection: Axis.horizontal,
                  itemCount: _professionalTitleList.length,
                  itemBuilder: (context, index) {
                    if (_professionalTitleList == null ||
                        _professionalTitleList.isEmpty) {
                      return Text('No professional titles available');
                    }

                    dynamic professionalTitle = _professionalTitleList[index];

                    return SizedBox(
                      height: 94,
                      width: 132,
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image(
                              image: professionalTitle['image'] == null
                                  ? AssetImage('images/dummy_title_image.png')
                                  : NetworkImage(
                                      ApiBaseHelper.imageUrl +
                                          professionalTitle['image'],
                                    ),
                              width: 132,
                              height: 94,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            professionalTitle['title']?.toString() ?? '---',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorBlack2,
                              fontWeight: FontWeight.w600,
                              fontFamily: gilroySemiBold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ).onClick(
                      onTap: () {
                        conatiner.projectsResponse.clear();
                        conatiner.setProjectsResponse("serviceType", '0');
                        conatiner.setProjectsResponse(
                            "professionalTitleId[${index.toString()}]",
                            professionalTitle['_id']);

                        Navigator.pushNamed(
                          context,
                          Routes.chooseSpecialities,
                          arguments: professionalTitle['_id'].toString(),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CustomLoader(),
          ),
        );
      },
    );
  }

  Widget specialtiesWidget() {
    return FutureBuilder<List<dynamic>>(
      future: _specialtiesFuture,
      builder: (context, snapshot) {
        _topSpecialtiesList.clear();

        if (snapshot.hasData) {
          if (snapshot.data != null && snapshot.data.length > 0) {
            for (dynamic specialty in snapshot.data) {
              //TODO : TEMP COMMENT FOR FEATURED
              _topSpecialtiesList.add(specialty);

              if (specialty['isFeatured'] != null) {
                if (specialty['isFeatured']) {
                  _topSpecialtiesList.add(specialty);
                }
              }
            }
          }

          if (_topSpecialtiesList == null || _topSpecialtiesList.isEmpty) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Popular Specialties',
                  style: TextStyle(
                    color: colorBlack2,
                    fontWeight: FontWeight.w700,
                    fontFamily: gilroyBold,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                height: 200,
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  // separatorBuilder: (BuildContext context, int index) =>
                  //     SizedBox(width: 13),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3 / 4, crossAxisCount: 2),

                  scrollDirection: Axis.horizontal,
                  itemCount: _topSpecialtiesList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (_topSpecialtiesList == null ||
                        _topSpecialtiesList.isEmpty) {
                      return Text('No Specialities available');
                    }

                    dynamic specialty = _topSpecialtiesList[index];

                    return Container(
                      height: 100,
                      width: 132,
                      margin: EdgeInsets.only(top: 10, left: 10),
                      padding: EdgeInsets.only(
                          left: 10, right: 0, top: 2, bottom: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[100]),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image(
                                image: specialty['image'] == null
                                    ? AssetImage('images/dummy_title_image.png')
                                    : NetworkImage(
                                        ApiBaseHelper.imageUrl +
                                            specialty['image'],
                                      ),
                                width: 35,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            specialty['title']?.toString() ?? '---',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorBlack2,
                              fontWeight: FontWeight.w500,
                              fontFamily: gilroyMedium,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ).onClick(
                      onTap: () {
                        conatiner.projectsResponse.clear();
                        conatiner.setProjectsResponse(
                            "specialtyId[${index.toString()}]",
                            specialty["_id"]);
                        conatiner.setProjectsResponse("serviceType", '0');

                        Navigator.pushNamed(
                          context,
                          Routes.providerListScreen,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CustomLoader(),
          ),
        );
      },
    );
  }

  _navigateToMap(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.chooseLocation,
      arguments: _latLng,
    );

    LatLng latLng = result;

    if (latLng != null) {
      _locationLoading(true);

      _latLng = latLng;

      getLocationAddress(latLng.latitude, latLng.longitude);
    }
  }

  initPlatformState() async {
    _locationLoading(true);

    Location _location = Location();
    PermissionStatus _permission;

    _permission = await _location.requestPermission();
    print("Permission: $_permission");

    switch (_permission) {
      case PermissionStatus.granted:
        bool serviceStatus = await _location.serviceEnabled();
        print("Service status: $serviceStatus");

        if (serviceStatus) {
          Widgets.showToast("Getting Location. Please wait..");

          try {
            LocationData locationData = await _location.getLocation();

            getLocationAddress(locationData.latitude, locationData.longitude);

            _latLng = LatLng(
                locationData.latitude ?? 0.00, locationData.longitude ?? 0.00);

            SharedPref().getToken().then((token) {
              _myDoctorsFuture = _api.getMyDoctors(token, _latLng);
            });
          } on PlatformException catch (e) {
            _locationLoading(false);

            Widgets.showToast(e.message.toString());
            e.toString().debugLog();

            log(e.code);

            _location = null;
          }
        } else {
          bool serviceStatusResult = await _location.requestService();
          print("Service status activated after request: $serviceStatusResult");
          initPlatformState();
        }

        break;
      case PermissionStatus.denied:
        initPlatformState();
        break;
      case PermissionStatus.deniedForever:
        break;
    }
  }

  getLocationAddress(latitude, longitude) async {
    try {
      final coordinates = new Coordinates(latitude, longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      conatiner.setUserLocation("latLng", LatLng(latitude, longitude));

      var first = "addresses.first.addressLine?.toString()";

      if (addresses[0].locality != null) {
        first = addresses[0].locality;
      } else {
        first = addresses[0].subLocality;
      }

      if (mounted) {
        setState(() {
          _isLocLoading = false;
          _currentddress = first;
        });

        conatiner.setUserLocation("userAddress", _currentddress);
      }
    } on PlatformException catch (e) {
      _locationLoading(false);
      print(e.message.toString() ?? e.toString());
    }
  }

  void _locationLoading(bool loading) {
    setState(() {
      _isLocLoading = loading;
    });
  }

  void _loading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }
}
