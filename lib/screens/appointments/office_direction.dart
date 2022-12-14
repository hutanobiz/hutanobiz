import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/chat/models/chat_data_model.dart';
import 'package:hutano/screens/chat/socket_class.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/pin_info.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:location/location.dart' as Loc;

const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class OfficeDirectionScreen extends StatefulWidget {
  const OfficeDirectionScreen({Key? key, this.trackOfficeModel})
      : super(key: key);

  final dynamic trackOfficeModel;

  @override
  _OfficeDirectionScreenState createState() => _OfficeDirectionScreenState();
}

class _OfficeDirectionScreenState extends State<OfficeDirectionScreen> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> _polyLineLatlngList = [];
  LatLng? _initialPosition;
  LatLng? currentPosition;
  LatLng _desPosition = LatLng(0, 0);

  late GoogleMapController _googleMapController;
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  ApiBaseHelper api = ApiBaseHelper();
  String _totalDistance = "";
  String _totalDuration = "";
  Map<String, String> appointmentCompleteMap = Map();
  TextEditingController textEditingController = TextEditingController();
  PinInformation? currentlySelectedPin = PinInformation(
    pinPath: '',
    avatarPath: '',
    location: LatLng(0, 0),
  );

  PinInformation? sourcePinInfo, destinationPinInfo;
  CameraPosition? initialCameraPosition;

  Loc.LocationData? destinationLocation;
  Loc.Location location = Loc.Location();

  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();

  setPolylines() async {
    PolylineResult polylineResult = await polylinePoints
        .getRouteBetweenCoordinates(
          Strings.kGoogleApiKey,
          PointLatLng(_initialPosition!.latitude, _initialPosition!.longitude),
          PointLatLng(_desPosition.latitude, _desPosition.longitude),
        )
        .catchError((error) => error.toString().debugLog());

    List<PointLatLng> result = polylineResult.points;
    _polyLineLatlngList.clear();
    _polyline.clear();
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
    setSourceAndDestinationIcons();
    setInitialLocation();
  }

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _googleMapController = controller;
      setPolylines().then((_) => _setMapFitToTour(_polyline));
    });
  }

  Future<void> _setMapFitToTour(Set<Polyline> p) async {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;

    p.forEach((poly) {
      poly.points.forEach((point) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      });
    });
    _googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        20));
  }

  void setInitialLocation() async {
    await location.getLocation().then((Loc.LocationData value) {
      setState(() {
        _initialPosition = LatLng(value.latitude!, value.longitude!);
        currentPosition = LatLng(value.latitude!, value.longitude!);
      });

      showPinsOnMap();
      updateAppointmentCoordinates(LatLng(
        _initialPosition!.latitude,
        _initialPosition!.longitude,
      ));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosition != null) {
      api
          .getDistanceAndTime(
              currentPosition!, _desPosition, Strings.kGoogleApiKey)
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
          _totalDuration = "NO duration available";
          _totalDistance = "NO distance available";
        });
        error.toString().debugLog();
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: "Track Appointment",
        color: AppColors.snow,
        isAddBack: false,
        addHeader: true,
        padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: widgetList(widget.trackOfficeModel),
        ),
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {}

  void setSourceAndDestinationIcons() async {
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_initial_marker.png");
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_destination_marker.png");
  }

  Widget widgetList(dynamic appointment) {
    String address = '---';
    LatLng latLng = new LatLng(0, 0);
    address = Extensions.addressFormat(
      appointment['data']["doctorAddress"]["address"]?.toString(),
      appointment['data']["doctorAddress"]["street"]?.toString(),
      appointment['data']["doctorAddress"]["city"]?.toString(),
      appointment['data']["doctorAddress"]["state"],
      appointment['data']["doctorAddress"]["zipCode"]?.toString(),
    );

    if (appointment['data']["doctorAddress"]["coordinates"] != null) {
      List location = appointment['data']["doctorAddress"]["coordinates"];

      if (location.length > 0) {
        latLng = LatLng(
          double.parse(location[1].toString()),
          double.parse(location[0].toString()),
        );
      }
    }
    if (appointment['data']['doctorAddress'] != null) {
      if (appointment['data']['doctorAddress']['coordinates'] != null) {
        List location = appointment['data']['doctorAddress']['coordinates'];

        if (location.length > 0) {
          _desPosition = LatLng(31.34, 76.68
              // todo lat
              // double.parse(location[1].toString()),
              // double.parse(location[0].toString()),
              );
        }
      }
    }
    return _initialPosition == null
        ? Container()
        : Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                child: ClipRRect(
                  child: GoogleMap(
                    myLocationEnabled: true,
                    compassEnabled: true,
                    tiltGesturesEnabled: false,
                    markers: _markers,
                    polylines: _polyline,
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition!,
                      zoom: 13.0,
                    ),
                    onCameraMove: _onCameraMove,
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
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(14.0),
                        ),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.0),
                          FlatButton(
                            padding: const EdgeInsets.all(0.0),
                            onPressed: () => latLng.launchMaps(),
                            child: Text(
                              "Get Directions",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.windsor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(14.0),
                        ),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: textEditingController,
                              textAlignVertical: TextAlignVertical.top,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "Quick message",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, right: 2, left: 2, top: 4),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.goldenTainoi,
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (textEditingController.text != '') {
                                    sendChatMessage();
                                    textEditingController.clear();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
            ],
          );
  }

  void showPinsOnMap() {
    var pinPosition =
        LatLng(_initialPosition!.latitude, _initialPosition!.longitude);

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
  }

  updateAppointmentCoordinates(LatLng latLng) {
    Map map = Map();
    map["location.coordinates[0]"] = latLng.longitude.toString();
    map["location.coordinates[1]"] = latLng.latitude.toString();

    SharedPref().getToken().then((token) {
      api
          .updateAppointmentCoordinates(
              token, map, widget.trackOfficeModel['data']['_id'])
          .then((value) {
        value.toString().debugLog();
      }).futureError((error) {
        Widgets.showToast(error.toString());
        error.toString().debugLog();
      });
    });
  }

  sendChatMessage() {
    sendMessage(Message(
        sender: widget.trackOfficeModel['data']['user']['_id'],
        receiver: widget.trackOfficeModel['data']['doctor']['_id'],
        message: textEditingController.text,
        appointmentId: widget.trackOfficeModel['data']['_id']));
  }

  sendMessage(Message message) {
    SocketClass().sendMessage(message);
  }
}
