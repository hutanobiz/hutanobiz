import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/simple_timer_text.dart';
import 'package:hutano/widgets/tracking_button.dart';
import 'package:hutano/widgets/tracking_provider_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;

const TRACK_STATUS_PROVIDER = 'trackingStatusProvider';
const PROVIDER_START_DRIVING = 'providerStartDriving';
const PROVIDER_ARRIVED = 'providerArrived';

class TrackTelemedicineAppointment extends StatefulWidget {
  TrackTelemedicineAppointment({Key key, this.appointmentId}) : super(key: key);
  String appointmentId;

  @override
  _TrackTelemedicineAppointmentState createState() =>
      _TrackTelemedicineAppointmentState();
}

class _TrackTelemedicineAppointmentState
    extends State<TrackTelemedicineAppointment> {
  Future<dynamic> _profileFuture;
  String token;
  int _appointmentType = 0;
  bool _isLoading = false;

  String _trackStatusKey = TRACK_STATUS_PROVIDER;
  String _startDrivingStatusKey = PROVIDER_START_DRIVING;
  String _arrivedStatusKey = PROVIDER_ARRIVED;

  var _userLocation = LatLng(0.00, 0.00);
  ApiBaseHelper api = ApiBaseHelper();
  String userRating;
  dynamic appointmentResponse;
  InheritedContainerState _container;
  bool isProviderArrivedConfirm;
  SimpleCountDownController _simpleCountDownController2 =
      SimpleCountDownController();
  var appointmentTime;
  var currentTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _container = InheritedContainer.of(context);
    _userLocation = LatLng(0.00, 0.00);

    SharedPref().getToken().then((tokenString) {
      token = tokenString;
      setState(() {
        _profileFuture = api.getAppointmentDetails(
          token,
          widget.appointmentId,
          _userLocation,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Appointment Status",
        isLoading: _isLoading,
        isAddBack: true,
        addBackButton: false,
        color: Colors.white,
        padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
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
            },
          ),
        ),
      ),
    );
  }

  Widget widgetList(Map appointment) {
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

    String name = "---", stringStatus = "", avatar;

    _trackStatusKey = TRACK_STATUS_PROVIDER;
    _startDrivingStatusKey = PROVIDER_START_DRIVING;
    _arrivedStatusKey = PROVIDER_ARRIVED;

    _appointmentType = appointment['data']["type"];

    if (appointment["reason"] != null && appointment["reason"].length > 0) {
      userRating = appointment["reason"][0]["rating"]?.toString();
    }

    isProviderArrivedConfirm =
        appointment['data'][_trackStatusKey]['isProviderArrivedConfirm'];

    int status = 0;
    if (appointment['data']['videoAppointmentStatus'] != null) {
      if (appointment['data']['videoAppointmentStatus']["status"] != null) {
        status = appointment['data']['videoAppointmentStatus']["status"] ?? 0;
      } else {
        status = appointment['data']['videoAppointmentStatus'] ?? 0;
      }
    }

    stringStatus = status == 4
        ? 'Appointment Complete'
        : appointment['data']['isDoctorJoin']
            ? 'Provider Ready'
            : "Appointment accepted";

    name = appointment["data"]['doctor']['fullName'];
    avatar = appointment["data"]['doctor']['avatar'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      padding: EdgeInsets.all(20),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SimpleCountDownTimer(
            controller: _simpleCountDownController2,
            duration: appointmentTime.difference(currentTime).inSeconds > 86400
                ? appointmentTime.difference(currentTime).inSeconds - 86400
                : 0,
            text: '',
            fontSize: 0.0,
            onComplete: () {
              setState(() {
                _profileFuture = api.getAppointmentDetails(
                    token, widget.appointmentId, _userLocation);
              });
            },
          ),
          TrackingProviderWidget(
              avatar: avatar,
              name: name,
              stringStatus: stringStatus,
              appointment: appointment),
          timingWidget(appointment['data'], status),
        ],
      ),
    );
  }

  Widget _onsiteButton(dynamic response) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FancyButton(
        buttonHeight: 55,
        title: response[TRACK_STATUS_PROVIDER]["status"] == 5
            ? "Treatment Summary"
            : "Confirm Treatment End",
        onPressed: () {
          int status = response[TRACK_STATUS_PROVIDER]["status"] ?? 0;
          switch (status) {
            case 4:
              showConfirmTreatmentDialog();
              break;
            case 5:
              Map _map = {};
              _map['id'] = widget.appointmentId;
              _map['appointmentType'] = _appointmentType;
              _map['latLng'] = _userLocation;

              Navigator.of(context).pushNamed(
                Routes.treatmentSummaryScreen,
                arguments: _map,
              );
              break;
          }
        },
      ),
    );
  }

