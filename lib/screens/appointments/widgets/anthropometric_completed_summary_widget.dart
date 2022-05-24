import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/appointments/model/appointment_detail.dart';

import 'package:hutano/text_style.dart';

class AnthopometricCompletedSummaryWidget extends StatelessWidget {
  AnthopometricCompletedSummaryWidget({
    Key key,
    @required this.anthropometricMeasurements,
  }) : super(key: key);

  final AnthropometricMeasurements anthropometricMeasurements;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Image.asset(
                "images/anthro.png",
                height: 36,
                width: 36,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Anthropometric Measurements",
                  style: AppTextStyle.boldStyle(fontSize: 18)),
            ],
          ),
        ),
        Column(children: [
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
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  anthropometricMeasurements.height != null &&
                          anthropometricMeasurements.height.feet != null &&
                          anthropometricMeasurements.height.inches != null &&
                          anthropometricMeasurements.height.feet != '' &&
                          anthropometricMeasurements.height.inches != ''
                      ? Text(
                          'Height: ${anthropometricMeasurements.height.feet}.${anthropometricMeasurements.height.inches} feet',
                          style: AppTextStyle.mediumStyle(fontSize: 14),
                        )
                      : SizedBox(),
                  anthropometricMeasurements.weight != null &&
                          anthropometricMeasurements.weight.current != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Weight: ${anthropometricMeasurements.weight.current} lbs',
                            style: AppTextStyle.mediumStyle(fontSize: 14),
                          ),
                        )
                      : SizedBox(),
                  anthropometricMeasurements.weight.goal != null
                      ? GoalWidget(
                          goal: anthropometricMeasurements.weight.goal,
                          unit: 'lbs')
                      : SizedBox(),
                  anthropometricMeasurements.bmi != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Bmi: ${anthropometricMeasurements.bmi}',
                            style: AppTextStyle.mediumStyle(fontSize: 14),
                          ),
                        )
                      : SizedBox(),
                  anthropometricMeasurements.hip != null &&
                          anthropometricMeasurements.hip.current != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Hip Circumference: ${anthropometricMeasurements.hip.current} inches',
                            style: AppTextStyle.mediumStyle(fontSize: 14),
                          ),
                        )
                      : SizedBox(),
                  anthropometricMeasurements.hip.goal != null
                      ? GoalWidget(
                          goal: anthropometricMeasurements.hip.goal,
                          unit: 'inches')
                      : SizedBox(),
                  anthropometricMeasurements.waist != null &&
                          anthropometricMeasurements.waist.current != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Waist Cicumference: ${anthropometricMeasurements.waist.current} inches',
                            style: AppTextStyle.mediumStyle(fontSize: 14),
                          ),
                        )
                      : SizedBox(),
                  anthropometricMeasurements.waist.goal != null
                      ? GoalWidget(
                          goal: anthropometricMeasurements.waist.goal,
                          unit: 'inches')
                      : SizedBox(),
                  anthropometricMeasurements.calf != null &&
                          anthropometricMeasurements.calf.current != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Calf Cicumference: ${anthropometricMeasurements.calf.current} inches',
                            style: AppTextStyle.mediumStyle(fontSize: 14),
                          ),
                        )
                      : SizedBox(),
                  anthropometricMeasurements.calf.goal != null
                      ? GoalWidget(
                          goal: anthropometricMeasurements.calf.goal,
                          unit: 'inches')
                      : SizedBox(),
                  anthropometricMeasurements.arm != null &&
                          anthropometricMeasurements.arm.current != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Arm Cicumference: ${anthropometricMeasurements.arm.current} inches',
                            style: AppTextStyle.mediumStyle(fontSize: 14),
                          ),
                        )
                      : SizedBox(),
                  anthropometricMeasurements.arm.goal != null
                      ? GoalWidget(
                          goal: anthropometricMeasurements.arm.goal,
                          unit: 'inches')
                      : SizedBox(),
                ],
              )),
        ]),
      ],
    );
  }
}

class GoalWidget extends StatelessWidget {
  GoalWidget({
    Key key,
    @required this.goal,
    @required this.unit,
  }) : super(key: key);

  final Goal goal;
  final String unit;
  Map<String, String> timeSpanConfig = {
    "1": "Hours",
    "2": "Days",
    "3": "Weeks",
    "4": "Months",
    "5": "Years"
  };
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      goal.achieve != null
          ? Text('Goal: ${goal.achieve} $unit',
              style: AppTextStyle.mediumStyle(fontSize: 14))
          : SizedBox(),
      goal.timeFrame != null
          ? Text(
              'Timeframe: ${goal.timeFrame} ${timeSpanConfig[goal.timeUnit]}',
              style: AppTextStyle.mediumStyle(fontSize: 14))
          : SizedBox(),
      goal.improvements != null && goal.improvements.length > 0
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Treatment options: ',
                style: AppTextStyle.semiBoldStyle(fontSize: 14),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: goal.improvements.length,
                  itemBuilder: (context, index) {
                    return Text(
                      goal.improvements[index],
                      style: AppTextStyle.mediumStyle(fontSize: 14),
                    );
                  })
            ])
          : SizedBox(),
    ]);
  }
}
