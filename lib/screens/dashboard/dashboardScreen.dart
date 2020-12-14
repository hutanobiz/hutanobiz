import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/provider_tile_widget.dart';
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
  bool isEmailVerified = false;

  String _currentddress;

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

  bool _isLoading = false;
  List<String> _topProvidersList = [
    'Office Appointment',
    'Video Appointment',
    'Onsite Appointment'
  ];

  Future<List<dynamic>> _myDoctorsFuture;
  Future<List<dynamic>> _specialtiesFuture;
  Future<List<dynamic>> _professionalTitleFuture;

  @override
  void initState() {
    super.initState();

    setState(() {
      initPlatformState();
    });

    _professionalTitleFuture = _api.getProfessionalTitle();
    _specialtiesFuture = _api.getSpecialties();
  }

  @override
  void didChangeDependencies() {
    conatiner = InheritedContainer.of(context);
    SharedPref().getValue("isEmailVerified").then((value) {
      if (value == null || value == false) {
        SharedPref().getToken().then((value) {
          _api.profile(value, Map()).then((value) {
            setState(() {
              isEmailVerified = value["response"]["isEmailVerified"] ?? false;
              SharedPref().setBoolValue("isEmailVerified",
                  value["response"]["isEmailVerified"] ?? false);
            });
          });
        });
      } else {
        setState(() {
          isEmailVerified = value;
        });
      }
    });
    _container = InheritedContainer.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white_smoke,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isEmailVerified
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.windsor,
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Email not verified.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            Text(
                              "Resend Verification Link",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ).onClick(onTap: () {
                        _loading(true);
                        SharedPref().getToken().then((value) {
                          Map map = {};
                          map["step"] = "5";
                          _api.emailVerfication(value, map).whenComplete(() {
                            _loading(false);
                            Widgets.showToast(
                                'Verification link sent successfully');
                          }).futureError((error) => _loading(false));
                        });
                      }),
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
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Find Top Providers',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              topProviderWidget(),
                              myDoctorsWidget(),
                              professionalTitleWidget(),
                              specialtiesWidget(),
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
        _isLocLoading
            ? Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : InkWell(
                onTap: () => _navigateToMap(context),
                child: Row(
                  children: <Widget>[
                    _currentddress != null && _currentddress.length > 45
                        ? SizedBox(
                            width: 250,
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
          // onTap: () {
          //   conatiner.projectsResponse.clear();
          //   Navigator.of(context).pushNamed(
          //     Routes.dashboardSearchScreen,
          //     arguments: _topSpecialtiesList,
          //   );
          // },
          // child: Container(
          // width: MediaQuery.of(context).size.width,
          // padding: const EdgeInsets.fromLTRB(12.0, 15.0, 14.0, 14.0),
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("images/ic_search.png"),
          //     alignment: Alignment.centerRight,
          //   ),
          //   color: Colors.white,
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(
          //       8.0,
          //     ),
          //   ),
          // ),
          child: TextFormField(
            maxLines: 1,
            onChanged: (value) {
              _searchText = value;

              setState(() {
                _searchFuture = _api.searchDoctors(_searchText);
              });
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("images/ic_search.png", height: 24),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: AppColors.snow,
              labelStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
              hintText: "Type the name of a provider or specialty",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.windsor),
                borderRadius: BorderRadius.circular(8.0),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.windsor),
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: EdgeInsets.fromLTRB(12.0, 15.0, 14.0, 14.0),
            ),
          ),
        ),
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
                  name: tempList[index][searchKey],
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

                    _container.setProviderId(tempList[index]["_id"].toString());
                    Navigator.of(context)
                        .pushNamed(Routes.providerProfileScreen);
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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'My Doctors',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 175,
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                      height: 173,
                      width: 160,
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
                              width: 72.0,
                              height: 72.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: avatar == null || avatar == "null"
                                  ? Image(
                                      image:
                                          AssetImage('images/profile_user.png'),
                                      height: 72.0,
                                      width: 72.0,
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        ApiBaseHelper.imageUrl + avatar,
                                        width: 72.0,
                                        height: 72.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Text(
                              (doctorData['title']?.toString() ?? 'Dr.') +
                                  ' ' +
                                  (doctorData['fullName']?.toString() ?? '---'),
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
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              width: 160,
                              height: 36,
                              padding: const EdgeInsets.only(top: 9.0),
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
                                  "Book Appointment",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  doctor['distance'] =
                                      _myDoctorsList[index]['distance'];
                                  conatiner.providerResponse.clear();
                                  conatiner.setProviderData(
                                    "providerData",
                                    doctor,
                                  );

                                  conatiner.setProviderData(
                                      "subServices", subServices);

                                  Navigator.of(context).pushNamed(
                                    Routes.appointmentTypeScreen,
                                    arguments: _appointentTypeMap,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          conatiner.setProviderId(doctorData["_id"]);
                          Navigator.of(context)
                              .pushNamed(Routes.providerProfileScreen);
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
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Professional titles',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 130,
                margin: const EdgeInsets.only(top: 20, bottom: 25),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Top Specialities',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 137,
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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

      getLocationAddress(latLng.latitude, latLng.longitude);
    }
  }

  initPlatformState() async {
    _locationLoading(true);

    Location _location = Location();
    PermissionStatus _permission;

    _permission = await _location.requestPermission();
    print("Permission: $_permission");

    switch (_permission) {
      case PermissionStatus.granted:
        bool serviceStatus = await _location.serviceEnabled();
        print("Service status: $serviceStatus");

        if (serviceStatus) {
          Widgets.showToast("Getting Location. Please wait..");

          try {
            LocationData locationData = await _location.getLocation();

            getLocationAddress(locationData.latitude, locationData.longitude);

            _latLng = LatLng(
                locationData.latitude ?? 0.00, locationData.longitude ?? 0.00);

            SharedPref().getToken().then((token) {
              _myDoctorsFuture = _api.getMyDoctors(token, _latLng);
            });
          } on PlatformException catch (e) {
            _locationLoading(false);

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
      case PermissionStatus.denied:
        initPlatformState();
        break;
      case PermissionStatus.deniedForever:
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
