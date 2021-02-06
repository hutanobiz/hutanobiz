import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';

class ProviderListScreen extends StatefulWidget {
  ProviderListScreen({Key key}) : super(key: key);

  @override
  _ProviderListScreenState createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormFieldState> _searchKey = GlobalKey<FormFieldState>();

  ApiBaseHelper api = new ApiBaseHelper();
  Future<dynamic> _providerFuture;

  List<dynamic> _responseData;
  String _searchText = "";

  Map _degreeMap;

  List<dynamic> _dummySearchList = List();

  List<String> _appointmentTypeFilterList = [
    'All',
    'Office',
    'Video',
    'Onsite',
    'Filter'
  ];

  String _selectedAppointmentType;

  Map _containerMap;
  InheritedContainerState _container;

  Map filterMap = {};

  Map _projectResponse = {};

  Map _appointmentFilterMap = {};

  String token = '';

  LatLng _userLocation = LatLng(0, 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    _projectResponse = _container.getProjectsResponse();
    _selectedAppointmentType = _projectResponse['serviceType'].toString();

    if (this._containerMap != _projectResponse) {
      this._containerMap = _projectResponse;
    }

    Map _providerMap = {};

    _providerMap.clear();
    _providerMap.addAll(_projectResponse);

    switch (_providerMap['serviceType']) {
      case '1':
        _providerMap['isOfficeEnabled'] = '1';
        break;
      case '2':
        _providerMap['isVideoChatEnabled'] = '1';
        break;
      case '3':
        _providerMap['isOnsiteEnabled'] = '1';
        break;
    }

    if (_container.userLocationMap.isNotEmpty) {
      _userLocation = _container.userLocationMap['latLng'];

      _providerMap['lattitude'] = _userLocation.latitude.toStringAsFixed(2);
      _providerMap['longitude'] = _userLocation.longitude.toStringAsFixed(2);
    }

    _providerMap.remove('serviceType');

    filterMap = _providerMap;

    SharedPref().getToken().then((token) {
      setState(() {
        this.token = token;
        _providerFuture = api.providerFilter(token, _providerMap);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Providers List",
        color: AppColors.snow,
        isAddBack: false,
        addBackButton: true,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            searchBar(),
            appointmentTypeFilter(),
            SizedBox(height: 23.0),
            listWidget(),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
        key: _searchKey,
        maxLines: 1,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() {
            _searchText = value;
          });
          filterSearch(value);
        },
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
          labelText: "Search for providers",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.fromLTRB(12.0, 15.0, 14.0, 14.0),
        ),
      ),
    );
  }

  Widget appointmentTypeFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(top: 14),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 10),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        itemCount: _appointmentTypeFilterList.length,
        itemBuilder: (context, index) {
          String _appointmentType = _appointmentTypeFilterList[index];

          return _appointmentType.toLowerCase().contains('filter')
              ? InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (filterMap == null || filterMap.isEmpty) {
                      filterMap = _projectResponse;
                    }

                    Navigator.of(context)
                        .pushNamed(
                      Routes.providerFiltersScreen,
                      arguments: filterMap,
                    )
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          filterMap = value;
                        });

                        if (filterMap.length > 0) {
                          setState(() {
                            _providerFuture =
                                api.providerFilter(token, filterMap);
                          });
                        }
                      }
                    });
                  },
                  child: Container(
                    height: 42,
                    width: 96,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.windsor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        'filter_icon'.imageIcon(),
                        SizedBox(width: 5),
                        Text(
                          _appointmentType,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : _appointmentTypeWidget(
                  _appointmentType,
                  _selectedAppointmentType == index.toString(),
                  onClick: () {
                    if (this._selectedAppointmentType == index.toString())
                      return;

                    setState(() {
                      this._selectedAppointmentType = index.toString();
                      _appointmentFilterMap.clear();
                    });

                    if (filterMap != null && filterMap.length > 0) {
                      _appointmentFilterMap.addAll(filterMap);
                    } else {
                      _appointmentFilterMap.addAll(_projectResponse);
                    }

                    switch (index) {
                      case 1:
                        _appointmentFilterMap['isOfficeEnabled'] = '1';
                        _appointmentFilterMap.remove('isOnsiteEnabled');
                        _appointmentFilterMap.remove('isVideoChatEnabled');
                        break;
                      case 2:
                        _appointmentFilterMap['isVideoChatEnabled'] = '1';
                        _appointmentFilterMap.remove('isOnsiteEnabled');
                        _appointmentFilterMap.remove('isOfficeEnabled');
                        break;
                      case 3:
                        _appointmentFilterMap['isOnsiteEnabled'] = '1';
                        _appointmentFilterMap.remove('isOfficeEnabled');
                        _appointmentFilterMap.remove('isVideoChatEnabled');
                        break;
                      default:
                        _appointmentFilterMap.remove('isOnsiteEnabled');
                        _appointmentFilterMap.remove('isVideoChatEnabled');
                        _appointmentFilterMap.remove('isOfficeEnabled');
                    }

                    SharedPref().getToken().then((token) {
                      setState(() {
                        _providerFuture =
                            api.providerFilter(token, _appointmentFilterMap);
                      });
                    });
                  },
                );
        },
      ),
    );
  }

  Widget listWidget() {
    return Expanded(
      child: FutureBuilder<dynamic>(
        future: _providerFuture,
        builder: (_, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("NO data available");
              break;
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                _responseData = snapshot.data["response"]['providerData'];

                if (snapshot.data["degree"] != null)
                  _degreeMap = snapshot.data["degree"];

                return _searchText == null || _searchText == ""
                    ? _listWidget(_degreeMap, _responseData)
                    : _listWidget(_degreeMap, _dummySearchList);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              break;
          }
          return null;
        },
      ),
    );
  }

  Widget _listWidget(Map degreeMap, List _responseData) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 70),
      itemCount: _responseData.length,
      itemBuilder: (context, index) {
        dynamic _provider = _responseData[index]['provider'];
        dynamic subServices = _responseData[index]['subServices'];

        Map _appointentTypeMap = {};

        _appointentTypeMap["isOfficeEnabled"] = _provider["isOfficeEnabled"];
        _appointentTypeMap["isVideoChatEnabled"] =
            _provider["isVideoChatEnabled"];
        _appointentTypeMap["isOnsiteEnabled"] = _provider["isOnsiteEnabled"];

        return InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            if (_provider["userId"] != null && _provider["userId"] is Map) {
              _container.setProviderId(_provider["userId"]["_id"]);
            } else if (_provider["User"] != null &&
                _provider["User"].length > 0) {
              _container.setProviderId(_provider["User"][0]["_id"]);
            }

            _container.setProjectsResponse(
                "serviceType", _selectedAppointmentType);

            Navigator.of(context).pushNamed(
              Routes.providerProfileScreen,
              arguments: _selectedAppointmentType,
            );
          },
          child: ProviderWidget(
            data: _provider,
            selectedAppointment: _selectedAppointmentType,
            averageRating:
                _provider['averageRating']?.toStringAsFixed(2) ?? "0",
            bookAppointment: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _container.providerResponse.clear();

              _container.setProviderData("providerData", _provider);
              _container.setProviderData("subServices", subServices);

              if (_selectedAppointmentType == '0') {
                Navigator.of(context).pushNamed(
                  Routes.appointmentTypeScreen,
                  arguments: _appointentTypeMap,
                );
              } else {
                _container.setProjectsResponse(
                    "serviceType", _selectedAppointmentType);

                Navigator.of(context).pushNamed(Routes.selectServicesScreen);
              }
            },
          ),
        );
      },
    );
  }

  Widget _appointmentTypeWidget(String title, bool isSelected,
      {Function onClick}) {
    String icon = title.toLowerCase().contains('office')
        ? (isSelected ? 'ic_office_app' : 'ic_office_app_unselected')
        : title.toLowerCase().contains('video')
            ? (isSelected ? 'ic_video_app' : 'ic_video_app_unselected')
            : title.toLowerCase().contains('onsite')
                ? (isSelected ? 'ic_onsite_app' : 'ic_onsite_app_unselected')
                : '';

    return InkWell(
      onTap: onClick,
      child: Container(
        height: 42,
        width: title.toLowerCase().contains('all') ? 64 : 96,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.windsor.withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.windsor.withOpacity(0.16),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title.toLowerCase().contains('all')
                ? Container()
                : icon.imageIcon(
                    width: 21,
                    height: 21,
                  ),
            title.toLowerCase().contains('all')
                ? Container()
                : SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                color: AppColors.windsor.withOpacity(0.85),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }

  void filterSearch(String searchKey) {
    _dummySearchList.clear();

    if (searchKey.isNotEmpty) {
      _dummySearchList = _responseData.where((f) {
        if (f['provider']["userId"] != null &&
            f['provider']["userId"] is Map &&
            f['provider']["userId"]["fullName"]
                .toLowerCase()
                .contains(searchKey.toLowerCase())) {
          return true;
        } else if (f['provider']["User"] != null &&
            f['provider']["User"].length > 0 &&
            f['provider']["User"][0]["fullName"] != null &&
            f['provider']["User"][0]["fullName"]
                .toLowerCase()
                .contains(searchKey.toLowerCase())) {
          return true;
        }

        return false;
      }).toList();
    }
  }
}
