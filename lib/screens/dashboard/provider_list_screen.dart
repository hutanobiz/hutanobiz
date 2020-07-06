import 'package:flutter/material.dart';
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
    'Onsite'
  ];

  String _selectedAppointmentType;

  Map _containerMap;
  InheritedContainerState _container;

  Map filterMap = {};

  Map _projectResponse;

  Map _appointmentFilterMap = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    _projectResponse = _container.getProjectsResponse();
    if (this._containerMap != _projectResponse) {
      this._containerMap = _projectResponse;
    }

    if (_projectResponse.containsKey("specialityId"))
      _providerFuture = api.getSpecialityProviderList(
          _projectResponse["specialityId"].toString());
    else if (_projectResponse.containsKey("serviceId"))
      _providerFuture =
          api.getServiceProviderList(_projectResponse["serviceId"].toString());
    else {
      _providerFuture = api.getProviderList(_projectResponse);
    }

    _selectedAppointmentType = _projectResponse['serviceType'].toString();
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
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
        ),
        SizedBox(width: 12),
        Image(
          width: 42.0,
          height: 42.0,
          image: AssetImage("images/ic_filter.png"),
        ).onClick(onTap: () {
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
                SharedPref().getToken().then((token) {
                  setState(() {
                    _providerFuture = api.providerFilter(token, filterMap);
                  });
                });
              }
            }
          });
        }),
      ],
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
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        itemCount: _appointmentTypeFilterList.length,
        itemBuilder: (context, index) {
          String _appointmentType = _appointmentTypeFilterList[index];

          return _appointmentTypeWidget(
            _appointmentType,
            _selectedAppointmentType == index.toString(),
            onClick: () {
              if (this._selectedAppointmentType == index.toString()) return;

              setState(() {
                this._selectedAppointmentType = index.toString();
                _appointmentFilterMap.clear();
              });

              switch (index) {
                case 0:
                  _appointmentFilterMap['isOfficeEnabled'] = '1';
                  _appointmentFilterMap['isVideoChatEnabled'] = '1';
                  _appointmentFilterMap['isOnsiteEnabled'] = '1';

                  // setState(() {
                  //   _providerFuture = api.getProviderList(_projectResponse);
                  // });
                  break;
                case 1:
                  _appointmentFilterMap['isOfficeEnabled'] = '1';
                  break;
                case 2:
                  _appointmentFilterMap['isVideoChatEnabled'] = '1';
                  break;
                case 3:
                  _appointmentFilterMap['isOnsiteEnabled'] = '1';
                  break;
              }

              // if (index != 0) {
              _appointmentFilterMap['specialtyId[]'] =
                  _projectResponse['specialtyId[]'];
              SharedPref().getToken().then((token) {
                setState(() {
                  _providerFuture =
                      api.providerFilter(token, _appointmentFilterMap);
                });
              });
              // }
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
                if ((filterMap != null && filterMap.length > 0) ||
                    (_appointmentFilterMap != null &&
                        _appointmentFilterMap.length > 0)) {
                  // if (((filterMap != null && filterMap.length > 0) ||
                  //         (_appointmentFilterMap != null &&
                  //             _appointmentFilterMap.length > 0)) &&
                  //     _selectedAppointmentType != '0') {
                  _responseData = snapshot.data["response"]['providerData'];
                } else {
                  _responseData = snapshot.data["response"];
                }

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
      padding: const EdgeInsets.only(bottom: 50),
      itemCount: _responseData.length,
      itemBuilder: (context, index) {
        dynamic _provider = _responseData[index];

        Map _appointentTypeMap = {};

        _appointentTypeMap["isOfficeEnabled"] = _provider["isOfficeEnabled"];
        _appointentTypeMap["isVideoChatEnabled"] =
            _provider["isVideoChatEnabled"];
        _appointentTypeMap["isOnsiteEnabled"] = _provider["isOnsiteEnabled"];

        return InkWell(
          onTap: () {
            _container.setProviderId(_provider["userId"]["_id"]);
            Navigator.of(context).pushNamed(Routes.providerProfileScreen);
          },
          child: ProviderWidget(
            data: _provider,
            averageRating:
                _provider['averageRating']?.toStringAsFixed(2) ?? "0",
            bookAppointment: () {
              _container.getProviderData().clear();

              _container.setProviderData("providerData", _provider);

              Navigator.of(context).pushNamed(
                Routes.appointmentTypeScreen,
                arguments: _appointentTypeMap,
              );
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
      _responseData.forEach((f) {
        if (f["userId"]["fullName"] != null) {
          if (f["userId"]["fullName"]
              .toLowerCase()
              .contains(searchKey.toLowerCase())) {
            _dummySearchList.add(f);
          }
        }
      });
    }
  }
}
