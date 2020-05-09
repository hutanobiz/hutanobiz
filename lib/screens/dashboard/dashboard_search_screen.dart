import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_tile_widget.dart';

class DashboardSearchScreen extends StatefulWidget {
  @override
  _DashboardSearchScreenState createState() => _DashboardSearchScreenState();
}

class _DashboardSearchScreenState extends State<DashboardSearchScreen> {
  String _searchText = "";
  List<dynamic> _servicesList = List();
  List<dynamic> _doctorList = List();
  List<dynamic> _specialityList = List();

  ApiBaseHelper _api = ApiBaseHelper();

  Future<dynamic> _searchFuture;
  InheritedContainerState _container;

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
        color: Colors.white,
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: column(),
      ),
    );
  }

  Widget column() {
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
        _searchText.length < 0 || _searchText == ""
            ? Container()
            : Expanded(child: _buildList()),
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
            _servicesList.addAll(snapshot.data["services"]);
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
                      ? _listWidget(_servicesList, "title", false, 3)
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
                            onTap: () => Navigator.of(context).pushNamed(
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
            return isDoctorList
                ? ProviderTileWidget(
                    name: tempList[index][searchKey],
                    profession: tempList[index][searchKey],
                    onTap: () {
                      _container
                          .setProviderId(tempList[index]["_id"].toString());
                      Navigator.of(context)
                          .pushNamed(Routes.providerProfileScreen);
                    },
                  )
                : ListTile(
                    title: Text(tempList[index][searchKey]),
                    onTap: () {
                      log(type.toString());
                      final container = InheritedContainer.of(context);

                      container.getProjectsResponse().clear();

                      if (type == 1) {
                        container.setProjectsResponse(
                            "specialityId", tempList[index]["_id"]);
                      } else if (type == 3) {
                        InheritedContainer.of(context).setProjectsResponse(
                            "serviceId", tempList[index]["_id"]);
                      }

                      Navigator.of(context)
                          .pushNamed(Routes.providerListScreen);
                    },
                  );
          }

          return Container();
        });
  }
}
