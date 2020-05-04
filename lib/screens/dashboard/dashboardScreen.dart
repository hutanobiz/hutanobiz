import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:location/location.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiBaseHelper _api = new ApiBaseHelper();

  Future<List<dynamic>> _titleFuture;

  String _currentddress;

  EdgeInsetsGeometry _edgeInsetsGeometry =
      const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0);

  LatLng _latLng;

  bool _isLoading = false;

  InheritedContainerState conatiner;

  @override
  void initState() {
    super.initState();
    _titleFuture = _api.getProfessionalTitle();

    setState(() {
      initPlatformState();
    });
  }

  @override
  void didChangeDependencies() {
    conatiner = InheritedContainer.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white_smoke,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: _edgeInsetsGeometry,
              child: adressBar(),
            ),
            Padding(
              padding: _edgeInsetsGeometry,
              child: searchBar(),
            ),
            Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(22.0),
                      topRight: const Radius.circular(22.0),
                    ),
                  ),
                  child: professionalTitle()),
            ),
          ],
        ),
      ),
    );
  }

  Widget adressBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image(
          width: 15.0,
          height: 18.0,
          image: AssetImage("images/ic_location.png"),
        ),
        SizedBox(width: 10),
        _isLoading
            ? Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : InkWell(
                onTap: () => _navigateToMap(context),
                child: Row(
                  children: <Widget>[
                    _currentddress.length > 45
                        ? SizedBox(
                            width: 120,
                            child: Text(
                              _currentddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.midnight_express,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Text(
                            _currentddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.midnight_express,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    _currentddress.length > 45
                        ? Container()
                        : SizedBox(width: 5),
                    Image(
                      width: 8.0,
                      height: 4.0,
                      image: AssetImage("images/ic_arrow_down.png"),
                    ),
                  ],
                ),
              ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Image(
              width: 20.0,
              height: 20.0,
              image: AssetImage("images/ic_notification.png"),
            ),
          ),
        ),
      ],
    );
  }

  Widget searchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "What are you looking for?",
          style: TextStyle(
            color: AppColors.midnight_express,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.0),
        InkWell(
          onTap: () =>
              Navigator.of(context).pushNamed(Routes.dashboardSearchScreen),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(12.0, 15.0, 14.0, 14.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/ic_search.png"),
                alignment: Alignment.centerRight,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  8.0,
                ),
              ),
            ),
            child: Text(
              "Search for doctors or by specialty...",
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget professionalTitle() {
    return FutureBuilder<List<dynamic>>(
      future: _titleFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data;

          if (data == null || data.length == 0) return Container();

          return GridView.builder(
            padding: const EdgeInsets.all(20.0),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18.0,
              crossAxisSpacing: 21.0,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (data == null || data.length == 0) return Container();

              return ListTile(
                contentPadding: EdgeInsets.all(0.0),
                title: Column(
                  children: <Widget>[
                    data[index]["image"] != null
                        ? Image.network(
                            data[index]["image"],
                          )
                        : Image(
                            image: AssetImage(
                              "images/dummy_title_image.png",
                            ),
                          ),
                    SizedBox(height: 10.0),
                    Text(
                      data[index]["title"] ?? "---",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  conatiner.getProjectsResponse().clear();
                  conatiner.setProjectsResponse(
                      "professionalTitleId", data[index]["_id"]);

                  Navigator.pushNamed(
                    context,
                    Routes.chooseSpecialities,
                    arguments: data[index]["_id"],
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _navigateToMap(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.chooseLocation,
      arguments: _latLng,
    );

    LatLng latLng = result;

    if (latLng != null) {
      _loading();

      _latLng = latLng;

      getLocationAddress(latLng.latitude, latLng.longitude);
    }
  }

  initPlatformState() async {
    _loading();

    Location _locationService = Location();
    PermissionStatus _permission;
    Geolocator geolocator = Geolocator();

    _permission = await _locationService.requestPermission();
    print("Permission: $_permission");

    switch (_permission) {
      case PermissionStatus.GRANTED:
        bool serviceStatus = await _locationService.serviceEnabled();
        print("Service status: $serviceStatus");

        if (serviceStatus) {
          Widgets.showToast("Getting Location. Please wait..");

          try {
            Position position = await geolocator.getLastKnownPosition();
            if (position == null) {
              position = await geolocator.getCurrentPosition();
            }

            getLocationAddress(position.latitude, position.longitude);

            _latLng = LatLng(position.latitude, position.longitude);
          } on PlatformException catch (e) {
            setState(() {
              _isLoading = false;
            });

            Widgets.showToast(e.message.toString());
            print(e);
            if (e.code == 'PERMISSION_DENIED') {
              log(e.code);
              Widgets.showToast(e.message.toString());
            } else if (e.code == 'SERVICE_STATUS_ERROR') {
              log(e.code);
            }
            _locationService = null;
          }
        } else {
          bool serviceStatusResult = await _locationService.requestService();
          print("Service status activated after request: $serviceStatusResult");
          initPlatformState();
        }

        break;
      case PermissionStatus.DENIED:
        initPlatformState();
        break;
      case PermissionStatus.DENIED_FOREVER:
        break;
    }
  }

  getLocationAddress(latitude, longitude) async {
    try {
      final coordinates = new Coordinates(latitude, longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      conatiner.setUserLocation("latLng", LatLng(latitude, longitude));

      String address = "";

      if (addresses.first.subThoroughfare != null &&
          addresses.first.subThoroughfare != "") {
        address = addresses.first.subThoroughfare + ", ";
      }

      if (addresses.first.thoroughfare != null &&
          addresses.first.thoroughfare != "") {
        address = address + addresses.first.thoroughfare + ", ";
      }

      if (addresses.first.subAdminArea != null &&
          addresses.first.subAdminArea != "") {
        address = address + addresses.first.subAdminArea;
      }

      // var first = addresses.first.subThoroughfare ??
      //     addresses.first.thoroughfare ??
      //     addresses.first.subAdminArea;

      setState(() {
        _isLoading = false;
        _currentddress = address.endsWith(", ")
            ? address.substring(0, address.length - 2)
            : address;
        conatiner.setUserLocation("userAddress", _currentddress);
      });
    } on PlatformException catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.message.toString() ?? e.toString());
    }
  }

  void _loading() {
    setState(() {
      _isLoading = true;
    });
  }
}
