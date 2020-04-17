import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:hutano/widgets/yes_no_check.dart';

class SeekingCureScreen extends StatefulWidget {
  SeekingCureScreen({Key key}) : super(key: key);

  @override
  _SeekingCureScreenState createState() => _SeekingCureScreenState();
}

class _SeekingCureScreenState extends State<SeekingCureScreen> {
  bool isProblemImproving = false, isReceivedTreatment = false;

  final TextEditingController _descController = TextEditingController();
  bool isHoursSelect = false,
      isDaysSelect = false,
      isWeeksSelect = false,
      isMonthsSelect = false;

  InheritedContainerState _container;

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Reason for seeking care.",
        isAddBack: false,
        addBottomArrows: true,
        onForwardTap: () {
          FocusScope.of(context).requestFocus(FocusNode());

          if (!isHoursSelect &&
              !isDaysSelect &&
              !isWeeksSelect &&
              !isMonthsSelect)
            Widgets.showToast("Please select the duration");
          else {
            if (isHoursSelect)
              _container.setConsentToTreatData("problemTimeSpan", "1");
            else if (isDaysSelect)
              _container.setConsentToTreatData("problemTimeSpan", "2");
            else if (isWeeksSelect)
              _container.setConsentToTreatData("problemTimeSpan", "3");
            else if (isMonthsSelect) {
              _container.setConsentToTreatData("problemTimeSpan", "4");
            }

            isProblemImproving
                ? _container.setConsentToTreatData("isProblemImproving", "1")
                : _container.setConsentToTreatData("isProblemImproving", "0");

            isReceivedTreatment
                ? _container.setConsentToTreatData("isTreatmentReceived", "1")
                : _container.setConsentToTreatData("isTreatmentReceived", "0");

            if (_descController.text.isNotEmpty) {
              _container.setConsentToTreatData(
                  "description", _descController.text);
              Navigator.of(context).pushNamed(Routes.uploadImagesScreen);
              log(_container.consentToTreatMap.length.toString());
            } else
              Widgets.showToast(
                  "Please give a brief description of your symptoms");
          }
        },
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgetList(),
          ),
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = new List();

    formWidget.add(Text(
      "Brief description of your symptoms",
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
    ));

    formWidget.add(SizedBox(height: 14.0));

    formWidget.add(Container(
      height: 150.0,
      child: TextField(
        controller: _descController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 10,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.grey),
          labelText: "Tell us why you are seeking care..",
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
              color: Colors.grey[300],
              width: 0.5,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
              color: Colors.grey[300],
              width: 0.5,
            ),
          ),
        ),
      ),
    ));

    formWidget.add(SizedBox(height: 30));

    formWidget.add(Divider());

    formWidget.add(SizedBox(height: 30));

    formWidget.add(Text(
      "How long have you had this problem.",
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
    ));

    formWidget.add(SizedBox(height: 20));

    formWidget.add(Row(
      children: <Widget>[
        checkWidget("Hours", isHoursSelect, () {
          setState(() {
            isHoursSelect ? isHoursSelect = false : isHoursSelect = true;
            isDaysSelect = false;
            isMonthsSelect = false;
            isWeeksSelect = false;
          });
        }),
        SizedBox(width: 30.0),
        checkWidget("Days", isDaysSelect, () {
          setState(() {
            isDaysSelect ? isDaysSelect = false : isDaysSelect = true;
            isHoursSelect = false;
            isMonthsSelect = false;
            isWeeksSelect = false;
          });
        }),
        SizedBox(width: 30.0),
        checkWidget("Weeks", isWeeksSelect, () {
          setState(() {
            isHoursSelect = false;
            isDaysSelect = false;
            isMonthsSelect = false;
            isWeeksSelect ? isWeeksSelect = false : isWeeksSelect = true;
          });
        }),
        SizedBox(width: 30.0),
        checkWidget("Months", isMonthsSelect, () {
          setState(() {
            isHoursSelect = false;
            isDaysSelect = false;
            isMonthsSelect ? isMonthsSelect = false : isMonthsSelect = true;
            isWeeksSelect = false;
          });
        }),
      ],
    ));

    formWidget.add(SizedBox(height: 30));

    formWidget.add(Divider());

    formWidget.add(SizedBox(height: 30));

    formWidget.add(YesNoCheckWidget(
        labelValue: "Is the problem improving.",
        value: isProblemImproving,
        onYesTap: (value) {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(
            () => isProblemImproving = value,
          );
        },
        onNoTap: (value) => setState(() => isProblemImproving = !value)));

    formWidget.add(SizedBox(height: 30));

    formWidget.add(Divider());

    formWidget.add(SizedBox(height: 30));

    formWidget.add(YesNoCheckWidget(
        labelValue:
            "Have you received treatment for this condition in the past 3 months.",
        value: isReceivedTreatment,
        onYesTap: (value) {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(
            () => isReceivedTreatment = value,
          );
        },
        onNoTap: (value) => setState(() => isReceivedTreatment = !value)));

    formWidget.add(SizedBox(height: 65));

    return formWidget;
  }

  Widget checkWidget(String title, bool isSelected, Function onTap) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        border: Border.all(
            color: isSelected ? AppColors.goldenTainoi : Colors.grey[100]),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.0,
          color: isSelected
              ? AppColors.goldenTainoi
              : Colors.black.withOpacity(0.5),
        ),
      ),
    ).onClick(onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
      onTap();
    });
  }
}
