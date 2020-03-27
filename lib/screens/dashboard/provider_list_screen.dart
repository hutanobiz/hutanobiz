import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
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

  Map _containerMap;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final _containerMap = InheritedContainer.of(context).getProjectsResponse();
    if (this._containerMap != _containerMap) this._containerMap = _containerMap;

    if (_containerMap.length < 3) {
      if (_containerMap.containsKey("specialityId"))
        _providerFuture = api.getSpecialityProviderList(
            _containerMap["specialityId"].toString());
      else
        _providerFuture =
            api.getServiceProviderList(_containerMap["serviceId"].toString());
    } else {
      _providerFuture = api.getProviderList(_containerMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "General Medicine",
        color: AppColors.snow,
        isAddBack: false,
        addBackButton: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            searchBar(),
            SizedBox(height: 23.0),
            listWidget(),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
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
            hasFloatingPlaceholder: false,
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(fontSize: 13.0, color: Colors.grey),
            labelText: "Search for general medicine",
            suffixIcon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image(
                width: 34.0,
                height: 34.0,
                image: AssetImage("images/ic_search.png"),
              ),
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
      ],
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
                _responseData = snapshot.data["response"];

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
      itemCount: _responseData.length,
      itemBuilder: (context, index) {
        List educatonList = _responseData[index]["education"];
        String degree = "---";

        if (degreeMap != null)
          educatonList.map((f) {
            if (degreeMap.containsKey(f["degree"])) {
              degree = degreeMap[f["degree"]];
            }
          }).toList();

        return ProviderWidget(
          data: _responseData[index],
          degree: degree,
          bookAppointment: () {
            final container = InheritedContainer.of(context);
            container.setProviderData("providerData", _responseData[index]);
            container.setProviderData("degree", degree);

            if (_containerMap.length < 3)
              Navigator.of(context).pushNamed(Routes.appointmentTypeScreen);
            else
              Navigator.of(context)
                  .pushNamed(Routes.selectAppointmentTimeScreen);
          },
        );
      },
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