// import 'dart:async';
// import 'dart:isolate';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hutano/apis/api_helper.dart';
// import 'package:hutano/colors.dart';
// import 'package:hutano/routes.dart';
// import 'package:hutano/screens/dashboard/choose_location_screen.dart';
// import 'package:hutano/strings.dart';
// import 'package:hutano/utils/extensions.dart';
// import 'package:hutano/utils/pin_info.dart';
// import 'package:hutano/utils/shared_prefrences.dart';
// import 'package:hutano/widgets/custom_loader.dart';
// import 'package:hutano/widgets/fancy_button.dart';
// import 'package:hutano/widgets/inherited_widget.dart';
// import 'package:hutano/widgets/loading_background_new.dart';
// import 'package:hutano/widgets/widgets.dart';
// import 'package:location/location.dart';

// const double CAMERA_ZOOM = 16;
// const double CAMERA_TILT = 80;
// const double CAMERA_BEARING = 30;
// const TRACK_STATUS = 'trackingStatus';
// const PATIENT_START_DRIVING = 'patientStartDriving';
// const PATIENT_ARRIVED = 'patientArrived';

// class TrackTreatmentScreen extends StatefulWidget {
//   const TrackTreatmentScreen({Key key, this.appointmentId}) : super(key: key);

//   final String appointmentId;

//   @override
//   _TrackTreatmentScreenState createState() => _TrackTreatmentScreenState();
// }

// class _TrackTreatmentScreenState extends State<TrackTreatmentScreen> {
//   Future<dynamic> _profileFuture;

//   bool _isLoading = false;=

//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polyline = {};

//   PolylinePoints polylinePoints = PolylinePoints();

//   List<LatLng> _polyLineLatlngList = [];
//   LatLng _initialPosition;
//   LatLng _desPosition = LatLng(0, 0);
//   Completer<GoogleMapController> _controller = Completer();
//   BitmapDescriptor sourceIcon;
//   BitmapDescriptor destinationIcon;
//   ApiBaseHelper api = ApiBaseHelper();

//   PinInformation currentlySelectedPin = PinInformation(
//     pinPath: '',
//     avatarPath: '',
//     location: LatLng(0, 0),
//   );

//   PinInformation sourcePinInfo, destinationPinInfo;
//   CameraPosition initialCameraPosition;

//   LocationData destinationLocation;
//   Location location = Location();

//   static const String _isolateName = "LocatorIsolate";
//   ReceivePort port = ReceivePort();
//   var _userLocation = LatLng(0.00, 0.00);


//   setPolylines(LatLng _initialPosition, LatLng _desPosition) async {
//     PolylineResult polylineResult = await polylinePoints
//         .getRouteBetweenCoordinates(
//           Strings.kGoogleApiKey,
//           PointLatLng(_initialPosition.latitude, _initialPosition.longitude),
//           PointLatLng(_desPosition.latitude, _desPosition.longitude),
//         )
//         .catchError((error) => error.toString().debugLog());

//     List<PointLatLng> result = polylineResult.points;

//     if (result.isNotEmpty) {
//       result.forEach((PointLatLng point) {
//         _polyLineLatlngList.add(LatLng(point.latitude, point.longitude));
//       });
//     }

//     if (mounted) {
//       setState(() {
//         _polyline.add(
//           Polyline(
//             polylineId: PolylineId(_initialPosition.toString()),
//             color: AppColors.windsor,
//             points: _polyLineLatlngList,
//             width: 5,
//             startCap: Cap.roundCap,
//             endCap: Cap.roundCap,
//           ),
//         );
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     // _appointmentType = widget.appointmentType;

//     setSourceAndDestinationIcons();
//     setInitialLocation();
//   }

//   void updatePinOnMap(LatLng latLng) async {
//     if (mounted) {
//       CameraPosition cPosition = CameraPosition(
//         zoom: CAMERA_ZOOM,
//         tilt: CAMERA_TILT,
//         bearing: CAMERA_BEARING,
//         target: latLng,
//       );

//       GoogleMapController controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

//       setState(() {
//         var pinPosition = LatLng(latLng.latitude, latLng.longitude);

//         sourcePinInfo.location = pinPosition;

//         _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
//         _markers.add(Marker(
//           markerId: MarkerId('sourcePin'),
//           onTap: () {
//             setState(() {
//               currentlySelectedPin = sourcePinInfo;
//             });
//           },
//           position: pinPosition,
//           icon: sourceIcon,
//         ));

//         _polyLineLatlngList.clear();
//         _polyline.clear();

//         setPolylines(latLng, _desPosition);
//       });
//     }
//   }

//   void setInitialLocation() async {
//     await location.getLocation().then((LocationData value) {
//       setState(() {
//         _initialPosition = LatLng(value.latitude, value.longitude);
//       });
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     _userLocation = LatLng(0.00, 0.00);

