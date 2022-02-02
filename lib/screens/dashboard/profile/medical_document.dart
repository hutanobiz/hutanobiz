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
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:intl/intl.dart';

class MedicalDocumentsScreen extends StatefulWidget {
  MedicalDocumentsScreen({Key key}) : super(key: key);

  @override
  _MedicalDocumentsScreenState createState() => _MedicalDocumentsScreenState();
}

class _MedicalDocumentsScreenState extends State<MedicalDocumentsScreen> {
  ApiBaseHelper _api = ApiBaseHelper();

  List<dynamic> _closedAppointmentsList = List();
  // List<dynamic> ondemandAppointmentsList = List();
  // List<dynamic> _activeAppointmentsList = List();

  Future<dynamic> _requestsFuture;

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
                    if (snapshot.data["pastRequest"].length > 0) {
                      for (dynamic app in snapshot.data["pastRequest"]) {
                        if (app['status'] == 4) {
                          _closedAppointmentsList.add(app);
                        }
                      }
                    }
                    if (snapshot.data["onDemandPastRequest"].length > 0) {
                      for (dynamic app
                          in snapshot.data["onDemandPastRequest"]) {
                        if (app['status'] == 4) {
                          _closedAppointmentsList.add(app);
                        }
                      }
                    }
                    // _closedAppointmentsList
                    //     .addAll(snapshot.data["pastRequest"]);
                    // _closedAppointmentsList
                    //     .addAll(snapshot.data['onDemandPastRequest']);

                    if (_closedAppointmentsList.isEmpty)
                      return Center(
                        child: Text("No documents."),
                      );
                    else
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 20),
                            child: Text('Appointment Documents',
                                style: AppTextStyle.boldStyle(fontSize: 16)),
                          ),
                          ListView.separated(
                            // padding: EdgeInsets.symmetric(horizontal: 20),
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _closedAppointmentsList.length,
                            itemBuilder: (context, index) {
                              if (_closedAppointmentsList == null ||
                                  _closedAppointmentsList.length == 0)
                                return Container();

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: _requestList(
                                    _closedAppointmentsList[index]),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                height: 1,
                                color: Colors.grey[400],
                              );
                            },
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
        if (response["doctorData"]["professionalTitle"].isNotEmpty) {
          professionalTitle = response["doctorData"]["professionalTitle"][0]
                      ["title"]
                  ?.toString() ??
              "---";
        }
        if (response["doctorData"]["education"].isNotEmpty) {
          name += ' ' +
                  response["doctorData"]["education"][0]["degree"]
                      ?.toString() ??
              "---";
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
                  response["doctorData"][0]["education"][0]["degree"]
                      ?.toString() ??
              "---";
        }
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
            hasIcon: true,
            iconSize: spacing30,
            iconColor: colorBlack60,
            iconPadding: EdgeInsets.only(top: spacing15)),
        header: Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(ApiBaseHelper.image_base_url + avatar,
                  height: 30, width: 30)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Provider Name',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ]),
        expanded: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          offset: Offset(300, 50),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'view',
              textStyle: TextStyle(
                  color: colorBlack2,
                  fontWeight: fontWeightRegular,
                  fontSize: spacing12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_red_eye,
                    size: 15,
                  ),
                  SizedBox(
                    width: spacing5,
                  ),
                  Text('View')
                ],
              ),
            ),

            // _popMenuCommonItem(context, Localization.of(context).remove,
            // FileConstants.icRemoveBlack)
          ],
          onSelected: (value) {
            if (value == "view") {
              Navigator.pushNamed(context, Routes.completedAppointmentSummary,
                  arguments: response["_id"]);
            } else {}
          },
          child: Column(
            children: [
              rowWidget('Date',
                  DateFormat(Strings.datePattern).format(dateTime(response))),
              rowWidget('Time',
                  DateFormat(Strings.timePattern).format(dateTime(response))),
              rowWidget(
                  'Appointment Type',
                  response["type"] == 1
                      ? "Office Appt."
                      : response["type"] == 2
                          ? "Video Appt."
                          : "Onsite Appt."),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(children: [
                  SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ]),
              ),
              rowWidget('Action', '...'),
            ],
          ),
        ),
        collapsed: null,
      ),
    );
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
