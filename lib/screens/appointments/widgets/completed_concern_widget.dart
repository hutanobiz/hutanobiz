import 'package:flutter/material.dart';
import 'package:hutano/text_style.dart';

class EmrCompleteDiagnosisListWidget extends StatelessWidget {
  const EmrCompleteDiagnosisListWidget({
    Key? key,
    required this.diagnosisList,
  }) : super(key: key);

  final List<String?>? diagnosisList;

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: EdgeInsets.only(bottom: 0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
            'Diagnosis',
            style: AppTextStyle.boldStyle(fontSize: 14),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: diagnosisList!.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "\u2022 " + (diagnosisList![index] ?? ""),
                    style: AppTextStyle.mediumStyle(fontSize: 14),
                  ),
                );
              }),
        ]);
  }
}

class EmrCompleteTreatmentListWidget extends StatelessWidget {
  const EmrCompleteTreatmentListWidget({
    Key? key,
    required this.treatmentList,
  }) : super(key: key);

  final List<String?>? treatmentList;

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 0),
        children: [
          Text(
            'Treatment',
            style: AppTextStyle.boldStyle(fontSize: 14),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: treatmentList!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "\u2022 " + (treatmentList![index] ?? ''),
                  style: AppTextStyle.mediumStyle(fontSize: 14),
                ),
              );
            },
          )
        ]);
  }
}

class EmrCompleteConcernListWidget extends StatelessWidget {
  const EmrCompleteConcernListWidget({
    Key? key,
    required this.clinicalList,
  }) : super(key: key);

  final List<String?>? clinicalList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 0),
      children: [
        Text(
          'Clinical concern',
          style: AppTextStyle.boldStyle(fontSize: 14),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: clinicalList!.length,
          itemBuilder: (BuildContext context, int index) {
            return clinicalList?[index] == null
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "\u2022 " + (clinicalList![index] ?? ''),
                      style: AppTextStyle.mediumStyle(fontSize: 14),
                    ),
                  );
          },
        ),
      ],
    );
  }
}
