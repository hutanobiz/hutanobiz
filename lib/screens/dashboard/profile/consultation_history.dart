import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/appointment_list_widget.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:intl/intl.dart';

class ConsultationHistoryScreen extends StatefulWidget {
  ConsultationHistoryScreen({Key? key}) : super(key: key);

  @override
  _ConsultationHistoryScreenState createState() =>
      _ConsultationHistoryScreenState();
}

class _ConsultationHistoryScreenState extends State<ConsultationHistoryScreen> {
  ApiBaseHelper _api = ApiBaseHelper();

  List<dynamic> _closedAppointmentsList = [];
  // List<dynamic> ondemandAppointmentsList = List();
  // List<dynamic> _activeAppointmentsList = List();

  Future<dynamic>? _requestsFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appointmentsFuture();
  }

  void appointmentsFuture() {
    _requestsFuture = _api.userAppointments(
        "Bearer ${getString(PreferenceKey.tokens)}", LatLng(0.00, 0.00));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
            title: "",
            padding: const EdgeInsets.only(bottom: 0),
            isAddBack: false,
            addHeader: true,
            isBackRequired: true,
            child: FutureBuilder<dynamic>(
              future: _requestsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: new CustomLoader(),
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

                    _closedAppointmentsList
                        .addAll(snapshot.data["ondemandAppointments"]);
                    _closedAppointmentsList
                        .addAll(snapshot.data["presentRequest"]);
                    _closedAppointmentsList
                        .addAll(snapshot.data["pastRequest"]);
                    _closedAppointmentsList
                        .addAll(snapshot.data['onDemandPastRequest']);

                    if (_closedAppointmentsList.isEmpty)
                      return Center(
                        child: Text("No Document Uploaded Yet."),
                      );
                    else
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: Text('Consultation History',
                                style: AppTextStyle.boldStyle(fontSize: 16)),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _closedAppointmentsList.length,
                              itemBuilder: (context, index) {
                                if (_closedAppointmentsList == null ||
                                    _closedAppointmentsList.length == 0)
                                  return Container();

                                return _requestList(
                                    _closedAppointmentsList[index]);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container();
                              },
                            ),
                          ),
                        ],
                      );
                  }
                } else {
                  return Center(
                    child: new CustomLoader(),
                  );
                }
              },
            )));
  }

  Widget _requestList(Map response) {
    String name = "---";
    String? avatar, averageRating = "---", professionalTitle = "---";

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
        if (response["doctorData"]["professionalTitle"].isNotEmpty) {
          professionalTitle = response["doctorData"]["professionalTitle"][0]
                      ["title"]
                  ?.toString() ??
              "---";
        }
        if (response["doctorData"]["education"].isNotEmpty) {
          name += ' ' +
              (response["doctorData"]["education"][0]["degree"]?.toString() ??
                  "---");
        }
      } else {
        if (response["doctorData"][0]["professionalTitle"] != null) {
          professionalTitle = response["doctorData"][0]["professionalTitle"]
                      ["title"]
                  ?.toString() ??
              "---";
        }
        if (response["doctorData"][0]["education"].isNotEmpty) {
          name += ' ' +
              (response["doctorData"][0]["education"][0]["degree"]
                      ?.toString() ??
                  "---");
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
          Navigator.of(context).pushNamed(
            Routes.appointmentDetailScreen,
            arguments: response["_id"],
          );
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

  rowWidget(String key, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [
        SizedBox(width: 40),
        Expanded(
          child: Text(
            key,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ]),
    );
  }

  dateTime(response) {
    DateTime date = DateTime.utc(
            DateTime.parse(response['date']).year,
            DateTime.parse(response['date']).month,
            DateTime.parse(response['date']).day,
            int.parse(response['fromTime'].split(':')[0]),
            int.parse(response['fromTime'].split(':')[1]))
        .toLocal();
    return date;
  }
}
