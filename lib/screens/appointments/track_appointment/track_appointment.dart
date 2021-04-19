import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/screens/appointments/track_appointment/stepper.dart'
    as StepTracker;
import 'package:hutano/src/apis/api_manager.dart';
import 'package:hutano/src/apis/error_model.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/utils/date_utils.dart';
import 'package:hutano/src/utils/dialog_utils.dart';
import 'package:hutano/src/widgets/text_with_image.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

import '../../../colors.dart';
import 'model/res_tracking_appointment.dart';
import 'provider_info.dart';
import 'package:intl/date_symbol_data_local.dart';

class TrackAppointment extends StatefulWidget {
  @override
  _TrackAppointmentState createState() => _TrackAppointmentState();
}

final String onWayToOffice = "1";
final String arrived = "2";

enum AppointmentType { office, onsite, video }
enum OfficeAppointmentStatus {
  appointmentAccepted,
  officeReady,
  onwayToOffice,
  arrived,
  appooitnmentComplete,
  feedback
}

class _TrackAppointmentState extends State<TrackAppointment> {
  AppointmentTrackData statusData;
  ProviderData providerData;
  ApiBaseHelper api = ApiBaseHelper();
  List statusList = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en');

    _getOfficeStatus();
  }

  _getOfficeStatus() async {
    final param = <String, dynamic>{
      'appointmentId': "606add193bc27d15f45dc5b5",
    };

    try {
      var res = await ApiManager().getOfficeAppointmentStatus(param);
      if (res.response != null) {
        statusData = res.response.appointmentTrackData;
        providerData = res.response.providerData;

        _setStatusList();

        setState(() {});
      }
    } on ErrorModel catch (e) {
      DialogUtils.showAlertDialog(context, e.response);
    } catch (e) {
      debugPrint(e);
    }
  }

  changeRequestStatus(String id, String status) {
    Map map = Map();
    map["trackingStatus.status"] = status;
    SharedPref().getToken().then((token) {
      api.appointmentTrackingStatus(token, map, id).then((value) {
        var a = value;
        _getOfficeStatus();
      });
    });
  }

  _setStatusList() {
    var list = [];

    list.add(statusData.appointmentAccepted);
    list.add(statusData.providerOfficeReady);
    list.add(statusData.patientStartDriving);
    list.add(statusData.patientArrived);
    list.add(statusData.patientTreatmentEnded);
    list.add(statusData.feedback);

    statusList = list;
  }

  onStatusChange(status) {
    changeRequestStatus("606add193bc27d15f45dc5b5", status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Track Appointment",
        color: AppColors.snow,
        isAddBack: false,
        addHeader: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (statusData != null) ProviderInfo(providerData: providerData),
            if (statusData != null)
              TrackAppointmentStatus(
                  statusData: statusData,
                  statusList: statusList,
                  onStatusChange: onStatusChange),
          ],
        ),
      ),
    );
  }
}

class TrackAppointmentStatus extends StatelessWidget {
  final AppointmentTrackData statusData;
  final List statusList;
  final Function onStatusChange;

  const TrackAppointmentStatus(
      {Key key, this.statusData, this.statusList, this.onStatusChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StepTracker.Stepper(
      currentStep: _getActiveStep() - 1,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Row(
          children: <Widget>[
            Container(
              child: null,
            ),
            Container(
              child: null,
            ),
          ],
        );
      },
      type: StepTracker.StepperType.vertical,
      steps: [
        StepTracker.Step(
            state: statusList[0] != null
                ? StepTracker.StepState.complete
                : StepTracker.StepState.disabled,
            title: _getTitle("Appointment Accepted", statusList[0]),
            content: Text("")),
        StepTracker.Step(
          isActive: false,
          state: statusList[1] != null
              ? StepTracker.StepState.complete
              : StepTracker.StepState.disabled,
          title: _getTitle("Provider's Office Ready", statusList[1]),
          content: _getContent("Start Driving", FileConstants.icDrive, () {
            onStatusChange(onWayToOffice);
          }),
        ),
        StepTracker.Step(
          isActive: false,
          state: statusList[2] != null
              ? StepTracker.StepState.complete
              : StepTracker.StepState.disabled,
          title: _getTitle("On my way to the office", statusList[2]),
          content: _getContent("Directions", FileConstants.icNavigation, () {
            Widgets.showToast("asd");
          }),
        ),
        StepTracker.Step(
          isActive: false,
          state: statusList[3] != null
              ? StepTracker.StepState.complete
              : StepTracker.StepState.disabled,
          title: _getTitle("Arrived", statusList[3]),
          content: _getContent("Check In", FileConstants.icNavigation, () {
            Widgets.showToast("asd");
          }),
        ),
        StepTracker.Step(
          isActive: false,
          state: statusList[4] != null
              ? StepTracker.StepState.complete
              : StepTracker.StepState.disabled,
          title: _getTitle("Appointment Complete", statusList[4]),
          content: _getContent("Need help?", FileConstants.icNavigation, () {
            Widgets.showToast("asd");
          }),
        ),
        StepTracker.Step(
          isActive: false,
          state: statusList[5] != null
              ? StepTracker.StepState.complete
              : StepTracker.StepState.disabled,
          title: _getTitle("Feedback", statusList[5]),
          content: _getContent("Give Feedback", FileConstants.icRatingBlue, () {
            Widgets.showToast("asd");
          }),
        )
      ],
    ));
  }

  _getTime(time) {
    if (time == null) return "";
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z").parse(time);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('hh:mm a');
    return outputFormat.format(inputDate);
  }

  _getActiveStep() {
    int step = statusList.indexWhere((element) => element == null);
    print(step.toString());
    return step;
  }

  _getTitle(title, date) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                color: colorBlack2,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
          ),
        ),
        Text("${_getTime(date)}")
      ],
    );
  }

  _getContent(label, icon, onPressed) {
    return Container(
      margin: EdgeInsets.only(left: 80),
      child: InkWell(
        onTap: onPressed,
        child: TextWithImage(
            size: 20,
            imageSpacing: 7,
            textStyle: TextStyle(
                color: colorPurple100,
                fontWeight: FontWeight.w500,
                fontFamily: gilroyMedium,
                fontStyle: FontStyle.normal,
                fontSize: 13.0),
            label: label,
            image: icon),
      ),
    );
  }

  // _getActiveStep() {
  //   var step = 0;
  //   if (statusData.appointmentAccepted == null) {
  //     step = 0;
  //   } else if (statusData.providerOfficeReady == null) {
  //     step = 1;
  //   } else if (statusData.patientStartDriving == null) {
  //     step = 2;
  //   } else if (statusData.patientArrived == null) {
  //     step = 3;
  //   } else if (statusData.patientTreatmentEnded == null) {
  //     step = 4;
  //   } else if (statusData.feedback == null) {
  //     step = 5;
  //   }
  //   return step;
  // }

  _getStep() {
    StepTracker.Step(
        isActive: true,
        state: StepTracker.StepState.complete,
        title: Row(
          children: [
            Expanded(child: Text("Appintment Accepter")),
            Text("Time")
          ],
        ),
        content: Text("Appintment Accepter"));
  }
}
