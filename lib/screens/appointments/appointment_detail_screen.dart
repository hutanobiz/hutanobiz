import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/video_player.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({Key key, this.args}) : super(key: key);

  final Map args;

  @override
  _AppointmentDetailScreenState createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  Future<dynamic> _profileFuture;
  InheritedContainerState _container;
  List feeList = List();
  double totalFee = 0;
  String _appointmentStatus = "---";

  Map profileMap = Map();

  Map _medicalHistoryMap = {};

  int _appointmentListType = 1;
  ApiBaseHelper api = ApiBaseHelper();
  String token = '';

  final Set<Marker> _markers = {};
  BitmapDescriptor sourceIcon;
  Completer<GoogleMapController> _controller = Completer();

  LatLng _userLocation = new LatLng(0.00, 0.00);

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_destination_marker.png");
  }

  @override
  void initState() {
    super.initState();

    setSourceAndDestinationIcons();

    if (widget.args['listType'] != null) {
      _appointmentListType = widget.args['listType'];
    }

    _appointmentStatus = widget.args["_appointmentStatus"] ?? "---";
  }

  initPlatformState() async {
    Location _location = Location();
    PermissionStatus _permission;

    _permission = await _location.requestPermission();
    print("Permission: $_permission");

    switch (_permission) {
      case PermissionStatus.granted:
      case PermissionStatus.grantedLimited:
        bool serviceStatus = await _location.serviceEnabled();
        print("Service status: $serviceStatus");

        if (serviceStatus) {
          // Widgets.showToast("Getting Location. Please wait..");

          try {
            LocationData locationData = await _location.getLocation();

            _userLocation =
                LatLng(locationData.latitude, locationData.longitude);
          } on PlatformException catch (e) {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    if (_container.userLocationMap != null &&
        _container.userLocationMap.isNotEmpty) {
      _userLocation = _container.userLocationMap['latLng'];
    } else {
      initPlatformState();
    }

    appointmentDetailsFuture(_userLocation);
  }

  void appointmentDetailsFuture(LatLng latLng) {
    SharedPref().getToken().then((userToken) {
      token = userToken;
      token.debugLog();

      setState(() {
        _profileFuture =
            api.getAppointmentDetails(userToken, widget.args["id"], latLng);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackground(
          title: "Appointment Detail",
          isAddBack: false,
          addBackButton: true,
          color: Colors.white,
          rightButtonText: "Medical History",
          onRightButtonTap: () {
            _medicalHistoryMap['isBottomButtonsShow'] = false;
            _medicalHistoryMap['isFromAppointment'] = true;

            Navigator.of(context).pushNamed(
              Routes.updateMedicalHistory,
              arguments: _medicalHistoryMap,
            );
          },
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: FutureBuilder(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                profileMap = snapshot.data;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: profileWidget(profileMap),
                      ),
                    ),
                    profileMap['data']["type"] == 2?SizedBox():
                    Align(
                      alignment: FractionalOffset.bottomRight,
                      child: Container(
                        height: 55.0,
                        width: 200.0,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(right: 20.0),
                        child: FancyButton(
                          title: profileMap['data']["type"] == 2
                              ? _appointmentStatus == '4'
                                  ? 'Treatment Summary'
                                  : "Join Call"
                              : "Show status",
                          onPressed: _appointmentStatus == "2" ||
                                  _appointmentStatus == "6"
                              ? null
                              : profileMap['data']["type"] == 2
                                  ? _appointmentStatus == '4'
                                      ? () {
                                          Map _map = {};
                                          _map['id'] = profileMap['data']["_id"]
                                              .toString();
                                          _map['appointmentType'] =
                                              profileMap['data']["type"];
                                          _map['latLng'] = _userLocation;

                                          Navigator.of(context).pushNamed(
                                            Routes.treatmentSummaryScreen,
                                            arguments: _map,
                                          );
                                        }
                                      : ()
                                      // { var map = {};
                                      //   map['appointmentId'] =
                                      //       profileMap["data"]["_id"];
                                      //   api
                                      //       .checkTimeToStartVideo(
                                      //           context, token, map)
                                      //       .then((value)
                                      // async {
                                      //     Map<Permission.Permission,
                                      //             Permission.PermissionStatus>
                                      //         statuses = await [
                                      //       Permission.Permission.camera,
                                      //       Permission.Permission.microphone
                                      //     ].request();
                                      //     if ((statuses[Permission
                                      //                 .Permission.camera]
                                      //             .isGranted) &&
                                      //         (statuses[Permission
                                      //                 .Permission.microphone]
                                      //             .isGranted)) {
                                      //       var map = {};
                                      //       map['_id'] =
                                      //           profileMap["data"]["_id"];
                                      //       map['name'] = profileMap['data']
                                      //                   ["doctor"]["fullName"]
                                      //               ?.toString() ??
                                      //           "---";
                                      //       map['address'] = 'a';
                                      //       map['dateTime'] = 't';
                                      //       return Navigator.of(context).pushNamed(
                                      //           Routes.callPage,
                                      //           // arguments: profileMap["data"]["_id"],
                                      //           arguments: map);
                                      //       // }).futureError((onError) {
                                      //       //   Widgets.showErrorialog(
                                      //       //       context: context, description: onError);
                                      //       // });

                                      //     } else {
                                      //       Widgets.showErrorialog(
                                      //           context: context,
                                      //           description:
                                      //               'Camera & Microphone permission Requied');
                                      //     }
                                      //   }
                                      {
                                          Navigator.pushNamed(
                                              context,
                                              Routes
                                                  .telemedicineTrackTreatmentScreen,
                                              arguments: profileMap['data']
                                                  ["_id"]);
                                        }
                                  : () => Navigator.of(context)
                                      .pushNamed(
                                        Routes.trackTreatmentScreen,
                                        arguments: profileMap["data"]["type"],
                                      )
                                      .whenComplete(
                                        () => appointmentDetailsFuture(
                                            _userLocation),
                                      ),
                        ),
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
// Map<Permission.Permission,Permission.PermissionStatus> statuses =
    await [Permission.Permission.camera, Permission.Permission.microphone]
        .request();
// print(statuses[Permission.Permission.location]);

    // await Permission.PermissionHandler().requestPermissions(
    //   [
    //     Permission.PermissionGroup.camera,
    //     Permission.PermissionGroup.microphone
    //   ],
    // );
  }

  Widget profileWidget(Map _data) {
    Map _providerData = _data["data"];
    _container.setAppointmentId(_providerData["_id"].toString());

    int paymentType = 0;

    if (_providerData["insuranceId"] != null) {
      paymentType = 2;
    } else if (_providerData["cashPayment"] != null) {
      paymentType = 1;
    } else if (_providerData["cardPayment"] != null) {
      if (_providerData["cardPayment"]["cardId"] != null &&
          _providerData["cardPayment"]["cardNumber"] != null) {
        paymentType = 3;
      }
    } else {
      paymentType = 0;
    }

    _container.providerResponse.clear();
    _container.setProviderData("providerData", _data);

    String name = "---",
        averageRating = "---",
        userRating,
        professionalTitle = "---",
        fee = "0.00",
        parkingFee = "0.00",
        avatar,
        address = "---",
        officeVisitFee = "0.00",
        insuranceName = "---",
        insuranceImage;

    LatLng latLng = new LatLng(0, 0);

    if (_data["reason"] != null && _data["reason"].length > 0) {
      userRating = _data["reason"][0]["rating"]?.toString();
    }

    averageRating = _data["averageRating"]?.toStringAsFixed(2) ?? "0";

    if (_providerData['medicalHistory'] != null &&
        _providerData['medicalHistory'].length > 0) {
      this._medicalHistoryMap['medicalHistory'] =
          _providerData['medicalHistory'];
    }
    if (_providerData['medicalImages'] != null &&
        _providerData['medicalImages'].length > 0) {
      this._medicalHistoryMap['medicalImages'] = _providerData['medicalImages'];
    }
    if (_providerData['medicalDocuments'] != null &&
        _providerData['medicalDocuments'].length > 0) {
      this._medicalHistoryMap['medicalDocuments'] =
          _providerData['medicalDocuments'];
    }

    if (_data["subServices"] != null) {
      feeList = _data["subServices"];
    }

    if (_data["insuranceData"] != null) {
      insuranceName = _data["insuranceData"]["insuranceName"];
      insuranceImage = _data["insuranceData"]["insuranceDocumentFront"];
    }

    if (_data["doctorData"] != null) {
      for (dynamic detail in _data["doctorData"]) {
        if (detail["professionalTitle"] != null) {
          professionalTitle = detail["professionalTitle"]["title"] ?? "---";
        }

        List providerInsuranceList = List();

        if (detail["insuranceId"] != null) {
          providerInsuranceList = detail["insuranceId"];
        }

        _container.setProviderInsuranceMap(providerInsuranceList);

        if (_data['data']["fees"] != null) {
          // for (dynamic consultanceFee in _data['data']["fees"]) {
          fee = _data['data']["fees"]?.toStringAsFixed(2) ?? "0.00";
          // }
        }

        if (_providerData["type"].toString() == '3') {
          if (_providerData['parking'] != null &&
              _providerData['parking']['fee'] != null) {
            parkingFee = _providerData['parking']['fee'].toStringAsFixed(2);
          }

          address = Extensions.addressFormat(
            _providerData["userAddress"]["address"]?.toString(),
            _providerData["userAddress"]["street"]?.toString(),
            _providerData["userAddress"]["city"]?.toString(),
            _providerData["userAddress"]["state"],
            _providerData["userAddress"]["zipCode"]?.toString(),
          );

          if (_providerData["userAddress"]["coordinates"] != null) {
            List location = _providerData["userAddress"]["coordinates"];

            if (location.length > 0) {
              latLng = LatLng(
                double.parse(location[1].toString()),
                double.parse(location[0].toString()),
              );
            }
          }
        } else {
          if (detail["businessLocation"] != null) {
            dynamic business = detail["businessLocation"];

            address = Extensions.addressFormat(
              business["address"]?.toString(),
              business["street"]?.toString(),
              business["city"]?.toString(),
              business["state"],
              business["zipCode"]?.toString(),
            );

            if (detail["businessLocation"]["coordinates"] != null) {
              List location = detail["businessLocation"]["coordinates"];

              if (location.length > 0) {
                latLng = LatLng(
                  double.parse(location[1].toString()),
                  double.parse(location[0].toString()),
                );
              }
            }
          }
        }
      }
    }

    if (_providerData["doctor"] != null) {
      name = _providerData["doctor"]["fullName"]?.toString() ?? "---";
      avatar = _providerData["doctor"]["avatar"];
    }

    if (_providerData["parking"] != null) {
      officeVisitFee =
          _providerData["parking"]["fee"]?.toStringAsFixed(2) ?? "0.00";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 62.0,
                height: 62.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: avatar == null
                        ? AssetImage('images/profile_user.png')
                        : NetworkImage(ApiBaseHelper.imageUrl + avatar),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: AppColors.goldenTainoi,
                          size: 12.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          "$averageRating \u2022 $professionalTitle",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _appointmentStatus?.appointmentStatus(),
                      SizedBox(height: 5.0),
                      Text(
                        "\$${double.parse(fee).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        _appointmentStatus != "4" ? Container() : rateWidget(userRating),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 11.0),
          child: Text(
            "Appointment Type",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        appoCard(
          _providerData["type"],
        ),
        _providerData["type"] == 2 ? recordingInfoWidget() : SizedBox(),
        divider(topPadding: 18.0),
        dateTimeWidget(DateFormat('EEEE, dd MMMM, HH:mm')
                .format(DateTime.utc(
                        DateTime.parse(_providerData['date']).year,
                        DateTime.parse(_providerData['date']).month,
                        DateTime.parse(_providerData['date']).day,
                        int.parse(_providerData['fromTime'].split(':')[0]),
                        int.parse(_providerData['fromTime'].split(':')[1]))
                    .toLocal())
                .toString() +
            ' to ' +
            DateFormat('HH:mm')
                .format(DateTime.utc(
                        DateTime.parse(_providerData['date']).year,
                        DateTime.parse(_providerData['date']).month,
                        DateTime.parse(_providerData['date']).day,
                        int.parse(_providerData['toTime'].split(':')[0]),
                        int.parse(_providerData['toTime'].split(':')[1]))
                    .toLocal())
                .toString()),
        _providerData["type"] == 2 ? SizedBox() : divider(topPadding: 8.0),
        _providerData["type"] == 2
            ? SizedBox()
            : locationWidget(address, latLng, _data['distance']),
        _data["videos"].length > 0
            ? divider(topPadding: 8.0)
            : SizedBox(height: 1),
        _data["videos"].length > 0
            ? recordingWidget(_data["videos"])
            : SizedBox(),
        _data["videos"].length > 0
            ? divider(topPadding: 8.0)
            : SizedBox(height: 1),
        divider(),
        seekingCareWidget(_providerData),
        divider(),
        feeWidget(
            fee, officeVisitFee, parkingFee, _providerData["type"].toString()),
        divider(),
        paymentType == 0
            ? Container()
            : paymentWidget(paymentType, insuranceName, insuranceImage),
        paymentType == 0 ? Container() : divider(topPadding: 10.0),
      ],
    );
  }

  Widget rateWidget(String userRating) {
    return Container(
      padding: userRating == null
          ? const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0)
          : const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      color: AppColors.goldenTainoi.withOpacity(0.06),
      child: Row(
        children: <Widget>[
          Text(
            userRating == null ? 'Not Rated Yet' : "You Rated",
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: userRating == null
                  ? FlatButton.icon(
                      icon: Icon(
                        Icons.star,
                        color: AppColors.goldenTainoi,
                        size: 20.0,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(
                            Routes.rateDoctorScreen,
                            arguments: "2",
                          )
                          .whenComplete(
                              () => appointmentDetailsFuture(_userLocation)),
                      label: Text(
                        "Rate Now",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.goldenTainoi,
                        ),
                      ),
                    )
                  : RatingBar.builder(
                      initialRating: double.parse(userRating),
                      itemSize: 20.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      glow: false,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: null,
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget appoCard(int cardText) {
    return Container(
      width: 172.0,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[100]),
      ),
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage(
              cardText == 1
                  ? "images/office_appointment.png"
                  : cardText == 2
                      ? "images/video_chat_appointment.png"
                      : "images/onsite_appointment.png",
            ),
            height: 52.0,
            width: 52.0,
          ),
          SizedBox(width: 12.0),
          Text(
            cardText == 1
                ? "Office\nAppointment"
                : cardText == 2
                    ? "Video\nAppointment"
                    : "Onsite\nAppointment",
            maxLines: 2,
            style: TextStyle(
              color: AppColors.midnight_express,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget dateTimeWidget(String dateTime) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Date & Time",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              "ic_appointment_time".imageIcon(),
              SizedBox(width: 8.0),
              Text(
                dateTime,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          _appointmentListType == 2 ||
                  _appointmentStatus == "2" ||
                  _appointmentStatus == "6"
              ? Container()
              : SizedBox(height: 5.0),
          _appointmentListType == 2 ||
                  _appointmentStatus == "2" ||
                  _appointmentStatus == "6"
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          "I need help with my Appiontment",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.windsor.withOpacity(0.85),
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10.0,
                        color: AppColors.windsor,
                      ),
                    ],
                  ),
                ).onClick(
                  roundCorners: false,
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.cancelAppointmentScreen,
                    arguments: profileMap,
                  ),
                ),
        ],
      ),
    );
  }

  Widget locationWidget(String location, LatLng latLng, dynamic distance) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Location",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.0),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  "ic_location_grey".imageIcon(),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      location,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () => latLng.launchMaps(),
                        child: Text(
                          Extensions.getDistance(distance),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.windsor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 155.0,
                margin: const EdgeInsets.only(top: 11.0, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: GoogleMap(
                    myLocationEnabled: false,
                    compassEnabled: false,
                    rotateGesturesEnabled: false,
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                      target: latLng,
                      zoom: 9.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);

                      setState(() {
                        _markers.add(
                          Marker(
                            markerId: MarkerId(latLng.toString()),
                            position: latLng,
                            icon: sourceIcon,
                          ),
                        );
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  recordingWidget(List<dynamic> videos) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Recordings",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: 17),
            padding: const EdgeInsets.only(top: 20),
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SamplePlayer(
                        videoPath: videos[index]['videoLink'],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    border: Border.all(color: Colors.grey[100]),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                            color: AppColors.goldenTainoi.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(color: Colors.grey[100]),
                          ),
                          height: 44,
                          width: 44,
                          child: Center(child: 'video'.imageIcon(height: 16))),
                      SizedBox(width: 17.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Recorded video call',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              DateFormat('dd MMMM, HH:mm').format(
                                  DateTime.parse(videos[index]['createdAt'])
                                      .toLocal()),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.play_circle_fill,
                        color: AppColors.windsor,
                        size: 28,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget feeWidget(String generalFee, String officeVisitCharge,
      String parkingFee, String appType) {
    if (feeList.length > 0) {
      totalFee = feeList.fold(
          0,
          (sum, item) =>
              sum + double.parse(item["subService"]["amount"].toString()));
    } else {
      totalFee = (double.parse(generalFee) + double.parse(officeVisitCharge));
    }

    if (appType == '3') {
      totalFee += double.parse(officeVisitCharge);
    }

    _container.setProviderData("totalFee", totalFee.toStringAsFixed(2));

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Consultation Fee Breakdown",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 18.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: Colors.grey[100],
              ),
            ),
            child: Column(
              children: <Widget>[
                feeList.length > 0
                    ? ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: feeList.length,
                        itemBuilder: (context, index) {
                          return subServicesFeeWidget(feeList[index]);
                        })
                    : Column(
                        children: <Widget>[
                          subFeeWidget(
                              "General Medicine Consult", "\$$generalFee"),
                          officeVisitCharge == "0.00"
                              ? Container()
                              : subFeeWidget("Office Visit charge",
                                  "\$$officeVisitCharge"),
                        ],
                      ),
                appType != '3'
                    ? Container()
                    : subFeeWidget("Parking charge", "\$$parkingFee"),
                SizedBox(height: 16),
                Divider(),
                subFeeWidget("Total", "\$" + totalFee.toStringAsFixed(2)),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget seekingCareWidget(dynamic _providerData) {
    String timeSpan = "---";
    if (_providerData["problemTimeSpan"] != null) {
      timeSpan = _providerData["problemTimeSpan"].toString();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Description of problem",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 18.0),
          Text(
            _providerData['description']?.toString() ?? '---',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: Colors.grey[200])),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Problem duration: ",
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      timeSpan == "1"
                          ? "Hours"
                          : timeSpan == "2"
                              ? "Days"
                              : timeSpan == "3"
                                  ? "Weeks"
                                  : timeSpan == "4"
                                      ? "Months"
                                      : "---",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _providerData["isTreatmentReceived"]
                            ? "Treatment for this complaint is taken in the past 3 months."
                            : "No treatment for this complaint in the past 3 months.",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _providerData["isProblemImproving"]
                          ? "The problem is NOT improving."
                          : "The problem is NOT improving.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget subServicesFeeWidget(Map feeMap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: <Widget>[
          Text(
            feeMap["subServiceName"]?.toString() ?? "---",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.80),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "\$" + feeMap["subService"]["amount"]?.toStringAsFixed(2) ??
                    "0.00",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.80),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget subFeeWidget(String title, String fee) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: title.toLowerCase().contains("total")
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: Colors.black.withOpacity(0.80),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                fee,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.80),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentWidget(
      int paymentType, String insuranceName, String insuranceImage) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Payment Method",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 18.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              paymentType == 1
                  ? Image.asset("images/ic_cash_payment.png",
                      height: 42, width: 42)
                  : insuranceImage == null
                      ? Image.asset("images/insurancePlaceHolder.png",
                          height: 42, width: 42)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            ApiBaseHelper.imageUrl + insuranceImage,
                            height: 42,
                            width: 42,
                            fit: BoxFit.cover,
                          ),
                        ),
              SizedBox(width: 14.0),
              Expanded(
                child: Text(
                  paymentType == 1 ? "Cash" : insuranceName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget divider({double topPadding}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 0.0),
      child: Divider(
        color: AppColors.white_smoke,
        thickness: 6.0,
      ),
    );
  }

  Widget recordingInfoWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.sunglow.withOpacity(0.20),
        border: Border.all(
          width: 1.0,
          color: AppColors.sunglow,
        ),
        borderRadius: BorderRadius.circular(
          14.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Note",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Video appointments are recorded and securely stored for you and your provider's to review on demand.",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
