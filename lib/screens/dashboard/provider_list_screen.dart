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
  Future<dynamic> _todoFuture;

  Map selecteddynamic = Map();

  @override
  void initState() {
    Map<String, String> map = Map();

    map["professionalTitleId"] = "5e5f7e90a266960a8524f2d5";
    map["specialtyId[]"] = "5e5f7e90a266960a8524f338";
    map["serviceType"] = widget.argumentsMap.map["appointmentType"];

    //TODO: change static professionalTitleId and specialtyId[]
    _todoFuture = api.getProviderList(map);

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
        future: _todoFuture,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> data = snapshot.data["response"];
            String degree;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Map degreeMap = snapshot.data["degree"];
                List educatonList = data[index]["education"];

                educatonList.map((f) {
                  if (degreeMap.containsKey(f["degree"])) {
                    degree = degreeMap[f["degree"]];
                  }
                }).toList();

                return ProviderWidget(
                  data: data[index],
                  degree: degree ?? "---",
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
      ),
    );
  }
}
