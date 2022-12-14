import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_constants.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReviewAppointmentScreen extends StatefulWidget {
  @override
  _ReviewAppointmentScreenState createState() =>
      _ReviewAppointmentScreenState();
}

class _ReviewAppointmentScreenState extends State<ReviewAppointmentScreen> {
  late InheritedContainerState _container;
  late Map _appointmentData;
  late Map _providerData, _userLocationMap;
  bool _isLoading = false;
  String? _timeHours, _timeMins;
  DateTime? _bookedDate;
  String? _bookedTime;
  List<Services>? _servicesList = [];
  String _timezone = 'Unknown';

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  String averageRating = "0";

  PolylinePoints _polylinePoints = PolylinePoints();

  List<LatLng> latlng = [];
  LatLng? _initialPosition, _middlePoint;
  LatLng _desPosition = LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor _sourceIcon;
  late BitmapDescriptor _destinationIcon;

  String _totalDistance = "";
  String _totalDuration = "";
  Map? _profileMap = new Map();
  Map _servicesMap = new Map();
  Map<String, dynamic> _reviewAppointmentData = Map();
  late Map _consentToTreatMap;
  String? paymentType, insuranceName, insuranceImage, insuranceId;
  ApiBaseHelper api = ApiBaseHelper();
  List<dynamic>? _consultaceList = [];

  setPolylines() async {
    PolylineResult polylineResult =
        await _polylinePoints.getRouteBetweenCoordinates(
      Strings.kGoogleApiKey,
      PointLatLng(_initialPosition!.latitude, _initialPosition!.longitude),
      PointLatLng(_desPosition.latitude, _desPosition.longitude),
    );

    List<PointLatLng> result = polylineResult.points;

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        latlng.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      _polyline.add(
        Polyline(
          polylineId: PolylineId(_initialPosition.toString()),
          color: AppColors.persian_indigo,
          points: latlng,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    });
  }

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
    _userLocationMap = _container.userLocationMap;
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
      averageRating =
          _providerData["providerData"]["averageRating"]?.toStringAsFixed(1) ??
              "0";

