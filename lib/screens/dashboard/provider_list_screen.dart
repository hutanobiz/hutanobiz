import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/arrow_button.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/round_corners_background.dart';

class ProviderListScreen extends StatefulWidget {
  ProviderListScreen({Key key, this.argumentsMap}) : super(key: key);

  final MapArguments argumentsMap;

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

  Map degreeMap;

  List<dynamic> dummySearchList = List();

  @override
  void initState() {
    Map<String, String> map = Map();

    map["professionalTitleId"] = "5e5f7e90a266960a8524f2d5";
    map["specialtyId[]"] = "5e5f7e90a266960a8524f338";
    map["serviceType"] = widget.argumentsMap.map["appointmentType"];

    //TODO: change static professionalTitleId and specialtyId[]
    _providerFuture = api.getProviderList(map);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RoundCornerBackground(
        scaffoldKey: _scaffoldKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            searchBar(),
            SizedBox(height: 23.0),
            listWidget(),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: ArrowButton(
                  iconData: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
              ),
            )
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
        Text(
          "General Medicine",
          style: TextStyle(
            color: AppColors.midnight_express,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 19.0),
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
          if (snapshot.hasData) {
            _responseData = snapshot.data["response"];
            degreeMap = snapshot.data["degree"];

            return _searchText == null || _searchText == ""
                ? _listWidget(degreeMap, _responseData)
                : _listWidget(degreeMap, dummySearchList);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _listWidget(Map degreeMap, List _responseData) {
    return ListView.builder(
      itemCount: _responseData.length,
      itemBuilder: (context, index) {
        List educatonList = _responseData[index]["education"];
        String degree;

        educatonList.map((f) {
          if (degreeMap.containsKey(f["degree"])) {
            degree = degreeMap[f["degree"]];
          }
        }).toList();

        return ProviderWidget(
          data: _responseData[index],
          degree: degree ?? "---",
        );
      },
    );
  }

  void filterSearch(String searchKey) {
    dummySearchList.clear();

    if (searchKey.isNotEmpty) {
      _responseData.forEach((f) {
        if (f["userId"]["fullName"] != null) {
          if (f["userId"]["fullName"]
              .toLowerCase()
              .contains(searchKey.toLowerCase())) {
            dummySearchList.add(f);
          }
        }
      });
    }
  }
}
