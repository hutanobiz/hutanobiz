import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'dart:math' as math;
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
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
import 'package:hutano/widgets/circular_countdown_timer.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/simple_timer_text.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const TRACK_STATUS = 'trackingStatus';
const PATIENT_START_DRIVING = 'patientStartDriving';
const PATIENT_ARRIVED = 'patientArrived';

class OfficeTrackTreatmentScreen extends StatefulWidget {
  const OfficeTrackTreatmentScreen({Key key, this.appointmentType = 0})
      : super(key: key);

  final int appointmentType;

  @override
  _OfficeTrackTreatmentScreenState createState() =>
      _OfficeTrackTreatmentScreenState();
}

class _OfficeTrackTreatmentScreenState extends State<OfficeTrackTreatmentScreen>
    with SingleTickerProviderStateMixin {
  Future<dynamic> _profileFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  InheritedContainerState _container;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  PolylinePoints polylinePoints = PolylinePoints();
  CountDownController _countDownController = CountDownController();
  SimpleCountDownController _simpleCountDownController = SimpleCountDownController();

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
  final TextEditingController _quickMessageController = TextEditingController();
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
  AnimationController _animationcontroller;
  String _trackStatusKey = TRACK_STATUS;
  String _startDrivingStatusKey = PATIENT_START_DRIVING;
  String _arrivedStatusKey = PATIENT_ARRIVED;
  Map typeMap = Map();
  var _userLocation = LatLng(0.00, 0.00);
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

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
    _trackStatusKey = TRACK_STATUS;
    _startDrivingStatusKey = PATIENT_START_DRIVING;
    _arrivedStatusKey = PATIENT_ARRIVED;

    typeMap['1'] = "At the provider's office";
    typeMap['2'] = 'Virtually by telemedicine';
    typeMap['3'] = 'In your home or office';

    setSourceAndDestinationIcons();
    setInitialLocation();
    _animationcontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  void onEnd() {
    print('onEnd');
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
      _userLocation =
          _container.userLocationMap['latLng'] ?? LatLng(0.00, 0.00);
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
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Office",
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

  String practicingSince = '';
  Widget widgetList(Map appointment) {
    Map response = appointment["data"];
    Map doctorData = appointment['doctorData'][0];
    var appointmentTime = DateTime.parse(response['date']).toLocal();

    practicingSince = doctorData["practicingSince"] != null
        ? ((DateTime.now()
                    .difference(DateTime.parse(doctorData["practicingSince"]))
                    .inDays /
                366))
            .toStringAsFixed(1)
        : "---";

    String name = "---",
        rating = "---",
        professionalTitle = "---",
        avatar,
        address = "---",
        appointmentType = "---",
        dateTime;

    appointmentType = response["type"] == 1
        ? "Office response"
        : response["type"] == 2
            ? "Video response"
            : "Onsite response";

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
      String title = response["doctor"]["title"]?.toString() ?? "";
      name = title + ' ' + response["doctor"]["fullName"]?.toString() ?? "---";
      avatar = response["doctor"]["avatar"];
    }

    appointmentCompleteMap["name"] = name;
    appointmentCompleteMap["address"] = address;
    appointmentCompleteMap["dateTime"] = dateTime;
    appointmentCompleteMap["type"] = response["type"].toString();

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

    return (status == 1 
    // &&
    //         appointmentTime.difference(DateTime.now()).inHours > 24
            )
        ? previousDayWidget(avatar, name, rating, professionalTitle, doctorData,
            response, address, appointmentTime)
        : (status == 0 || status == 1)
            ? Stack(
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
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);

                                    setState(() {
                                      showPinsOnMap(_initialPosition);
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(
                                  60.0, 33.0, 0.0, 0.0),
                              padding: const EdgeInsets.fromLTRB(
                                  5.0, 10.0, 5.0, 10.0),
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
                                  "ic_map_clock"
                                      .imageIcon(width: 30.0, height: 30.0),
                                  SizedBox(width: 5.0),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(14.0),
                          ),
                          border: Border.all(color: Colors.grey[300]),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Office Appointment',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Divider(color: Colors.grey[300]),
                            SizedBox(
                              height: 16,
                            ),
                            providerWidget(avatar, name, professionalTitle,
                                appointmentType, address),
                            SizedBox(
                              height: 18,
                            ),
                            CircularCountDownTimer(
                              // Countdown duration in Seconds
                              duration: appointmentTime
                                  .difference(DateTime.now())
                                  .inSeconds,

                              // Controller to control (i.e Pause, Resume, Restart) the Countdown
                              controller: _countDownController,

                              // Width of the Countdown Widget
                              width: 88,

                              // Height of the Countdown Widget
                              height: 88,

                              // Default Color for Countdown Timer
                              color: Colors.white,

                              // Filling Color for Countdown Timer
                              fillColor: AppColors.windsor,

                              // Background Color for Countdown Widget
                              backgroundColor: null,

                              // Border Thickness of the Countdown Circle
                              strokeWidth: 1.0,

                              // Begin and end contours with a flat edge and no extension
                              strokeCap: StrokeCap.butt,
                              bottomText: 'ETA',
                              bottomTextStyle: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),

                              // Text Style for Countdown Text
                              textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),

                              // true for reverse countdown (max to 0), false for forward countdown (0 to max)
                              isReverse: true,

                              // true for reverse animation, false for forward animation
                              isReverseAnimation: true,

                              // Optional [bool] to hide the [Text] in this widget.
                              isTimerTextShown: true,
                              isImage: false,

                              // Function which will execute when the Countdown Ends
                              onComplete: () {
                                // Here, do whatever you want
                                print('Countdown Ended');
                              },
                            ),

                            SizedBox(
                              height: 22,
                            ),

                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14.0),
                                  ),
                                  border: Border.all(color: Colors.grey[300]),
                                ),
                                height: 36,
                                child: Row(
                                  children: [
                                    SizedBox(width: 12),
                                    Icon(Icons.exit_to_app),
                                    SizedBox(width: 12),

                                    SimpleCountDownTimer(controller: _simpleCountDownController,duration: 1000, text: 'Your appointment starts in', ),
                                    // Text(
                                    //     'Your appointment starts in 00:20 min.'),
                                  ],
                                )),

                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: picker(_quickMessageController, "",
                                  'images/my_insurance.png', () {
                                mapBottomDialog(
                                    _quickMessageController, typeMap, 3);
                              }),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(14.0),
                                            ),
                                            border: Border.all(
                                                color: Colors.grey[300]),
                                          ),
                                          height: 55,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.exit_to_app),
                                              SizedBox(width: 6),
                                              Text('Reschedule'),
                                            ],
                                          ))),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: response[_trackStatusKey]
                                                ["status"] ==
                                            0
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(14.0),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey[300]),
                                            ),
                                            height: 55,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.exit_to_app),
                                                SizedBox(width: 6),
                                                Text('Start driving'),
                                              ],
                                            )).onClick(onTap: () {
                                            changeRequestStatus(
                                                _container.appointmentIdMap[
                                                    "appointmentId"],
                                                "1");

                                            IsolateNameServer
                                                .registerPortWithName(
                                                    port.sendPort,
                                                    _isolateName);

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

                                              updateAppointmentCoordinates(
                                                  LatLng(
                                                lastLocation.latitude,
                                                lastLocation.longitude,
                                              ));
                                            });

                                            initPlatformState();
                                            startLocationService();

                                            Widgets.showToast(
                                                "You started driving");
                                          })
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(14.0),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey[300]),
                                            ),
                                            height: 55,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.exit_to_app),
                                                SizedBox(width: 6),
                                                Text('Arrived'),
                                              ],
                                            )).onClick(onTap: () {
                                            changeRequestStatus(
                                                _container.appointmentIdMap[
                                                    "appointmentId"],
                                                "2");

                                            IsolateNameServer
                                                .removePortNameMapping(
                                                    _isolateName);
                                            BackgroundLocator
                                                .unRegisterLocationUpdate();
                                          }),
                                  ),
                                ],
                              ),
                            ),

                            // timingWidget(response),
                            // (response[_trackStatusKey]["status"] == 2 ||
                            //         response[_trackStatusKey]["status"] == 3
                            //     ? Container()
                            //     : _button(
                            //         response,
                            //       )),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            : status == 3 || status == 4 || status == 5
                ? ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: <Widget>[
                            status == 3
                                ? "ic_map_clock"
                                    .imageIcon(width: 16.0, height: 16.0)
                                : "ic_completed"
                                    .imageIcon(width: 16.0, height: 16.0),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(status == 3
                                  ? "Provider Started Treatment"
                                  : status == 4
                                      ? "Provider Treatment Completed"
                                      : "Treatment Completed"),
                            ),
                          ],
                        ),
                      ),
                      providerWidget(avatar, name, professionalTitle,
                          appointmentType, address),
                      timingWidget(response),
                      (response[_trackStatusKey]["status"] == 2 ||
                              response[_trackStatusKey]["status"] == 3
                          ? Container()
                          : _button(
                              response,
                            )),
                    ],
                  )
                : Stack(
                    children: <Widget>[
                      _initialPosition == null
                          ? Container()
                          : Stack(
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height - 250,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: GoogleMap(
                                      myLocationEnabled: false,
                                      compassEnabled: false,
                                      rotateGesturesEnabled: false,
                                      initialCameraPosition:
                                          initialCameraPosition,
                                      polylines: _polyline,
                                      markers: _markers,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);

                                        setState(() {
                                          showPinsOnMap(_initialPosition);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      60.0, 33.0, 0.0, 0.0),
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 10.0, 5.0, 10.0),
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
                                      "ic_map_clock"
                                          .imageIcon(width: 30.0, height: 30.0),
                                      SizedBox(width: 5.0),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                        ? "ic_map_clock".imageIcon(
                                            width: 16.0, height: 16.0)
                                        : "ic_completed".imageIcon(
                                            width: 16.0, height: 16.0),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        status == 0
                                            ? (_totalDuration
                                                    .toLowerCase()
                                                    .contains('no')
                                                ? _totalDuration
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
                                                                        .contains(
                                                                            'no')
                                                                    ? _totalDuration
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
                                              ? AssetImage(
                                                  'images/profile_user.png')
                                              : NetworkImage(
                                                  ApiBaseHelper.imageUrl +
                                                      avatar),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(21.0)),
                                        border: Border.all(
                                          color: Colors.grey[300],
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            // SizedBox(height: 3.0),
                                            // Text(
                                            //   "$professionalTitle \u2022 $appointmentType",
                                            //   style: TextStyle(
                                            //     fontSize: 12.0,
                                            //     fontWeight: FontWeight.w400,
                                            //     color: Colors.black.withOpacity(0.70),
                                            //   ),
                                            // ),
                                            SizedBox(height: 7.0),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    address,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black
                                                          .withOpacity(0.7),
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
                              (response[_trackStatusKey]["status"] == 2 ||
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

  Padding providerWidget(String avatar, String name, String professionalTitle,
      String appointmentType, String address) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
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
                  // SizedBox(height: 3.0),
                  // Text(
                  //   "$professionalTitle \u2022 $appointmentType",
                  //   style: TextStyle(
                  //     fontSize: 12.0,
                  //     fontWeight: FontWeight.w400,
                  //     color: Colors.black.withOpacity(0.70),
                  //   ),
                  // ),
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
    );
  }

  ListView previousDayWidget(
      String avatar,
      String name,
      String rating,
      String professionalTitle,
      Map doctorData,
      Map response,
      String address,
      DateTime appointmentTime) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 22.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 18, left: 12, right: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        splashColor: Colors.grey[200],
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.of(context).pushNamed(
                            Routes.providerImageScreen,
                            arguments: (ApiBaseHelper.imageUrl + avatar),
                          );
                        },
                        child: Container(
                          width: 58.0,
                          height: 58.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: avatar == null
                                  ? AssetImage('images/profile_user.png')
                                  : NetworkImage(
                                      ApiBaseHelper.imageUrl + avatar),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(50.0)),
                            border: new Border.all(
                              color: Colors.grey[300],
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(
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
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                                right: 5.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Image(
                                    image: AssetImage(
                                      "images/ic_experience.png",
                                    ),
                                    height: 14.0,
                                    width: 11.0,
                                  ),
                                  SizedBox(width: 3.0),
                                  Expanded(
                                    child: Text(
                                      practicingSince + " yrs experience",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    "ic_rating_golden"
                                        .imageIcon(width: 12, height: 12),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      rating ?? "0",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    '\u2022 ' + professionalTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                                right: 5.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  doctorData['isOfficeEnabled']
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: 'ic_provider_office'.imageIcon(
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      : Container(),
                                  doctorData['isVideoChatEnabled']
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: 'ic_provider_video'.imageIcon(
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      : Container(),
                                  doctorData['isOnsiteEnabled']
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: 'ic_provider_onsite'.imageIcon(
                                            width: 20,
                                            height: 20,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "\$${response['fees'].toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        'ic_forward'.imageIcon(
                          width: 9,
                          height: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, bottom: 18.0),
                child: Row(
                  children: <Widget>[
                    'ic_location_grey'.imageIcon(height: 14.0, width: 11.0),
                    SizedBox(width: 3.0),
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: <Widget>[
                          "ic_app_distance".imageIcon(),
                          SizedBox(width: 5.0),
                          Text(
                            _totalDistance == 'NO distance available'
                                ? '---'
                                : _totalDistance,
                            style: TextStyle(
                              color: AppColors.windsor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 22.0),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: Column(children: <Widget>[
            SizedBox(
              height: 32,
            ),
            Text(
              'Upcoming Office Appointment',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              DateFormat('EEEE, dd MMMM, HH:mm')
                  .format(appointmentTime)
                  .toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            CircularCountDownTimer(
              // Countdown duration in Seconds
              duration: appointmentTime.difference(DateTime.now()).inSeconds,

              // Controller to control (i.e Pause, Resume, Restart) the Countdown
              controller: _countDownController,

              // Width of the Countdown Widget
              width: 176,

              // Height of the Countdown Widget
              height: 176,

              // Default Color for Countdown Timer
              color: Colors.white,

              // Filling Color for Countdown Timer
              fillColor: AppColors.windsor,

              // Background Color for Countdown Widget
              backgroundColor: null,

              // Border Thickness of the Countdown Circle
              strokeWidth: 3.0,
              bottomText: 'ETA',
              // Begin and end contours with a flat edge and no extension
              strokeCap: StrokeCap.butt,

              // Text Style for Countdown Text
              textStyle: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),

              // true for reverse countdown (max to 0), false for forward countdown (0 to max)
              isReverse: true,

              // true for reverse animation, false for forward animation
              isReverseAnimation: true,

              // Optional [bool] to hide the [Text] in this widget.
              isTimerTextShown: true,

              // Function which will execute when the Countdown Ends
              onComplete: () {
                // Here, do whatever you want
                print('Countdown Ended');
              },
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(14.0),
                          ),
                          border: Border.all(color: Colors.grey[300]),
                        ),
                        height: 55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.exit_to_app),
                            SizedBox(width: 6),
                            Text('Exit'),
                          ],
                        ))),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(14.0),
                        ),
                        border: Border.all(color: Colors.grey[300]),
                      ),
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(width: 6),
                          Text('Reschedule'),
                        ],
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
          ]),
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

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  void startLocationService() {
    BackgroundLocator.registerLocationUpdate(
      callback,
      androidSettings: AndroidSettings(
        androidNotificationSettings: AndroidNotificationSettings(
          notificationTitle: "Start Location Tracking",
          notificationMsg: "Track location in background",
          //wakeLockTime: 20,
          //autoStop: false,
          //interval: 5,
        ),

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
                "Started Driving",
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
                "Arrived",
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
                            changeRequestStatus(
                                _container.appointmentIdMap["appointmentId"],
                                "5");

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

  Widget picker(final controller, String labelText, String image, onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey[300],
        onTap: () {
          FocusScope.of(context).unfocus();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: TextFormField(
            controller: controller,
            enabled: false,
            style: const TextStyle(fontSize: 14.0, color: Colors.black87),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Image.asset(image, height: 16),
              ),
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[400],
              ),
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void mapBottomDialog(controller, Map list, int value) {
    showModalBottomSheet(
        context: _scaffoldKey.currentContext,
        builder: (context) {
          return Container(
            height: list.length * 60.0,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                String key = list.keys.elementAt(index);
                return ListTile(
                  title: Center(
                    child: Text(
                      list[key],
                      style: TextStyle(
                          // color: key == value ? AppColors.neon_blue : Colors.black,
                          // fontSize: key == value ? 20.0 : 16.0,
                          ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      controller.text = list[key];

                      // selectedType = key;

                      Navigator.pop(context);
                    });
                  },
                );
              },
            ),
          );
        });
  }
}
