import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_constants.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/screens/appointments/model/req_booking_appointment_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/screens/registration/payment/utils/card_utils.dart';

import 'package:hutano/strings.dart';
import 'package:hutano/utils/app_constants.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/text_with_image.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as Loc;
import 'package:provider/provider.dart';
import 'package:hutano/utils/caps_extension.dart';

import '../../colors.dart';
import '../../routes.dart';

class ReviewAppointmentDetail extends StatefulWidget {
  @override
  _ReviewAppointmentDetailState createState() =>
      _ReviewAppointmentDetailState();
}

class _ReviewAppointmentDetailState extends State<ReviewAppointmentDetail> {
  late InheritedContainerState _container;
  late Map _appointmentData;
  late Map _providerData, _userLocationMap;
  String? _timeHours, _timeMins;
  DateTime? _bookedDate;
  String? _bookedTime;
  List<Services>? _servicesList = [];
  String _timezone = 'Unknown';
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  String averageRating = "0";
  Map profileMap = Map();
  PolylinePoints _polylinePoints = PolylinePoints();
  bool _isLoading = false;
  List<LatLng> latlng = [];
  LatLng? _initialPosition, _middlePoint;
  LatLng _desPosition = LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor _sourceIcon;
  BitmapDescriptor? _destinationIcon;

  String? _totalDistance = "";
  String _totalDuration = "";
  Map? _profileMap = new Map();
  Map _servicesMap = new Map();
  Map<String, String?> _reviewAppointmentData = Map();
  late Map _consentToTreatMap;
  String? paymentType, insuranceName, insuranceImage, insuranceId;

  List<dynamic>? _consultaceList = [];
  double _totalAmount = 0;

  Future<dynamic>? _profileFuture;
  List feeList = [];
  double totalFee = 0;
  String _appointmentStatus = "---";

  Map _medicalHistoryMap = {};

  int _appointmentListType = 1;
  ApiBaseHelper api = ApiBaseHelper();
  String token = '';

  BitmapDescriptor? sourceIcon;

  LatLng _userLocation = new LatLng(0.00, 0.00);

