import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/dashboard/choose_location_screen.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/pin_info.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:location/location.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const TRACK_STATUS_PROVIDER = 'trackingStatusProvider';
const TRACK_STATUS = 'trackingStatus';
const PATIENT_START_DRIVING = 'patientStartDriving';
const PROVIDER_START_DRIVING = 'providerStartDriving';
const PATIENT_ARRIVED = 'patientArrived';
const PROVIDER_ARRIVED = 'providerArrived';

class TrackTreatmentScreen extends StatefulWidget {
  const TrackTreatmentScreen({Key key, this.appointmentType = 0})
      : super(key: key);

  final int appointmentType;

  @override
  _TrackTreatmentScreenState createState() => _TrackTreatmentScreenState();
}

class _TrackTreatmentScreenState extends State<TrackTreatmentScreen> {
  Future<dynamic> _profileFuture;

  bool _isLoading = false;
  InheritedContainerState _container;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> _polyLineLatlngList = [];
  LatLng _initialPosition;
  LatLng _desPosition = LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  ApiBaseHelper api = ApiBaseHelper();
  String _totalDistance = "";
  String _totalDuration = "";
  Map<String, String> appointmentCompleteMap = Map();

  PinInformation currentlySelectedPin = PinInformation(
    pinPath: '',
    avatarPath: '',
    location: LatLng(0, 0),
  );

  PinInformation sourcePinInfo, destinationPinInfo;
  CameraPosition initialCameraPosition;

  LocationData destinationLocation;
  Location location = Location();

  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();

  int _appointmentType = 0;

  String _trackStatusKey = TRACK_STATUS;
  String _startDrivingStatusKey = PATIENT_START_DRIVING;
  String _arrivedStatusKey = PATIENT_ARRIVED;

