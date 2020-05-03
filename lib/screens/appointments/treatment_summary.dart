import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:intl/intl.dart';

class TreatmentSummaryScreen extends StatefulWidget {
  TreatmentSummaryScreen({Key key}) : super(key: key);

  @override
  _TreatmentSummaryScreenState createState() => _TreatmentSummaryScreenState();
}

class _TreatmentSummaryScreenState extends State<TreatmentSummaryScreen> {
  InheritedContainerState _container;
  Map appointmentData;
  List<String> administrationRoute = new List();
  List<String> recommendFollowList = new List();
  List medicalHistoryList = new List();

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    appointmentData = _container.getProviderData()["providerData"]["data"];

    if (appointmentData["pharmaceuticalsAdminstration"]
            ["administrationRoute"] !=
        null) {
      appointmentData["pharmaceuticalsAdminstration"]["administrationRoute"]
          .toString()
          .split(",")
          .map((f) => administrationRoute.add(f))
          .toList();
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
    super.didChangeDependencies();
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
                      timeWidget(
                          "ic_initiated",
                          "Initiated at",
                          appointmentData["fromTime"].toString() +
                              " on " +
                              DateFormat(
                                'dd MMMM yyyy',
                              )
                                  .format(
                                      DateTime.parse(appointmentData['date']))
                                  .toString()),
                      Expanded(
                        child: VerticalDivider(
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                          color: Colors.grey[200],
                        ),
                      ),
                      timeWidget("ic_completed", "Completed at", "---"),
                    ],
                  ),
                ),
              ),
              feeWidget(
                appointmentData["doctor"]["fullName"] ?? "---",
                appointmentData["type"],
                "---",
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
              medicalHistoryList == null
                  ? Container()
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
                                medicalHistoryList[index].toString());
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
                  appointmentData["description"] ?? "---",
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
                  appointmentData["pharmaceuticalsAdminstration"]["drugs"] ??
                      "---",
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
                      margin: const EdgeInsets.only(top: 10),
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
                appointmentData["followUp"]['date'] == null
                    ? "---"
                    : DateFormat(
                        'dd MMMM yyyy',
                      )
                        .format(
                            DateTime.parse(appointmentData["followUp"]['date']))
                        .toString(),
                "ic_calendar",
              ),
              followUpWidget(
                appointmentData["followUp"]["fromTime"]?.toString() ?? "---",
                "ic_appointment_time",
              ),
              SizedBox(height: 30),
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

  Widget feeWidget(String pateintName, int medicalCareVia,
      String cheifComplaint, String hours) {
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
              medicalCareVia == 1
                  ? "Office Appointment"
                  : medicalCareVia == 2
                      ? "Video Appointment"
                      : "Onsite Appointment"),
          Divider(),
          subFeeWidget("Office Visit charge", hours),
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

  Widget followUpWidget(String subtitle, String icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon.imageIcon(
            color: AppColors.persian_indigo,
          ),
          SizedBox(width: 8.0),
          Text(
            subtitle,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
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
