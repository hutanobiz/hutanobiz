import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/appointments/model/appointment_detail.dart';
import 'package:hutano/screens/appointments/widgets/completed_concern_widget.dart';

import 'package:hutano/text_style.dart';

class VitalsCompleteWidget extends StatelessWidget {
  VitalsCompleteWidget({Key key, @required this.vitals}) : super(key: key);
  Vitals vitals;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Image.asset(
                "images/vital.png",
                height: 36,
                width: 36,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Vitals", style: AppTextStyle.boldStyle(fontSize: 18)),
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
            child: Text.rich(TextSpan(children: [
              TextSpan(
                text: vitals.bloodPressureSbp != null &&
                        vitals.bloodPressureDbp != null
                    ? 'Blood Pressure: '
                    : '',
                style: AppTextStyle.regularStyle(fontSize: 14),
              ),
              TextSpan(
                text: vitals.bloodPressureSbp != null &&
                        vitals.bloodPressureDbp != null
                    ? '${vitals.bloodPressureSbp}/${vitals.bloodPressureDbp}\t\t\t\t'
                    : '',
                style: AppTextStyle.boldStyle(fontSize: 14),
              ),
              TextSpan(
                text: vitals.heartRate != null ? 'Heart Rate :' : '',
                style: AppTextStyle.regularStyle(fontSize: 14),
              ),
              TextSpan(
                text: vitals.heartRate != null
                    ? '${vitals.heartRate}\t\t\t\t'
                    : '',
                style: AppTextStyle.boldStyle(fontSize: 14),
              ),
              TextSpan(
                text: vitals.oxygenSaturation != null
                    ? 'Oxygen Saturation: '
                    : '',
                style: AppTextStyle.regularStyle(fontSize: 14),
              ),
              TextSpan(
                text: vitals.oxygenSaturation != null
                    ? '${vitals.oxygenSaturation}\t\t\t\t'
                    : '',
                style: AppTextStyle.boldStyle(fontSize: 14),
              ),
              TextSpan(
                text: vitals.temperature != null ? 'Temperature: ' : '',
                style: AppTextStyle.regularStyle(fontSize: 14),
              ),
              TextSpan(
                text: vitals.temperature != null
                    ? '${vitals.temperature}\t\t\t\t'
                    : '',
                style: AppTextStyle.boldStyle(fontSize: 14),
              ),
              TextSpan(
                text: vitals.pain != null ? 'Pain: ' : '',
                style: AppTextStyle.regularStyle(fontSize: 14),
              ),
              TextSpan(
                text: vitals.pain != null ? '${vitals.pain}/10' : '',
                style: AppTextStyle.boldStyle(fontSize: 14),
              ),
            ]))),
        vitals.bloodPressureSummary != null &&
                (vitals.bloodPressureSummary.clinicalConcern.isNotEmpty ||
                    vitals.bloodPressureSummary.treatment.isNotEmpty ||
                    vitals.bloodPressureSummary.icd.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Blood pressure: ${vitals.bloodPressureSbp}/${vitals.bloodPressureDbp}',
                  style: AppTextStyle.boldStyle(fontSize: 18),
                ),
              )
            : SizedBox(),
        vitals.bloodPressureSummary != null &&
                (vitals.bloodPressureSummary.clinicalConcern.isNotEmpty ||
                    vitals.bloodPressureSummary.treatment.isNotEmpty ||
                    vitals.bloodPressureSummary.icd.isNotEmpty)
            ? Container(
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
                      vitals.bloodPressureSummary.clinicalConcern.isNotEmpty
                          ? EmrCompleteConcernListWidget(
                              clinicalList:
                                  vitals.bloodPressureSummary.clinicalConcern)
                          : SizedBox(),
                      vitals.bloodPressureSummary.treatment.isNotEmpty
                          ? EmrCompleteTreatmentListWidget(
                              treatmentList:
                                  vitals.bloodPressureSummary.treatment)
                          : SizedBox(),
                      vitals.bloodPressureSummary.icd.isNotEmpty
                          ? EmrCompleteDiagnosisListWidget(
                              diagnosisList: vitals.bloodPressureSummary.icd)
                          : SizedBox(),
                    ]),
              )
            : SizedBox(),
        vitals.heartRateSummary != null &&
                (vitals.heartRateSummary.clinicalConcern.isNotEmpty ||
                    vitals.heartRateSummary.treatment.isNotEmpty ||
                    vitals.heartRateSummary.icd.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Heart Rate : ${vitals.heartRate} BPM',
                  style: AppTextStyle.boldStyle(fontSize: 18),
                ),
              )
            : SizedBox(),
        vitals.heartRateSummary != null &&
                (vitals.heartRateSummary.clinicalConcern.isNotEmpty ||
                    vitals.heartRateSummary.treatment.isNotEmpty ||
                    vitals.heartRateSummary.icd.isNotEmpty)
            ? Container(
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
                      vitals.heartRateSummary.clinicalConcern.isNotEmpty
                          ? EmrCompleteConcernListWidget(
                              clinicalList:
                                  vitals.heartRateSummary.clinicalConcern)
                          : SizedBox(),
                      vitals.heartRateSummary.treatment.isNotEmpty
                          ? EmrCompleteTreatmentListWidget(
                              treatmentList: vitals.heartRateSummary.treatment)
                          : SizedBox(),
                      vitals.heartRateSummary.icd.isNotEmpty
                          ? EmrCompleteDiagnosisListWidget(
                              diagnosisList: vitals.heartRateSummary.icd)
                          : SizedBox(),
                    ]))
            : SizedBox(),
        vitals.oxygenSaturationSummary != null &&
                (vitals.oxygenSaturationSummary.clinicalConcern.isNotEmpty ||
                    vitals.oxygenSaturationSummary.treatment.isNotEmpty ||
                    vitals.oxygenSaturationSummary.icd.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Oxygen Saturation: ${vitals.oxygenSaturation}%',
                  style: AppTextStyle.boldStyle(fontSize: 18),
                ),
              )
            : SizedBox(),
        vitals.oxygenSaturationSummary != null &&
                (vitals.oxygenSaturationSummary.clinicalConcern.isNotEmpty ||
                    vitals.oxygenSaturationSummary.treatment.isNotEmpty ||
                    vitals.oxygenSaturationSummary.icd.isNotEmpty)
            ? Container(
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
                      vitals.oxygenSaturationSummary.clinicalConcern.isNotEmpty
                          ? EmrCompleteConcernListWidget(
                              clinicalList: vitals
                                  .oxygenSaturationSummary.clinicalConcern)
                          : SizedBox(),
                      vitals.oxygenSaturationSummary.treatment.isNotEmpty
                          ? EmrCompleteTreatmentListWidget(
                              treatmentList:
                                  vitals.oxygenSaturationSummary.treatment)
                          : SizedBox(),
                      vitals.oxygenSaturationSummary.icd.isNotEmpty
                          ? EmrCompleteDiagnosisListWidget(
                              diagnosisList: vitals.oxygenSaturationSummary.icd)
                          : SizedBox(),
                    ]))
            : SizedBox(),
        vitals.temperatureSummary != null &&
                (vitals.temperatureSummary.clinicalConcern.isNotEmpty ||
                    vitals.temperatureSummary.treatment.isNotEmpty ||
                    vitals.temperatureSummary.icd.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Temperature: ${vitals.temperature}',
                  style: AppTextStyle.boldStyle(fontSize: 18),
                ),
              )
            : SizedBox(),
        vitals.temperatureSummary != null &&
                (vitals.temperatureSummary.clinicalConcern.isNotEmpty ||
                    vitals.temperatureSummary.treatment.isNotEmpty ||
                    vitals.temperatureSummary.icd.isNotEmpty)
            ? Container(
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
                      vitals.temperatureSummary.clinicalConcern.isNotEmpty
                          ? EmrCompleteConcernListWidget(
                              clinicalList:
                                  vitals.temperatureSummary.clinicalConcern)
                          : SizedBox(),
                      vitals.temperatureSummary.treatment.isNotEmpty
                          ? EmrCompleteTreatmentListWidget(
                              treatmentList:
                                  vitals.temperatureSummary.treatment)
                          : SizedBox(),
                      vitals.temperatureSummary.icd.isNotEmpty
                          ? EmrCompleteDiagnosisListWidget(
                              diagnosisList: vitals.temperatureSummary.icd)
                          : SizedBox(),
                    ]))
            : SizedBox(),
        vitals.painSummary != null &&
                (vitals.painSummary.clinicalConcern.isNotEmpty ||
                    vitals.painSummary.treatment.isNotEmpty ||
                    vitals.painSummary.icd.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Pain: ${vitals.pain}/10 ',
                  style: AppTextStyle.boldStyle(fontSize: 18),
                ),
              )
            : SizedBox(),
        vitals.painSummary != null &&
                (vitals.painSummary.clinicalConcern.isNotEmpty ||
                    vitals.painSummary.treatment.isNotEmpty ||
                    vitals.painSummary.icd.isNotEmpty)
            ? Container(
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
                      vitals.painSummary.clinicalConcern.isNotEmpty
                          ? EmrCompleteConcernListWidget(
                              clinicalList: vitals.painSummary.clinicalConcern)
                          : SizedBox(),
                      vitals.painSummary.treatment.isNotEmpty
                          ? EmrCompleteTreatmentListWidget(
                              treatmentList: vitals.painSummary.treatment)
                          : SizedBox(),
                      vitals.painSummary.icd.isNotEmpty
                          ? EmrCompleteDiagnosisListWidget(
                              diagnosisList: vitals.painSummary.icd)
                          : SizedBox(),
                    ]))
            : SizedBox()
      ],
    );
  }
}

