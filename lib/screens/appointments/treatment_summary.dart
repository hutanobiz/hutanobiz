import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:intl/intl.dart';

class TreatmentSummaryScreen extends StatefulWidget {
  final Map providerData;

  TreatmentSummaryScreen({Key key, @required this.providerData})
      : super(key: key);

  @override
  _TreatmentSummaryScreenState createState() => _TreatmentSummaryScreenState();
}

class _TreatmentSummaryScreenState extends State<TreatmentSummaryScreen> {
  Map appointmentData = Map();

  List<String> administrationRoute = new List();
  List<String> recommendFollowList = new List();
  List followUpServicesList = new List();
  List medicalHistoryList = new List();
  String drugs = "---";
  Map userMap = Map();
  String name = "---", type = "---", durationOfSymtoms = "---";
  String initiated = "---";
  String completed = "---";
  String serviceType = "---";

  Map followUpMap = Map();

  @override
  void initState() {
    super.initState();

    if (widget.providerData != null) {
      Map providerData = widget.providerData;
      if (providerData["data"] != null) {
        appointmentData = providerData["data"];
      } else {
        appointmentData = providerData;
      }

      if (providerData["followUpAppointment"] != null &&
          providerData["followUpAppointment"].length > 0) {
        followUpMap["time"] =
            providerData["followUpAppointment"][0]["fromTime"];
        followUpMap["date"] =
            DateTime.parse(providerData["followUpAppointment"][0]["date"]);
        followUpMap["service"] =
            providerData["followUpAppointment"][0]["type"].toString();
        if (providerData["followUpAppointment"][0]["services"] != null &&
            providerData["followUpAppointment"][0]["services"].length > 0) {
          followUpMap["status"] = "1";
          List<Services> list = List();
          for (dynamic subService in providerData["followUpAppointment"][0]
              ["services"]) {
            list.add(Services.fromJson(subService));
          }
          followUpMap["services"] = list;
        } else {
          followUpMap["status"] = "2";
        }
      }
    }

    if (followUpMap["service"] != null) {
      serviceType = followUpMap["service"] == "1"
          ? "Office appointment"
          : followUpMap["service"] == "2"
              ? "Video Chat APpointment"
              : followUpMap["service"] == "3" ? "Onsite Appointment" : "---";
    }

    if (appointmentData != null) {
      durationOfSymtoms =
          appointmentData["problemTimeSpan"]?.toString() ?? "---";

      String date = DateFormat('dd MMMM yyyy')
          .format(DateTime.parse(appointmentData['date']))
          .toString();

      if (appointmentData["trackingStatus"] != null) {
        if (appointmentData["trackingStatus"]["treatmentStarted"] != null) {
          initiated = appointmentData["trackingStatus"]["treatmentStarted"] +
              " on " +
              date;
        }
        if (appointmentData["trackingStatus"]["providerTreatmentEnded"] !=
            null) {
          completed = appointmentData["trackingStatus"]
                  ["providerTreatmentEnded"] +
              " on " +
              date;
        }
      }

      if (appointmentData["pharmaceuticalsAdminstration"] != null) {
        if (appointmentData["pharmaceuticalsAdminstration"]
                ["administrationRoute"] !=
            null) {
          appointmentData["pharmaceuticalsAdminstration"]["administrationRoute"]
              .toString()
              .split(",")
              .map((f) => administrationRoute.add(f))
              .toList();
        }

        drugs = appointmentData["pharmaceuticalsAdminstration"]["drugs"]
                ?.toString() ??
            "---";
      }

      if (appointmentData["recommendedFollowUpCare"] != null) {
        appointmentData["recommendedFollowUpCare"]
            .toString()
            .split(",")
            .map((f) => recommendFollowList.add(f))
            .toList();
      }

      if (appointmentData["medicalHistory"] != null) {
        medicalHistoryList = appointmentData["medicalHistory"];
      }

      if (appointmentData["user"] != null) {
        if (appointmentData["user"] is String) {
        } else {
          userMap = appointmentData["user"];

          name = userMap["fullName"]?.toString() ?? "---";
          type = userMap["type"]?.toString() ?? "---";
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Treatment Summary",
        color: Colors.white,
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Color(0xFFF4F6F8).withOpacity(0.57),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      timeWidget("ic_initiated", "Initiated at", initiated),
                      Expanded(
                        child: VerticalDivider(
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                          color: Colors.grey[200],
                        ),
                      ),
                      timeWidget("ic_completed", "Completed at", completed),
                    ],
                  ),
                ),
              ),
              feeWidget(
                name ?? "---",
                type ?? "---",
                durationOfSymtoms,
                "---",
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Text(
                  "Medical History",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              medicalHistoryList == null || medicalHistoryList.isEmpty
                  ? Text("NO medical history")
                  : Container(
                      height: 40,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: medicalHistoryList.length,
                          itemBuilder: (context, index) {
                            return chipWidget(
                                medicalHistoryList[index]["name"].toString());
                          }),
                    ),
              divider(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Description of problem",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  appointmentData["description"]?.toString() ?? "---",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.73),
                  ),
                ),
              ),
              SizedBox(height: 12),
              divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  "Adverse Effects of Treatment",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: adverseWidget(
                  "Adverse effects",
                  appointmentData["adverseEffectsOfTreatment"]
                          ["adverseEffects"] ??
                      "---",
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: adverseWidget(
                  "Action Taken",
                  appointmentData["adverseEffectsOfTreatment"]["actionTaken"] ??
                      "---",
                ),
              ),
              divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  "Pharmaceuticals Administration",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: adverseWidget(
                  "Drugs",
                  drugs,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Administration Route",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.85),
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 10),
                      child: administrationRoute == null ||
                              administrationRoute.isEmpty
                          ? Text("NO administration route available")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: administrationRoute.length - 1,
                              itemBuilder: (context, index) {
                                return chipWidget(administrationRoute[index]);
                              },
                            ),
                    ),
                  ],
                ),
              ),
              divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Recommended follow Up Care",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 40,
                      child: recommendFollowList == null ||
                              recommendFollowList.isEmpty
                          ? Text("NO reccommend follow up")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: recommendFollowList.length - 1,
                              itemBuilder: (context, index) {
                                return chipWidget(recommendFollowList[index]);
                              },
                            ),
                    ),
                  ],
                ),
              ),
              divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Follow-up Treatment",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              followUpWidget(
                "Follow-up Date",
                followUpMap["date"] == null
                    ? "---"
                    : DateFormat(
                        'dd MMMM yyyy',
                      ).format(followUpMap["date"]).toString(),
                "ic_calendar",
              ),
              followUpWidget(
                "Follow-up Time",
                followUpMap["time"] ?? "---",
                "ic_appointment_time",
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        "ic_follow_services".imageIcon(
                          color: AppColors.persian_indigo,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          "Follow Up Services",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 40,
                      child: followUpMap["services"] == null ||
                              followUpMap["services"].isEmpty
                          ? Text("NO follow up services")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: followUpMap["services"].length,
                              itemBuilder: (context, index) {
                                Services services =
                                    followUpMap["services"][index];
                                return chipWidget(
                                    services.subServiceName.toString());
                              },
                            ),
                    ),
                  ],
                ),
              ),
              followUpChipWidget(
                "Appointment Type",
                serviceType,
                "experiencr_icon_blue",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget adverseWidget(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.85),
          ),
        ),
        SizedBox(height: 12),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.73),
          ),
        ),
      ],
    );
  }

  Widget timeWidget(String icon, String title, String dateTime) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              "$icon".imageIcon(),
              SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(
                  color: title.toLowerCase().contains("initiated")
                      ? AppColors.goldenTainoi
                      : AppColors.jade,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Text(
            dateTime,
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget feeWidget(String pateintName, String medicalCareVia, String hours,
      String cheifComplaint) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.fromLTRB(16, 3, 16, 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Colors.grey[100],
        ),
      ),
      child: Column(
        children: <Widget>[
          subFeeWidget("Patient Name", pateintName),
          Divider(),
          subFeeWidget(
              "Medical Care via",
              medicalCareVia == "1"
                  ? "Office Appointment"
                  : medicalCareVia == "2"
                      ? "Video Appointment"
                      : "Onsite Appointment"),
          Divider(),
          subFeeWidget(
            "Duration of Symptoms",
            hours == "1"
                ? "Hours"
                : hours == "2"
                    ? "Days"
                    : hours == "3" ? "Weeks" : hours == "4" ? "Months" : "---",
          ),
        ],
      ),
    );
  }

  Widget subFeeWidget(String title, String fee) {
    return Padding(
      padding: const EdgeInsets.only(top: 13, bottom: 13),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                fee,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.85),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chipWidget(String title) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: Colors.grey[100]),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.75),
        ),
      ),
    );
  }

  Widget followUpWidget(String title, String subtitle, String icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              icon.imageIcon(
                color: AppColors.persian_indigo,
              ),
              SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 11),
          Text(
            subtitle,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget followUpChipWidget(String title, String subtitle, String icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              icon.imageIcon(
                color: AppColors.persian_indigo,
              ),
              SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 11),
          chipWidget(subtitle),
        ],
      ),
    );
  }

  Widget divider({double topPadding}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 0.0),
      child: Divider(
        color: AppColors.white_smoke,
        thickness: 6.0,
      ),
    );
  }
}
