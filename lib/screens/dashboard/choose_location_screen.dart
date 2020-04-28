import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/fancy_button.dart';

const kGoogleApiKey = "AIzaSyAkq7DnUBTkddWXddoHAX02Srw6570ktx8";
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class ChooseLocationScreen extends StatefulWidget {
  ChooseLocationScreen({Key key, @required this.latLng}) : super(key: key);

  final LatLng latLng;

  @override
  _ChooseLocationScreenState createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _addressController = TextEditingController();
  CameraPosition _myLocation;
  GoogleMapController controller;

  @override
  void initState() {
    super.initState();

    _myLocation = CameraPosition(
      target: LatLng(widget.latLng.latitude, widget.latLng.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Stack(children: <Widget>[
                        GoogleMap(
                          initialCameraPosition: _myLocation,
                          onMapCreated: _onMapCreated,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          onCameraMove: (position) {
                            _myLocation = position;
                          },
                          onCameraIdle: () {
                            getLocationAddress(
                              _myLocation.target.latitude,
                              _myLocation.target.longitude,
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.place,
                            color: Colors.red,
                            size: 48.0,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.snow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Set Your Location",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              _handlePressButton();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: 12, top: 8, bottom: 8, left: 4),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  border: Border.all(color: Colors.grey[300])),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 32,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      textAlign: TextAlign.justify,
                                      enabled: false,
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      controller: _addressController,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(color: Colors.grey[300]),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8.0),
                    child: FancyButton(
                        buttonHeight: 55.0,
                        title: "Submit",
                        buttonColor: AppColors.goldenTainoi,
                        onPressed: () {
                          Navigator.pop(context, _myLocation.target);
                        }),
                  ),
                ],
              ),
              InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  getLocationAddress(latitude, longitude) async {
    try {
    final coordinates = new Coordinates(latitude,longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first.addressLine;
    _addressController.text = first;
    return first;
    } on PlatformException catch (e) {
      print(e.message.toString() ?? e.toString());
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    if ([_myLocation] != null) {
      LatLng position = _myLocation.target;
      setState(() {});

      Future.delayed(Duration(seconds: 0), () async {
        controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0,
            ),
          ),
        );
      });
    }
  }

  Future<void> _handlePressButton() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.fullscreen,
        language: "en");
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      _myLocation = CameraPosition(
        bearing: 0,
        target: LatLng(lat, lng),
        zoom: 17.0,
      );
      controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        _myLocation,
      ));
      getLocationAddress(
          _myLocation.target.latitude, _myLocation.target.longitude);
    }
  }
}