class HeartLungsCompleteWidget extends StatelessWidget {
  HeartLungsCompleteWidget({
    Key key,
    @required this.heartAndLungs,
  }) : super(key: key);

  HeartAndLungs heartAndLungs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Image.asset(
                "images/heart_lung.png",
                height: 36,
                width: 36,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Heart and Lungs",
                  style: AppTextStyle.boldStyle(fontSize: 18)),
            ],
          ),
        ),
        Column(children: [
          heartAndLungs.heart.sound.isNotEmpty
              ? Container(
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
                      Text(
                        'Heart Sound',
                        style: AppTextStyle.boldStyle(fontSize: 14),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: heartAndLungs.heart.sound.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "\u2022 " + heartAndLungs.heart.sound[index],
                              style: AppTextStyle.mediumStyle(fontSize: 14),
                            ),
                          );
                        },
                      ),
                      heartAndLungs.heart.clinicalConcern.isNotEmpty
                          ? EmrCompleteConcernListWidget(
                              clinicalList: heartAndLungs.heart.clinicalConcern)
                          : SizedBox(),
                      heartAndLungs.heart.treatment.isNotEmpty
                          ? EmrCompleteTreatmentListWidget(
                              treatmentList: heartAndLungs.heart.treatment)
                          : SizedBox(),
                      heartAndLungs.heart.icd.isNotEmpty
                          ? EmrCompleteDiagnosisListWidget(
                              diagnosisList: heartAndLungs.heart.icd)
                          : SizedBox(),
                    ],
                  ))
              : SizedBox(),
          heartAndLungs.lung.summary.isNotEmpty
              ? LungsCompleteWidget(
                  lungSounds: heartAndLungs.lung.summary,
                  heartLungConcernList: heartAndLungs.lung.clinicalConcern,
                  heartLungTreatmentlist: heartAndLungs.lung.treatment,
                  heartLungDiagnosisList: heartAndLungs.lung.icd,
                  title: 'Lung Sound')
              : SizedBox(),
        ]),
      ],
    );
  }
}

