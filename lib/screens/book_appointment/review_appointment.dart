import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class ReviewAppointmentScreen extends StatefulWidget {
  @override
  _ReviewAppointmentScreenState createState() =>
      _ReviewAppointmentScreenState();
}

class _ReviewAppointmentScreenState extends State<ReviewAppointmentScreen> {
  InheritedContainerState _container;
  Map _appointmentData;
  Map _providerData, _userLocationMap;
  bool _isLoading = false;
  String _timeHours, _timeMins;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> latlng = [];
  LatLng _initialPosition, _middlePoint;
  LatLng _news;
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  double _totalDistance = 0;

  setPolylines() async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
      "AIzaSyAkq7DnUBTkddWXddoHAX02Srw6570ktx8",
      _initialPosition.latitude,
      _initialPosition.longitude,
      _news.latitude,
      _news.longitude,
    );

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

    _initialPosition = _userLocationMap["latLng"];
    _news = LatLng(
        _providerData["providerData"]["businessLocation"]["coordinates"][1],
        _providerData["providerData"]["businessLocation"]["coordinates"][0]);

    _middlePoint = LatLng((_initialPosition.latitude + _news.latitude) / 2,
        (_initialPosition.longitude + _news.longitude) / 2);
    _getUserLocation();

    String bookedTime = _appointmentData["time"];

    if (bookedTime.length < 4) {
      if (bookedTime[0] != "0") {
        bookedTime = bookedTime.substring(0, 2) + "0" + bookedTime.substring(2);
      } else {
        bookedTime = "0" + bookedTime;
      }
    }
    _timeHours = bookedTime.substring(0, 2);
    _timeMins = bookedTime.substring(2, 4);
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_initial_marker.png");
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_destination_marker.png");
  }

  void _getUserLocation() async {
    await Geolocator()
        .distanceBetween(
      _initialPosition.latitude,
      _initialPosition.longitude,
      _news.latitude,
      _news.longitude,
    )
        .then((distance) {
      setState(() {
        _totalDistance = distance;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Review Appointment",
        color: AppColors.snow,
        isLoading: _isLoading,
        isAddBack: false,
        addBackButton: true,
        buttonColor: AppColors.windsor,
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgetList(),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                width: MediaQuery.of(context).size.width - 76.0,
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: FancyButton(
                  title: "Send Office Request",
                  buttonIcon: "ic_send_request",
                  buttonColor: AppColors.windsor,
                  onPressed: () {
                    _loading(true);

                    String doctorId = _providerData["providerData"]["userId"]
                            ["_id"]
                        .toString();

                    String startTime = _timeHours + ":" + _timeMins;

                    String endTime = (int.parse(_timeHours) + 1).toString() +
                        ":" +
                        _timeMins;

                    Map appointmentData = Map();

                    appointmentData["type"] =
                        _container.getProjectsResponse()["serviceType"];
                    appointmentData["date"] = DateFormat("MM/dd/yyyy")
                        .format(_appointmentData["date"])
                        .toString();

                    appointmentData["fromTime"] = startTime;
                    appointmentData["toTime"] = endTime;
                    appointmentData["doctor"] = doctorId;

                    SharedPref().getToken().then((String token) {
                      debugPrint(token, wrapWidth: 1024);

                      ApiBaseHelper api = ApiBaseHelper();

                      api
                          .bookAppointment(token, appointmentData)
                          .then((response) {
                        _loading(false);

                        Widgets.showToast("Booking request sent successfully!");
                      }).catchError((error) {
                        _loading(false);
                        debugPrint(error.toString(), wrapWidth: 1024);
                      });
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        onForwardTap: () {},
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = new List();

    formWidget.add(Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: ProviderWidget(
        data: _providerData["providerData"],
        degree: _providerData["degree"].toString(),
        isOptionsShow: false,
      ),
    ));

    formWidget.add(SizedBox(height: 30.0));

    formWidget.add(container(
        "Date & Time",
        "${DateFormat('EEEE, dd MMMM').format(_appointmentData['date']).toString()} " +
            TimeOfDay(hour: int.parse(_timeHours), minute: int.parse(_timeMins))
                .format(context),
        "ic_calendar"));

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(container(
        "Office Address",
        _providerData["providerData"]['businessLocation']['address'] ?? "---",
        "ic_office_address"));

    SizedBox(height: 6.0);

    formWidget.add(_initialPosition == null
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
                    initialCameraPosition: CameraPosition(
                      target: _middlePoint,
                    ),
                    polylines: _polyline,
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        setPolylines();

                        _controller.complete(controller);

                        _markers.add(Marker(
                          markerId: MarkerId(_initialPosition.toString()),
                          position: _initialPosition,
                          icon: sourceIcon,
                        ));

                        _markers.add(Marker(
                          markerId: MarkerId(_news.toString()),
                          position: _news,
                          icon: destinationIcon,
                        ));
                      });
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
                          "${(((_totalDistance * 0.000621371) / 30) * 60).toStringAsFixed(1)} mins",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${(_totalDistance * 0.000621371).toStringAsFixed(1)} miles away",
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

    return formWidget;
  }

  Widget container(String heading, String subtitle, String icon) {
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
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              icon.imageIcon(),
              SizedBox(width: 8.0),
              Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _loading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }
}
