import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/fancy_button.dart';

const kGoogleApiKey = "AIzaSyC8Foj0EQFzLwUUHg2vWyD0-biDfb3Swpg";

class ChooseLocationScreen extends StatefulWidget {
  ChooseLocationScreen({Key key, @required this.latLng}) : super(key: key);

  final LatLng latLng;

  @override
  _ChooseLocationScreenState createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition cameraPosition;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onNavigateBack(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.goldenTainoi,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _handlePressButton();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    initialCameraPosition: _myLocation(),
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    compassEnabled: false,
                    rotateGesturesEnabled: false,
                    onCameraMove: (CameraPosition position) =>
                        cameraPosition = position,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.place,
                      color: Colors.red,
                      size: 48.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FancyButton(
                buttonHeight: 60.0,
                title: "Submit",
                buttonColor: AppColors.goldenTainoi,
                onPressed: () => onNavigateBack(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onNavigateBack(BuildContext context) =>
      Navigator.pop(context, cameraPosition.target);

  CameraPosition _myLocation() {
    cameraPosition = CameraPosition(
      target: LatLng(widget.latLng.latitude, widget.latLng.longitude),
      zoom: 17.0,
    );
    return cameraPosition;
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    if ([_myLocation()] != null) {
      LatLng position = _myLocation().target;

      Future.delayed(Duration(seconds: 0), () async {
        GoogleMapController controller = await _controller.future;
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
    var p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.fullscreen,
        language: "en");
  }
  //TODO: implement PlacesAutocomplete and get address from places screen
}
