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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "\u2022 " +
                                      integumentry.summary[index].type +
                                      ' ' +
                                      integumentry.summary[index].location,
                                  style:
                                      AppTextStyle.semiBoldStyle(fontSize: 16),
                                ),
                                integumentry.summary[index].length != null
                                    ? titleWidget('Length',
                                        '${integumentry.summary[index].length.current} cm')
                                    : SizedBox(),
                                integumentry.summary[index].length != null
                                    ? getGoalText(
                                        integumentry.summary[index].length.goal)
                                    : SizedBox(),
                                integumentry.summary[index].width != null
                                    ? titleWidget('Width',
                                        '${integumentry.summary[index].width.current} cm')
                                    : SizedBox(),
                                integumentry.summary[index].depth != null
                                    ? getGoalText(
                                        integumentry.summary[index].width.goal)
                                    : SizedBox(),
                                integumentry.summary[index].depth != null
                                    ? titleWidget('Depth',
                                        '${integumentry.summary[index].depth.current} cm')
                                    : SizedBox(),
                                integumentry.summary[index].depth != null
                                    ? getGoalText(
                                        integumentry.summary[index].depth.goal)
                                    : SizedBox(),
                                integumentry.summary[index].staging != null
                                    ? titleWidget('Staging',
                                        '${integumentry.summary[index].staging}')
                                    : SizedBox(),
                                integumentry.summary[index].granulation != null
                                    ? titleWidget('Granulation',
                                        '${integumentry.summary[index].granulation.current} %')
                                    : SizedBox(),
                                integumentry.summary[index].granulation != null
                                    ? getGoalText(integumentry
                                        .summary[index].granulation.goal)
                                    : SizedBox(),
                                integumentry.summary[index].slough != null
                                    ? titleWidget('Slough',
                                        '${integumentry.summary[index].slough.current} %')
                                    : SizedBox(),
                                integumentry.summary[index].slough != null
                                    ? getGoalText(
                                        integumentry.summary[index].slough.goal)
                                    : SizedBox(),
                                integumentry.summary[index].necrosis != null
                                    ? titleWidget('Necrosis',
                                        '${integumentry.summary[index].necrosis.current} %')
                                    : SizedBox(),
                                integumentry.summary[index].necrosis != null
                                    ? getGoalText(integumentry
                                        .summary[index].necrosis.goal)
                                    : SizedBox(),
                                integumentry.summary[index].periwound != null &&
                                        integumentry.summary[index].periwound
                                                .length >
                                            0
                                    ? periWoundWidget(
                                        integumentry.summary[index].periwound)
                                    : SizedBox(),
                                integumentry.summary[index].drainageType != null
                                    ? titleWidget('Drainage Type',
                                        '${integumentry.summary[index].drainageType.current}')
                                    : SizedBox(),
                                integumentry.summary[index].drainageType != null
                                    ? getGoalText(integumentry
                                        .summary[index].drainageType.goal)
                                    : SizedBox(),
                                integumentry.summary[index].drainageAmount !=
                                        null
                                    ? titleWidget('Drainage Amount',
                                        '${integumentry.summary[index].drainageAmount.current}')
                                    : SizedBox(),
                                integumentry.summary[index].drainageAmount !=
                                        null
                                    ? getGoalText(integumentry
                                        .summary[index].drainageAmount.goal)
                                    : SizedBox(),
                                integumentry.summary[index].odor != null
                                    ? titleWidget('Odor',
                                        '${integumentry.summary[index].odor.current}')
                                    : SizedBox(),
                                integumentry.summary[index].odor != null
                                    ? getGoalText(
                                        integumentry.summary[index].odor.goal)
                                    : SizedBox(),
                                integumentry.summary[index].mechanismOfInjury !=
                                        null
                                    ? titleWidget('Mechanism Of Injury',
                                        '${integumentry.summary[index].mechanismOfInjury}')
                                    : SizedBox(),
                                integumentry.summary[index].pain != null
                                    ? titleWidget('Pain',
                                        '${integumentry.summary[index].pain}')
                                    : SizedBox(),
                                integumentry.summary[index].notes != null
                                    ? titleWidget('Notes',
                                        '${integumentry.summary[index].notes}')
                                    : SizedBox(),
                              ],
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

  periWoundWidget(List<String> periWound) {
    var periString = '';
    periWound.forEach((element) {
      periString += element + ', ';
    });

    if (periString.length > 2) {
      periString = periString.substring(0, periString.length - 2);
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'PeriWound: ',
            style: AppTextStyle.semiBoldStyle(fontSize: 16),
          ),
          TextSpan(
            text: periString,
          ),
        ],
      ),
    );
  }

  getGoalText(Goal goal) {
    if (goal != null && goal.achieve != null && goal.achieve != '') {
      var improvements = '';
      if (goal.improvements != null) {
        goal.improvements.forEach((element) {
          improvements += element + ', ';
        });
      }
      if (improvements.length > 2) {
        improvements = improvements.substring(0, improvements.length - 2);
      }
      return Text(
          "Goal:${goal.achieve} within ${goal.timeFrame} ${timeSpanConfig[goal.timeUnit]}\nimprovements: $improvements");
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