class LungsCompleteWidget extends StatelessWidget {
  LungsCompleteWidget({
    Key key,
    @required this.lungSounds,
    @required this.heartLungConcernList,
    @required this.heartLungTreatmentlist,
    @required this.heartLungDiagnosisList,
    @required this.title,
  }) : super(key: key);

  final List<Summary> lungSounds;
  final List heartLungConcernList;
  final List heartLungTreatmentlist;
  final List heartLungDiagnosisList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Text(
              title,
              style: AppTextStyle.boldStyle(fontSize: 14),
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: lungSounds.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "\u2022 ${(lungSounds[index].type)} ${lungSounds[index].sound}",
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                );
              },
            ),
            heartLungConcernList.isNotEmpty
                ? EmrCompleteConcernListWidget(
                    clinicalList: heartLungConcernList)
                : SizedBox(),
            heartLungTreatmentlist.isNotEmpty
                ? EmrCompleteTreatmentListWidget(
                    treatmentList: heartLungTreatmentlist)
                : SizedBox(),
            heartLungDiagnosisList.isNotEmpty
                ? EmrCompleteDiagnosisListWidget(
                    diagnosisList: heartLungDiagnosisList)
                : SizedBox(),
          ],
        ));
  }
}

class NeurologicalCompleteWidget extends StatelessWidget {
  const NeurologicalCompleteWidget({
    Key key,
    @required this.sensoryDeficts,
    @required this.dtrDeficts,
    @required this.strengthDeficts,
    @required this.romDeficts,
    @required this.positiveTestDeficts,
    @required this.neurologicalConcernList,
    @required this.neurologicalTreatmentlist,
    @required this.neurologicalDiagnosisList,
  }) : super(key: key);