// 0:"status" -> 0
// 1:"startcallTime" -> null
// 2:"endcallTime" -> null
// 3:"providerTreatmentEnded" -> null
// 4:"isDoctorVideoCallStart" -> false
// 5:"isPatientVideoCallStart" -> false

// "isUserJoin" -> false
// 50:"isDoctorJoin" -> false
// 52:"isUserWantRejoin" -> false
// 53:"isDoctorWantRejoin" -> false

  Widget timingWidget(Map response, status) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        timingSubWidget("Appointment Accepted", 0, status,
            response['isUserJoin'], response['isDoctorJoin']),
        timingSubWidget('Provider Ready', 1, status, response['isUserJoin'],
            response['isDoctorJoin']),
        timingSubWidget('Consult Complete', 2, status, response['isUserJoin'],
            response['isDoctorJoin']),
        timingSubWidget(
          "Feedback",
          3,
          status,
          response['isUserJoin'],
          response['isDoctorJoin'],
          isRated: userRating == null ? false : true,
        ),
      ],
    );
  }

  Widget timingSubWidget(
      String title, int index, int status, bool isUserJoin, bool isDoctorJoin,
      {bool isRated}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Image.asset(
              index == 3
                  ? userRating != null
                      ? 'images/trackCheckedCurrent.png'
                      : 'images/trackUnchecked.png'
                  : index == 2
                      ? status == 4
                          ? userRating != null
                              ? 'images/trackChecked.png'
                              : 'images/trackCheckedCurrent.png'
                          : 'images/trackUnchecked.png'
                      : index == 1
                          ? isDoctorJoin
                              ? status == 4
                                  ? 'images/trackChecked.png'
                                  : 'images/trackCheckedCurrent.png'
                              : 'images/trackUnchecked.png'
                          : isDoctorJoin
                              ? 'images/trackChecked.png'
                              : 'images/trackCheckedCurrent.png',
              height: 24,
            ),
            index == 3
                ? SizedBox()
                : index == 2
                    ? userRating != null
                        ? Container(
                            height: 35,
                            width: 1,
                            color: Colors.green,
                          )
                        : dottedLine()
                    : index == 1
                        ? status == 4
                            ? Container(
                                height: 45,
                                width: 1,
                                color: Colors.green,
                              )
                            : dottedLine()
                        : isDoctorJoin
                            ? Container(
                                height: 45,
                                width: 1,
                                color: Colors.green,
                              )
                            : dottedLine()
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
              index == 3
                  ? userRating == null && status == 4
                      ? TrackingButton(
                          title: 'Give Feedback',
                          image: 'images/trackGiveFeedBack.png',
                          onTap: () {
                            Widgets.showCallDialog(
                                context: context,
                                isRejoin: false,
                                onEnterCall: (bool record, bool video) async {
                                  print('$record $video');
                                });
                            // Navigator.pushNamed(
                            //     context, Routes.rateDoctorScreen, arguments: {
                            //   'rateFrom': "2",
                            //   'appointmentId': widget.appointmentId
                            // });
                          })
                      : SizedBox()
                  : index == 2
                      ? SizedBox()
                      : index == 1
                          ? status == 4
                              ? SizedBox()
                              : !isDoctorJoin
                                  ? SizedBox()
                                  : !isUserJoin
                                      ? TrackingButton(
                                          title: 'Enter Waiting Room',
                                          image: 'images/watch.png',
                                          onTap: () {
                                            var appointmentId = {};
                                            appointmentId['appointmentId'] =
                                                widget.appointmentId;
                                            api
                                                .patientAvailableForCall(
                                                    token, appointmentId)
                                                .then((value) {
                                              setState(() {
                                                _profileFuture =
                                                    api.getAppointmentDetails(
                                                        token,
                                                        widget.appointmentId,
                                                        _userLocation);
                                              });
                                            });
                                          })
                                      : TrackingButton(
                                          title: 'Join Call',
                                          image: 'images/ic_video_app.png',
                                          onTap: () async {
                                            Widgets.showCallDialog(
                                                context: context,
                                                isRejoin: false,
                                                onEnterCall: (bool record,
                                                    bool video) async {
                                                  print('$record $video');
                                                  Map<
                                                          Permission.Permission,
                                                          Permission
                                                              .PermissionStatus>
                                                      statuses = await [
                                                    Permission
                                                        .Permission.camera,
                                                    Permission
                                                        .Permission.microphone
                                                  ].request();
                                                  if ((statuses[Permission
                                                              .Permission
                                                              .camera]
                                                          .isGranted) &&
                                                      (statuses[Permission
                                                              .Permission
                                                              .microphone]
                                                          .isGranted)) {
                                                    Map appointment = {};
                                                    appointment["_id"] =
                                                        widget.appointmentId;
                                                    appointment['video'] = true;
                                                    appointment['record'] =
                                                        true;
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      Routes.callPage,
                                                      arguments: appointment,
                                                    )
                                                        .then((value) {
                                                      setState(() {
                                                        _profileFuture = api
                                                            .getAppointmentDetails(
                                                                token,
                                                                widget
                                                                    .appointmentId,
                                                                _userLocation);
                                                      });
                                                    });
                                                  } else {
                                                    Widgets.showErrorialog(
                                                        context: context,
                                                        description:
                                                            'Camera & Microphone permission Requied');
                                                  }
                                                });
                                          })
                          : Row(
                              children: [
                                isUserJoin || isDoctorJoin
                                    ? SizedBox()
                                    : appointmentTime
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
                                                      appointmentResponse[
                                                              'data']['doctor']
                                                          ['_id'],
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
                                isUserJoin || isDoctorJoin
                                    ? SizedBox()
                                    : appointmentTime
                                                .difference(currentTime)
                                                .inSeconds >
                                            86400
                                        ? Container(
                                            height: 20,
                                            width: 1,
                                            color: Colors.grey[300],
                                          )
                                        : SizedBox(),
                                !isUserJoin
                                    ? TrackingButton(
                                        title: 'Enter Waiting Room',
                                        image: 'images/watch.png',
                                        onTap: () {
                                          var appointmentId = {};
                                          appointmentId['appointmentId'] =
                                              widget.appointmentId;
                                          api
                                              .patientAvailableForCall(
                                                  token, appointmentId)
                                              .then((value) {
                                            setState(() {
                                              _profileFuture =
                                                  api.getAppointmentDetails(
                                                      token,
                                                      widget.appointmentId,
                                                      _userLocation);
                                            });
                                          });
                                        })
                                    : SizedBox()
                              ],
                            )
            ],
          ),
        ),
        // timing != ''
        //     ? Container(
        //         height: 20,
        //         width: 1,
        //         color: Colors.grey[600],
        //       )
        //     : SizedBox(),
        // SizedBox(
        //   width: 6,
        // ),
        // Column(
        //   children: [
        //     SizedBox(height: 4),
        //     Text(
        //       timing,
        //       style: TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w400,
        //           color: Colors.grey[600]),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Column dottedLine() {
    return Column(
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
    );
  }

  onsiteChangeRequestStatus(String id, String status) {
    Map map = Map();
    map["trackingStatusProvider.status"] = status;
    api.onsiteAppointmentTrackingStatus(token, map, id).then((value) {
      if (status == '5') {
        setState(() {
          _isLoading = false;
        });
        var appointmentCompleteMap = {};
        appointmentCompleteMap['appointmentId'] = widget.appointmentId;
        appointmentCompleteMap['type'] =
            appointmentResponse['data']['type'].toString();
        appointmentCompleteMap['name'] = appointmentResponse["data"]['doctor']
                ['title'] +
            ' ' +
            appointmentResponse["data"]['doctor']['fullName'];
        appointmentCompleteMap["dateTime"] =
            DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

        Navigator.of(context)
            .pushNamed(
          Routes.appointmentCompleteConfirmation,
          arguments: appointmentCompleteMap,
        )
            .then((value) {
          _profileFuture = api.getAppointmentDetails(token, id, _userLocation);
        });
        // Navigator.pushNamed(context, Routes.rateDoctorScreen, arguments: {
        //   'rateFrom': "2",
        //   'appointmentId': widget.appointmentId
        // }).then((value) {
        //   _profileFuture =
        //       api.getAppointmentDetails(token, id, _userLocation);
        // });
      } else {
        if (mounted) {
          setState(() {
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

                            onsiteChangeRequestStatus(
                                widget.appointmentId, "5");
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
