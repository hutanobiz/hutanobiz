import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/appointments/model/appointment_detail.dart';
import 'package:hutano/screens/appointments/widgets/completed_concern_widget.dart';
import 'package:hutano/text_style.dart';

class IntegumentryCompletedWidget extends StatelessWidget {
  IntegumentryCompletedWidget({
    Key key,
    @required this.integumentry,
  }) : super(key: key);

  final Integumentary integumentry;
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
                "images/integumentry.png",
                height: 36,
                width: 36,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Integumentary",
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              integumentry.summary.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: integumentry.summary.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
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
                            child: Text(
                              "\u2022 " +
                                  radioValues[int.parse(
                                      integumentry.summary[index].type)] +
                                  ' ' +
                                  integumentry.summary[index].location +
                                  '; ' +
                                  '${integumentry.summary[index].length}cm X ${integumentry.summary[index].width}cm X ${integumentry.summary[index].depth}cm; ${integumentry.summary[index].staging}; ${integumentry.summary[index].granulation}% granulation, ${integumentry.summary[index].slough}% slough, ${integumentry.summary[index].necrosis}% necrosis, ${integumentry.summary[index].drainageType}, ${integumentry.summary[index].drainageAmount}; ${integumentry.summary[index].odor}, ${integumentry.summary[index].mechanismOfInjury}; pain ${integumentry.summary[index].pain}/10.',
                              style: AppTextStyle.semiBoldStyle(fontSize: 16),
                            ));
                      },
                    )
                  : SizedBox(),
              integumentry.woundCareSummary != null &&
                      (integumentry
                              .woundCareSummary.clinicalConcern.isNotEmpty ||
                          integumentry.woundCareSummary.treatment.isNotEmpty ||
                          integumentry.woundCareSummary.icd.isNotEmpty)
                  ? Text(
                      "Wound Care",
                      style: AppTextStyle.boldStyle(fontSize: 15),
                    )
                  : SizedBox(),
              integumentry.woundCareSummary.clinicalConcern.isNotEmpty
                  ? EmrCompleteConcernListWidget(
                      clinicalList:
                          integumentry.woundCareSummary.clinicalConcern)
                  : SizedBox(),
              integumentry.woundCareSummary.treatment.isNotEmpty
                  ? EmrCompleteTreatmentListWidget(
                      treatmentList: integumentry.woundCareSummary.treatment)
                  : SizedBox(),
              integumentry.woundCareSummary.icd.isNotEmpty
                  ? EmrCompleteDiagnosisListWidget(
                      diagnosisList: integumentry.woundCareSummary.icd)
                  : SizedBox(),
              integumentry.painSummary != null &&
                      (integumentry.painSummary.clinicalConcern.isNotEmpty ||
                          integumentry.painSummary.treatment.isNotEmpty ||
                          integumentry.painSummary.icd.isNotEmpty)
                  ? Text(
                      "Pain",
                      style: AppTextStyle.boldStyle(fontSize: 15),
                    )
                  : SizedBox(),
              integumentry.painSummary.clinicalConcern.isNotEmpty
                  ? EmrCompleteConcernListWidget(
                      clinicalList: integumentry.painSummary.clinicalConcern)
                  : SizedBox(),
              integumentry.painSummary.treatment.isNotEmpty
                  ? EmrCompleteTreatmentListWidget(
                      treatmentList: integumentry.painSummary.treatment)
                  : SizedBox(),
              integumentry.painSummary.icd.isNotEmpty
                  ? EmrCompleteDiagnosisListWidget(
                      diagnosisList: integumentry.painSummary.icd)
                  : SizedBox(),
            ])),
      ],
    );
  }
}
