import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/text_style.dart';

class SummaryPatientWidget extends StatelessWidget {
  const SummaryPatientWidget({
    Key key,
    @required this.context,
    @required this.name,
    @required this.exp,
    @required this.img,
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
          border: Border.all(color: Colors.grey[200]),
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
    Key key,
    @required this.context,
    @required this.name,
    @required this.exp,
    @required this.img,
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
          border: Border.all(color: Colors.grey[200]),
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

class InstructionWidget extends StatelessWidget {
  const InstructionWidget({
    Key key,
    @required this.title,
    @required this.text,
  }) : super(key: key);

  final String title;
  final String text;

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
          text,
          style: AppTextStyle.mediumStyle(fontSize: 14),
        ),
      ],
    );
  }
}