  final List<SensoryDeficits> sensoryDeficts;
  final List<SensoryDeficits> dtrDeficts;
  final List<SensoryDeficits> strengthDeficts;
  final List<SensoryDeficits> romDeficts;
  final List<SensoryDeficits> positiveTestDeficts;
  final List<String> neurologicalConcernList;
  final List<String> neurologicalTreatmentlist;
  final List<String> neurologicalDiagnosisList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Image.asset(
                'images/neurological.png',
                height: 36,
                width: 36,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Neurological", style: AppTextStyle.boldStyle(fontSize: 18)),
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
              sensoryDeficts.isNotEmpty
                  ? NeurologicalCompleteListWidget(
                      title: 'Sensory deficts', list: sensoryDeficts)
                  : SizedBox(),
              dtrDeficts.isNotEmpty
                  ? NeurologicalCompleteListWidget(
                      title: 'DTR deficts', list: dtrDeficts)
                  : SizedBox(),
              strengthDeficts.isNotEmpty
                  ? NeurologicalCompleteListWidget(
                      title: 'Strength deficts', list: strengthDeficts)
                  : SizedBox(),
              romDeficts.isNotEmpty
                  ? NeurologicalCompleteListWidget(
                      title: 'ROM deficts', list: romDeficts)
                  : SizedBox(),
              positiveTestDeficts.isNotEmpty
                  ? NeurologicalCompleteListWidget(
                      title: 'Positive tests', list: positiveTestDeficts)
                  : SizedBox(),
              neurologicalConcernList.isNotEmpty
                  ? EmrCompleteConcernListWidget(
                      clinicalList: neurologicalConcernList)
                  : SizedBox(),
              neurologicalTreatmentlist.isNotEmpty
                  ? EmrCompleteTreatmentListWidget(
                      treatmentList: neurologicalTreatmentlist)
                  : SizedBox(),
              neurologicalDiagnosisList.isNotEmpty
                  ? EmrCompleteDiagnosisListWidget(
                      diagnosisList: neurologicalDiagnosisList)
                  : SizedBox(),
            ])),
      ],
    );
  }
}

class NeurologicalCompleteListWidget extends StatelessWidget {
  NeurologicalCompleteListWidget({Key key, this.title, this.list})
      : super(key: key);
  String title;
  List<SensoryDeficits> list;

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
            title,
            style: AppTextStyle.boldStyle(fontSize: 14),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "\u2022 ${(list[index].type)} ${list[index].deficits}",
                  style: AppTextStyle.mediumStyle(fontSize: 14),
                ),
              );
            },
          ),
        ]);
  }
}

class SpecialTestCompleteWidget extends StatelessWidget {
  SpecialTestCompleteWidget({
    Key key,
    @required this.specialTests,
    @required this.specialTestsConcernList,
    @required this.specialTestsTreatmentlist,
    @required this.specialTestsDiagnosisList,
  }) : super(key: key);

