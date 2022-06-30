import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/text_style.dart';

class SummaryPatientWidget extends StatelessWidget {
  const SummaryPatientWidget({
    Key? key,
    required this.context,
    required this.name,
    required this.exp,
    required this.img,
  }) : super(key: key);

  final BuildContext context;
  final String name;
  final String exp;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                ApiBaseHelper.image_base_url + img,
                width: 34,
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyle.semiBoldStyle(fontSize: 15),
                ),
                Text(
                  exp,
                  style: AppTextStyle.regularStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ));
  }
}

class SummaryProviderWidget extends StatelessWidget {
  const SummaryProviderWidget({
    Key? key,
    required this.context,
    required this.name,
    required this.exp,
    required this.img,
  }) : super(key: key);

  final BuildContext context;
  final String name;
  final String exp;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(ApiBaseHelper.image_base_url + img,
                    width: 34)),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyle.semiBoldStyle(fontSize: 15),
                ),
                Row(
                  children: [
                    Image.asset('images/problem.png', height: 11, width: 11),
                    SizedBox(width: 4.0),
                    Text(
                      exp,
                      style: AppTextStyle.regularStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}

class SummaryHeaderWidget extends StatelessWidget {
  const SummaryHeaderWidget({
    Key? key,
    required this.context,
    required this.encounterDate,
    required this.provider,
    required this.patient,
    required this.mrn,
    required this.appointmentType,
  }) : super(key: key);

  final BuildContext context;
  final String encounterDate;
  final String? provider;
  final String? patient;
  final String? mrn;
  final String appointmentType;

  @override
  Widget build(BuildContext context) {
    return
        // Container(
        //     width: MediaQuery.of(context).size.width,
        //     padding: EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //       color: Colors.grey[50],
        //       borderRadius: BorderRadius.all(Radius.circular(10)),
        //       border: Border.all(color: Colors.grey[200]),
        //     ),
        // child:
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextWidget(
          keyText: 'Encounter Date',
          value: encounterDate,
        ),
        RichTextWidget(
          keyText: 'Provider',
          value: provider,
        ),
        RichTextWidget(
          keyText: 'Patient',
          value: patient,
        ),
        RichTextWidget(
          keyText: 'MRN',
          value: mrn,
        ),
        RichTextWidget(
          keyText: 'Service Location',
          value: appointmentType,
        )

        // Text(
        //   'Provider: $provider',
        //   style: AppTextStyle.regularStyle(fontSize: 15),
        // ),
        // Text(
        //   'Patient: $patient',
        //   style: AppTextStyle.regularStyle(fontSize: 15),
        // ),
        // Text(
        //   'MRN: $mrn',
        //   style: AppTextStyle.regularStyle(fontSize: 15),
        // ),
        // Text(
        //   'Service Location: $appointmentType',
        //   style: AppTextStyle.regularStyle(fontSize: 15),
        // ),
      ],
    );
  }
}

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({
    Key? key,
    required this.keyText,
    required this.value,
    text,
  }) : super(key: key);

  final String keyText;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            children: <TextSpan>[
          TextSpan(
            text: '$keyText: ',
            style: AppTextStyle.mediumStyle(fontSize: 14),
          ),
          TextSpan(text: value, style: AppTextStyle.regularStyle(fontSize: 14)),
        ]));
  }
}

class InstructionWidget extends StatelessWidget {
  const InstructionWidget({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          title,
          style: AppTextStyle.semiBoldStyle(fontSize: 16),
        ),
        SizedBox(height: 2),
        Text(
          text!,
          style: AppTextStyle.mediumStyle(fontSize: 14),
        ),
      ],
    );
  }
}
