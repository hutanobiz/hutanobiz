import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/appointment_list_widget.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';

class AppointmentsScreen extends StatefulWidget {
  AppointmentsScreen({Key key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  ApiBaseHelper _api = ApiBaseHelper();

  List<dynamic> _closedAppointmentsList = List();
  List<dynamic> ondemandAppointmentsList = List();
  List<dynamic> _activeAppointmentsList = List();

  Future<dynamic> _requestsFuture;

  var _userLocation = LatLng(0.00, 0.00);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appointmentsFuture(_userLocation);
  }

  void appointmentsFuture(LatLng latLng) {
    SharedPref().getToken().then((token) {
      setState(() {
        _requestsFuture = _api.userAppointments(token, _userLocation);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Appointments",
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: new CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          if (snapshot.data is String) {
            return Center(
              child: Text('No appointments.'),
            );
          } else {
            _closedAppointmentsList.clear();
            ondemandAppointmentsList = snapshot.data["ondemandAppointments"];
            _activeAppointmentsList = snapshot.data["presentRequest"];
            _closedAppointmentsList.addAll(snapshot.data["pastRequest"]);
            _closedAppointmentsList
                .addAll(snapshot.data['onDemandPastRequest']);

            if (_activeAppointmentsList.isEmpty &&
                _closedAppointmentsList.isEmpty &&
                ondemandAppointmentsList.isEmpty)
              return Center(
                child: Text("No appointments."),
              );
            else
              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      heading("On Demand Appointments",
                          ondemandAppointmentsList, 0),
                      ondemandAppointmentsList.isNotEmpty
                          ? _listWidget(ondemandAppointmentsList, 0)
                          : Container(),
                      heading(
                          "Active Appointments", _activeAppointmentsList, 1),
                      _activeAppointmentsList.isNotEmpty
                          ? _listWidget(_activeAppointmentsList, 1)
                          : Container(),
                      heading("Past Appointments", _closedAppointmentsList, 2),
                      _closedAppointmentsList.isNotEmpty
                          ? _listWidget(_closedAppointmentsList, 2)
                          : Container(),
                    ]),
              );
          }
        } else {
          return Center(
            child: new CircularProgressIndicator(),
          );
        }
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
        if (_list == null || _list.length == 0) return Container();

        return _requestList(_list[index], listType);
      },
    );
  }

  Widget _requestList(Map response, int listType) {
    String name = "---",
        avatar,
        averageRating = "---",
        professionalTitle = "---";

    if (response["averageRating"] != null) {
      averageRating = '${response["averageRating"]?.toStringAsFixed(1)}' +
          '(${response['totalRating']})';
    }

    if (response["doctor"] != null) {
      if (response["isOndemand"] == true) {
        name = (response["doctor"][0]["title"] ?? "---") +
                ' ' +
                response["doctor"][0]["fullName"] ??
            "---";
        avatar = response["doctor"][0]["avatar"].toString();
      } else {
        name = (response["doctor"]["title"] ?? "---") +
                ' ' +
                response["doctor"]["fullName"] ??
            "---";
        avatar = response["doctor"]["avatar"].toString();
      }
    }

    if (response["doctorData"] != null) {
      if (response["isOndemand"] == true) {
        if (response["doctorData"]["professionalTitle"] != null) {
          professionalTitle = response["doctorData"]["professionalTitle"][0]
                      ["title"]
                  ?.toString() ??
              "---";
          name += Extensions.getSortProfessionTitle(professionalTitle);
        }
      } else {
        if (response["doctorData"][0]["professionalTitle"] != null) {
          professionalTitle = response["doctorData"][0]["professionalTitle"]
                      ["title"]
                  ?.toString() ??
              "---";
          name += Extensions.getSortProfessionTitle(professionalTitle);
        }
      }
    }

    return AppointmentListWidget(
        context: context,
        response: response,
        avatar: avatar,
        name: name,
        averageRating: averageRating,
        professionalTitle: professionalTitle,
        onTap: () {
          // if (response['type'] != 2) {
          Navigator.of(context)
              .pushNamed(
            Routes.appointmentDetailScreen,
            arguments: response["_id"],
          )
              .then((val) {
            appointmentsFuture(_userLocation);
          });
          // } else {
          //   if (response["status"] == 4) {
          //     Navigator.of(context)
          //         .pushNamed(
          //           Routes.appointmentDetailScreen,
          //           arguments: response["_id"],
          //         )
          //         .whenComplete(() => appointmentsFuture(_userLocation));
          //   } else {
          //     Navigator.pushNamed(
          //             context, Routes.telemedicineTrackTreatmentScreen,
          //             arguments: response["_id"])
          //         .whenComplete(() => appointmentsFuture(_userLocation));
          //   }
          // }
        });
  }
}
