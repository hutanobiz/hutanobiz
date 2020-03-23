import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Widget build(BuildContext context) {
    conatiner = InheritedContainer.of(context);

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
      bottomNavigationBar: bottomnavigationBar(),
    );
  }

  Widget adressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          width: 15.0,
          height: 18.0,
          image: AssetImage("images/ic_location.png"),
        ),
        _isLoading
            ? Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () => _navigateToMap(context),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
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
                  ),
                ),
              ),
        Image(
          width: 8.0,
          height: 4.0,
          image: AssetImage("images/ic_arrow_down.png"),
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
              return ListTile(
                contentPadding: EdgeInsets.all(0.0),
                title: Column(
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                      placeholder: "images/dummy_title_image.png",
                      image: '',
                      //TODO: add title image
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      data[index]["title"],
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

                  log(conatiner.getProjectsResponse().toString());

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

    _loading();

    if (latLng != null) {
      _latLng = latLng;
      log(latLng.toString());

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
            print(e);
            if (e.code == 'PERMISSION_DENIED') {
              log(e.code);
              Widgets.showToast(e.message.toString());
            } else if (e.code == 'SERVICE_STATUS_ERROR') {
              log(e.code);
              Widgets.showToast(e.message.toString());
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
      var addresses =
          await Geolocator().placemarkFromCoordinates(latitude, longitude);

      var first = addresses.first;

      setState(() {
        _isLoading = false;

        _currentddress =
            '${first.name}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}';
      });
    } catch (e) {
      print(e.getMessage() ?? e.toString());
    }
  }

  Widget bottomnavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(14.0),
          topLeft: Radius.circular(14.0),
        ),
        border: Border.all(width: 0.5, color: Colors.grey[300]),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(14.0),
          topLeft: Radius.circular(14.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.persian_indigo,
          unselectedItemColor: Colors.grey[400],
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/ic_home.png")),
              activeIcon: ImageIcon(AssetImage("images/ic_active_home.png")),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/ic_appointments.png")),
              activeIcon:
                  ImageIcon(AssetImage("images/ic_active_appointments.png")),
              title: Text('Appointments'),
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("images/ic_settings.png")),
                activeIcon:
                    ImageIcon(AssetImage("images/ic_active_settings.png")),
                title: Text('Settings'))
          ],
        ),
      ),
    );
  }

  void _loading() {
    setState(() {
      _isLoading = true;
    });
  }
}
