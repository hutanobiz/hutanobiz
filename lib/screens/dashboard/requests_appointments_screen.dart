import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/circular_loader.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/request_list_widget.dart';

class RequestAppointmentsScreen extends StatefulWidget {
  const RequestAppointmentsScreen({Key key}) : super(key: key);

  @override
  _RequestAppointmentsScreenState createState() =>
      _RequestAppointmentsScreenState();
}

class _RequestAppointmentsScreenState extends State<RequestAppointmentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiBaseHelper api = ApiBaseHelper();

  List<dynamic> _closedRequestsList = List();
  List<dynamic> _activeRequestsList = List();
  List<dynamic> ondemandAppointmentsList = List();
  List<dynamic> followupRequestList = List();
  bool isLoading = false;
  Future<dynamic> _requestsFuture;
  InheritedContainerState _container;
  var _userLocation = LatLng(0.00, 0.00);
  String userToken;

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    if (_container.userLocationMap.isNotEmpty) {
      _userLocation =
          _container.userLocationMap['latLng'] ?? LatLng(0.00, 0.00);
    }

    SharedPref().getToken().then((token) {
      setState(() {
        token.toString().debugLog();
        userToken = token;

        requestFuture();
      });
    });

    super.didChangeDependencies();
  }

  void requestFuture() {
    setState(() {
      _requestsFuture = api.appointmentRequests(userToken, _userLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      // backgroundColor: AppColors.goldenTainoi,
      body:
          // LoadingBackgroundNew(
          // addHeader: true,
          //   title: "Requests",
          //   isAddBack: false,
          //   color: Colors.white,
          //   child:
          _buildList(),
      // ),
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
              child: CustomLoader(),
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              _closedRequestsList.clear();
              followupRequestList = snapshot.data['followupRequest'];
              ondemandAppointmentsList = snapshot.data['ondemandAppointments'];
              _activeRequestsList = snapshot.data["presentRequest"];
              _closedRequestsList.addAll(snapshot.data["pastRequest"]);
              _closedRequestsList
                  .addAll(snapshot.data["ondemandExpiredAppointments"]);

              if (_activeRequestsList.length == 0 &&
                  _closedRequestsList.length == 0 &&
                  followupRequestList.length == 0 &&
                  ondemandAppointmentsList.length == 0)
                return Center(
                  child: Text("No Requests."),
                );

              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          heading("FollowUp Requests", followupRequestList, 3),
                          followupRequestList.isNotEmpty
                              ? _listWidget(followupRequestList, 3)
                              : Container(),
                          heading("On Demand Requests",
                              ondemandAppointmentsList, 0),
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
                  ),
                  isLoading ? CircularLoader() : Container(),
                ],
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
      if (response["isOndemand"]) {
        name = (response["doctor"][0]['title']?.toString() ?? 'Dr.') +
                ' ' +
                response["doctor"][0]["fullName"]?.toString() ??
            "---";
        avatar = response["doctor"][0]["avatar"].toString();
        if (response['doctorData'] != null) {
          if (response['doctorData']["professionalTitle"] != null) {
            professionalTitle = response['doctorData']["professionalTitle"][0]
                        ["title"]
                    ?.toString() ??
                "---";
          }
          if (response['doctorData']["education"].isNotEmpty) {
            name += ' ' +
                    response['doctorData']["education"][0]["degree"]
                        ?.toString() ??
                "---";
            ;
          }
        }
      } else if (response['isFollowUp']) {
        name = (response["doctor"]['title']?.toString() ?? 'Dr.') +
                ' ' +
                response["doctor"]["fullName"]?.toString() ??
            "---";
        avatar = response["doctor"]["avatar"].toString();
        if (response['doctorData'] != null) {
          if (response['doctorData'][0]["professionalTitle"] != null) {
            professionalTitle = response['doctorData'][0]["professionalTitle"]
                        ["title"]
                    ?.toString() ??
                "---";
          }
          if (response['doctorData'][0]["education"].isNotEmpty) {
            name += ' ' +
                    response['doctorData'][0]["education"][0]["degree"]
                        ?.toString() ??
                "---";
          }
        }
      } else {
        name = (response["doctor"]['title']?.toString() ?? 'Dr.') +
                ' ' +
                response["doctor"]["fullName"]?.toString() ??
            "---";
        avatar = response["doctor"]["avatar"].toString();
        if (response['doctorData'] != null) {
          if (response['doctorData'][0]["professionalTitle"] != null) {
            professionalTitle = response['doctorData'][0]["professionalTitle"]
                        ["title"]
                    ?.toString() ??
                "---";
          }
          if (response['doctorData'][0]["education"].isNotEmpty) {
            name += ' ' +
                    response['doctorData'][0]["education"][0]["degree"]
                        ?.toString() ??
                "---";
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
      professionalTitle: professionalTitle,
      listType: listType,
      onRequestTap: () {
        Navigator.of(context)
            .pushNamed(
              Routes.requestDetailScreen,
              arguments: response['_id'],
            )
            .whenComplete(() => requestFuture());
      },
      onAcceptTap: listType == 3
          ? () {
              var locMap = {};
              locMap['lattitude'] = 0;
              locMap['longitude'] = 0;
              setState(() {
                isLoading = true;
              });
              api
                  .getProviderProfile(response['doctor']['_id'], locMap)
                  .then((value) {
                _container.setProviderData("providerData", value);
                _container.setServicesData("status", "2");
                _container.setServicesData("consultaceFee", '10');
                setState(() {
                  isLoading = false;
                });
                Navigator.pushNamed(context, Routes.paymentMethodScreen,
                    arguments: {
                      'paymentType': 2,
                      'appointmentId': response['_id']
                    }).whenComplete(() => requestFuture());
              });
            }
          : null,
      onRescheduleTap: listType == 3
          ? () {
              var locMap = {};
              locMap['lattitude'] = 0;
              locMap['longitude'] = 0;
              setState(() {
                isLoading = true;
              });
              api
                  .getProviderProfile(response['doctor']['_id'], locMap)
                  .then((value) {
                _container.setProviderData("providerData", value);

                _container.setProjectsResponse(
                    'serviceType', response['type'].toString());
                _container.setServicesData("status", "2");
                _container.setServicesData("consultaceFee", '10');
                setState(() {
                  isLoading = false;
                });
                // if (profileMap['subServices'].length > 0) {
                //   _container.setServicesData("status", "1");
                //   _container.setServicesData(
                //       "services", profileMap['subServices']);

                //   Navigator.of(context).pushNamed(
                //       Routes.selectAppointmentTimeScreen,
                //       arguments: SelectDateTimeArguments(
                //           fromScreen: 3, appointmentId: response['_id']));
                // } else {

                Navigator.of(context)
                    .pushNamed(Routes.selectAppointmentTimeScreen,
                        arguments: SelectDateTimeArguments(
                            fromScreen: 3, appointmentId: response['_id']))
                    .whenComplete(() => requestFuture());
                // }
              });
            }
          : null,
    );
  }
}
