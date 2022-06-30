import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/appointments/model/appointment_detail.dart';
import 'package:hutano/screens/appointments/widgets/completed_concern_widget.dart';
import 'package:hutano/text_style.dart';

class GaitCompletedWidget extends StatelessWidget {
  GaitCompletedWidget({
    Key? key,
    required this.gait,
  }) : super(key: key);

  final Gait? gait;
  List<String> radioValues = ['', "Bilateral", "Left", "Right"];
  Map<String, String> timeSpanConfig = {
    "1": "Hours",
    "2": "Days",
    "3": "Weeks",
    "4": "Months",
    "5": "Years"
  };
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
                itemCount: gait!.summary!.length,
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
                            gait!.summary![index].gaitType != null
                                ? "\u2022 " +
                                    gait!.summary![index].gaitType!.current!
                                : "\u2022 ",
                            style: AppTextStyle.semiBoldStyle(fontSize: 16),
                          ),
                          gait!.summary![index].gaitType != null
                              ? getGoalText(gait!.summary![index].gaitType!.goal)
                              : SizedBox(),
                          gait!.summary![index].distance != null
                              ? titleWidget('Distance',
                                  '${gait!.summary![index].distance!.current} ft')
                              : SizedBox(),
                          gait!.summary![index].distance != null
                              ? getGoalText(gait!.summary![index].distance!.goal)
                              : SizedBox(),
                          gait!.summary![index].assistance != null
                              ? titleWidget('Assistance',
                                  '${gait!.summary![index].assistance!.current}')
                              : SizedBox(),
                          gait!.summary![index].assistance != null
                              ? getGoalText(gait!.summary![index].assistance!.goal)
                              : SizedBox(),
                          gait!.summary![index].assistiveDevice != null
                              ? titleWidget('Assistive Device',
                                  '${gait!.summary![index].assistiveDevice!.current}')
                              : SizedBox(),
                          gait!.summary![index].assistiveDevice != null
                              ? getGoalText(
                                  gait!.summary![index].assistiveDevice!.goal)
                              : SizedBox(),
                          gait!.summary![index].cuing != null
                              ? titleWidget('Cuing',
                                  '${gait!.summary![index].cuing!.current}')
                              : SizedBox(),
                          gait!.summary![index].cuing != null
                              ? getGoalText(gait!.summary![index].cuing!.goal)
                              : SizedBox(),
                          gait!.summary![index].terraine != null
                              ? titleWidget(
                                  'Terraine', '${gait!.summary![index].terraine}')
                              : SizedBox(),
                          gait!.summary![index].ambulationTrainer != null
                              ? titleWidget('Ambulation Trainer',
                                  '${gait!.summary![index].ambulationTrainer}')
                              : SizedBox(),
                          gait!.summary![index].time != null
                              ? titleWidget(
                                  'Time', '${gait!.summary![index].time}')
                              : SizedBox(),
                          gait!.summary![index].patientResponse != null
                              ? titleWidget('Patient Response',
                                  '${gait!.summary![index].patientResponse}')
                              : SizedBox(),
                          gait!.summary![index].notes != null
                              ? titleWidget(
                                  'Notes', '${gait!.summary![index].notes}')
                              : SizedBox(),
                        ],
                      ));
                },
              ),
              gait!.gaitSummary!.clinicalConcern!.isNotEmpty
                  ? EmrCompleteConcernListWidget(
                      clinicalList: gait!.gaitSummary!.clinicalConcern)
                  : SizedBox(),
              gait!.gaitSummary!.treatment!.isNotEmpty
                  ? EmrCompleteTreatmentListWidget(
                      treatmentList: gait!.gaitSummary!.treatment)
                  : SizedBox(),
              gait!.gaitSummary!.icd!.isNotEmpty
                  ? EmrCompleteDiagnosisListWidget(
                      diagnosisList: gait!.gaitSummary!.icd)
                  : SizedBox(),
            ])),
      ],
    );
  }

  getGoalText(Goal? goal) {
    if (goal != null && goal.achieve != null && goal.achieve != '') {
      var improvements = '';
      if (goal.improvements != null) {
        goal.improvements!.forEach((element) {
          improvements += element + ', ';
        });
      }
      if (improvements.length > 2) {
        improvements = improvements.substring(0, improvements.length - 2);
      }
      return Text(
          "Goal:${goal.achieve} within ${goal.timeFrame} ${timeSpanConfig[goal.timeUnit!]}\nTreatment options: $improvements");
    } else {
      return SizedBox();
    }
  }

  titleWidget(String key, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$key: ',
            style: AppTextStyle.semiBoldStyle(fontSize: 16),
          ),
          TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }
}
