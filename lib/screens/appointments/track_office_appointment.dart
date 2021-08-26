import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/appointments/model/track_office_model.dart';
import 'package:hutano/screens/appointments/track_appointment/track_appointment.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'dart:async';
import 'dart:ui';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/simple_timer_text.dart';
import 'package:hutano/widgets/tracking_button.dart';
import 'package:hutano/widgets/tracking_provider_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

const TRACK_STATUS = 'trackingStatus';
const PATIENT_START_DRIVING = 'patientStartDriving';
const PATIENT_ARRIVED = 'patientArrived';

class TrackOfficeAppointment extends StatefulWidget {
  final String appointmentId;
  TrackOfficeAppointment({Key key, @required this.appointmentId})
      : super(key: key);

  @override
  _TrackOfficeAppointmentState createState() => _TrackOfficeAppointmentState();
}

class _TrackOfficeAppointmentState extends State<TrackOfficeAppointment> {
  bool _isLoading = false;
  String token;
  ApiBaseHelper api = ApiBaseHelper();
  Future<dynamic> _profileFuture;
  LatLng _userLocation = LatLng(0.00, 0.00);
  dynamic appointmentResponse;
  String _trackStatusKey = TRACK_STATUS;
  String _startDrivingStatusKey = PATIENT_START_DRIVING;
  String _arrivedStatusKey = PATIENT_ARRIVED;
  String userRating;
  InheritedContainerState _container;
  SimpleCountDownController _simpleCountDownController2 =
      SimpleCountDownController();
  var appointmentTime;
  var currentTime;
  String name = '', avatar;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    SharedPref().getToken().then((usertoken) {
      token = usertoken;
      setState(() {
        _profileFuture = api.getAppointmentDetails(
          token,
          widget.appointmentId,
          LatLng(0.00, 0.00),
        );
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackgroundNew(
            title: "Track Appointment",
            color: AppColors.snow,
            isAddBack: false,
            addHeader: true,
            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
            child: Container(
              child: FutureBuilder(
                  future: _profileFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: new CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      appointmentResponse = snapshot.data;
                      return widgetList(snapshot.data);
                    } else {
                      return Center(
                        child: new CircularProgressIndicator(),
                      );
                    }
                  }),
            )));
  }

  widgetList(dynamic appointment) {
    appointmentTime = DateTime.utc(
            DateTime.parse(appointment['data']['date']).year,
            DateTime.parse(appointment['data']['date']).month,
            DateTime.parse(appointment['data']['date']).day,
            int.parse(appointment['data']['fromTime'].split(':')[0]),
            int.parse(appointment['data']['fromTime'].split(':')[1]))
        .toLocal();
    currentTime = DateTime.utc(
            DateTime.parse(appointment['currentDate']).year,
            DateTime.parse(appointment['currentDate']).month,
            DateTime.parse(appointment['currentDate']).day,
            DateTime.parse(appointment['currentDate']).hour,
            DateTime.parse(appointment['currentDate']).minute)
        .toLocal();
    int status = 0;
    String stringStatus;
    if (appointment["data"][_trackStatusKey] != null) {
      if (appointment["data"][_trackStatusKey]["status"] != null) {
        status = appointment["data"][_trackStatusKey]["status"] ?? 0;
      } else {
        status = appointment["data"][_trackStatusKey] ?? 0;
      }
    }
    if (appointment["reason"] != null && appointment["reason"].length > 0) {
      userRating = appointment["reason"][0]["rating"]?.toString();
    }

    stringStatus = status == 0
        ? "Appointment accepted"
        : status == 1
            ? 'Driving to Office'
            : status == 2
                ? 'Arrived at Office'
                : status == 3
                    ? 'Treatment Started'
                    : 'Appointment Complete';
    name = appointment["data"]['doctor']['title'] +
        appointment["data"]['doctor']['fullName'];
    avatar = appointment["data"]['doctor']['avatar'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          SimpleCountDownTimer(
            controller: _simpleCountDownController2,
            duration: appointmentTime.difference(currentTime).inSeconds > 86400
                ? appointmentTime.difference(currentTime).inSeconds - 86400
                : 0,
            text: '',
            fontSize: 0.0,
            onComplete: () {
              _profileFuture = api.getAppointmentDetails(
                  token, widget.appointmentId, _userLocation);
            },
          ),
          TrackingProviderWidget(
              avatar: avatar,
              name: name,
              stringStatus: stringStatus,
              appointment: appointment),
          SizedBox(
            height: 20,
          ),
          timingWidget(appointment["data"]),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _button(dynamic response) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FancyButton(
        title: response[_trackStatusKey]["status"] == 0 ||
                response[_trackStatusKey]["status"] == null
            ? "Start Driving"
            : response[_trackStatusKey]["status"] == 1
                ? "Arrived"
                : response[_trackStatusKey]["status"] == 2 ||
                        response[_trackStatusKey]["status"] == 3 ||
                        response[_trackStatusKey]["status"] == 4
                    ? "Confirm Treatment End"
                    : response[_trackStatusKey]["status"] == 5
                        ? "Treatment Summary"
                        : "Start Driving",
        onPressed: () {
          int status = response[_trackStatusKey]["status"] ?? 0;
          switch (status) {
            case 0:
              changeRequestStatus(widget.appointmentId, "1");

              Widgets.showToast("You started driving");

              break;
            case 1:
              changeRequestStatus(widget.appointmentId, "2");

              break;
            case 4:
              showConfirmTreatmentDialog();
              break;
            case 5:
              Map _map = {};
              _map['id'] = widget.appointmentId;
              _map['appointmentType'] = '1';
              _map['latLng'] = _userLocation;

              Navigator.of(context).pushNamed(
                Routes.treatmentSummaryScreen,
                arguments: _map,
              );
              break;
          }
        },
        buttonHeight: 55,
      ),
    );
  }

