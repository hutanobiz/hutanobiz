import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/preference_constants.dart';
import 'package:hutano/utils/preference_key.dart';
import 'package:hutano/utils/preference_utils.dart';
import 'package:hutano/widgets/problem_widget.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hutano/utils/extensions.dart';

class CurrentAppointmentMedicalHistory extends StatefulWidget {
  CurrentAppointmentMedicalHistory({Key key, this.isBottomButtonsShow})
      : super(key: key);

  final Map isBottomButtonsShow;

  @override
  _CurrentAppointmentMedicalHistoryState createState() =>
      _CurrentAppointmentMedicalHistoryState();
}

class _CurrentAppointmentMedicalHistoryState
    extends State<CurrentAppointmentMedicalHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: <Widget>[
          Text(
            "Description of problem",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 20),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.isBottomButtonsShow['appointmentProblems'].length,
            itemBuilder: (context, index) {
              return ProblemWidget(
                dob: getString(AppPreference.dobKey),
                gender: getInt(PreferenceKey.gender),
                appointmentProblem:
                    widget.isBottomButtonsShow['appointmentProblems'][index],
              );
            },
          ),
          ((widget.isBottomButtonsShow['vitals']['oxygenSaturation'] != null &&
                      widget.isBottomButtonsShow['vitals']
                              ['oxygenSaturation'] !=
                          '') ||
                  (widget.isBottomButtonsShow['vitals']['heartRate'] != null &&
                      widget.isBottomButtonsShow['vitals']['heartRate'] !=
                          '') ||
                  (widget.isBottomButtonsShow['vitals']['temperature'] !=
                          null &&
                      widget.isBottomButtonsShow['vitals']
                              ['temperature'] !=
                          '') ||
                  (widget.isBottomButtonsShow['vitals']['bloodPressureSbp'] !=
                          null &&
                      widget.isBottomButtonsShow['vitals']
                              ['bloodPressureSbp'] !=
                          '') ||
                  (widget.isBottomButtonsShow['vitals']['bloodPressureDbp'] !=
                          null &&
                      widget.isBottomButtonsShow['vitals']
                              ['bloodPressureDbp'] !=
                          ''))
              ? vitalsDetail(widget.isBottomButtonsShow['vitals'])
              : SizedBox(),
          widget.isBottomButtonsShow['medicalHistory'].length > 0
              ? medicalHistoryDetail(
                  widget.isBottomButtonsShow['medicalHistory'])
              : SizedBox(),
          widget.isBottomButtonsShow['medicalDiagnostics'].length > 0
              ? dianosticTestDetail(
                  widget.isBottomButtonsShow['medicalDiagnostics'])
              : SizedBox(),
          widget.isBottomButtonsShow['medications'].length > 0
              ? medicationDetail(widget.isBottomButtonsShow['medications'])
              : SizedBox()
        ],
      ),
    );
  }

  medicalHistoryList(List<dynamic> medicals) {
    List<Widget> daysWidget = [];
    for (dynamic medical in medicals) {
      daysWidget
          .add(chipWidget(medical['name'], medical['month'], medical['year']));
    }
    return daysWidget;
  }

  chipWidget(name, month, year) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: Colors.grey[200])),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            name,
            style: AppTextStyle.mediumStyle(color: Colors.black),
          ),
          Text(
            month + ', ' + year,
            style: TextStyle(color: AppColors.windsor),
          ),
        ],
      ),
    );
  }

  vitalsDetail(dynamic vitals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Vitals",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        vitalWidget(context, vitals),
      ],
    );
  }

  medicalHistoryDetail(dynamic medicalHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Medical history",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 14,
        ),
        medicalHistoryWidget(medicalHistory),
      ],
    );
  }

  dianosticTestDetail(dynamic medicalDiagnostics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Diagnostic tests",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 14),
        diagnosticTestWidget(medicalDiagnostics),
      ],
    );
  }

  medicationDetail(dynamic medications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Medications",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 14),
        medicationWidget(medications),
        SizedBox(height: 20),
      ],
    );
  }

  Container medicationWidget(List medications) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey[200]),
        ),
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: medications.length,
            itemBuilder: (context, index) {
              return Text(
                  medications[index]['name'] +
                      ', ' +
                      medications[index]['dose'] +
                      ', ' +
                      // doses[
                      medications[index]['frequency'], //],
                  style: AppTextStyle.semiBoldStyle(fontSize: 13));
            }));
  }

  Container diagnosticTestWidget(List medicalDiagnostics) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey[200]),
        ),
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: medicalDiagnostics.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                      height: 80,
                      width: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        clipBehavior: Clip.antiAlias,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: medicalDiagnostics[index]['image']
                                    .toLowerCase()
                                    .endsWith("pdf")
                                ? "ic_pdf".imageIcon()
                                : Image.network(
                                    ApiBaseHelper.image_base_url +
                                        medicalDiagnostics[index]['image'],
                                    height: 80.0,
                                    width: 80.0,
                                    fit: BoxFit.cover,
                                  )),
                      )).onClick(
                    onTap: medicalDiagnostics[index]['image']
                            .toLowerCase()
                            .endsWith("pdf")
                        ? () async {
                            var url = ApiBaseHelper.image_base_url +
                                medicalDiagnostics[index]['image'];
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                        : () {
                            Navigator.of(context).pushNamed(
                              Routes.providerImageScreen,
                              arguments: ApiBaseHelper.imageUrl +
                                  medicalDiagnostics[index].image,
                            );
                          },
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Expanded(
                        //   child:
                        Text(medicalDiagnostics[index]['type'],
                            style: AppTextStyle.semiBoldStyle(fontSize: 13)),
                        // ),
                        SizedBox(
                          height: 8,
                        ),
                        // Expanded(
                        //   child:
                        Text(medicalDiagnostics[index]['name'] +
                            ' ' +
                            medicalDiagnostics[index]['type'] +
                            ' taken on ' +
                            (medicalDiagnostics[index]['date'])),
                        // ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }

  Container medicalHistoryWidget(List medicalHistory) {
    // String medicalHistories = '';
    // for (dynamic medical in medicalHistory) {
    //   medicalHistories += medical['name'] + ', ';
    // }
    // if (medicalHistories != '') {
    //   medicalHistories =
    //       medicalHistories.substring(0, medicalHistories.length - 2);
    // }

    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey[200]),
        ),
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: medicalHistory.length,
            itemBuilder: (context, index) {
              return Wrap(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medicalHistory[index]['name'],
                      style: AppTextStyle.semiBoldStyle(fontSize: 14)),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                      medicalHistory[index]['month'] +
                          ', ' +
                          medicalHistory[index]['year'],
                      style: AppTextStyle.regularStyle(fontSize: 13))
                ],
              );
            }));
    // Column(
    //   children: [
    //     Text(
    //       medicalHistories,
    //       style: AppTextStyle.mediumStyle(fontSize: 14),
    //     ),
    //     Text(
    //       month + ', ' + year,
    //       style: TextStyle(color: AppColors.windsor),
    //     ),
    //   ],
    // ),
  }
}

