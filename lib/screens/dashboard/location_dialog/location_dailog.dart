import 'dart:async';
import 'dart:convert';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/src/utils/app_config.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:location/location.dart' as Loc;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/places.dart';

class LocationDialog {
  static final LocationDialog _singleton = LocationDialog._internal();

  factory LocationDialog() {
    return _singleton;
  }

  LocationDialog._internal();

  final _addressController = TextEditingController();
  String _sessionToken;
  List<dynamic> _placeList = [];
  List<String> radiusList = ['1', '2', '5', '10', '20', '50', '100', '1000'];
  bool isShowList = false;
  bool isShowRadiusList = false;
  Completer<GoogleMapController> _controller = Completer();
  PlacesDetailsResponse detail;
  final radiuscontroller = TextEditingController();
  CameraPosition _myLocation;
  GoogleMapController controller;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKey);
  String _currentddress = "";
  Loc.LocationData geoLocation;
  var uuid = new Uuid();

  EdgeInsetsGeometry _edgeInsetsGeometry =
      const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0);

  LatLng latLng = new LatLng(0.00, 0.00);

  bool _isLocLoading = false;

  InheritedContainerState conatiner;
  Map typeMap = Map();
  Map placesMap = Map();
  Map insuranceMap = Map();
  String selectedType = '1', selectedPlace = '1', selectedInsurance = '1';
  String avatar;

  String radius = '---';
  bool _isLoading = false;

  init() async {
    _currentddress = await SharedPref().getValue('address');
    if (_currentddress == null) {
      _currentddress = "";
    }
    radius = await SharedPref().getValue('radius');

    if (radius == null) {
      radius = "10";
    } else {
      radiuscontroller.text = radius + ' Miles';
    }
  }

  getLocation() async {
    var lat = await SharedPref().getValue('lat');
    var lng = await SharedPref().getValue('lng');
    _currentddress = await SharedPref().getValue('address');
    radius = await SharedPref().getValue('radius');

    _myLocation = CameraPosition(
      target: LatLng(lat ?? 0.00, lng ?? 0.00),
    );

    latLng = new LatLng(lat ?? 0.00, lng ?? 0.00);
    SharedPref().getToken().then((token) {
    });
    conatiner?.setUserLocation(
        "latLng", LatLng(latLng.latitude, latLng.longitude));
  }

  dynamic showLocationDialog(isFilter, context) async {
    await getLocation();
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(14),
                      )),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'Change Location',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  'images/locationClose.png',
                                  height: 32,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: _addressController,
                            onChanged: ((val) {
                              if (_sessionToken == null) {
                                setModalState(() {
                                  _sessionToken = uuid.v4();
                                });
                              }
                              isShowList = true;
                              isShowRadiusList = false;
                              getSuggestion(val, setModalState);
                            }),
                            decoration: InputDecoration(
                                labelText: "Address",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]),
                                    borderRadius: BorderRadius.circular(5.0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            keyboardType: TextInputType.text,
                            validator: Validations.validateEmpty,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.grey[300],
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                setModalState(() {
                                  isShowList = false;

                                  isShowRadiusList = true;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: TextFormField(
                                  controller: radiuscontroller,
                                  enabled: false,
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.black87),
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey[400],
                                    ),
                                    labelText: 'Radius',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: GoogleMap(
                              initialCameraPosition: _myLocation,
                              onMapCreated: ((controller) {
                                _onMapCreated(controller, setModalState);
                              }),
                              myLocationButtonEnabled: false,
                              myLocationEnabled: false,
                              zoomControlsEnabled: false,
                              onCameraMove: (position) {},
                              onCameraIdle: () {},
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              )),
                              height: 40,
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_addressController.text == '') {
                                  Widgets.showErrorDialog(
                                    context: context,
                                    description: 'Please Enter Address',
                                    // isError: true
                                  );
                                } else if (radiuscontroller.text == '') {
                                  Widgets.showErrorDialog(
                                    context: context,
                                    description: 'Please Select Radius',
                                    // isError: true
                                  );
                                } else {
                                  await SharedPref().setDoubleValue(
                                      'lat', _myLocation.target.latitude);
                                  await SharedPref().setDoubleValue(
                                      'lng', _myLocation.target.longitude);
                                  await SharedPref().setValue(
                                      'address', _addressController.text);
                                  await SharedPref().setValue('radius',
                                      radiuscontroller.text.split(' ')[0]);
                                  await getLocation();
                                  Navigator.pop(context, true);
                                  return;
                                  if (isFilter) {
                                    conatiner.setUserLocation(
                                        "latLng",
                                        LatLng(_myLocation.target.latitude,
                                            _myLocation.target.longitude));
                                    conatiner.setUserLocation(
                                        "userAddress", _addressController.text);
                                    conatiner.setProjectsResponse(
                                        "serviceType", selectedType);
                                    conatiner.setProjectsResponse(
                                        "insuranceType",
                                        selectedInsurance == '2' ? '1' : '0');
                                    conatiner.setProjectsResponse(
                                        "maximumDistance",
                                        radiuscontroller.text.split(' ')[0]);
                                    // Navigator.pushNamed(context,
                                    //     Routes.allTitlesSpecialtesScreen);
                                  }
                                }
                              },
                              color: AppColors.windsor,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                      isShowList
                          ? Column(
                              children: [
                                SizedBox(height: 130),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _placeList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        tileColor: Colors.white,
                                        onTap: () async {
                                          detail =
                                              await _places.getDetailsByPlaceId(
                                                  _placeList[index]
                                                      ["place_id"]);
                                          final lat = detail
                                              .result.geometry.location.lat;
                                          final lng = detail
                                              .result.geometry.location.lng;
                                          _myLocation = CameraPosition(
                                            bearing: 0,
                                            target: LatLng(lat, lng),
                                            zoom: 17.0,
                                          );
                                          print(detail.result.adrAddress
                                              .toString());
                                          PlacesDetailsResponse aa = detail;
                                          print(aa);
                                          print(aa.result.adrAddress);

                                          _addressController.text =
                                              aa.result.name;
                                          if (controller == null) {
                                            controller =
                                                await _controller.future;
                                          }
                                          controller.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                            _myLocation,
                                          ));
                                          setModalState(() {
                                            isShowList = false;
                                          });
                                        },
                                        title: Text(
                                            _placeList[index]["description"]),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      isShowRadiusList
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 80.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 200),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: radiusList.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          tileColor: Colors.white,
                                          onTap: () {
                                            radiuscontroller.text =
                                                radiusList[index] + ' Miles';
                                            setModalState(() {
                                              isShowRadiusList = false;
                                            });
                                          },
                                          title: Text(
                                              radiusList[index] + ' Miles'),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  )),
            );
          });
        });
  }

  void _onMapCreated(
      GoogleMapController controller, StateSetter setModalState) async {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
    if ([_myLocation] != null) {
      LatLng position = _myLocation.target;

      Future.delayed(Duration(seconds: 0), () async {
        if (!_controller.isCompleted) {
          controller = await _controller.future;
        }
        this.controller = controller;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0,
            ),
          ),
        );
      });
      setModalState(() {});
    }
  }

  void getSuggestion(String input, StateSetter setModalState) async {
    String kPLACES_API_KEY = googleApiKey;
    String type = '(cities)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request;
    if (geoLocation != null) {
      request =
          '$baseURL?input=$input&radius=5000&location=${geoLocation.latitude},${geoLocation.longitude}&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    } else {
      request =
          '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    }
    var response = await http.get(request);
    if (response.statusCode == 200) {
      setModalState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