  @override
  void initState() {
    super.initState();

    setSourceAndDestinationIcons();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    _providerData = _container.getProviderData();
    _appointmentData = _container.appointmentData;
    if (_container.userLocationMap != null &&
        _container.userLocationMap.isNotEmpty) {
      _userLocationMap = _container.userLocationMap;
    } else {
      _userLocationMap = _container.userLocationMap;
      initPlatformState();
    }
    _consentToTreatMap = _container.consentToTreatMap;

    if (_consentToTreatMap["paymentMap"] != null) {
      paymentType = _consentToTreatMap["paymentMap"]["paymentType"];

      if (_consentToTreatMap["paymentMap"]["insuranceId"] != null) {
        insuranceId = _consentToTreatMap["paymentMap"]["insuranceId"];
      }
      if (_consentToTreatMap["paymentMap"]["insuranceName"] != null) {
        insuranceName = _consentToTreatMap["paymentMap"]["insuranceName"];
      }
      if (_consentToTreatMap["paymentMap"]["insuranceImage"] != null) {
        insuranceImage = _consentToTreatMap["paymentMap"]["insuranceImage"];
      }
    }

    if (_providerData["providerData"]["data"] != null) {
      debugPrint(
          "RATTTINGGG G ${_providerData["providerData"]["averageRating"]?.toStringAsFixed(2)}");
      averageRating =
          _providerData["providerData"]["averageRating"]?.toStringAsFixed(2) ??
              "0";

      _providerData["providerData"]["data"].map((f) {
        _profileMap!.addAll(f);
      }).toList();
    } else {
      _profileMap = _providerData["providerData"];
      averageRating = _profileMap!["averageRating"]?.toStringAsFixed(2) ?? "0";
    }
    _initialPosition = _userLocationMap["latLng"];

    if (_container.projectsResponse["serviceType"].toString() == '3') {
      if (Provider.of<HealthConditionProvider>(context, listen: false)
              .addressDetails !=
          null) {
        _desPosition = LatLng(
            Provider.of<HealthConditionProvider>(context, listen: false)
                .coordinatesDetails!
                .longitude,
            Provider.of<HealthConditionProvider>(context, listen: false)
                .coordinatesDetails!
                .latitude);
      } else {
        _desPosition = LatLng(
            _consentToTreatMap["userAddress"]['coordinates'][1],
            _consentToTreatMap["userAddress"]['coordinates'][0]);
      }
    } else if (_container.projectsResponse["serviceType"].toString() == '1') {
      if (_appointmentData["selectedAddress"] != null) {
        if (_appointmentData["selectedAddress"]["coordinates"].length > 0) {
          _desPosition = LatLng(
              double.parse(_appointmentData["selectedAddress"]["coordinates"][1]
                  .toString()),
              double.parse(_appointmentData["selectedAddress"]["coordinates"][0]
                  .toString()));
        }
      }
    } else {
      if (_profileMap!["businessLocation"] != null &&
          _profileMap!["businessLocation"]['stateCode'] != null &&
          _profileMap!["businessLocation"]['city'] != null) {
        if (_profileMap!["businessLocation"]["coordinates"].length > 0) {
          _desPosition = LatLng(
              double.parse(_profileMap!["businessLocation"]["coordinates"][1]
                  .toString()),
              double.parse(_profileMap!["businessLocation"]["coordinates"][0]
                  .toString()));
        }
      } else {
        if (_profileMap!["User"][0]['location']["coordinates"].length > 0) {
          _desPosition = LatLng(
              double.parse(_profileMap!["User"][0]['location']["coordinates"][1]
                  .toString()),
              double.parse(_profileMap!["User"][0]['location']["coordinates"][0]
                  .toString()));
        }
      }
    }
    if (_initialPosition != null) {
      _middlePoint = LatLng(
          (_initialPosition!.latitude + _desPosition.latitude) / 2,
          (_initialPosition!.longitude + _desPosition.longitude) / 2);

      if (_initialPosition != null) {
        getDistanceAndTime(_initialPosition!, _desPosition);
      }
    }

    _setBookingTime(_appointmentData["time"]);
    _bookedDate = _appointmentData["date"];

    _servicesMap = _container.selectServiceMap;

    _reviewAppointmentData["statusType"] = _servicesMap["status"].toString();

    if (_servicesList!.length > 0) _servicesList!.clear();

    if (_servicesMap["status"].toString() == "1") {
      if (_servicesMap["services"] != null) {
        _servicesList = _servicesMap["services"];

        for (int i = 0; i < _servicesList!.length; i++) {
          _totalAmount =
              double.parse(_servicesList![i].amount.toString()) + _totalAmount;
          _reviewAppointmentData["services[${i.toString()}][subServiceId]"] =
              _servicesList![i].subServiceId;
          _reviewAppointmentData["services[${i.toString()}][amount]"] =
              _servicesList![i].amount.toString();
        }
      }
    } else {
      _consultaceList = _servicesMap["consultaceFee"];

      for (int i = 0; i < _consultaceList!.length; i++) {
        _totalAmount =
            double.parse(_consultaceList![i]["fee"].toString()) + _totalAmount;
        _reviewAppointmentData["consultanceFee[${i.toString()}][fee]"] =
            _consultaceList![i]["fee"].toString();
      }
    }
  }

  initPlatformState() async {
    Loc.Location _location = Loc.Location();
    Loc.PermissionStatus _permission;

    _permission = await _location.requestPermission();
    print("Permission: $_permission");

    switch (_permission) {
      case Loc.PermissionStatus.granted:
        bool serviceStatus = await _location.serviceEnabled();
        print("Service status: $serviceStatus");

        if (serviceStatus) {
          Widgets.showToast("Getting Location. Please wait.");

          try {
            Loc.LocationData locationData = await _location.getLocation();

            _initialPosition =
                LatLng(locationData.latitude!, locationData.longitude!);
            _middlePoint = LatLng(
                (_initialPosition!.latitude + _desPosition.latitude) / 2,
                (_initialPosition!.longitude + _desPosition.longitude) / 2);

            if (_initialPosition != null) {
              getDistanceAndTime(_initialPosition!, _desPosition);
            }
          } on PlatformException catch (e) {
            Widgets.showToast(e.message.toString());
            e.toString().debugLog();

            log(e.code);

            // _location = null;
          }
        } else {
          bool serviceStatusResult = await _location.requestService();
          print("Service status activated after request: $serviceStatusResult");
          initPlatformState();
        }

        break;
      case Loc.PermissionStatus.denied:
        initPlatformState();
        break;
      case Loc.PermissionStatus.deniedForever:
        break;
      case Loc.PermissionStatus.grantedLimited:
        // TODO: Handle this case.
        break;
    }
  }

