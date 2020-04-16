import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class YesNoCheckWidget extends StatefulWidget {
  final String labelValue;
  final bool value;
  final Function onYesTap;
  final Function onNoTap;
  const YesNoCheckWidget(
      {Key key,
      @required this.labelValue,
      @required this.value,
      @required this.onYesTap,
      @required this.onNoTap})
      : super(key: key);

  @override
  _YesNoCheckWidgetState createState() => _YesNoCheckWidgetState();
}

class _YesNoCheckWidgetState extends State<YesNoCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.labelValue, style: TextStyle(fontWeight: FontWeight.w500)),
        Row(
          children: <Widget>[
            Checkbox(
              onChanged: widget.onYesTap,
              value: widget.value,
              activeColor: AppColors.goldenTainoi,
            ),
            Text("Yes"),
            SizedBox(width: 20.0),
            Checkbox(
              onChanged: widget.onNoTap,
              value: !widget.value,
              activeColor: AppColors.goldenTainoi,
            ),
            Text(
              "No",
            ),
          ],
        ),
      ],
    );
  }
}