Widget vitalWidget(BuildContext context, Map<String, dynamic> vitals) {
  return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey[200]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vitals['date'] == null || vitals['date'] == ''
                ? '---'
                : DateFormat("MMM dd, yyyy")
                    .format(DateTime.parse(vitals['date']).toLocal())
                    .toString(),
            style: AppTextStyle.mediumStyle(fontSize: 15),
          ),
          SizedBox(
            height: 4,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: vitals['bloodPressureSbp'] == null ||
                          vitals['bloodPressureSbp'] == '' ||
                          vitals['bloodPressureDbp'] == null ||
                          vitals['bloodPressureDbp'] == ''
                      ? ''
                      : 'Blood Pressure ',
                  style: AppTextStyle.regularStyle(fontSize: 14),
                ),
                TextSpan(
                  text: vitals['bloodPressureSbp'] == null ||
                          vitals['bloodPressureSbp'] == '' ||
                          vitals['bloodPressureDbp'] == null ||
                          vitals['bloodPressureDbp'] == ''
                      ? ''
                      : '${vitals['bloodPressureSbp']}/${vitals['bloodPressureDbp']}; \t',
                  style: AppTextStyle.mediumStyle(fontSize: 14),
                ),
                TextSpan(
                  text: vitals['oxygenSaturation'] == null ||
                          vitals['oxygenSaturation'] == ''
                      ? ''
                      : 'Oxygen Saturation ',
                  style: AppTextStyle.regularStyle(fontSize: 14),
                ),
                TextSpan(
                  text: vitals['oxygenSaturation'] == null ||
                          vitals['oxygenSaturation'] == ''
                      ? ''
                      : '${vitals['oxygenSaturation']}%; \t',
                  style: AppTextStyle.mediumStyle(fontSize: 14),
                ),
                TextSpan(
                  text: vitals['heartRate'] == null || vitals['heartRate'] == ''
                      ? ''
                      : 'Heart Rate ',
                  style: AppTextStyle.regularStyle(fontSize: 14),
                ),
                TextSpan(
                  text: vitals['heartRate'] == null || vitals['heartRate'] == ''
                      ? ''
                      : '${vitals['heartRate']} b/m; \t',
                  style: AppTextStyle.mediumStyle(fontSize: 14),
                ),
                TextSpan(
                  text: vitals['temperature'] == null ||
                          vitals['temperature'] == ''
                      ? ''
                      : 'Temperature ',
                  style: AppTextStyle.regularStyle(fontSize: 14),
                ),
                TextSpan(
                  text: vitals['temperature'] == null ||
                          vitals['temperature'] == ''
                      ? ''
                      : '${vitals['temperature']} \u2109',
                  style: AppTextStyle.mediumStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ));
}
