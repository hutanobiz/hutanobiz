import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/appointments/model/appointment_detail.dart';
import 'package:hutano/screens/appointments/widgets/completed_concern_widget.dart';
import 'package:hutano/text_style.dart';

class GaitCompletedWidget extends StatelessWidget {
  GaitCompletedWidget({
    Key key,
    @required this.gait,
  }) : super(key: key);

  final Gait gait;
  List<String> radioValues = ['', "Bilateral", "Left", "Right"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Image.asset(
                "images/gait_training.png",
                height: 36,
                width: 36,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Gait Training",
                  style: AppTextStyle.boldStyle(fontSize: 18)),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: AppColors.borderGreyShadow,
                      offset: Offset(0, 2),
                      spreadRadius: 2,
                      blurRadius: 30),
                ],
                border: Border.all(color: Colors.grey.shade100),
                color: Colors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gait.summary.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.borderGreyShadow,
                                offset: Offset(0, 2),
                                spreadRadius: 2,
                                blurRadius: 30),
                          ],
                          border: Border.all(color: Colors.grey.shade100),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\u2022 " + gait.summary[index].type,
                            style: AppTextStyle.semiBoldStyle(fontSize: 16),
                          ),
                          gait.summary[index].distance != null
                              ? Text(
                                  'Distance: ${gait.summary[index].distance}')
                              : SizedBox(),
                          gait.summary[index].assistance != null
                              ? Text(
                                  'Assistance: ${gait.summary[index].assistance}')
                              : SizedBox(),
                          gait.summary[index].assistiveDevice != null
                              ? Text(
                                  'Assistance Device: ${gait.summary[index].assistiveDevice}')
                              : SizedBox(),
                          gait.summary[index].cuing != null
                              ? Text('Cuing: ${gait.summary[index].cuing}')
                              : SizedBox(),
                          gait.summary[index].terraine != null
                              ? Text(
                                  'Terraine: ${gait.summary[index].terraine}')
                              : SizedBox(),
                          gait.summary[index].ambulationTrainer != null
                              ? Text(
                                  'Ambulation Trainer: ${gait.summary[index].ambulationTrainer}')
                              : SizedBox(),
                          gait.summary[index].time != null
                              ? Text('Time: ${gait.summary[index].time}')
                              : SizedBox(),
                          gait.summary[index].patientResponse != null
                              ? Text(
                                  'Patient Response: ${gait.summary[index].patientResponse}')
                              : SizedBox(),
                          gait.summary[index].notes != null
                              ? Text('Notes: ${gait.summary[index].notes}')
                              : SizedBox(),
                        ],
                      ));
                },
              ),
              gait.gaitSummary.clinicalConcern.isNotEmpty
                  ? EmrCompleteConcernListWidget(
                      clinicalList: gait.gaitSummary.clinicalConcern)
                  : SizedBox(),
              gait.gaitSummary.treatment.isNotEmpty
                  ? EmrCompleteTreatmentListWidget(
                      treatmentList: gait.gaitSummary.treatment)
                  : SizedBox(),
              gait.gaitSummary.icd.isNotEmpty
                  ? EmrCompleteDiagnosisListWidget(
                      diagnosisList: gait.gaitSummary.icd)
                  : SizedBox(),
            ])),
      ],
    );
  }
}