  void getDistanceAndTime(LatLng initialPosition, LatLng desPosition) {
    ApiBaseHelper _apiHelper = ApiBaseHelper();
    _apiHelper
        .getDistanceAndTime(initialPosition, desPosition, Strings.kGoogleApiKey)
        .then((value) {
      _totalDistance =
          value["rows"][0]["elements"][0]["distance"]["text"].toString();
      _totalDuration =
          value["rows"][0]["elements"][0]["duration"]["text"].toString();
      ("DISTANCE AND TIME: " + value["rows"][0]["elements"][0].toString())
          .toString()
          .debugLog();
      setState(() {});
    }).futureError((error) {
      setState(() {
        _totalDuration = "NO duration available";
        _totalDistance = "NO distance available";
      });
      error.toString().debugLog();
    });
  }

  void _setBookingTime(String bookTime) {
    if (bookTime.length < 4) {
      if (bookTime[0] != "0") {
        bookTime = bookTime.substring(0, 2) + "0" + bookTime.substring(2);
      } else {
        bookTime = "0" + bookTime;
      }
    }

    var fromTime = new DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        9,
        int.parse(bookTime.split(':')[0]),
        int.parse(bookTime.split(':')[1]));

    _timeHours = DateFormat('HH').format(fromTime);
    _timeMins = DateFormat('mm').format(fromTime);
    _bookedTime = '$_timeHours:$_timeMins';
  }

  void setSourceAndDestinationIcons() async {
    _sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_initial_marker.png");
    _destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_destination_marker.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: false,
      body: LoadingBackgroundNew(
        title: "",
        addHeader: true,
        padding: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgetList(context),
          ),
        ),
      ),
    );
  }

  List<Widget> widgetList(BuildContext context) {
    List<Widget> _widgetList = [];
    String? address;

    if (_container.projectsResponse["serviceType"].toString() == '3') {
      if (Provider.of<HealthConditionProvider>(context, listen: false)
              .addressDetails !=
          null) {
        address = Extensions.addressFormat(
          Provider.of<HealthConditionProvider>(context, listen: false)
              .addressDetails!
              .address,
          Provider.of<HealthConditionProvider>(context, listen: false)
              .addressDetails!
              .street,
          Provider.of<HealthConditionProvider>(context, listen: false)
              .addressDetails!
              .city,
          Provider.of<HealthConditionProvider>(context, listen: false)
              .addressDetails!
              .state!
              .title
              .toString(),
          Provider.of<HealthConditionProvider>(context, listen: false)
              .addressDetails!
              .zipCode,
        );
      } else {
        address = Extensions.addressFormat(
          _consentToTreatMap["userAddress"]["address"]?.toString(),
          _consentToTreatMap["userAddress"]["street"]?.toString(),
          _consentToTreatMap["userAddress"]["city"]?.toString(),
          _consentToTreatMap["userAddress"]['state'],
          _consentToTreatMap["userAddress"]["zipCode"]?.toString(),
        );
      }
    } else if (_container.projectsResponse["serviceType"].toString() == '1') {
      if (_appointmentData["selectedAddress"] != null) {
        dynamic _state;

        if (_appointmentData["selectedAddress"]["state"] is Map &&
            _appointmentData["selectedAddress"]["state"].length > 0) {
          _state = _appointmentData["selectedAddress"]["state"];
        } else if (_profileMap!['State'] != null &&
            _profileMap!["State"].length > 0) {
          _state = _profileMap!['State'][0];
        }
        address = Extensions.addressFormat(
          _appointmentData["selectedAddress"]["address"]?.toString(),
          _appointmentData["selectedAddress"]["street"]?.toString(),
          _appointmentData["selectedAddress"]["city"]?.toString(),
          _state,
          _appointmentData["selectedAddress"]["zipCode"]?.toString(),
        );
      }
    } else {
      if (_profileMap!["businessLocation"] != null &&
          _profileMap!["businessLocation"]['stateCode'] != null &&
          _profileMap!["businessLocation"]['city'] != null) {
        dynamic business = _profileMap!["businessLocation"];

        dynamic _state;

        if (business["state"] is Map && business["state"].length > 0) {
          _state = business["state"];
        } else if (_profileMap!['State'] != null &&
            _profileMap!["State"].length > 0) {
          _state = _profileMap!['State'][0];
        }
        address = Extensions.addressFormat(
          business["address"]?.toString(),
          business["street"]?.toString(),
          business["city"]?.toString(),
          _state,
          business["zipCode"]?.toString(),
        );
      } else {
        if (_profileMap!["User"][0]['city'] != null) {
          // dynamic business = _profileMap["businessLocation"];

          dynamic _state;

          if (_profileMap!["User"][0]["state"] is Map &&
              _profileMap!["User"][0]["state"].length > 0) {
            _state = _profileMap!["User"][0]["state"];
          } else if (_profileMap!['State'] != null &&
              _profileMap!["State"].length > 0) {
            _state = _profileMap!['State'][0];
          }
          address = Extensions.addressFormat(
            _profileMap!["User"][0]["address"]?.toString(),
            _profileMap!["User"][0]["street"]?.toString(),
            _profileMap!["User"][0]["city"]?.toString(),
            _state,
            _profileMap!["User"][0]["zipCode"]?.toString(),
          );
        }
      }
    }

    _widgetList.add(
      Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            left: 20.0,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0x1f8b8b8b), width: 0.5),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0x148b8b8b),
                          offset: Offset(0, 2),
                          blurRadius: 30,
                          spreadRadius: 0)
                    ],
                    color: const Color(0xffffffff)),
                height: 135,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  splashColor: Colors.grey[200],
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    Navigator.of(context).pushNamed(
                                      Routes.providerImageScreen,
                                      arguments: (_profileMap!
                                              .containsKey('User')
                                          ? ApiBaseHelper.imageUrl +
                                              _profileMap!['User'][0]['avatar']
                                          : ApiBaseHelper.imageUrl +
                                              _profileMap!["userId"]["avatar"]),
                                    );
                                  },
                                  child: Container(
                                    width: 58.0,
                                    height: 58.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: _profileMap!.containsKey('User')
                                            ? (_profileMap!['User'][0]['avatar'] == null
                                                    ? AssetImage(FileConstants
                                                        .icImgPlaceHolder)
                                                    : NetworkImage(
                                                        ApiBaseHelper.imageUrl +
                                                            _profileMap!['User']
                                                                [0]['avatar']))
                                                as ImageProvider<Object>
                                            : (_profileMap!["userId"]["avatar"] == null
                                                    ? AssetImage(FileConstants
                                                        .icImgPlaceHolder)
                                                    : NetworkImage(ApiBaseHelper.imageUrl + _profileMap!["userId"]["avatar"]))
                                                as ImageProvider<Object>,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(50.0)),
                                      border: new Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        _profileMap!.containsKey("User")
                                            ? "Dr. ${_profileMap!['User'][0]['fullName']}"
                                            : "Dr. ${_profileMap!["userId"]["fullName"]}",
                                        style: const TextStyle(
                                            color: colorBlack,
                                            fontWeight: fontWeightSemiBold,
                                            fontSize: fontSize14),
                                        textAlign: TextAlign.left),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    IntrinsicWidth(
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        height: 24,
                                        child: Text(
                                          _profileMap!.containsKey("User")
                                              ? _profileMap!['ProfessionalTitle']
                                                          .length >
                                                      0
                                                  ? _profileMap![
                                                          'ProfessionalTitle']
                                                      [0]['title']
                                                  : ''
                                              : _profileMap![
                                                  'professionalTitle']['title'],
                                          style: TextStyle(
                                              color: colorBlack2,
                                              fontWeight: fontWeightRegular,
                                              fontSize: 12.0),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: colorBlack2.withOpacity(0.06),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: Colors.grey,
                            thickness: 0.3,
                          ),
                          Row(
                            children: [
                              IntrinsicWidth(
                                child: TextWithImage(
                                  imageSpacing: spacing4,
                                  image: getAppointmentImage(
                                      _container.projectsResponse["serviceType"]
                                          .toString(),
                                      context),
                                  label: getAppointmentType(
                                      _container.projectsResponse["serviceType"]
                                          .toString(),
                                      context),
                                  textStyle: TextStyle(
                                      color: colorBlack70,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: fontSize12),
                                ),
                              ),
                              Spacer(),
                              IntrinsicWidth(
                                child: TextWithImage(
                                  imageSpacing: spacing4,
                                  image: FileConstants.icClockTimer,
                                  label: _appointmentData["isOndemand"] == '1'
                                      ? "Ondemand Appointment"
                                      : '${DateFormat('MMM dd,').format(_bookedDate!).toString()}' +
                                          ' ${int.parse(_appointmentData['time'].split(':')[0])}:${int.parse(_appointmentData['time'].split(':')[1])} ${int.parse(_appointmentData['time'].split(':')[0]) >= 12 ? 'PM' : 'AM'}',
                                  textStyle: TextStyle(
                                      color: colorBlack70,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: fontSize12),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: colorPurple100,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                FileConstants.icStarPoints,
                                height: 14,
                                width: 14,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                averageRating != null ? averageRating : "0.00",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          )),
    );

    _widgetList.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        locationWidget(address, _desPosition, _profileMap!['distance']),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          child: Text(
            "The provider will be paid after the appointment.",
            style: TextStyle(
                color: colorBlack.withOpacity(0.9),
                fontWeight: fontWeightRegular,
                fontSize: 13.0),
          ),
        ),
        Container(
          height: 55.0,
          padding: const EdgeInsets.only(right: 14, left: 20.0),
          child: FancyButton(
            title: "OK",
            onPressed: () async {
              _timezone = await FlutterNativeTimezone.getLocalTimezone();
              if (_appointmentData["time"].length < 4) {
                if (_appointmentData["time"][0] != "0") {
                  _appointmentData["time"] =
                      _appointmentData["time"].substring(0, 2) +
                          "0" +
                          _appointmentData["time"].substring(2);
                } else {
                  _appointmentData["time"] = "0" + _appointmentData["time"];
                }
              }
              var fromTime = new DateTime.utc(
                  DateTime.now().year,
                  DateTime.now().month,
                  9,
                  int.parse(_appointmentData["time"].split(':')[0]),
                  int.parse(_appointmentData["time"].split(':')[1]));

              String doctorId = '';

              if (_profileMap!["userId"] != null &&
                  _profileMap!["userId"] is Map) {
                doctorId = _profileMap!["userId"]["_id"].toString();
              } else if (_profileMap!["User"] != null is Map) {
                doctorId = _profileMap!["User"][0]["_id"].toString();
              }
              List<String?> medicalImages = [];
              if (Provider.of<HealthConditionProvider>(context, listen: false)
                      .medicalImagesData
                      .length >
                  0) {
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .medicalImagesData
                    .forEach((element) {
                  medicalImages.add(element.sId);
                });
              }
              List<String?> medicalDocuments = [];
              if (Provider.of<HealthConditionProvider>(context, listen: false)
                      .medicalDocumentsData
                      .length >
                  0) {
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .medicalDocumentsData
                    .forEach((element) {
                  medicalDocuments.add(element.sId);
                });
              }

              List<String?> medicalDiagnosticsTests = [];
              if (Provider.of<HealthConditionProvider>(context, listen: false)
                      .medicalDiagnosticsTestsModelData
                      .length >
                  0) {
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .medicalDiagnosticsTestsModelData
                    .forEach((element) {
                  medicalDiagnosticsTests.add(element.sId);
                });
              }

              final finalModel = ReqBookingAppointmentModel(
                  // consultation: "",
                  isFollowUp: "0",
                  // otherMedicalHistory: "",
                  services: _servicesMap["services"] ?? [],
                  statusType: _servicesMap["status"].toString(),
                  timeZonePlace: _timezone,
                  type: _container.getProjectsResponse()["serviceType"]?.toString() ??
                      "1",
                  date: DateFormat("MM/dd/yyyy")
                      .format(_appointmentData["date"])
                      .toString(),
                  doctor: doctorId,
                  fromTime:
                      '${DateFormat('HH').format(fromTime)}:${DateFormat('mm').format(fromTime)}',
                  isOndemand: int.parse(_appointmentData["isOndemand"]),
                  officeId: _appointmentData["officeId"] ?? '',

                  // previousAppointmentId: "",

                  parkingFee: _container.projectsResponse["serviceType"].toString() ==
                          "3"
                      ? getParkingFee()
                      : "",
                  parkingType:
                      _container.projectsResponse["serviceType"].toString() == "3"
                          ? getParkingType()
                          : "",
                  instruction:
                      _container.projectsResponse["serviceType"].toString() == "3"
                          ? getParkingInstruction()
                          : "",
                  parkingBay:
                      _container.projectsResponse["serviceType"].toString() == "3"
                          ? getParkingBay()
                          : "",
                  userAddressId:
                      _container.projectsResponse["serviceType"].toString() == "3"
                          ? getUserAddress()
                          : "",
                  consentToTreat: true,
                  paymentMethod: getPaymentMethod(),
                  cardId: _consentToTreatMap["paymentMap"] != null
                      ? _consentToTreatMap["paymentMap"]["selectedCard"] != null
                          ? _consentToTreatMap["paymentMap"]["selectedCard"]
                                      ['id'] !=
                                  null
                              ? _consentToTreatMap["paymentMap"]["selectedCard"]
                                      ['id'] ??
                                  ''
                              : ''
                          : ''
                      : '',
                  insuranceId: _consentToTreatMap["paymentMap"] != null
                      ? _consentToTreatMap["paymentMap"]["insuranceId"] != null
                          ? _consentToTreatMap["paymentMap"]["insuranceId"] ?? ''
                          : ''
                      : '',
                  medicalDiagnosticsTests: medicalDiagnosticsTests,
                  medicalDocuments: medicalDocuments,
                  medicalHistory: Provider.of<HealthConditionProvider>(context, listen: false).medicalHistoryData,
                  medicalImages: medicalImages,
                  preferredPharmacy: Provider.of<HealthConditionProvider>(context, listen: false).preferredPharmacyData,
                  problems: Provider.of<HealthConditionProvider>(context, listen: false).allHealthIssuesData,
                  vitals: Provider.of<HealthConditionProvider>(context, listen: false).vitalsData,
                  allergy: Provider.of<HealthConditionProvider>(context, listen: false).allergies,
                  socialHistory: Provider.of<HealthConditionProvider>(context, listen: false).socialHistory,
                  medicationDetails: Provider.of<HealthConditionProvider>(context, listen: false).medicationData);

              finalModel.toJson().toString().debugLog();
              _newBookAppointmentApiCall(context, finalModel);
            },
          ),
        )
      ],
    ));
    _container.projectsResponse["serviceType"].toString() == '2'
        ? _widgetList.add(recordingInfoWidget())
        : _widgetList.add(Container());

    _widgetList.add(paymentType == "3" ? duePaymentWidget() : Container());

    _widgetList.add(Container(
      height: 55.0,
      width: double.infinity,
    ));

    return _widgetList;
  }

  String getParkingFee() {
    if (_consentToTreatMap["parkingMap"] != null) {
      if (_consentToTreatMap["parkingMap"]["parkingFee"] != null) {
        return _consentToTreatMap["parkingMap"]["parkingFee"].toString();
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  String getParkingType() {
    if (_consentToTreatMap["parkingMap"] != null) {
      if (_consentToTreatMap["parkingMap"]["parkingType"] != null) {
        return _consentToTreatMap["parkingMap"]["parkingType"].toString();
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  String getParkingInstruction() {
    if (_consentToTreatMap["parkingMap"] != null) {
      if (_consentToTreatMap["parkingMap"]["instructions"] != null) {
        return _consentToTreatMap["parkingMap"]["instructions"].toString();
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  String getParkingBay() {
    _consentToTreatMap["parkingMap"]["parkingBay"].toString();
    if (_consentToTreatMap["parkingMap"] != null) {
      if (_consentToTreatMap["parkingMap"]["parkingBay"] != null) {
        return _consentToTreatMap["parkingMap"]["parkingBay"].toString();
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  String? getUserAddress() {
    if (Provider.of<HealthConditionProvider>(context, listen: false)
            .addressDetails !=
        null) {
      return Provider.of<HealthConditionProvider>(context, listen: false)
          .addressDetails!
          .sId;
    } else if (_consentToTreatMap["userAddress"] != null) {
      if (_consentToTreatMap["userAddress"]["_id"] != null) {
        return _consentToTreatMap["userAddress"]["_id"].toString();
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  dynamic getPaymentMethod() {
    if (paymentType != null) {
      if (paymentType == "3") {
        return 3;
      } else if (paymentType == "2") {
        return 2;
      } else {
        return 1;
      }
    }
  }

  Widget locationWidget(String? location, LatLng latLng, dynamic distance) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _container.projectsResponse["serviceType"].toString() == '3'
                ? getString(PreferenceKey.fullName, "").capitalizeFirstOfEach +
                    " 's Address"
                : _profileMap!.containsKey("User")
                    ? "${_profileMap!['User'][0]['fullName']}'s Office Address is;"
                    : "${_profileMap!["userId"]["fullName"]}'s Office Address is;",
            style:
                TextStyle(fontWeight: fontWeightSemiBold, fontSize: fontSize14),
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
                      location ??
                          Provider.of<HealthConditionProvider>(context,
                                  listen: false)
                              .providerAddress,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: fontWeightRegular,
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
                          distance != null
                              ? Extensions.getDistance(distance)
                              : _totalDistance ?? "0 mi",
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
                  border: Border.all(color: Colors.grey[300]!),
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
                      zoom: 14.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);

                      setState(() {
                        _markers.add(
                          Marker(
                              markerId: MarkerId(latLng.toString()),
                              position: latLng,
                              icon: _sourceIcon),
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

  String getAppointmentType(String status, BuildContext context) {
    switch (status) {
      case "1":
        return Localization.of(context)!.officeAppointmentLabel;
        break;
      case "2":
        return Localization.of(context)!.videoChatLabel;
        break;
      case "3":
        return Localization.of(context)!.onSiteLabel;
        break;
      default:
        return "";
        break;
    }
  }

  String getAppointmentImage(String status, BuildContext context) {
    switch (status) {
      case "1":
        return 'images/ic_office_app.png';
        break;
      case "2":
        return 'images/ic_video_app.png';
        break;
      case "3":
        return 'images/ic_onsite_app.png';
        break;
      default:
        return "";
        break;
    }
  }

  String _getAppointmentDateTime(
          BuildContext context, Map<dynamic, dynamic> response) =>
      DateFormat(AppConstants.requestAppointmentDateTimeFormat)
          .format(DateTime.utc(
                  DateTime.parse(response['data']['date']).year,
                  DateTime.parse(response['data']['date']).month,
                  DateTime.parse(response['data']['date']).day)
              .toLocal())
          .toString() +
      ' ${int.parse(response['data']['fromTime'].split(':')[0])} : ${int.parse(response['data']['fromTime'].split(':')[1])} ${int.parse(response['data']['fromTime'].split(':')[0]) >= 12 ? 'pm' : 'am'}';

  Widget duePaymentWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      padding: const EdgeInsets.all(20),
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
            "If you paid be credit card, look out for a charge from Hutano.",
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

  void showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  _container.projectsResponse["serviceType"].toString() == '1'
                      ? "Office Request Sent!"
                      : _container.projectsResponse["serviceType"].toString() ==
                              '2'
                          ? "Video Request Sent!"
                          : "Onsite Request Sent!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.90),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Your request has been sent. You will be notified when the "
                  "provider accepts your appointment request.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
                SizedBox(height: 26),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: AppColors.goldenTainoi,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      _container.consentToTreatMap.clear();
                      _container.getProviderData().clear();
                      _container.appointmentData.clear();
                      Provider.of<HealthConditionProvider>(context,
                              listen: false)
                          .resetHealthConditionProvider();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.dashboardScreen,
                        (Route<dynamic> route) => false,
                        arguments: 1,
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  Widget appoCard(String cardText) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          border: Border.all(
              color: colorShadowCheckbox.withOpacity(0.5), width: 0.5),
          boxShadow: [
            BoxShadow(
                color: const Color(0x148b8b8b),
                offset: Offset(0, 2),
                blurRadius: 30,
                spreadRadius: 0)
          ],
          color: colorWhite),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardText == '1'
                      ? "Office Appointment"
                      : cardText == '2'
                          ? "Virtual Care"
                          : "Onsite Appointment",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: colorBlack2,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  '\$${_totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: colorGolden,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                ),
              ],
            ),
          ),
          Image(
            image: AssetImage(
              cardText == '1'
                  ? "images/office_appointment.png"
                  : cardText == '2'
                      ? "images/video_chat_appointment.png"
                      : "images/onsite_appointment.png",
            ),
            height: 52.0,
            width: 52.0,
          ),
        ],
      ),
    );
  }

  void _loading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  Widget _buildCardWidget() {
    var _card;
    var title;
    late var image;
    if (paymentType == "1") {
      _card = _consentToTreatMap["paymentMap"]["selectedCard"]['card'];
      title = "**** **** **** ${_card['last4']}";
    } else if (paymentType == "2") {
      image = "images/insurancePlaceHolder.png";
      title = insuranceName;
    } else {
      title = "Cash";
      image = "images/ic_cash_payment.png";
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                paymentType == "1"
                    ? getCardIcon(CardType.Master)!
                    : (paymentType == "2" && insuranceImage == null)
                        ? Image.network(
                            ApiBaseHelper.imageUrl + insuranceImage!,
                            height: 42,
                            width: 42,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            image,
                            width: 28,
                            height: 28,
                          ),
                SizedBox(width: spacing25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: fontSize14,
                          color: colorBorder2,
                          fontWeight: fontWeightSemiBold),
                    ),
                    if (paymentType == "1") ...[
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        'Expires ${_card["exp_month"]}/${_card["exp_year"].toString().substring(2, 4)}',
                        style: TextStyle(
                            fontSize: fontSize12,
                            color: colorBorder2,
                            fontWeight: fontWeightRegular),
                      ),
                    ]
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.popUntil(context,
                        ModalRoute.withName(Routes.paymentMethodScreen));
                  },
                  child: Text("Change",
                      style: const TextStyle(
                          color: const Color(0xff1e36ba),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 13.0),
                      textAlign: TextAlign.right),
                )
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: spacing5),
            padding: EdgeInsets.all(spacing15),
            width: double.infinity,
            height: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 30,
                  color: colorLightGrey.withOpacity(0.2),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget recordingInfoWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 20),
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

  Future<void> _newBookAppointmentApiCall(BuildContext context,
      ReqBookingAppointmentModel reqBookingAppointmentModel) async {
    ProgressDialogUtils.showProgressDialog(context);
    await ApiManager()
        .bookNewAppointment(reqBookingAppointmentModel)
        .then(((result) {
      ProgressDialogUtils.dismissProgressDialog();
      showConfirmDialog();
    })).catchError((dynamic e) {
      ProgressDialogUtils.dismissProgressDialog();
      if (e is ErrorModel) {
        if (e.response == 'Please select correct appointment date') {
          Widgets.showConfirmationDialog(
              context: context,
              title: 'Slot Unavailable',
              description: 'Please select correct appointment slot',
              rightText: 'Cancel',
              leftText: 'Change Time',
              onLeftPressed: () {
                Navigator.of(context)
                    .pushNamed(
                  Routes.selectAppointmentTimeScreen,
                  arguments: SelectDateTimeArguments(fromScreen: 1),
                )
                    .then((value) {
                  if (value != null) {
                    Map _editDateTimeData = value as Map<dynamic, dynamic>;

                    setState(() {
                      _setBookingTime(_editDateTimeData["time"]);
                      _bookedDate = _editDateTimeData["date"];
                    });
                  }
                });
              });
        } else {
          Widgets.showErrorialog(
              context: context,
              description: e.response,
              buttonText: (e.response!.contains('already') ||
                      e.response!.contains('declined'))
                  ? 'Go to requests'
                  : 'Ok',
              onPressed: () {
                if (e.response!.contains('already') ||
                    e.response!.contains('declined')) {
                  _container.consentToTreatMap.clear();
                  _container.getProviderData().clear();
                  _container.appointmentData.clear();
                  Provider.of<HealthConditionProvider>(context, listen: false)
                      .resetHealthConditionProvider();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.dashboardScreen,
                    (Route<dynamic> route) => false,
                    arguments: 1,
                  );
                } else {
                  Navigator.pop(context);
                }
              });
          e.toString().debugLog();
        }
      }
    });
  }
}