//     SharedPref().getToken().then((token) {
//       setState(() {
//         _profileFuture = api.getAppointmentDetails(
//           token,
//           widget.appointmentId,
//           _userLocation,
//         );
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_initialPosition != null) {
//       initialCameraPosition = CameraPosition(
//         target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
//         zoom: CAMERA_ZOOM,
//         tilt: CAMERA_TILT,
//         bearing: CAMERA_BEARING,
//       );
//     }

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: AppColors.goldenTainoi,
//       body: LoadingBackgroundNew(
//         addHeader: true,
//         title: "Appointment Status",
//         isLoading: _isLoading,
//         isAddBack: true,
//         addBackButton: false,
//         color: Colors.white,
//         padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           child: FutureBuilder(
//             future: _profileFuture,
//             builder: (context, snapshot) {
//               if (_initialPosition != null) {
//                 api
//                     .getDistanceAndTime(
//                         _initialPosition, _desPosition, Strings.kGoogleApiKey)
//                     .then((value) {
//                   _totalDistance = value["rows"][0]["elements"][0]["distance"]
//                           ["text"]
//                       .toString();
//                   _totalDuration = value["rows"][0]["elements"][0]["duration"]
//                           ["text"]
//                       .toString();
//                   ("DISTANCE AND TIME: " +
//                           value["rows"][0]["elements"][0].toString())
//                       .toString()
//                       .debugLog();
//                 }).futureError((error) {
//                   setState(() {
//                     _totalDuration = "NO duration available";
//                     _totalDistance = "NO distance available";
//                   });
//                   error.toString().debugLog();
//                 });
//               }

//               if (snapshot.hasData) {
//                 return widgetList(snapshot.data);
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}");
//               }

//               return Center(
//                 child: CustomLoader(),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void setSourceAndDestinationIcons() async {
//     sourceIcon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 2.5),
//         "images/ic_initial_marker.png");
//     destinationIcon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 2.5),
//         "images/ic_destination_marker.png");
//   }

//   Widget widgetList(Map appointment) {
//     Map response = appointment["data"];   

//     if (appointment["doctorData"] != null) {
//       for (dynamic detail in appointment["doctorData"]) {
       

//         if (detail["businessLocation"] != null) {
//           dynamic business = detail["businessLocation"];

          
//         }
//       }
//     }

//     if (appointment["doctorData"] != null) {
//       for (dynamic detail in appointment["doctorData"]) {
//         if (detail["businessLocation"] != null) {
//           if (detail["businessLocation"]["coordinates"] != null) {
//             List location = detail["businessLocation"]["coordinates"];

//             if (location.length > 0) {
//               _desPosition = LatLng(
//                 double.parse(location[1].toString()),
//                 double.parse(location[0].toString()),
//               );
//             }
//           }
//         }
//       }
//     }

   

//     return Stack(
//       children: <Widget>[
//         _initialPosition == null
//             ? Container()
//             : Stack(
//                 children: <Widget>[
//                   Container(
//                     height: MediaQuery.of(context).size.height - 250,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(14.0),
//                       child: GoogleMap(
//                         myLocationEnabled: false,
//                         compassEnabled: false,
//                         rotateGesturesEnabled: false,
//                         initialCameraPosition: initialCameraPosition,
//                         polylines: _polyline,
//                         markers: _markers,
//                         onMapCreated: (GoogleMapController controller) {
//                           _controller.complete(controller);

//                           setState(() {
//                             showPinsOnMap(_initialPosition);
//                           });
//                         },
//                       ),
//                     ),
//                   ),
                 
//                 ],
//               ),
      
//       ],
//     );
//   }

//   Widget _button(dynamic response) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: FancyButton(
//         title: "Start Driving",
//         onPressed: () {
//           int status = response[_trackStatusKey]["status"] ?? 0;
//           switch (status) {
//             case 0:

//               IsolateNameServer.registerPortWithName(
//                   port.sendPort, _isolateName);

//               port.listen((dynamic data) {
//                 LocationDto lastLocation = data;

//                 if (mounted) {
//                   setState(() {
//                     _initialPosition = LatLng(
//                       lastLocation.latitude,
//                       lastLocation.longitude,
//                     );
//                   });
//                 }

//                 updatePinOnMap(LatLng(
//                   lastLocation.latitude,
//                   lastLocation.longitude,
//                 ));

//                 updateAppointmentCoordinates(LatLng(
//                   lastLocation.latitude,
//                   lastLocation.longitude,
//                 ));
//               });


//               Widgets.showToast("You started driving");

//               break;
//             case 1:
//               changeRequestStatus(widget.appointmentId, "2");
//               IsolateNameServer.removePortNameMapping(_isolateName);
//               break;
          
//           }
//         },
//         buttonHeight: 55,
//       ),
//     );
//   }

 

//   static void callback(LocationDto locationDto) async {
//     final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
//     send?.send(locationDto);
//   }


//   void showPinsOnMap(LatLng _initialPosition) {
//     var pinPosition =
//         LatLng(_initialPosition.latitude, _initialPosition.longitude);

//     var destPosition = LatLng(_desPosition.latitude, _desPosition.longitude);

//     sourcePinInfo = PinInformation(
//       locationName: "Start Location",
//       location: _initialPosition,
//       pinPath: "images/ic_initial_marker.png",
//     );

//     destinationPinInfo = PinInformation(
//       locationName: "End Location",
//       location: _desPosition,
//       pinPath: "images/ic_destination_marker.png",
//     );

//     _markers.add(Marker(
//         markerId: MarkerId('sourcePin'),
//         position: pinPosition,
//         onTap: () {
//           setState(() {
//             currentlySelectedPin = sourcePinInfo;
//           });
//         },
//         icon: sourceIcon));

//     _markers.add(Marker(
//         markerId: MarkerId('destPin'),
//         position: destPosition,
//         onTap: () {
//           setState(() {
//             currentlySelectedPin = destinationPinInfo;
//           });
//         },
//         icon: destinationIcon));
//     setPolylines(_initialPosition, _desPosition);
//   }
// }