  Widget timingWidget(Map response) {
    return Column(
      children: <Widget>[
        timingSubWidget("Appointment Placed", -1,
            response[_trackStatusKey]["status"], "", false),
        timingSubWidget("Chart Reviewed", -1,
            response[_trackStatusKey]["status"], "", false),
        timingSubWidget("Appointment Accepted", 0,
            response[_trackStatusKey]["status"], "", false),
        timingSubWidget(
            "On my way to the office",
            1,
            response[_trackStatusKey]["status"],
            response[_trackStatusKey][_startDrivingStatusKey] != null
                ? response[_trackStatusKey][_startDrivingStatusKey]
                    .toString()
                    .formatDate(dateFormat: Strings.timePattern)
                : "",
            false),
        timingSubWidget(
            "Arrived",
            2,
            response[_trackStatusKey]["status"],
            response[_trackStatusKey][_arrivedStatusKey] != null
                ? response[_trackStatusKey][_arrivedStatusKey]
                    .toString()
                    .formatDate(dateFormat: Strings.timePattern)
                : "",
            false),
        timingSubWidget(
            "Treatment Started",
            3,
            response[_trackStatusKey]["status"],
            response[_trackStatusKey]["treatmentStarted"] != null
                ? response[_trackStatusKey]["treatmentStarted"]
                    .toString()
                    .formatDate(dateFormat: Strings.timePattern)
                : "",
            false),
        response[_trackStatusKey]["status"] == 4
            ? timingSubWidget(
                "Appointment Completed",
                4,
                response[_trackStatusKey]["status"],
                response[_trackStatusKey]["providerTreatmentEnded"] != null
                    ? response[_trackStatusKey]["providerTreatmentEnded"]
                        .toString()
                        .formatDate(dateFormat: Strings.timePattern)
                    : "",
                false,
              )
            : timingSubWidget(
                "Appointment Completed",
                5,
                response[_trackStatusKey]["status"],
                response[_trackStatusKey]["patientTreatmentEnded"] != null
                    ? response[_trackStatusKey]["patientTreatmentEnded"]
                        .toString()
                        .formatDate(dateFormat: Strings.timePattern)
                    : "",
                true,
              ),
        timingSubWidget(
          "Feedback",
          6,
          userRating == null ? response[_trackStatusKey]["status"] : 6,
          "",
          true,
        ),
      ],
    );
  }

