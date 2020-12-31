import 'package:flutter/material.dart';

import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';

class FeedbackWidget extends StatefulWidget {
  final Function onChanged;
  final List<dynamic> quetions;
  const FeedbackWidget({Key key, this.onChanged, this.quetions})
      : super(key: key);
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackWidget> {
  List<String> question = [];
  List<bool> postiveFeedback = [false, false, false, false, false];
  List<bool> negativeFeedback = [false, false, false, false, false];

  @override
  void initState() {
    for (var i = 0; i < widget.quetions.length; i++) {
      print(widget.quetions[i]["reason"]);
      question.add(widget.quetions[i]["reason"]);
    }

    super.initState();
  }

  _getRatingCount() {
    final count = postiveFeedback.where((item) => item == true).length;
    widget.onChanged(count ,postiveFeedback);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Yes"),
            SizedBox(width: 20),
            Text("No"),
            SizedBox(width: 20),
          ],
        ),
        Container(
          child: ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, pos) {
                return Row(
                  children: [
                    Expanded(
                        child: Text(
                      question[pos] ?? "",
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    )),
                    Radio(
                        value: postiveFeedback[pos],
                        activeColor: AppColors.goldenTainoi,
                        groupValue: true,
                        onChanged: (s) {
                          postiveFeedback[pos] = !postiveFeedback[pos];
                          negativeFeedback[pos] = false;
                          _getRatingCount();
                          setState(() {});
                        }),
                    Radio(
                        value: negativeFeedback[pos],
                        activeColor: AppColors.goldenTainoi,
                        groupValue: true,
                        onChanged: (s) {
                          negativeFeedback[pos] = !negativeFeedback[pos];
                          postiveFeedback[pos] = false;
                          _getRatingCount();
                          setState(() {});
                        })
                  ],
                );
              }),
        ),
      ],
    );
  }
}