      _providerData["providerData"]["data"].map((f) {
        _profileMap!.addAll(f);
      }).toList();
    } else {
      _profileMap = _providerData["providerData"];
      averageRating = _profileMap!["averageRating"]?.toStringAsFixed(1) ?? "0";
    }

    _initialPosition = _userLocationMap["latLng"];

    if (_container.projectsResponse["serviceType"].toString() == '3') {
      _desPosition = LatLng(
          double.parse(
              _consentToTreatMap["userAddress"]['coordinates'][1].toString()),
          double.parse(
              _consentToTreatMap["userAddress"]['coordinates'][0].toString()));
      if (_profileMap!["businessLocation"] != null) {
        if (_profileMap!["businessLocation"]["coordinates"].length > 0) {
          _initialPosition = LatLng(
              double.parse(_profileMap!["businessLocation"]["coordinates"][1]
                  .toString()),
              double.parse(_profileMap!["businessLocation"]["coordinates"][0]
                  .toString()));
        }
      }
    } else if (_container.projectsResponse["serviceType"].toString() == '1') {
      if (_profileMap!["businessLocation"] != null) {
        if (_profileMap!["businessLocation"]["coordinates"].length > 0) {
          _desPosition = LatLng(
              double.parse(_profileMap!["businessLocation"]["coordinates"][1]
                  .toString()),
              double.parse(_profileMap!["businessLocation"]["coordinates"][0]
                  .toString()));
        }
      }
    } else {}

    _middlePoint = LatLng(
        (_initialPosition!.latitude + _desPosition.latitude) / 2,
        (_initialPosition!.longitude + _desPosition.longitude) / 2);

    if (_initialPosition != null) {
      getDistanceAndTime(_initialPosition!, _desPosition);
    }

    _setBookingTime(_appointmentData["time"]);
    _bookedDate = _appointmentData["date"];

    _servicesMap = _container.selectServiceMap;

    _reviewAppointmentData["statusType"] = _servicesMap["status"].toString();

    if (_servicesList!.length > 0) _servicesList!.clear();

    if (_servicesMap["status"].toString() == "1") {
      if (_servicesMap["services"] != null) {
        _servicesList = _servicesMap["services"];

        if (_servicesList!.length > 0) {
          _reviewAppointmentData["services"] = _servicesList;
        }
      }
    } else {
      _consultaceList = _servicesMap["consultaceFee"];

      for (int i = 0; i < _consultaceList!.length; i++) {
        _reviewAppointmentData["consultanceFee[${i.toString()}][fee]"] =
            _consultaceList![i]["fee"].toString();
      }
    }
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
      body: LoadingBackgroundNew(
        title: "Review Appointment",
        color: AppColors.snow,
        isLoading: _isLoading,
        isAddAppBar: true,
        addHeader: true,
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgetList(),
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                width: MediaQuery.of(context).size.width - 76.0,
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: FancyButton(
                  title: "Book Appointment",
                  buttonIcon: "ic_send_request",
                  onPressed: _bookAppointment,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentWidget(
      String? paymentType, String? insuranceName, String? insuranceImage) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
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
              paymentType == "3"
                  ? Image.asset("images/ic_cash_payment.png",
                      height: 42, width: 42)
                  : paymentType == "1"
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
                  paymentType == "3"
                      ? "Cash"
                      : paymentType == "1"
                          ? "Card **** **** **** ${_consentToTreatMap["paymentMap"]["selectedCard"]['card']['last4']}"
                          : insuranceName!,
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

  _bookAppointment() async {
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    if (mounted) {
      setState(() {});
    }
    try {
      SharedPref().getToken().then((token) async {
        _loading(true);
        Uri uri = Uri.parse(
            ApiBaseHelper.base_url + "api/patient/appointment-booking-v1");

        String doctorId = '';

        if (_profileMap!["userId"] != null && _profileMap!["userId"] is Map) {
          doctorId = _profileMap!["userId"]["_id"].toString();
        } else if (_profileMap!["User"] != null is Map) {
          doctorId = _profileMap!["User"][0]["_id"].toString();
        }

        _reviewAppointmentData["type"] =
            _container.getProjectsResponse()["serviceType"]?.toString() ?? "1";
        _reviewAppointmentData["date"] =
            DateFormat("MM/dd/yyyy").format(_bookedDate!).toString();
        _reviewAppointmentData["fromTime"] = _bookedTime;
        _reviewAppointmentData["timeZonePlace"] = _timezone;
        _reviewAppointmentData["doctor"] = doctorId;

        _reviewAppointmentData["isOndemand"] = _appointmentData["isOndemand"];

        if (_appointmentData["officeId"] != null) {
          _reviewAppointmentData["officeId"] = _appointmentData["officeId"];
        }
        if (_reviewAppointmentData["type"] == '3') {
          _reviewAppointmentData['userAddressId'] =
              _consentToTreatMap["userAddress"]["_id"].toString();
          _reviewAppointmentData['parkingType'] =
              _consentToTreatMap["parkingMap"]["parkingType"].toString();
          _reviewAppointmentData['parkingFee'] =
              _consentToTreatMap["parkingMap"]["parkingFee"].toString();
          _reviewAppointmentData['parkingBay'] =
              _consentToTreatMap["parkingMap"]["parkingBay"].toString();

          if (_consentToTreatMap["parkingMap"]["instructions"].toString() !=
              null) {
            _reviewAppointmentData['instructions'] =
                _consentToTreatMap["parkingMap"]["instructions"].toString();
          }
        }

        _reviewAppointmentData['consentToTreat'] = '1';
        _reviewAppointmentData['problemTimeSpan'] =
            _consentToTreatMap["problemTimeSpan"];
        _reviewAppointmentData['isProblemImproving'] =
            _consentToTreatMap["isProblemImproving"];
        _reviewAppointmentData['isTreatmentReceived'] =
            _consentToTreatMap["isTreatmentReceived"];
        _reviewAppointmentData['description'] =
            _consentToTreatMap["description"].toString().trim();

        if (paymentType != null) {
          if (paymentType == "3") {
            _reviewAppointmentData['cashPayment'] = "3";
            _reviewAppointmentData['paymentMethod'] = "3";
          } else if (paymentType == "2") {
            _reviewAppointmentData['paymentMethod'] = "2";
            _reviewAppointmentData['insuranceId'] = insuranceId;
          } else {
            _reviewAppointmentData['paymentMethod'] = "1";
            _reviewAppointmentData['cardId'] =
                _consentToTreatMap["paymentMap"]["selectedCard"]['id'];
          }
        }

        _reviewAppointmentData['medicalDiagnosticsTests'] =
            Provider.of<HealthConditionProvider>(context, listen: false)
                .medicalDiagnosticsTestsModelData;
        _reviewAppointmentData['medicalDocuments'] =
            Provider.of<HealthConditionProvider>(context, listen: false)
                .medicalDocumentsData;
        _reviewAppointmentData['medicalHistory'] =
            Provider.of<HealthConditionProvider>(context, listen: false)
                .medicalHistoryData;
        _reviewAppointmentData['medicalImages'] =
            Provider.of<HealthConditionProvider>(context, listen: false)
                .medicalImagesData;
        _reviewAppointmentData['preferredPharmacy'] =
            Provider.of<HealthConditionProvider>(context, listen: false)
                .preferredPharmacyData;
        _reviewAppointmentData['problems'] =
            Provider.of<HealthConditionProvider>(context, listen: false)
                .allHealthIssuesData;
        _reviewAppointmentData['vitals'] =
            Provider.of<HealthConditionProvider>(context, listen: false)
                .vitalsData;
        _reviewAppointmentData['medicationDetails'] =
            Provider.of<HealthConditionProvider>(context, listen: false)
                .medicationData;

        api
            .bookAppointment2(context, token, _reviewAppointmentData)
            .then((responseJson) {
          if (responseJson["response"] is String) {
            _loading(false);
            Widgets.showAppDialog(
                isError: true,
                context: context,
                buttonText: responseJson["response"].contains('already')
                    ? 'Go to Requests'
                    : 'Close',
                description: responseJson["response"],
                onPressed: () {
                  if (responseJson["response"].contains('already')) {
                    _container.consentToTreatMap.clear();
                    _container.getProviderData().clear();
                    _container.appointmentData.clear();

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.dashboardScreen,
                      (Route<dynamic> route) => false,
                      arguments: 1,
                    );
                  } else {
                    Navigator.pop(context);
                  }
                });
          } else {
            _loading(false);
            responseJson["response"].toString().debugLog();
            String name = '', nameTitle = '';
            if (_profileMap!['userId'] is Map) {
              if (_profileMap!["userId"] != null) {
                nameTitle =
                    _profileMap!["userId"]["title"]?.toString() ?? 'Dr. ';
                name = nameTitle +
                    (_profileMap!["userId"]["fullName"]?.toString() ?? "---");
              }
            } else if (_profileMap!["User"] != null &&
                _profileMap!["User"].length > 0) {
              nameTitle =
                  (_profileMap!["User"][0]["title"]?.toString() ?? 'Dr. ');
              name = '$nameTitle ' +
                  (_profileMap!["User"][0]["fullName"]?.toString() ?? "---");
            }
            var appointmentType = '';
            appointmentType = _container.projectsResponse["serviceType"]
                        .toString() ==
                    '1'
                ? "office"
                : _container.projectsResponse["serviceType"].toString() == '2'
                    ? "telemedicine"
                    : "onsite";
            Widgets.showAppDialog(
                context: context,
                description:
                    'Your $appointmentType appointment with $name is booked.',
                buttonText: 'Go to Requests',
                isCongrats: true,
                onPressed: () {
                  _container.consentToTreatMap.clear();
                  _container.getProviderData().clear();
                  _container.appointmentData.clear();

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.dashboardScreen,
                    (Route<dynamic> route) => false,
                    arguments: 1,
                  );
                });
          }
        }).futureError((error) {
          _loading(false);
          error.toString().debugLog();
        });
      });
    } on Exception catch (error) {
      _loading(false);
      error.toString().debugLog();
    }
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
                      ? "It's a wrap!"
                      : _container.projectsResponse["serviceType"].toString() ==
                              '2'
                          ? "It's a wrap!"
                          : "It's a wrap!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.90),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "The provider is reviewing your request "
                  "Thank you for trusting Hutano with your care.",
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

  List<Widget> widgetList() {
    List<Widget> _widgetList = [];
    String? address;

    if (_profileMap!["businessLocation"] != null) {
      dynamic business = _profileMap!["businessLocation"];

      dynamic _state;

      if (business["state"] is Map && business["state"].length > 0) {
        _state = business["state"];
      } else if (_profileMap!['State'] != null &&
          _profileMap!["State"].length > 0) {
        _state = _profileMap!['State'][0];
      }

      if (_container.projectsResponse["serviceType"].toString() == '3') {
        address = Extensions.addressFormat(
          _consentToTreatMap["userAddress"]["street"]?.toString(),
          _consentToTreatMap["userAddress"]["address"]?.toString(),
          _consentToTreatMap["userAddress"]["city"]?.toString(),
          _consentToTreatMap["userAddress"]['state'],
          _consentToTreatMap["userAddress"]["zipCode"]?.toString(),
        );
      } else if (_container.projectsResponse["serviceType"].toString() == '1') {
        address = Extensions.addressFormat(
          business["address"]?.toString(),
          business["street"]?.toString(),
          business["city"]?.toString(),
          _state,
          business["zipCode"]?.toString(),
        );
      } else {}
    }

    _widgetList.add(
      Padding(
        padding: const EdgeInsets.only(
          right: 20.0,
          left: 20.0,
        ),
        child: ProviderWidget(
          data: _profileMap,
          selectedAppointment:
              _container.projectsResponse['serviceType'].toString(),
          isOptionsShow: false,
          averageRating: averageRating,
        ),
      ),
    );
    _widgetList.add(Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 11.0),
      child: Text(
        "Appointment Type",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    ));
    _widgetList.add(appoCard(
      _container.projectsResponse["serviceType"].toString(),
    ));
    _container.projectsResponse["serviceType"].toString() == '2'
        ? _widgetList.add(recordingInfoWidget())
        : _widgetList.add(Container());

    _widgetList.add(
      container(
          "Date & Time",
          _appointmentData["isOndemand"] == '1'
              ? "On-demand Appointment"
              : "${DateFormat('EEEE, dd MMMM').format(_bookedDate!).toString()} " +
                  TimeOfDay(
                          hour: int.parse(_timeHours!),
                          minute: int.parse(_timeMins!))
                      .format(context),
          "ic_calendar"),
    );
    _container.projectsResponse["serviceType"].toString() == '2'
        ? _widgetList.add(Container())
        : _widgetList.add((_initialPosition == null && _middlePoint == null)
            ? Container()
            : Stack(
                children: <Widget>[
                  Container(
                    height: 155.0,
                    margin: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: GoogleMap(
                        myLocationEnabled: false,
                        compassEnabled: false,
                        rotateGesturesEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: _middlePoint!,
                          zoom: 8,
                        ),
                        polylines: _polyline,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) async {
                          LatLngBounds bound;
                          if (_initialPosition!.latitude >
                                  _desPosition.latitude &&
                              _initialPosition!.longitude >
                                  _desPosition.longitude) {
                            bound = LatLngBounds(
                                southwest: _desPosition,
                                northeast: _initialPosition!);
                          } else if (_initialPosition!.longitude >
                              _desPosition.longitude) {
                            bound = LatLngBounds(
                                southwest: LatLng(_initialPosition!.latitude,
                                    _desPosition.longitude),
                                northeast: LatLng(_desPosition.latitude,
                                    _initialPosition!.longitude));
                          } else if (_initialPosition!.latitude >
                              _desPosition.latitude) {
                            bound = LatLngBounds(
                                southwest: LatLng(_desPosition.latitude,
                                    _initialPosition!.longitude),
                                northeast: LatLng(_initialPosition!.latitude,
                                    _desPosition.longitude));
                          } else {
                            bound = LatLngBounds(
                                southwest: _initialPosition!,
                                northeast: _desPosition);
                          }

                          setState(() {
                            _controller.complete(controller);

                            _markers.add(Marker(
                              markerId: MarkerId(_initialPosition.toString()),
                              position: _initialPosition!,
                              icon: _sourceIcon,
                            ));

                            _markers.add(Marker(
                              markerId: MarkerId(_desPosition.toString()),
                              position: _desPosition,
                              icon: _destinationIcon,
                            ));

                            setPolylines();
                          });
                          try {
                            Future.delayed(Duration(milliseconds: 1000), () {
                              CameraUpdate u2 =
                                  CameraUpdate.newLatLngBounds(bound, 50);
                              controller.animateCamera(u2).then((void v) {
                                check(u2, controller);
                              });
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(60.0, 33.0, 0.0, 0.0),
                    padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        "ic_map_clock".imageIcon(width: 30.0, height: 30.0),
                        SizedBox(width: 5.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _totalDuration.toLowerCase().contains('mins')
                                  ? _totalDuration.replaceAll("mins", "minutes")
                                  : _totalDuration,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _totalDistance,
                              style: TextStyle(
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ));
    _container.projectsResponse["serviceType"].toString() == '2'
        ? _widgetList.add(Container())
        : _widgetList.add(container(
            _container.projectsResponse["serviceType"].toString() == '3'
                ? 'Site Address'
                : "Office Address",
            address,
            "ic_office_address"));

    _widgetList.add(
      servicesWidget(),
    );

    _widgetList.add(
      paymentWidget(paymentType, insuranceName, insuranceImage),
    );

    _widgetList.add(paymentType == "3" ? duePaymentWidget() : Container());

    return _widgetList;
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    c.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
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
    }).futureError((error) {
      setState(() {
        _totalDuration = "---";
        _totalDistance = "---";
      });
      error.toString().debugLog();
    });
  }

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
            "You will only be charged when the request has been accepted.",
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

  Widget container(String heading, String? subtitle, String icon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                heading,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              heading.toLowerCase().contains("date")
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.edit,
                                size: 10.0,
                                color: AppColors.jade,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                "Edit",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.jade.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ).onClick(
                          roundCorners: false,
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(
                              Routes.selectAppointmentTimeScreen,
                              arguments: SelectDateTimeArguments(fromScreen: 1),
                            )
                                .then((value) {
                              if (value != null) {
                                Map _editDateTimeData =
                                    value as Map<dynamic, dynamic>;

                                setState(() {
                                  _setBookingTime(_editDateTimeData["time"]);
                                  _bookedDate = _editDateTimeData["date"];
                                });
                              }
                            });
                          },
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 12.0),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14.0,
              ),
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: icon.imageIcon(),
                  ),
                ),
                TextSpan(text: subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget servicesWidget() {
    String selectedService =
        _container.projectsResponse["serviceType"].toString() == '1'
            ? "Office Appointment"
            : _container.projectsResponse["serviceType"].toString() == '2'
                ? "Telemedicine"
                : "Onsite Appointment";
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Selected Services: $selectedService",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 0.5,
              ),
            ),
            child: _servicesList != null && _servicesList!.length > 0
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _servicesList!.length,
                    itemBuilder: (context, index) {
                      Services services = _servicesList![index];
                      return serviceSlotWidget(services);
                    })
                : ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _consultaceList!.length,
                    itemBuilder: (context, index) {
                      dynamic consultance = _consultaceList![index];
                      return consultationSlotWidget(consultance);
                    }),
          ),
          SizedBox(height: 6.0),
        ],
      ),
    );
  }

  Widget serviceSlotWidget(Services services) {
    return ListTile(
      title: Text(
        services.subServiceName ?? "---",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Fee: \$',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: '${services.amount.toStringAsFixed(2)} \u2022 ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: 'Duration: ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: '${services.duration} minutes',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget consultationSlotWidget(Map consultaion) {
    return ListTile(
      title: Text(
        "Consultation Fee",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Fee: \$',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: (consultaion["fee"]?.toStringAsFixed(2) ?? '0.00') +
                  ' \u2022 ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: 'Duration: ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: consultaion["duration"]?.toString() ?? '---' + ' minutes',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  Widget appoCard(String cardText) {
    return Container(
      // width: 172.0,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
          SizedBox(width: 12.0),
          Text(
            cardText == '1'
                ? "Office\nAppointment"
                : cardText == '2'
                    ? "Telemedicine"
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
}