  Widget timingSubWidget(String title, int index, int status, String timing,
      bool isTreatCompleted) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Image.asset(
              index > status
                  ? 'images/trackUnchecked.png'
                  : index == status
                      ? 'images/trackCheckedCurrent.png'
                      : 'images/trackChecked.png',
              height: index == status ? 26 : 24,
            ),
            index == 6
                ? SizedBox()
                : index == 5 && userRating != null
                    ? Container(
                        height: 45,
                        width: 1,
                        color: Colors.green,
                      )
                    : index >= status
                        ? Column(
                            children: [
                              Container(
                                height: 5,
                                width: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 5,
                                width: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 5,
                                width: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 5,
                                width: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 5,
                                width: 1,
                                color: Colors.grey,
                              ),
                            ],
                          )
                        : Container(
                            height: 45,
                            width: 1,
                            color: Colors.green,
                          )
          ],
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              // true
              status == 5 && index == 6
                  ? TrackingButton(
                      title: 'Give Feedback',
                      image: 'images/trackGiveFeedBack.png',
                      onTap: () {
                        Navigator.pushNamed(context, Routes.rateDoctorScreen,
                            arguments: {
                              'rateFrom': "2",
                              'appointmentId': widget.appointmentId,
                              'name': name,
                              'avatar': avatar,
                            });
                      })
                  : status == index
                      ? index == 0
                          ? Row(
                              children: [
                                appointmentTime
                                            .difference(currentTime)
                                            .inSeconds >
                                        86400
                                    ? TrackingButton(
                                        title: 'Reschedule',
                                        image: 'images/trackReschedule.png',
                                        onTap: () {
                                          var locMap = {};
                                          locMap['lattitude'] = 0;
                                          locMap['longitude'] = 0;
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          api
                                              .getProviderProfile(
                                                  appointmentResponse['data']
                                                      ['doctor']['_id'],
                                                  locMap)
                                              .then((value) {
                                            _container.setProviderData(
                                                "providerData", value);

                                            _container.setProjectsResponse(
                                                'serviceType',
                                                appointmentResponse['data']
                                                        ['type']
                                                    .toString());
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            if (appointmentResponse[
                                                        'subServices']
                                                    .length >
                                                0) {
                                              _container.setServicesData(
                                                  "status", "1");
                                              _container.setServicesData(
                                                  "services",
                                                  appointmentResponse[
                                                      'subServices']);

                                              Navigator.of(context).pushNamed(
                                                  Routes
                                                      .selectAppointmentTimeScreen,
                                                  arguments:
                                                      SelectDateTimeArguments(
                                                          fromScreen: 2,
                                                          appointmentId: widget
                                                              .appointmentId));
                                            } else {
                                              _container.setServicesData(
                                                  "status", "0");
                                              _container.setServicesData(
                                                  "consultaceFee", '10');
                                              Navigator.of(context).pushNamed(
                                                  Routes
                                                      .selectAppointmentTimeScreen,
                                                  arguments:
                                                      SelectDateTimeArguments(
                                                          fromScreen: 2,
                                                          appointmentId: widget
                                                              .appointmentId));
                                            }
                                          });

                                          var map = {};
                                          map['appointmentId'] =
                                              appointmentResponse['data']
                                                  ['_id'];
                                        })
                                    : SizedBox(),
                                appointmentTime
                                            .difference(currentTime)
                                            .inSeconds >
                                        86400
                                    ? Container(
                                        height: 20,
                                        width: 1,
                                        color: Colors.grey[300],
                                      )
                                    : SizedBox(),
                                TrackingButton(
                                    title: 'Start driving',
                                    image: 'images/trackStartDriving.png',
                                    onTap: () {
                                      changeRequestStatus(
                                          widget.appointmentId, "1");
                                    })
                              ],
                            )
                          : index == 1
                              ? Row(
                                  children: [
                                    TrackingButton(
                                        title: 'Arrived',
                                        image: 'images/trackArrived.png',
                                        onTap: () {
                                          changeRequestStatus(
                                              widget.appointmentId, "2");
                                        }),
                                    TrackingButton(
                                        title: 'Directions',
                                        image:
                                            'assets/images/ic_navigation_blue.png',
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              Routes.officeDirectionScreen,
                                              arguments: TrackOfficeModel.fromJson(appointmentResponse));
                                        }),
                                  ],
                                )
                              : index == 2
                                  ? SizedBox()
                                  : index == 3
                                      ? SizedBox()
                                      : index == 4
                                          ? TrackingButton(
                                              title: 'Confirm Treatment End',
                                              image: 'images/trackArrived.png',
                                              onTap: () {
                                                showConfirmTreatmentDialog();
                                                // changeRequestStatus(
                                                //     widget.appointmentId, "5");
                                              })
                                          : index == 5
                                              ? SizedBox()
                                              : SizedBox()
                      : SizedBox()
            ],
          ),
        ),
        timing != ''
            ? Container(
                height: 20,
                width: 1,
                color: Colors.grey[600],
              )
            : SizedBox(),
        SizedBox(
          width: 6,
        ),
        Column(
          children: [
            SizedBox(height: 4),
            Text(
              timing,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  changeRequestStatus(String id, String status) {
    setState(() {
      _isLoading = true;
    });
    Map map = Map();
    map["trackingStatus.status"] = status;
    SharedPref().getToken().then((token) {
      api.appointmentTrackingStatus(token, map, id).then((value) {
        if (status == '5') {
          setState(() {
            _isLoading = false;
          });
          var appointmentCompleteMap = {};
          appointmentCompleteMap['appointmentId'] = widget.appointmentId;
          appointmentCompleteMap['type'] =
              appointmentResponse['data']['type'].toString();
          appointmentCompleteMap['name'] = name;
          appointmentCompleteMap['avatar'] = avatar;
          appointmentCompleteMap["dateTime"] =
              DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

          Navigator.of(context)
              .pushNamed(
            Routes.appointmentCompleteConfirmation,
            arguments: appointmentCompleteMap,
          )
              .then((value) {
            _profileFuture =
                api.getAppointmentDetails(token, id, _userLocation);
          });
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _profileFuture =
                  api.getAppointmentDetails(token, id, _userLocation);
            });
            value.toString().debugLog();
          }
        }
      }).futureError((error) {
        Widgets.showToast(error.toString());
        error.toString().debugLog();
      });
    });
  }

  void showConfirmTreatmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "The treatment is complete",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Please select confirm to complete treatment.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 26),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          side:
                              BorderSide(width: 0.3, color: AppColors.windsor),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.windsor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          color: AppColors.windsor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();

                            changeRequestStatus(widget.appointmentId, "5");
                          }),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
