import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/text_style.dart';

class ProblemWidget extends StatelessWidget {
  ProblemWidget({
    Key key,
    @required this.dob,
    @required this.gender,
    @required this.appointmentProblem,
    @required this.problemTimeSpanMap,
  }) : super(key: key);

  final dynamic appointmentProblem;
  final Map problemTimeSpanMap;
  final String dob;
  final int gender;
  Map sidesMap = {1: "Left", 2: "Right", 3: "Top", 4: "Bottom", 5: "All Over"};

  @override
  Widget build(BuildContext context) {
    String problemText = '';
    String problemTitle = '';

    if (appointmentProblem['bodyPart'].length > 0) {
      String bodyPartList = '';
      appointmentProblem['bodyPart'].forEach((value) {
        if (value['sides'].length > 0) {
          bodyPartList += ' ' +
              '${sidesMap[int.parse('${value['sides'][0]}')]} ' +
              value['name'] +
              ',';
        } else {
          bodyPartList += ' ' + value['name'] + ',';
        }
      });
      problemTitle += bodyPartList.substring(0, bodyPartList.length - 1);
    } else {
      problemTitle += '';
    }

    String age = "---";
    String sex = '';
    if (dob != null) {
      int day, month, year;
      if (dob.toString().contains('-')) {
        day = int.parse(dob.split("-")[2]);
        month = int.parse(dob.split("-")[1]);
        year = int.parse(dob.split("-")[0]);
      } else {
        day = int.parse(dob.split("/")[1]);
        month = int.parse(dob.split("/")[0]);
        year = int.parse(dob.split("/")[2]);
      }
      final birthday = DateTime(year, month, day);
      Duration dur = DateTime.now().difference(birthday);
      String differenceInYears = (dur.inDays / 365).floor().toString();
      age = differenceInYears + ' years';
      sex = (gender ?? 1) == 2 ? "Male" : "Female";
    }

// 20 year old male, reporting discomfort level, 0/10. Started 2 Weeks ago. Second time receiving care for this problem.
// Problem worsens with exertion and made better by Supplemental Oxygen, and rest. Reporting no effect to performing daily activities.

    // to check the level of the problem
    problemText +=
        "$age old $sex, reporting discomfort level, ${appointmentProblem['problemRating']}/10. ";

    // to check how long the problem is there
    if (appointmentProblem['problemFacingTimeSpan']['type'] != '' &&
        appointmentProblem['problemFacingTimeSpan']['period'] != '')
      problemText +=
          "Started ${appointmentProblem['problemFacingTimeSpan']['period']} ${problemTimeSpanMap[appointmentProblem['problemFacingTimeSpan']['type']]} ago. ";

    //to check any treatment taken previously
    if (appointmentProblem['isTreatmentReceived'] == 0 ||
        appointmentProblem['isTreatmentReceived'] == '0')
      problemText += "First time receiving care for this problem. ";
    else
      problemText += "Second time receiving care for this problem. ";
    // to check how worse the problem is
    if (appointmentProblem['problemWorst'].length > 0) {
      String listOfWorstProblems = '';
      // appointmentProblem['problemWorst'].forEach((value) {
      //   listOfWorstProblems += " $value,";
      // });
      for (int i = 0; i < appointmentProblem['problemWorst'].length; i++) {
        listOfWorstProblems += " ${appointmentProblem['problemWorst'][i]}";
        if (appointmentProblem['problemWorst'].length > 1) {
          if (appointmentProblem['problemWorst'].length - 2 == i) {
            listOfWorstProblems += ' and';
          } else {
            listOfWorstProblems += ',';
          }
        } else {
          listOfWorstProblems += ',';
        }
      }
      problemText +=
          "Problem worsen with${listOfWorstProblems.substring(0, listOfWorstProblems.length - 1)} ";
    } else {
      problemText += '';
    }
    // to check how better the problem is getting
    if (appointmentProblem['problemBetter'].length > 0) {
      String listOfBetterProblems = '';
      // appointmentProblem['problemBetter'].forEach((value) {
      //   listOfBetterProblems += " $value,";
      // });

      for (int i = 0; i < appointmentProblem['problemBetter'].length; i++) {
        listOfBetterProblems += " ${appointmentProblem['problemBetter'][i]}";
        if (appointmentProblem['problemBetter'].length > 1) {
          if (appointmentProblem['problemBetter'].length - 2 == i) {
            listOfBetterProblems += ' and';
          } else {
            listOfBetterProblems += ',';
          }
        } else {
          listOfBetterProblems += ',';
        }
      }
      problemText +=
          "and made better by${listOfBetterProblems.substring(0, listOfBetterProblems.length - 1)}. ";
    } else {
      problemText += '';
    }

    problemText += appointmentProblem['dailyActivity'] == '1'
        ? 'Reporting no effects on my day-to-day function.'
        : appointmentProblem['dailyActivity'] == '2'
            ? 'Reporting it is difficult to perform daily activities.'
            : appointmentProblem['dailyActivity'] == '3'
                ? 'Reporting it is impossible to perform daily activities.'
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
                      problemTitle +
                      ' discomfort',
                  style: AppTextStyle.mediumStyle(),
                ))
              ],
            ),
            Text(problemText),
          ],
        ));
  }
}