  var _userLocation = LatLng(0.00, 0.00);

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  setPolylines(LatLng _initialPosition, LatLng _desPosition) async {
    PolylineResult polylineResult = await polylinePoints
        .getRouteBetweenCoordinates(
          "AIzaSyAkq7DnUBTkddWXddoHAX02Srw6570ktx8",
          PointLatLng(_initialPosition.latitude, _initialPosition.longitude),
          PointLatLng(_desPosition.latitude, _desPosition.longitude),
        )
        .catchError((error) => error.toString().debugLog());

    List<PointLatLng> result = polylineResult.points;

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        _polyLineLatlngList.add(LatLng(point.latitude, point.longitude));
      });
    }

    if (mounted) {
      setState(() {
        _polyline.add(
          Polyline(
            polylineId: PolylineId(_initialPosition.toString()),
            color: AppColors.windsor,
            points: _polyLineLatlngList,
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _appointmentType = widget.appointmentType;

    if (_appointmentType == 3) {
      _trackStatusKey = TRACK_STATUS_PROVIDER;
      _startDrivingStatusKey = PROVIDER_START_DRIVING;
      _arrivedStatusKey = PROVIDER_ARRIVED;
    } else {
      _trackStatusKey = TRACK_STATUS;
      _startDrivingStatusKey = PATIENT_START_DRIVING;
      _arrivedStatusKey = PATIENT_ARRIVED;
    }

    setSourceAndDestinationIcons();
    setInitialLocation();
  }

  void updatePinOnMap(LatLng latLng) async {
    if (mounted) {
      CameraPosition cPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: latLng,
      );

      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

      setState(() {
        var pinPosition = LatLng(latLng.latitude, latLng.longitude);

        sourcePinInfo.location = pinPosition;

        _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
        _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
            });
          },
          position: pinPosition,
          icon: sourceIcon,
        ));

        _polyLineLatlngList.clear();
        _polyline.clear();

        setPolylines(latLng, _desPosition);
      });
    }
  }

  void setInitialLocation() async {
    await location.getLocation().then((LocationData value) {
      setState(() {
        _initialPosition = LatLng(value.latitude, value.longitude);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    if (_container.userLocationMap != null &&
        _container.userLocationMap.isNotEmpty) {
      _userLocation = _container.userLocationMap['latLng']?? LatLng(0.00, 0.00);
    }

    SharedPref().getToken().then((token) {
      setState(() {
        _profileFuture = api.getAppointmentDetails(
          token,
          _container.appointmentIdMap["appointmentId"],
          _userLocation,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialPosition != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Appointment Status",
        isLoading: _isLoading,
        isAddBack: true,
        addBackButton: false,
        color: Colors.white,
        padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (_initialPosition != null) {
                api
                    .getDistanceAndTime(
                        _initialPosition, _desPosition, kGoogleApiKey)
                    .then((value) {
                  _totalDistance = value["rows"][0]["elements"][0]["distance"]
                          ["text"]
                      .toString();
                  _totalDuration = value["rows"][0]["elements"][0]["duration"]
                          ["text"]
                      .toString();
                  ("DISTANCE AND TIME: " +
                          value["rows"][0]["elements"][0].toString())
                      .toString()
                      .debugLog();
                }).futureError((error) {
                  setState(() {
                    _totalDuration = "NO duration available";
                    _totalDistance = "NO distance available";
                  });
                  error.toString().debugLog();
                });
              }

              if (snapshot.hasData) {
                return widgetList(snapshot.data);
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

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_initial_marker.png");
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_destination_marker.png");
  }

  Widget widgetList(Map appointment) {
    Map response = appointment["data"];

    String name = "---",
        rating = "---",
        professionalTitle = "---",
        avatar,
        address = "---",
        appointmentType = "---",
        dateTime;

    appointmentType = response["type"] == 1
        ? "Office response"
        : response["type"] == 2 ? "Video response" : "Onsite response";

    rating = appointment["averageRating"]?.toStringAsFixed(2) ?? "0";

    if (appointment["doctorData"] != null) {
      for (dynamic detail in appointment["doctorData"]) {
        if (detail["professionalTitle"] != null) {
          professionalTitle =
              detail["professionalTitle"]["title"]?.toString() ?? "---";
        }

        if (detail["businessLocation"] != null) {
          dynamic business = detail["businessLocation"];

          address = Extensions.addressFormat(
            business["address"]?.toString(),
            business["street"]?.toString(),
            business["city"]?.toString(),
            business["state"],
            business["zipCode"]?.toString(),
          );
        }
      }
    }

    if (response[_trackStatusKey] != null &&
        response[_trackStatusKey]["treatmentStarted"] != null) {
      dateTime = "On " +
          response[_trackStatusKey]["treatmentStarted"].toString().formatDate(
                dateFormat: Strings.dateTimePattern,
              );
    }

    if (response["doctor"] != null) {
      name = response["doctor"]["fullName"]?.toString() ?? "---";
      avatar = response["doctor"]["avatar"];
    }

    appointmentCompleteMap["name"] = name;
    appointmentCompleteMap["address"] = address;
    appointmentCompleteMap["dateTime"] = dateTime;
    appointmentCompleteMap["type"] = response["type"];

    if (appointment["doctorData"] != null) {
      for (dynamic detail in appointment["doctorData"]) {
        if (detail["businessLocation"] != null) {
          if (detail["businessLocation"]["coordinates"] != null) {
            List location = detail["businessLocation"]["coordinates"];

            if (location.length > 0) {
              _desPosition = LatLng(
                double.parse(location[1].toString()),
                double.parse(location[0].toString()),
              );
            }
          }
        }
      }
    }

    int status = 0;
    if (response[_trackStatusKey] != null) {
      if (response[_trackStatusKey]["status"] != null) {
        status = response[_trackStatusKey]["status"] ?? 0;
      } else {
        status = response[_trackStatusKey] ?? 0;
      }
    }

    return Stack(
      children: <Widget>[
        _initialPosition == null
            ? Container()
            : Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: GoogleMap(
                        myLocationEnabled: false,
                        compassEnabled: false,
                        rotateGesturesEnabled: false,
                        initialCameraPosition: initialCameraPosition,
                        polylines: _polyline,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);

                          setState(() {
                            showPinsOnMap(_initialPosition);
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(60.0, 33.0, 0.0, 0.0),
                    padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                    height: 60,
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
                              _totalDuration,
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
              ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      status == 0 || status == 1
                          ? "ic_map_clock".imageIcon(width: 16.0, height: 16.0)
                          : "ic_completed".imageIcon(width: 16.0, height: 16.0),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          status == 0
                              ? (_totalDuration.toLowerCase().contains('no')
                                  ? _totalDuration
                                  : _appointmentType == 3
                                      ? 'Your provider is $_totalDuration'
                                      : 'Your provider’s office is $_totalDuration minutes away. '
                                          'Let us know when you are on your way.')
                              : status == 1
                                  ? "Started driving"
                                  : status == 2
                                      ? "You have Arrived."
                                      : status == 3
                                          ? "Treatment started"
                                          : status == 4
                                              ? "Provider Treatment Completed"
                                              : status == 5
                                                  ? "Treatment Completed"
                                                  : (_totalDuration
                                                          .contains('no')
                                                      ? _totalDuration
                                                      : _appointmentType == 3
                                                          ? 'Your provider is $_totalDuration'
                                                          : 'Your provider’s office is $_totalDuration minutes away. '
                                                              'Let us know when you are on your way.'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 42.0,
                        height: 42.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: avatar == null
                                ? AssetImage('images/profile_user.png')
                                : NetworkImage(ApiBaseHelper.imageUrl + avatar),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(21.0)),
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Text(
                                "$professionalTitle \u2022 $appointmentType",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.70),
                                ),
                              ),
                              SizedBox(height: 7.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      address,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                timingWidget(response),
                _appointmentType == 3
                    ? _onsiteButton(response)
                    : (response[_trackStatusKey]["status"] == 2 ||
                            response[_trackStatusKey]["status"] == 3
                        ? Container()
                        : _button(
                            response,
                          )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _button(dynamic response) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FancyButton(
        title: response[_trackStatusKey]["status"] == 0 ||
                response[_trackStatusKey]["status"] == null
            ? "Start Driving"
            : response[_trackStatusKey]["status"] == 1
                ? "Arrived"
                : response[_trackStatusKey]["status"] == 2 ||
                        response[_trackStatusKey]["status"] == 3 ||
                        response[_trackStatusKey]["status"] == 4
                    ? "Confirm Treatment End"
                    : response[_trackStatusKey]["status"] == 5
                        ? "Treatment Summary"
                        : "Start Driving",
        onPressed: () {
          int status = response[_trackStatusKey]["status"] ?? 0;
          switch (status) {
            case 0:
              changeRequestStatus(
                  _container.appointmentIdMap["appointmentId"], "1");

              IsolateNameServer.registerPortWithName(
                  port.sendPort, _isolateName);

              port.listen((dynamic data) {
                LocationDto lastLocation = data;

                if (mounted) {
                  setState(() {
                    _initialPosition = LatLng(
                      lastLocation.latitude,
                      lastLocation.longitude,
                    );
                  });
                }

                updatePinOnMap(LatLng(
                  lastLocation.latitude,
                  lastLocation.longitude,
                ));

                updateAppointmentCoordinates(LatLng(
                  lastLocation.latitude,
                  lastLocation.longitude,
                ));
              });

              initPlatformState();
              startLocationService();

              Widgets.showToast("You started driving");

              break;
            case 1:
              changeRequestStatus(
                  _container.appointmentIdMap["appointmentId"], "2");

              IsolateNameServer.removePortNameMapping(_isolateName);
              BackgroundLocator.unRegisterLocationUpdate();

              break;
            case 4:
              showConfirmTreatmentDialog();
              break;
            case 5:
              Map _map = {};
              _map['id'] = _container.appointmentIdMap["appointmentId"];
              _map['appointmentType'] = _appointmentType;
              _map['latLng'] = _userLocation;

              Navigator.of(context).pushNamed(
                Routes.treatmentSummaryScreen,
                arguments: _map,
              );
              break;
          }
        },
        buttonHeight: 55,
      ),
    );
  }

  Widget _onsiteButton(dynamic response) {
    return response[TRACK_STATUS_PROVIDER]["status"] == null ||
            response[TRACK_STATUS_PROVIDER]["status"] != 4
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: FancyButton(
              buttonHeight: 55,
              title: response[TRACK_STATUS_PROVIDER]["status"] == 5
                  ? "Treatment Summary"
                  : "Confirm Treatment End",
              onPressed: () {
                int status = response[TRACK_STATUS_PROVIDER]["status"] ?? 0;
                switch (status) {
                  case 4:
                    showConfirmTreatmentDialog();
                    break;
                  case 5:
                    Map _map = {};
                    _map['id'] = _container.appointmentIdMap["appointmentId"];
                    _map['appointmentType'] = _appointmentType;
                    _map['latLng'] = _userLocation;

                    Navigator.of(context).pushNamed(
                      Routes.treatmentSummaryScreen,
                      arguments: _map,
                    );
                    break;
                }
              },
            ),
          );
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  void startLocationService() {
    BackgroundLocator.registerLocationUpdate(
      callback,
      settings: LocationSettings(
        notificationTitle: "Start Location Tracking",
        notificationMsg: "Track location in background",
        wakeLockTime: 20,
        autoStop: false,
        interval: 5,
      ),
    );
  }

  void showPinsOnMap(LatLng _initialPosition) {
    var pinPosition =
        LatLng(_initialPosition.latitude, _initialPosition.longitude);

    var destPosition = LatLng(_desPosition.latitude, _desPosition.longitude);

    sourcePinInfo = PinInformation(
      locationName: "Start Location",
      location: _initialPosition,
      pinPath: "images/ic_initial_marker.png",
    );

    destinationPinInfo = PinInformation(
      locationName: "End Location",
      location: _desPosition,
      pinPath: "images/ic_destination_marker.png",
    );

    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
          });
        },
        icon: sourceIcon));

    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
          });
        },
        icon: destinationIcon));

    setPolylines(_initialPosition, _desPosition);
  }

  Widget timingWidget(Map response) {
    return Column(
      children: <Widget>[
        divider(),
        response[_trackStatusKey][_startDrivingStatusKey] == null
            ? Container()
            : timingSubWidget(
                _appointmentType == 3
                    ? 'Provider Started Driving'
                    : "Started Driving",
                response[_trackStatusKey][_startDrivingStatusKey] != null
                    ? response[_trackStatusKey][_startDrivingStatusKey]
                        .toString()
                        .formatDate(dateFormat: Strings.dateTimePattern)
                    : "---",
                false),
        response[_trackStatusKey][_arrivedStatusKey] == null
            ? Container()
            : divider(),
        response[_trackStatusKey][_arrivedStatusKey] == null
            ? Container()
            : timingSubWidget(
                _appointmentType == 3 ? 'Provider Arrived' : "Arrived",
                response[_trackStatusKey][_arrivedStatusKey] != null
                    ? response[_trackStatusKey][_arrivedStatusKey]
                        .toString()
                        .formatDate(dateFormat: Strings.dateTimePattern)
                    : "---",
                false),
        response[_trackStatusKey]["treatmentStarted"] == null
            ? Container()
            : divider(),
        response[_trackStatusKey]["treatmentStarted"] == null
            ? Container()
            : timingSubWidget(
                "Treatment Started",
                response[_trackStatusKey]["treatmentStarted"] != null
                    ? response[_trackStatusKey]["treatmentStarted"]
                        .toString()
                        .formatDate(dateFormat: Strings.dateTimePattern)
                    : "---",
                false),
        response[_trackStatusKey]["providerTreatmentEnded"] == null
            ? Container()
            : divider(),
        response[_trackStatusKey]["providerTreatmentEnded"] == null
            ? Container()
            : timingSubWidget(
                "Provider Treatment Completed",
                response[_trackStatusKey]["providerTreatmentEnded"] != null
                    ? response[_trackStatusKey]["providerTreatmentEnded"]
                        .toString()
                        .formatDate(dateFormat: Strings.dateTimePattern)
                    : "---",
                false,
              ),
        response[_trackStatusKey]["patientTreatmentEnded"] == null
            ? Container()
            : divider(),
        response[_trackStatusKey]["patientTreatmentEnded"] == null
            ? Container()
            : timingSubWidget(
                "Treatment Completed",
                response[_trackStatusKey]["patientTreatmentEnded"] != null
                    ? response[_trackStatusKey]["patientTreatmentEnded"]
                        .toString()
                        .formatDate(dateFormat: Strings.dateTimePattern)
                    : "---",
                true,
              ),
      ],
    );
  }

  Widget timingSubWidget(String title, String timing, bool isTreatCompleted) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
              ),
              Text(
                timing,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.windsor),
              ),
            ],
          ),
          isTreatCompleted ? SizedBox(height: 10) : Container(),
          isTreatCompleted
              ? Row(
                  children: <Widget>[
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Confirmed",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget divider({double topPadding}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 0.0),
      child: Divider(
        color: Colors.grey[100],
        thickness: 6.0,
      ),
    );
  }

  changeRequestStatus(String id, String status) {
    Map map = Map();
    map["trackingStatus.status"] = status;
    SharedPref().getToken().then((token) {
      api.appointmentTrackingStatus(token, map, id).then((value) {
        if (mounted) {
          setState(() {
            _profileFuture =
                api.getAppointmentDetails(token, id, _userLocation);
          });
          value.toString().debugLog();
        }
      }).futureError((error) {
        Widgets.showToast(error.toString());
        error.toString().debugLog();
      });
    });
  }

  onsiteChangeRequestStatus(String id, String status) {
    Map map = Map();
    map["trackingStatusProvider.status"] = status;
    SharedPref().getToken().then((token) {
      api.onsiteAppointmentTrackingStatus(token, map, id).then((value) {
        if (mounted) {
          setState(() {
            _profileFuture =
                api.getAppointmentDetails(token, id, _userLocation);
          });
          value.toString().debugLog();
        }
      }).futureError((error) {
        Widgets.showToast(error.toString());
        error.toString().debugLog();
      });
    });
  }

  updateAppointmentCoordinates(LatLng latLng) {
    Map map = Map();
    map["location.coordinates[0]"] = latLng.longitude.toString();
    map["location.coordinates[1]"] = latLng.latitude.toString();

    SharedPref().getToken().then((token) {
      api
          .updateAppointmentCoordinates(
              token, map, _container.appointmentIdMap["appointmentId"])
          .then((value) {
        value.toString().debugLog();
      }).futureError((error) {
        Widgets.showToast(error.toString());
        error.toString().debugLog();
      });
    });
  }

  void showConfirmTreatmentDialog() {
    showDialog(
      context: context,
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
                  "The treatment is complete",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Please select confirm to complete treatment.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 26),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          side:
                              BorderSide(width: 0.3, color: AppColors.windsor),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.windsor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          color: AppColors.windsor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();

                            if (_appointmentType == 3) {
                              onsiteChangeRequestStatus(
                                  _container.appointmentIdMap["appointmentId"],
                                  "5");
                            } else {
                              changeRequestStatus(
                                  _container.appointmentIdMap["appointmentId"],
                                  "5");
                            }

                            Navigator.of(context).pushNamed(
                              Routes.appointmentCompleteConfirmation,
                              arguments: appointmentCompleteMap,
                            );
                          }),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
