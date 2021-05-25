import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/dashboard/choose_location_screen.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/provider_tile_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:location/location.dart' as Loc;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/places.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiBaseHelper _api = new ApiBaseHelper();
  bool isEmailVerified = false;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Strings.kGoogleApiKey);
  var uuid = new Uuid();
  String _sessionToken;
  List<dynamic> _placeList = [];
  List<String> radiusList = ['1', '2', '5', '10', '20', '50', '100', '1000'];
  bool isShowList = false;
  bool isShowRadiusList = false;
  Completer<GoogleMapController> _controller = Completer();
  PlacesDetailsResponse detail;
  final _addressController = TextEditingController();
  final radiuscontroller = TextEditingController();
  CameraPosition _myLocation;
  GoogleMapController controller;
  String _currentddress;
  Loc.LocationData geoLocation;

  EdgeInsetsGeometry _edgeInsetsGeometry =
      const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0);

  LatLng _latLng = new LatLng(0.00, 0.00);

  bool _isLocLoading = false;

  InheritedContainerState conatiner;
  List _topSpecialtiesList = [];
  Future<dynamic> _searchFuture;
  String _searchText = "";
  List<dynamic> _servicesList = List();
  List<dynamic> _doctorList = List();
  List<dynamic> _specialityList = List();
  InheritedContainerState _container;
  final TextEditingController _typeContoller = TextEditingController();
  final TextEditingController _placeContoller = TextEditingController();
  final TextEditingController _insuranceContoller = TextEditingController();
  Map typeMap = Map();
  Map placesMap = Map();
  Map insuranceMap = Map();
  String selectedType = '1', selectedPlace = '1', selectedInsurance = '1';
  String avatar;
  String radius = '---';
  int unreadCount = 0;
  String token;

  bool _isLoading = false;
  List<String> _topProvidersList = [
    'Office Appointment',
    'Video Appointment',
    'Onsite Appointment'
  ];

  Future<List<dynamic>> _myDoctorsFuture;
  Future<List<dynamic>> _specialtiesFuture;
  Future<List<dynamic>> _professionalTitleFuture;
  Future<List<dynamic>> _ondemandDoctorsFuture;

  getLocation() async {
    var lat = await SharedPref().getValue('lat');
    var lng = await SharedPref().getValue('lng');
    _currentddress = await SharedPref().getValue('address');
    radius = await SharedPref().getValue('radius') ?? '100';

    _myLocation = CameraPosition(
      target: LatLng(lat ?? 0.00, lng ?? 0.00),
    );

    _latLng = new LatLng(lat ?? 0.00, lng ?? 0.00);

    _myDoctorsFuture = _api.getMyDoctors(token, _latLng);

    _ondemandDoctorsFuture =
        _api.getOnDemandDoctors(token, _latLng, radius, 'Asia/Kolkata');

    conatiner.setUserLocation(
        "latLng", LatLng(_latLng.latitude, _latLng.longitude));
    setState(() {});
  }

  @override
  Future<void> initState() {
    super.initState();

    initPlatformState();

    _professionalTitleFuture = _api.getProfessionalTitle();
    _specialtiesFuture = _api.getSpecialties();
    typeMap['1'] = "At the provider's office";
    typeMap['2'] = 'Virtually by telemedicine';
    typeMap['3'] = 'In your home or office';
    insuranceMap['1'] = 'All Providers';
    insuranceMap['2'] = 'Provider who take my insurance';
    placesMap['1'] = 'Providers near me';
    placesMap['2'] = 'Type City or Zip Code';
    _typeContoller.text = typeMap[selectedType];
    _placeContoller.text = placesMap[selectedPlace];
    _insuranceContoller.text = insuranceMap[selectedInsurance];
  }

  @override
  void didChangeDependencies() {
    conatiner = InheritedContainer.of(context);
    // SharedPref().getValue("isEmailVerified").then((value) {
    //   if (value == null || value == false) {
    SharedPref().getToken().then((value) {
      token = value;
      _api.profile(value, Map()).then((value) {
        setState(() {
          isEmailVerified = value["response"]["isEmailVerified"] ?? false;
          SharedPref().setBoolValue(
              "isEmailVerified", value["response"]["isEmailVerified"] ?? false);
          avatar = value['response']['avatar'].toString();
        });
      });
      getUnreadNotification();
    });
    // } else {
    //   setState(() {
    //     isEmailVerified = value;
    //   });
    // }
    // });
    _container = InheritedContainer.of(context);
    getLocation();

    super.didChangeDependencies();
  }

  getUnreadNotification() {
    _api.getUnreadNotifications(context, token).then((value) {
      setState(() {
        unreadCount = value['count'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(21.0, 17.0, 0.0, 17.0),
                  child: Row(
                    children: <Widget>[
                      Image(
                        width: 32.0,
                        height: 32.0,
                        image: AssetImage("images/logo.png"),
                      ),
                      Spacer(),
                      Container(
                        height: 36,
                        width: 36,
                        child: Stack(
                          children: [
                            Center(
                              child: Image(
                                width: 28.0,
                                height: 28.0,
                                image: AssetImage("images/ic_notification.png"),
                              ),
                            ),
                            unreadCount > 0
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      height: 24,
                                      width: 24,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.red),
                                      child: Center(
                                        child: Text(
                                            unreadCount > 9
                                                ? '9+'
                                                : unreadCount.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12)),
                                      ),
                                    ))
                                : SizedBox()
                          ],
                        ),
                      ).onClick(
                          onTap: () => Navigator.pushNamed(
                                  context, Routes.activityNotification)
                              .then((value) => getUnreadNotification())),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[300],
                            ),
                          ),
                          child: avatar == null || avatar == "null"
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image(
                                    image:
                                        AssetImage('images/profile_user.png'),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipOval(
                                  child: Image.network(
                                    ApiBaseHelper.imageUrl + avatar,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(22.0),
                        topRight: const Radius.circular(22.0),
                      ),
                    ),
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
                          child: _searchText != ''
                              ? _buildList()
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(top: 16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(22.0),
                                      topRight: const Radius.circular(22.0),
                                    ),
                                  ),
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    children: <Widget>[
                                      Text(
                                        'How do you want to receive care?',
                                        style: TextStyle(
                                          color: AppColors.midnight_express,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      picker(
                                          _typeContoller,
                                          "",
                                          selectedType == '1'
                                              ? 'images/ic_office_app.png'
                                              : selectedType == '2'
                                                  ? 'images/ic_provider_video.png'
                                                  : 'images/ic_provider_onsite.png',
                                          () {
                                        mapBottomDialog(
                                            _typeContoller, typeMap, 1);
                                      }),
                                      SizedBox(height: 20),
                                      picker(_placeContoller, "",
                                          'images/near_location.png', () {
                                        mapBottomDialog(
                                            _placeContoller, placesMap, 2);
                                      }),
                                      SizedBox(height: 20),
                                      picker(_insuranceContoller, "",
                                          'images/my_insurance.png', () {
                                        mapBottomDialog(_insuranceContoller,
                                            insuranceMap, 3);
                                      }),
                                      SizedBox(height: 20),
                                      FancyButton(
                                          title: 'Explore providers',
                                          onPressed: () {
                                            conatiner.setUserLocation(
                                                "latLng",
                                                LatLng(
                                                    _myLocation.target.latitude,
                                                    _myLocation
                                                        .target.longitude));
                                            conatiner.setUserLocation(
                                                "userAddress", _currentddress);

                                            conatiner.setProjectsResponse(
                                                "serviceType", selectedType);
                                            conatiner.setProjectsResponse(
                                                "insuranceType",
                                                selectedInsurance == '2'
                                                    ? '1'
                                                    : '0');
                                            conatiner.setProjectsResponse(
                                                "maximumDistance", radius);

                                            if (selectedPlace == '2') {
                                              showLocationDialog(true);
                                            } else {
                                              Navigator.pushNamed(
                                                  context,
                                                  Routes
                                                      .allTitlesSpecialtesScreen);
                                            }
                                          }),
                                      SizedBox(height: 20),
                                      // Text(
                                      //   'Find Top Providers',
                                      //   style: TextStyle(
                                      //     color: AppColors.midnight_express,
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w700,
                                      //   ),
                                      // ),
                                      // topProviderWidget(),
                                      onDemandDoctorsWidget(),
                                      myDoctorsWidget(),
                                      // professionalTitleWidget(),
                                      // specialtiesWidget(),
                                      // pointsWidget(),
                                      // SizedBox(height: 20),
                                      // inviteWidget(),
                                      // SizedBox(height: 20)
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _isLoading ? CircularLoader() : Container(),
          ],
        ),
      ),
    );
  }

  Container pointsWidget() {
    return Container(
        height: 186,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[100]),
            color: AppColors.windsor.withOpacity(0.1)),
        child: Column(
          // mainAxisAlignment:
          //     MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'images/refer_star.png',
                  height: 48,
                ),
                Text(
                  '76',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Image.asset(
                  'images/refer_info.png',
                  height: 48,
                ),
              ],
            ),
            Text(
              'STAR BALANCE',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Row(
              children: [
                Text(
                  'REDEEM POINTS',
                  style: TextStyle(
                    color: AppColors.windsor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios,
                    color: AppColors.windsor, size: 12)
              ],
            )
          ],
        ));
  }

  Container inviteWidget() {
    return Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[100]),
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/refer_icon.png', height: 44),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite Friends',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Earn more points',
                        style: TextStyle(
                          color: AppColors.windsor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios,
                          color: AppColors.windsor, size: 12)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
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
                      switch (value) {
                        case 1:
                          selectedType = key;

                          break;
                        case 2:
                          selectedPlace = key;
                          break;
                        default:
                          selectedInsurance = key;
                      }
                      Navigator.pop(context);
                    });
                  },
                );
              },
            ),
          );
        });
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
        InkWell(
          onTap: () {
            showLocationDialog(false);
          }, // _navigateToMap(context),
          child: Row(
            children: <Widget>[
              // SizedBox(
              //   width: (MediaQuery.of(context).size.width - 224),
              //   child:
              Text(
                _currentddress == null
                    ? '---'
                    : _currentddress.length > 14
                        ? _currentddress.substring(0, 14)
                        : _currentddress,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: AppColors.windsor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // ),
              Text(
                ' \u2022 ',
                style: TextStyle(
                  color: AppColors.windsor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Within $radius Miles ',
                style: TextStyle(
                  color: AppColors.windsor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Image(
                width: 10.0,
                height: 5.0,
                image: AssetImage("images/ic_arrow_down.png"),
              ),
            ],
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
        // Text(
        //   "What are you looking for?",
        //   style: TextStyle(
        //     color: AppColors.midnight_express,
        //     fontSize: 16.0,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // SizedBox(height: 6.0),
        // InkWell(
        //   child:
        TextFormField(
          maxLines: 1,
          onChanged: (value) {
            _searchText = value;

            setState(() {
              _searchFuture = _api.searchDoctors(_searchText);
            });
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: AppColors.snow,
            labelStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
            hintText: "Search provider by name or specility",
            prefixIcon: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset(
                'images/search.png',
                height: 16,
                // color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.snow),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: AppColors.snow),
            //   borderRadius: BorderRadius.circular(8.0),
            // ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.snow),
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(12.0, 15.0, 14.0, 14.0),
          ),
        ),
        // ),
        // ),
      ],
    );
  }

  Widget _buildList() {
    return FutureBuilder<dynamic>(
      future: _searchFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          _servicesList.clear();
          _doctorList.clear();
          _specialityList.clear();
          _container.setProjectsResponse("serviceType", '0');
          if (snapshot.data["services"].length > 0) {
            for (dynamic services in snapshot.data["services"]) {
              if (services['subServices'] != null) {
                for (dynamic subServices in services['subServices']) {
                  _servicesList.add(subServices);
                }
              }
            }
          }
          if (snapshot.data["doctorName"].length > 0) {
            _doctorList.addAll(snapshot.data["doctorName"]);
          }

          if (snapshot.data["specialty"].length > 0) {
            _specialityList.addAll(snapshot.data["specialty"]);
          }

          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  heading("Specialities", _specialityList, 1),
                  _specialityList.isNotEmpty
                      ? _listWidget(_specialityList, "title", false, 1)
                      : Container(),
                  heading("Providers", _doctorList, 2),
                  _doctorList.isNotEmpty
                      ? _listWidget(_doctorList, "fullName", true, 2)
                      : Container(),
                  heading("Services", _servicesList, 3),
                  _servicesList.isNotEmpty
                      ? _listWidget(_servicesList, "name", false, 3)
                      : Container(),
                ]),
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

  Widget heading(
    String heading,
    List<dynamic> list,
    int type, {
    bool isAddSeeAll = true,
  }) {
    return list.isNotEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 20.0),
            padding: const EdgeInsets.fromLTRB(20.0, 11.0, 5.0, 11.0),
            color: AppColors.snow,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  heading,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                list.isNotEmpty && isAddSeeAll
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            customBorder: CircleBorder(),
                            onTap: type == 0
                                ? null
                                : () => Navigator.of(context).pushNamed(
                                      Routes.seeAllSearchScreeen,
                                      arguments: SearchArguments(
                                        list: list,
                                        title: heading,
                                        type: type,
                                      ),
                                    ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          )
        : Container();
  }

  Widget _listWidget(
      List<dynamic> _list, String searchKey, bool isDoctorList, int type) {
    List<dynamic> tempList = List();
    String professionalTitle = "---";

    if (_list.isNotEmpty)
      _list.forEach((f) {
        if (f[searchKey] != null) {
          if (f[searchKey].toLowerCase().contains(_searchText.toLowerCase())) {
            tempList.add(f);
          }
        }
      });

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 0.0),
      itemCount: tempList.length >= 5 ? 5 : tempList.length,
      itemBuilder: (context, index) {
        if (tempList.isNotEmpty) {
          if (tempList[index]["UserDoctorDetails"] != null) {
            dynamic details = tempList[index]["UserDoctorDetails"];
            if (details["professionalTitle"] != null) {
              professionalTitle =
                  details["professionalTitle"]["title"]?.toString() ?? "---";
            }
          }

          return isDoctorList
              ? ProviderTileWidget(
                  avatar: tempList[index]['avatar'] ?? '',
                  name: tempList[index][searchKey] +
                      Extensions.getSortProfessionTitle(professionalTitle),
                  profession: professionalTitle,
                  onTap: () {
                    // if (!_recentSearchesList.contains(tempList[index])) {
                    //   if (_recentSearchesList.length >= 25) {
                    //     _recentSearchesList.removeAt(0);
                    //   }

                    //   tempList[index]['type'] = type;
                    //   _recentSearchesList.add(tempList[index]);

                    //   SharedPref().setValue(
                    //       'recentSearches', jsonEncode(_recentSearchesList));
                    // }

                    Navigator.of(context).pushNamed(
                        Routes.providerProfileScreen,
                        arguments: tempList[index]["_id"].toString());
                  },
                )
              : ListTile(
                  title: Text(tempList[index][searchKey]),
                  onTap: type == 0
                      ? null
                      : () {
                          // if (!_recentSearchesList.contains(tempList[index])) {
                          //   if (_recentSearchesList.length >= 25) {
                          //     _recentSearchesList.removeAt(0);
                          //   }

                          //   tempList[index]['type'] = type;
                          //   _recentSearchesList.add(tempList[index]);
                          //   SharedPref().setValue('recentSearches',
                          //       jsonEncode(_recentSearchesList));
                          // }

                          _container.projectsResponse.clear();

                          if (type == 1) {
                            _container.setProjectsResponse(
                                "specialtyId[${index.toString()}]",
                                tempList[index]["_id"]);
                            _container.setProjectsResponse("serviceType", '0');
                          } else if (type == 3) {
                            _container.setProjectsResponse(
                                "subServices[${index.toString()}]",
                                tempList[index]["_id"]);
                          }

                          _container.setProjectsResponse("serviceType", '0');

                          Navigator.of(context)
                              .pushNamed(Routes.providerListScreen);
                        },
                );
        }

        return Container();
      },
    );
  }

  Widget topProviderWidget() {
    return Container(
      height: 150,
      width: 143,
      margin: const EdgeInsets.only(top: 20, bottom: 30),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 13),
        scrollDirection: Axis.horizontal,
        itemCount: _topProvidersList.length,
        itemBuilder: (context, index) {
          String appointmentType = _topProvidersList[index];
          return Container(
            height: 150,
            width: 143,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey[100]),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: Image(
                      image: AssetImage(
                        appointmentType.toLowerCase().contains('office')
                            ? 'images/office_appointment.png'
                            : (appointmentType.toLowerCase().contains('vide')
                                ? 'images/video_chat_appointment.png'
                                : 'images/onsite_appointment.png'),
                      ),
                      width: 143,
                      height: 106.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    appointmentType,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onTap: () {
                conatiner.projectsResponse.clear();
                conatiner.setProjectsResponse(
                    "serviceType", (index + 1).toString());

                Navigator.pushNamed(context, Routes.allTitlesSpecialtesScreen);
              },
            ),
          );
        },
      ),
    );
  }

  void showLocationDialog(isFilter) {
    showDialog(
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
                                style: AppTextStyle.boldStyle(fontSize: 20),
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
                                style: AppTextStyle.regularStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              onPressed: () {
                                if (_addressController.text == '') {
                                  Widgets.showAppDialog(
                                      context: context,
                                      description: 'Please Enter Address',
                                      isError: true);
                                } else if (radiuscontroller.text == '') {
                                  Widgets.showAppDialog(
                                      context: context,
                                      description: 'Please Select Radius',
                                      isError: true);
                                } else {
                                  SharedPref().setDoubleValue(
                                      'lat', _myLocation.target.latitude);
                                  SharedPref().setDoubleValue(
                                      'lng', _myLocation.target.longitude);
                                  SharedPref().setValue(
                                      'address', _addressController.text);
                                  SharedPref().setValue('radius',
                                      radiuscontroller.text.split(' ')[0]);
                                  getLocation();
                                  Navigator.pop(context, true);
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
                                    Navigator.pushNamed(context,
                                        Routes.allTitlesSpecialtesScreen);
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
    String kPLACES_API_KEY = Strings.kGoogleApiKey;
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
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setModalState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Widget onDemandDoctorsWidget() {
    return FutureBuilder<List<dynamic>>(
      future: _ondemandDoctorsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _onDemandDoctorsList = snapshot.data;

          if (_onDemandDoctorsList == null || _onDemandDoctorsList.isEmpty) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'On demand providers',
                style: TextStyle(
                  color: AppColors.midnight_express,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                height: 156,
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 13),
                  scrollDirection: Axis.horizontal,
                  itemCount: _onDemandDoctorsList.length,
                  itemBuilder: (context, index) {
                    if (_onDemandDoctorsList == null ||
                        _onDemandDoctorsList.isEmpty) {
                      return Text('No my doctors available');
                    }

                    String professionalTitle = '---';

                    dynamic doctor = _onDemandDoctorsList[index];
                    // dynamic subServices =
                    //     _onDemandDoctorsList[index]['subServices'];
                    dynamic doctorData = doctor['doctor'];

                    String avatar = doctorData['avatar']?.toString();

                    Map _appointentTypeMap = {};

                    _appointentTypeMap["isOfficeEnabled"] =
                        doctor['doctorData']["isOfficeEnabled"];
                    _appointentTypeMap["isVideoChatEnabled"] =
                        doctor['doctorData']["isVideoChatEnabled"];
                    _appointentTypeMap["isOnsiteEnabled"] =
                        doctor['doctorData']["isOnsiteEnabled"];

                    if (doctor['doctorData']['professionalTitle'] != null) {
                      professionalTitle = doctor['doctorData']
                                  ['professionalTitle'][0]['title']
                              ?.toString() ??
                          '---';
                    }

                    return Container(
                      // height: 156,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[100]),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(12),
                              width: 52.0,
                              height: 52.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: avatar == null || avatar == "null"
                                  ? Image(
                                      image:
                                          AssetImage('images/profile_user.png'),
                                      height: 52.0,
                                      width: 52.0,
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        ApiBaseHelper.imageUrl + avatar,
                                        width: 52.0,
                                        height: 52.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Text(
                              (doctorData['title']?.toString() ?? 'Dr.') +
                                  ' ' +
                                  (doctorData['fullName']?.toString() ??
                                      '---') +
                                  Extensions.getSortProfessionTitle(
                                      professionalTitle),
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3, bottom: 6),
                              child: Text(
                                professionalTitle ?? '---',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 160,
                              height: 36,
                              padding:
                                  const EdgeInsets.only(top: 9.0, bottom: 4),
                              child: FlatButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                color: AppColors.persian_indigo,
                                splashColor: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(14.0),
                                    bottomLeft: Radius.circular(14.0),
                                  ),
                                ),
                                child: Text(
                                  "BOOK APPT.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  // doctor['distance'] =
                                  //     _onDemandDoctorsList[index]['distance'];
                                  // conatiner.providerResponse.clear();
                                  // conatiner.setProviderData(
                                  //   "providerData",
                                  //   doctor,
                                  // );

                                  // conatiner.setProviderData(
                                  //     "subServices", subServices);

                                  // Navigator.of(context).pushNamed(
                                  //   Routes.appointmentTypeScreen,
                                  //   arguments: _appointentTypeMap,
                                  // );
                                  Navigator.of(context).pushNamed(
                                      Routes.providerProfileScreen,
                                      arguments: doctorData["_id"]);
                                },
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              Routes.providerProfileScreen,
                              arguments: doctorData["_id"]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget myDoctorsWidget() {
    return FutureBuilder<List<dynamic>>(
      future: _myDoctorsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _myDoctorsList = snapshot.data;

          if (_myDoctorsList == null || _myDoctorsList.isEmpty) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Top Providers',
                style: TextStyle(
                  color: AppColors.midnight_express,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                height: 156,
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 13),
                  scrollDirection: Axis.horizontal,
                  itemCount: _myDoctorsList.length,
                  itemBuilder: (context, index) {
                    if (_myDoctorsList == null || _myDoctorsList.isEmpty) {
                      return Text('No my doctors available');
                    }

                    String professionalTitle = '---';

                    dynamic doctor = _myDoctorsList[index]['doctorData'];
                    dynamic subServices = _myDoctorsList[index]['subServices'];
                    dynamic doctorData = doctor['userId'];

                    String avatar = doctorData['avatar']?.toString();

                    Map _appointentTypeMap = {};

                    _appointentTypeMap["isOfficeEnabled"] =
                        doctor["isOfficeEnabled"];
                    _appointentTypeMap["isVideoChatEnabled"] =
                        doctor["isVideoChatEnabled"];
                    _appointentTypeMap["isOnsiteEnabled"] =
                        doctor["isOnsiteEnabled"];

                    if (doctor['professionalTitle'] != null) {
                      professionalTitle =
                          doctor['professionalTitle']['title']?.toString() ??
                              '---';
                    }

                    return Container(
                      // height: 156,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[100]),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(12),
                              width: 52.0,
                              height: 52.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: avatar == null || avatar == "null"
                                  ? Image(
                                      image:
                                          AssetImage('images/profile_user.png'),
                                      height: 52.0,
                                      width: 52.0,
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        ApiBaseHelper.imageUrl + avatar,
                                        width: 52.0,
                                        height: 52.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Text(
                              (doctorData['title']?.toString() ?? 'Dr.') +
                                  ' ' +
                                  (doctorData['fullName']?.toString() ??
                                      '---') +
                                  Extensions.getSortProfessionTitle(
                                      professionalTitle),
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3, bottom: 6),
                              child: Text(
                                professionalTitle ?? '---',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 160,
                              height: 36,
                              padding:
                                  const EdgeInsets.only(top: 9.0, bottom: 4),
                              child: FlatButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                color: AppColors.persian_indigo,
                                splashColor: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(13.0),
                                    bottomLeft: Radius.circular(13.0),
                                  ),
                                ),
                                child: Text(
                                  "BOOK APPT.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  // doctor['distance'] =
                                  //     _myDoctorsList[index]['distance'];
                                  // conatiner.providerResponse.clear();
                                  // conatiner.setProviderData(
                                  //   "providerData",
                                  //   doctor,
                                  // );

                                  // conatiner.setProviderData(
                                  //     "subServices", subServices);

                                  // Navigator.of(context).pushNamed(
                                  //   Routes.appointmentTypeScreen,
                                  //   arguments: _appointentTypeMap,
                                  // );
                                  Navigator.of(context).pushNamed(
                                      Routes.providerProfileScreen,
                                      arguments: doctorData["_id"]);
                                },
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              Routes.providerProfileScreen,
                              arguments: doctorData["_id"]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget professionalTitleWidget() {
    return FutureBuilder<List<dynamic>>(
      future: _professionalTitleFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _professionalTitleList = snapshot.data;

          if (_professionalTitleList == null ||
              _professionalTitleList.isEmpty) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Professional titles',
                style: TextStyle(
                  color: AppColors.midnight_express,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                height: 130,
                margin: const EdgeInsets.only(top: 20, bottom: 25),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 13),
                  scrollDirection: Axis.horizontal,
                  itemCount: _professionalTitleList.length,
                  itemBuilder: (context, index) {
                    if (_professionalTitleList == null ||
                        _professionalTitleList.isEmpty) {
                      return Text('No professional titles available');
                    }

                    dynamic professionalTitle = _professionalTitleList[index];

                    return SizedBox(
                      height: 94,
                      width: 132,
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image(
                              image: professionalTitle['image'] == null
                                  ? AssetImage('images/dummy_title_image.png')
                                  : NetworkImage(
                                      ApiBaseHelper.imageUrl +
                                          professionalTitle['image'],
                                    ),
                              width: 132,
                              height: 94,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            professionalTitle['title']?.toString() ?? '---',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ).onClick(
                      onTap: () {
                        conatiner.projectsResponse.clear();
                        conatiner.setProjectsResponse("serviceType", '0');
                        conatiner.setProjectsResponse(
                            "professionalTitleId[${index.toString()}]",
                            professionalTitle['_id']);

                        Navigator.pushNamed(
                          context,
                          Routes.chooseSpecialities,
                          arguments: professionalTitle['_id'].toString(),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget specialtiesWidget() {
    return FutureBuilder<List<dynamic>>(
      future: _specialtiesFuture,
      builder: (context, snapshot) {
        _topSpecialtiesList.clear();

        if (snapshot.hasData) {
          if (snapshot.data != null && snapshot.data.length > 0) {
            for (dynamic specialty in snapshot.data) {
              if (specialty['isFeatured'] != null) {
                if (specialty['isFeatured']) {
                  _topSpecialtiesList.add(specialty);
                }
              }
            }
          }

          if (_topSpecialtiesList == null || _topSpecialtiesList.isEmpty) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Top Specialities',
                style: TextStyle(
                  color: AppColors.midnight_express,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                height: 137,
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 13),
                  scrollDirection: Axis.horizontal,
                  itemCount: _topSpecialtiesList.length,
                  itemBuilder: (context, index) {
                    if (_topSpecialtiesList == null ||
                        _topSpecialtiesList.isEmpty) {
                      return Text('No Specialities available');
                    }

                    dynamic specialty = _topSpecialtiesList[index];

                    return Container(
                      height: 100,
                      width: 132,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[100]),
                      ),
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(14),
                              topRight: Radius.circular(14),
                            ),
                            child: Image(
                              image: specialty['image'] == null
                                  ? AssetImage('images/dummy_title_image.png')
                                  : NetworkImage(
                                      ApiBaseHelper.imageUrl +
                                          specialty['image'],
                                    ),
                              width: 132,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            specialty['title']?.toString() ?? '---',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ).onClick(
                      onTap: () {
                        conatiner.projectsResponse.clear();
                        conatiner.setProjectsResponse(
                            "specialtyId[${index.toString()}]",
                            specialty["_id"]);
                        conatiner.setProjectsResponse("serviceType", '0');

                        Navigator.pushNamed(
                          context,
                          Routes.providerListScreen,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(),
          ),
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
      _locationLoading(true);

      _latLng = latLng;

      // getLocationAddress(latLng.latitude, latLng.longitude);
    }
  }

  initPlatformState() async {
    // _locationLoading(true);

    Loc.Location _location = Loc.Location();
    Loc.PermissionStatus _permission;

    _permission = await _location.requestPermission();
    print("Permission: $_permission");

    switch (_permission) {
      case Loc.PermissionStatus.granted:
      case Loc.PermissionStatus.grantedLimited:
        bool serviceStatus = await _location.serviceEnabled();
        print("Service status: $serviceStatus");

        if (serviceStatus) {
          // Widgets.showToast("Getting Location. Please wait..");

          try {
            // Loc.LocationData
            geoLocation = await _location.getLocation();

            // getLocationAddress(locationData.latitude, locationData.longitude);

            // _latLng = LatLng(
            //     locationData.latitude ?? 0.00, locationData.longitude ?? 0.00);

            // SharedPref().getToken().then((token) {
            //   _myDoctorsFuture = _api.getMyDoctors(token, _latLng);
            // });
          } on PlatformException catch (e) {
            // _locationLoading(false);

            Widgets.showToast(e.message.toString());
            e.toString().debugLog();

            log(e.code);

            _location = null;
          }
        } else {
          bool serviceStatusResult = await _location.requestService();
          print("Service status activated after request: $serviceStatusResult");
          initPlatformState();
        }

        break;
      case Loc.PermissionStatus.denied:
        initPlatformState();
        break;
      case Loc.PermissionStatus.deniedForever:
        break;
    }
  }

  getLocationAddress(latitude, longitude) async {
    try {
      final coordinates = new Coordinates(latitude, longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      conatiner.setUserLocation("latLng", LatLng(latitude, longitude));

      var first = addresses.first.addressLine?.toString();

      if (mounted) {
        setState(() {
          _isLocLoading = false;
          _currentddress = first;
        });

        conatiner.setUserLocation("userAddress", _currentddress);
      }
    } on PlatformException catch (e) {
      _locationLoading(false);
      print(e.message.toString() ?? e.toString());
    }
  }

  void _locationLoading(bool loading) {
    setState(() {
      _isLocLoading = loading;
    });
  }

  void _loading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }
}
