import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_tile_widget.dart';

class DashboardSearchScreen extends StatefulWidget {
  final List topSpecialtiesList;

  const DashboardSearchScreen({Key key, this.topSpecialtiesList})
      : super(key: key);

  @override
  _DashboardSearchScreenState createState() => _DashboardSearchScreenState();
}

class _DashboardSearchScreenState extends State<DashboardSearchScreen> {
  String _searchText = "";
  List<dynamic> _servicesList = List();
  List<dynamic> _doctorList = List();
  List<dynamic> _specialityList = List();
  List<dynamic> _professionalTitleList = List();

  ApiBaseHelper _api = ApiBaseHelper();

  Future<dynamic> _searchFuture;
  InheritedContainerState _container;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _isLoading = true;

    _api.getProfessionalTitle().then((value) {
      if (value != null) {
        setState(() {
          _isLoading = false;
          _professionalTitleList = value;
        });
      }
    }).futureError((error) {
      setState(() {
        _isLoading = false;
      });
      error.toString().debugLog();
    });

    if (widget.topSpecialtiesList != null) {
      _specialityList = widget.topSpecialtiesList;
    } else {
      _specialityList.clear();
      _api.getSpecialties().then((value) {
        if (value != null) {
          if (value != null && value.length > 0) {
            for (dynamic specialty in value) {
              if (specialty['isFeatured'] != null) {
                if (specialty['isFeatured']) {
                  _specialityList.add(specialty);
                }
              }
            }
          }

          setState(() {
            _isLoading = false;
          });
        }
      }).futureError((error) {
        setState(() {
          _isLoading = false;
        });
        error.toString().debugLog();
      });
    }
  }

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Search",
        isLoading: _isLoading,
        color: Colors.white,
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: column(),
      ),
    );
  }

  Widget column() {
    if (widget.topSpecialtiesList != null) {
      _specialityList = widget.topSpecialtiesList;
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: AppColors.snow,
              labelStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
              labelText: "Search for doctors or by specialty...",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
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
        Expanded(
          child: _searchText.length < 0 || _searchText == ""
              ? SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      heading("Professional Title", _professionalTitleList, 1),
                      _specialityList.isNotEmpty
                          ? _listWidget(
                              _professionalTitleList, "title", false, 0)
                          : Container(),
                      heading("Specialities", _specialityList, 1),
                      _specialityList.isNotEmpty
                          ? _listWidget(_specialityList, "title", false, 1)
                          : Container(),
                    ],
                  ),
                )
              : _buildList(),
        ),
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
            physics: ClampingScrollPhysics(),
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

  Widget heading(String heading, List<dynamic> list, int type) {
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
                list.isNotEmpty
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
      physics: ClampingScrollPhysics(),
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
                  name: tempList[index][searchKey],
                  profession: professionalTitle,
                  onTap: () {
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
                          _container.projectsResponse.clear();

                          if (type == 1) {
                            _container.setProjectsResponse(
                                "specialtyId[]", tempList[index]["_id"]);
                          } else if (type == 3) {
                            _container.setProjectsResponse(
                                "subServices[]", tempList[index]["_id"]);
                          }

                          _container.setProjectsResponse("serviceType", '0');
                          _container.setProjectsResponse(
                              "index", index.toString());

                          Navigator.of(context)
                              .pushNamed(Routes.providerListScreen);
                        },
                );
        }

        return Container();
      },
    );
  }
}
