import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/request_list_widget.dart';

class RequestAppointmentsScreen extends StatefulWidget {
  const RequestAppointmentsScreen({Key key}) : super(key: key);

  @override
  _RequestAppointmentsScreenState createState() =>
      _RequestAppointmentsScreenState();
}

class _RequestAppointmentsScreenState extends State<RequestAppointmentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiBaseHelper _api = ApiBaseHelper();

  List<dynamic> _closedRequestsList = List();
  List<dynamic> _activeRequestsList = List();
  List<dynamic> ondemandAppointmentsList = List();

  Future<dynamic> _requestsFuture;

  var _userLocation = LatLng(0.00, 0.00);

  @override
  void didChangeDependencies() {
    var _container = InheritedContainer.of(context);

    if (_container.userLocationMap.isNotEmpty) {
      _userLocation =
          _container.userLocationMap['latLng'] ?? LatLng(0.00, 0.00);
    }

    SharedPref().getToken().then((token) {
      setState(() {
        token.toString().debugLog();
        _requestsFuture = _api.appointmentRequests(token, _userLocation);
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Requests",
        isAddBack: false,
        color: Colors.white,
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return FutureBuilder<dynamic>(
      future: _requestsFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("No Requests."),
            );
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
              _closedRequestsList.clear();
              ondemandAppointmentsList = snapshot.data['ondemandAppointments'];
              _activeRequestsList = snapshot.data["presentRequest"];
              _closedRequestsList.addAll(snapshot.data["pastRequest"]);
              _closedRequestsList
                  .addAll(snapshot.data["ondemandExpiredAppointments"]);

              if (_activeRequestsList.length == 0 &&
                  _closedRequestsList.length == 0 &&
                  ondemandAppointmentsList.length == 0)
                return Center(
                  child: Text("No Requests."),
                );

              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      heading(
                          "On Demand Requests", ondemandAppointmentsList, 0),
                      ondemandAppointmentsList.isNotEmpty
                          ? _listWidget(ondemandAppointmentsList, 0)
                          : Container(),
                      heading("Active Requests", _activeRequestsList, 1),
                      _activeRequestsList.isNotEmpty
                          ? _listWidget(_activeRequestsList, 1)
                          : Container(),
                      heading("Past Requests", _closedRequestsList, 2),
                      _closedRequestsList.isNotEmpty
                          ? _listWidget(_closedRequestsList, 2)
                          : Container(),
                    ]),
              );
            } else if (snapshot.hasError) {
              return Text('No Requests.');
            }
        }
        return null;
      },
    );
  }

  Widget heading(String heading, List<dynamic> list, int type) {
    return list.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                heading,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Divider(),
            ],
          )
        : Container();
  }

  Widget _listWidget(List<dynamic> _list, int listType) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _list.length,
      itemBuilder: (context, index) {
        return _requestList(_list[index], listType);
      },
    );
  }

  Widget _requestList(Map response, int listType) {
    String name = "---", avatar, professionalTitle = '';

    if (response["doctor"] != null) {
      if (response["isOndemand"] == true) {
        name = response["doctor"][0]["fullName"]?.toString() ?? "---";
        avatar = response["doctor"][0]["avatar"].toString();
        if (response['doctorData'] != null) {
          if (response['doctorData']["professionalTitle"] != null) {
            professionalTitle = response['doctorData']["professionalTitle"][0]
                        ["title"]
                    ?.toString() ??
                "---";
            name += Extensions.getSortProfessionTitle(professionalTitle);
          }
        }
      } else {
        name = response["doctor"]["fullName"]?.toString() ?? "---";
        avatar = response["doctor"]["avatar"].toString();
        if (response['doctorData'] != null) {
          if (response['doctorData'][0]["professionalTitle"] != null) {
            professionalTitle = response['doctorData'][0]["professionalTitle"]
                        ["title"]
                    ?.toString() ??
                "---";
            name += Extensions.getSortProfessionTitle(professionalTitle);
          }
        }
      }
    }

    String averageRating = "";
    if (response["averageRating"] != null) {
      averageRating =
          "${response["averageRating"].toStringAsFixed(1)} (${response["totalRating"]})";
    }

    return RequestListWidget(
        context: context,
        response: response,
        avatar: avatar,
        name: name,
        averageRating: averageRating,
        professionalTitle: professionalTitle);
  }
}