  final List<TestsCompleted> specialTests;
  final List<String> specialTestsConcernList;
  final List<String> specialTestsTreatmentlist;
  final List<String> specialTestsDiagnosisList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Image.asset(
                "images/special.png",
                height: 36,
                width: 36,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Special Tests",
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
              specialTests.isNotEmpty
                  ? SpecialTestCompleteListWidget(
                      title: 'Positive Test', list: specialTests)
                  : SizedBox(),
              specialTestsConcernList.isNotEmpty
                  ? EmrCompleteConcernListWidget(
                      clinicalList: specialTestsConcernList)
                  : SizedBox(),
              specialTestsTreatmentlist.isNotEmpty
                  ? EmrCompleteTreatmentListWidget(
                      treatmentList: specialTestsTreatmentlist)
                  : SizedBox(),
              specialTestsDiagnosisList.isNotEmpty
                  ? EmrCompleteDiagnosisListWidget(
                      diagnosisList: specialTestsDiagnosisList)
                  : SizedBox(),
            ])),
      ],
    );
  }
}

class SpecialTestCompleteListWidget extends StatelessWidget {
  SpecialTestCompleteListWidget({Key key, this.title, this.list})
      : super(key: key);
  String title;
  List<TestsCompleted> list;
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
            title,
            style: AppTextStyle.boldStyle(fontSize: 14),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "\u2022 ${(list[index].type)} ${list[index].name}",
                  style: AppTextStyle.mediumStyle(fontSize: 14),
                ),
              );
            },
          ),
        ]);
  }
}

class MuscleJointCompleteWidget extends StatelessWidget {
  const MuscleJointCompleteWidget({
    Key key,
    @required this.muscleList,
    @required this.jointList,
    @required this.masculoskeletonConcernList,
    @required this.masculoskeletonTreatmentlist,
    @required this.masculoskeletonDiagnosisList,
  }) : super(key: key);

  final List<Muscle> muscleList;
  final List<Joint> jointList;
  final List<String> masculoskeletonConcernList;
  final List<String> masculoskeletonTreatmentlist;
  final List<String> masculoskeletonDiagnosisList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Image.asset(
                "images/muscle.png",
                height: 36,
                width: 36,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Musculoskeletal",
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
              muscleList.isNotEmpty
                  ? MuscleCompleteListWidget(title: 'Muscle', list: muscleList)
                  : SizedBox(),
              jointList.isNotEmpty
                  ? JointCompleteListWidget(title: 'Joint', list: jointList)
                  : SizedBox(),
              masculoskeletonConcernList.isNotEmpty
                  ? EmrCompleteConcernListWidget(
                      clinicalList: masculoskeletonConcernList)
                  : SizedBox(),
              masculoskeletonTreatmentlist.isNotEmpty
                  ? EmrCompleteTreatmentListWidget(
                      treatmentList: masculoskeletonTreatmentlist)
                  : SizedBox(),
              masculoskeletonDiagnosisList.isNotEmpty
                  ? EmrCompleteDiagnosisListWidget(
                      diagnosisList: masculoskeletonDiagnosisList)
                  : SizedBox(),
            ])),
      ],
    );
  }
}

class MuscleCompleteListWidget extends StatelessWidget {
  MuscleCompleteListWidget({Key key, this.title, this.list}) : super(key: key);
  String title;
  List<Muscle> list;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Text(
          title,
          style: AppTextStyle.boldStyle(fontSize: 14),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\u2022 ${(list[index].type)} ${list[index].name}",
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                  Text(
                      "Strength: ${list[index].strength}, Functional Strenght: ${list[index].functionalStrength}")
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class JointCompleteListWidget extends StatelessWidget {
  JointCompleteListWidget({Key key, this.title, this.list}) : super(key: key);
  String title;
  List<Joint> list;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Text(
          title,
          style: AppTextStyle.boldStyle(fontSize: 14),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\u2022 ${(list[index].type)} ${list[index].name}",
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                  Text(
                    "Range of Motion: ${list[index].rangeOfMotion}, Functional Range of Motion: ${list[index].functionalRangeOfMotion}",
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
