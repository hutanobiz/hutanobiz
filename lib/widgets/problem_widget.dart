import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/text_style.dart';

class ProblemWidget extends StatelessWidget {
  ProblemWidget({
    Key key,
    @required this.appointmentProblem,
    @required this.problemTimeSpanMap,
  }) : super(key: key);

  final dynamic appointmentProblem;
  final Map problemTimeSpanMap;
  Map sidesMap = {1: "Left", 2: "Right", 3: "Back", 4: "Front"};

  @override
  Widget build(BuildContext context) {
    String problemText = '';
    String problemTitle = '';

    if (appointmentProblem['bodyPart'].length > 0) {
      String bodyPartList = '';
      appointmentProblem['bodyPart'].forEach((value) {
        if (value['sides'].length > 0) {
          bodyPartList +=
              ' ' + '${sidesMap[value['sides'][0]]} ' + value['name'] + ',';
        } else {
          bodyPartList += ' ' + value['name'] + ',';
        }
      });
      problemTitle += bodyPartList.substring(0, bodyPartList.length - 1);
    } else {
      problemTitle += '';
    }
    // to check the level of the problem
    problemText +=
        "Discomfort level of ${appointmentProblem['problemRating']}/10. ";

    // to check how long the problem is there
    if (appointmentProblem['problemFacingTimeSpan']['type'] != '' &&
        appointmentProblem['problemFacingTimeSpan']['period'] != '')
      problemText +=
          "Started ${appointmentProblem['problemFacingTimeSpan']['period']} ${problemTimeSpanMap[appointmentProblem['problemFacingTimeSpan']['type']]} ago. ";

    //to check any treatment taken previously
    if (appointmentProblem['isTreatmentReceived'] == 0)
      problemText += "First time receiving care for this problem. ";
    else
      problemText += "Second time receiving care for this problem. ";

    // to check how worse the problem is
    if (appointmentProblem['problemWorst'].length > 0) {
      String listOfWorstProblems = '';
      appointmentProblem['problemWorst'].forEach((value) {
        listOfWorstProblems += " $value,";
      });
      problemText +=
          "Problem worsen with${listOfWorstProblems.substring(0, listOfWorstProblems.length - 1)} ";
    } else {
      problemText += '';
    }

    // to check how better the problem is getting
    if (appointmentProblem['problemBetter'].length > 0) {
      String listOfBetterProblems = '';
      appointmentProblem['problemBetter'].forEach((value) {
        listOfBetterProblems += " $value,";
      });
      problemText +=
          "and made better by${listOfBetterProblems.substring(0, listOfBetterProblems.length - 1)}. ";
    } else {
      problemText += '';
    }

    problemText += appointmentProblem['dailyActivity'] == '1'
        ? 'Discomfort makes no effects on my day-to-day function.'
        : appointmentProblem['dailyActivity'] == '2'
            ? 'Discomfort makes it difficult to perform daily activities.'
            : appointmentProblem['dailyActivity'] == '3'
                ? 'Discomfort makes it impossible to perform daily activities.'
                : '';

    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey[200]),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey[200]),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: appointmentProblem['image'] != null
                        ? Image.network(
                            ApiBaseHelper.image_base_url +
                                appointmentProblem['image'],
                            height: 40,
                            width: 40,
                          )
                        : Image.asset(
                            'images/stethoscope.png',
                            height: 40,
                            width: 40,
                          ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Text(
                  appointmentProblem['name'] +
                      ' associated with' +
                      problemTitle,
                  style: AppTextStyle.mediumStyle(),
                ))
              ],
            ),
            Text(problemText),
          ],
        ));
  }
}
