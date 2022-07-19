import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/video_call.dart';
import 'package:hutano/screens/appointments/virtualappointment/overlay_handler.dart';
import 'package:hutano/screens/appointments/virtualappointment/overlay_service.dart';
import 'package:hutano/screens/book_appointment/morecondition/model/selection_health_issue_model.dart';
import 'package:hutano/screens/book_appointment/morecondition/providers/health_condition_provider.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/simple_timer_text.dart';
import 'package:hutano/widgets/tracking_button.dart';
import 'package:hutano/widgets/tracking_provider_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;
import 'package:provider/provider.dart';

const TRACK_STATUS_PROVIDER = 'trackingStatusProvider';
const PROVIDER_START_DRIVING = 'providerStartDriving';
const PROVIDER_ARRIVED = 'providerArrived';

class TrackTelemedicineAppointment extends StatefulWidget {
  TrackTelemedicineAppointment({Key? key, this.appointmentId})
      : super(key: key);
  String? appointmentId;

  @override
  _TrackTelemedicineAppointmentState createState() =>
      _TrackTelemedicineAppointmentState();
}

class _TrackTelemedicineAppointmentState
    extends State<TrackTelemedicineAppointment> {
  Future<dynamic>? _profileFuture;
  String? token;
  int? _appointmentType = 0;
  bool _isLoading = false;
  String _trackStatusKey = TRACK_STATUS_PROVIDER;

  var _userLocation = LatLng(0.00, 0.00);
  ApiBaseHelper api = ApiBaseHelper();
  String? userRating;
  dynamic appointmentResponse;
  late InheritedContainerState _container;
  bool? isProviderArrivedConfirm;
  SimpleCountDownController _simpleCountDownController2 =
      SimpleCountDownController();
  late var appointmentTime;
  var currentTime;
  String? name = "---", avatar;
  bool isEdit = false;
  ScrollController scrollController = ScrollController();
  double animateTo = 0.0;
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
    Provider.of<OverlayHandlerProvider>(context, listen: false)
        .updateVideoCallContext(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (Provider.of<OverlayHandlerProvider>(context, listen: false)
              .overlayActive) {
            Provider.of<OverlayHandlerProvider>(context, listen: false)
                .enablePip(.60);
            return false;
          }
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.goldenTainoi,
          body: LoadingBackgroundNew(
            title: "Track Appointment",
            color: AppColors.snow,
            isAddBack: false,
            addHeader: true,
            padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: new CustomLoader(),
                    );
                  } else if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    appointmentResponse = snapshot.data as Map;
                    return widgetList(snapshot.data as Map);
                  } else {
                    return Center(
                      child: new CustomLoader(),
                    );
                  }
                },
              ),
            ),
          ),
        ));
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

    String stringStatus = "";

    _trackStatusKey = TRACK_STATUS_PROVIDER;

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

    name = appointment["data"]['doctor']['title'] +
        appointment["data"]['doctor']['fullName'];
    avatar = appointment["data"]['doctor']['avatar'];
    Timer(
      Duration(milliseconds: 2),
      () => scrollController.jumpTo(animateTo),
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      padding: EdgeInsets.all(20),
      child: ListView(
        controller: scrollController,
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
              _profileFuture = api.getAppointmentDetails(
                  token, widget.appointmentId, _userLocation);
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
        timingSubWidget("Appointment Placed", -1, status,
            response['isUserJoin'], response['isDoctorJoin']),
        timingSubWidget("Chart Reviewed", -1, status, response['isUserJoin'],
            response['isDoctorJoin']),
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
        SizedBox(height: 20),
        response['status'] == 2 || response['status'] == 6 || status >= 3
            ? SizedBox()
            : Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.0),
                  ),
                  border: Border.all(width: 0.5, color: Colors.grey[300]!),
                ),
                child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    // recreationaltitleWidget('Edit appointment details', isEdit),
                    // isEdit
                    //     ? Column(
                    child: ExpansionTile(
                      initiallyExpanded: isEdit,
                      onExpansionChanged: ((val) {
                        // setState(() {
                        isEdit = !isEdit;
                        // });
                      }),
                      tilePadding: EdgeInsets.zero,
                      textColor: Colors.black,
                      collapsedTextColor: Colors.black,
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      title: Text(
                        'Edit appointment details',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      children: [
                        editWidget(
                            onTap: () {
                              animateTo = scrollController.position.pixels;
                              Navigator.of(context)
                                  .pushNamed(Routes.socialHistory, arguments: {
                                'isEdit': true,
                                'socialHistory': appointmentResponse['data']
                                    ['socialHistory'],
                                'appointmentId': widget.appointmentId
                              }).then((value) {
                                setState(() {
                                  _profileFuture = api.getAppointmentDetails(
                                      token,
                                      widget.appointmentId,
                                      _userLocation);
                                });
                              });
                            },
                            title: 'Social history'),
                        editWidget(
                            onTap: () {
                              animateTo = scrollController.position.pixels;
                              Navigator.of(context).pushNamed(
                                  Routes.allergiesScreen,
                                  arguments: {
                                    'isEdit': true,
                                    'allergy': appointmentResponse['data']
                                        ['allergy'],
                                    'appointmentId': widget.appointmentId
                                  }).then((value) {
                                setState(() {
                                  _profileFuture = api.getAppointmentDetails(
                                      token,
                                      widget.appointmentId,
                                      _userLocation);
                                });
                              });
                            },
                            title: 'Allergies'),
                        editWidget(
                            onTap: () {
                              animateTo = scrollController.position.pixels;
                              Navigator.of(context).pushNamed(
                                  Routes.medicalHistoryScreen,
                                  arguments: {
                                    'isEdit': true,
                                    'medicalHistory':
                                        appointmentResponse['data']
                                            ['medicalHistory'],
                                    'appointmentId': widget.appointmentId
                                  }).then((value) {
                                setState(() {
                                  _profileFuture = api.getAppointmentDetails(
                                      token,
                                      widget.appointmentId,
                                      _userLocation);
                                });
                              });
                            },
                            title: 'Medical history'),
                        editWidget(
                            onTap: () {
                              animateTo = scrollController.position.pixels;
                              Navigator.of(context).pushNamed(
                                  Routes.bookingUploadImages,
                                  arguments: {
                                    'isEdit': true,
                                    'medicalImages': appointmentResponse['data']
                                        ['medicalImages'],
                                    'appointmentId': widget.appointmentId,
                                    'appointmentProblems': appointmentResponse[
                                        'appointmentProblems'][0]
                                  }).then((value) {
                                setState(() {
                                  _profileFuture = api.getAppointmentDetails(
                                      token,
                                      widget.appointmentId,
                                      _userLocation);
                                });
                              });
                            },
                            title: 'Medical images'),
                        editWidget(
                            onTap: () {
                              animateTo = scrollController.position.pixels;
                              Navigator.of(context).pushNamed(
                                  Routes.bookingUploadMedicalDocument,
                                  arguments: {
                                    'isEdit': true,
                                    'medicalDocuments':
                                        appointmentResponse['data']
                                            ['medicalDocuments'],
                                    'appointmentId': widget.appointmentId,
                                    'appointmentProblems': appointmentResponse[
                                        'appointmentProblems'][0]
                                  }).then((value) {
                                setState(() {
                                  _profileFuture = api.getAppointmentDetails(
                                      token,
                                      widget.appointmentId,
                                      _userLocation);
                                });
                              });
                            },
                            title: 'Medical documents'),
                        editWidget(
                            onTap: () {
                              animateTo = scrollController.position.pixels;
                              Navigator.of(context).pushNamed(
                                  Routes.routeUploadDiagnosticNew,
                                  arguments: {
                                    'isEdit': true,
                                    'medicalDiagnostics':
                                        appointmentResponse['data']
                                            ['medicalDiagnostics'],
                                    'appointmentId': widget.appointmentId,
                                    'appointmentProblems': appointmentResponse[
                                        'appointmentProblems'][0]
                                  }).then((value) {
                                setState(() {
                                  _profileFuture = api.getAppointmentDetails(
                                      token,
                                      widget.appointmentId,
                                      _userLocation);
                                });
                              });
                            },
                            title: 'Vaccination documents'),
                        editWidget(
                            onTap: () {
                              animateTo = scrollController.position.pixels;
                              Navigator.of(context).pushNamed(
                                  Routes.routeMedicineInformation,
                                  arguments: {
                                    'isEdit': true,
                                    'medicationDetails':
                                        appointmentResponse['data']
                                            ['medications'],
                                    'appointmentId': widget.appointmentId
                                  }).then((value) {
                                setState(() {
                                  _profileFuture = api.getAppointmentDetails(
                                      token,
                                      widget.appointmentId,
                                      _userLocation);
                                });
                              });
                            },
                            title: 'Medication details'),
                        editWidget(
                            onTap: () {
                              animateTo = scrollController.position.pixels;
                              Navigator.of(context).pushNamed(
                                  Routes.routeAddPharmacy,
                                  arguments: {
                                    'isEdit': true,
                                    'preferredPharmacy':
                                        appointmentResponse['data']['pharmacy'],
                                    'appointmentId': widget.appointmentId
                                  }).then((value) {
                                setState(() {
                                  _profileFuture = api.getAppointmentDetails(
                                      token,
                                      widget.appointmentId,
                                      _userLocation);
                                });
                              });
                            },
                            title: 'Preferred pharmacy '),
                        editWidget(
                            onTap: () {
                              animateTo = scrollController.position.pixels;
                              Navigator.of(context).pushNamed(
                                  Routes.routeVitalReviews,
                                  arguments: {
                                    'isEdit': true,
                                    'vitals': appointmentResponse['data']
                                        ['vitals'],
                                    'appointmentId': widget.appointmentId
                                  }).then((value) {
                                setState(() {
                                  _profileFuture = api.getAppointmentDetails(
                                      token,
                                      widget.appointmentId,
                                      _userLocation);
                                });
                              });
                            },
                            title: 'Vitals'),
                        editWidget(
                          onTap: () {
                            animateTo = scrollController.position.pixels;
                            List<SelectionHealthIssueModel>
                                _selectedConditionList = [];
                            List<int> tempList = [];
                            int i = 0;
                            appointmentResponse['appointmentProblems']
                                .forEach((element) {
                              // if (element.isSelected) {
                              _selectedConditionList.add(
                                  SelectionHealthIssueModel(
                                      index: i,
                                      sId: element['problemId'],
                                      name: element['name'],
                                      image: element['image'],
                                      problem: appointmentResponse[
                                          'appointmentProblems'][i],
                                      isSelected: true));
                              tempList.add(i);
                              i++;
                              // } else {
                              //   i++;
                              // }
                            });
                            if (tempList.isNotEmpty) {
                              Provider.of<HealthConditionProvider>(context,
                                      listen: false)
                                  .updateHealthConditions(tempList);
                              Provider.of<HealthConditionProvider>(context,
                                      listen: false)
                                  .updateListOfSelectedHealthIssues(
                                      _selectedConditionList);
                              for (int i = 0;
                                  i <
                                      Provider.of<HealthConditionProvider>(
                                              context,
                                              listen: false)
                                          .listOfSelectedHealthIssues
                                          .length;
                                  i++) {
                                if (i ==
                                    Provider.of<HealthConditionProvider>(
                                            context,
                                            listen: false)
                                        .currentIndexOfIssue) {
                                  Provider.of<HealthConditionProvider>(context,
                                          listen: false)
                                      .updateCurrentIndex(0);
                                  Navigator.of(context).pushNamed(
                                      Routes.routeBoneAndMuscle,
                                      arguments: {
                                        ArgumentConstant.problemIdKey: Provider
                                                .of<HealthConditionProvider>(
                                                    context,
                                                    listen: false)
                                            .listOfSelectedHealthIssues[i]
                                            .sId,
                                        ArgumentConstant
                                            .problemNameKey: Provider.of<
                                                    HealthConditionProvider>(
                                                context,
                                                listen: false)
                                            .listOfSelectedHealthIssues[i]
                                            .name,
                                        ArgumentConstant
                                            .problemImageKey: Provider.of<
                                                    HealthConditionProvider>(
                                                context,
                                                listen: false)
                                            .listOfSelectedHealthIssues[i]
                                            .image,
                                        ArgumentConstant.problem: Provider.of<
                                                    HealthConditionProvider>(
                                                context,
                                                listen: false)
                                            .listOfSelectedHealthIssues[i]
                                            .problem,
                                        ArgumentConstant.appointmentId:
                                            widget.appointmentId
                                      }).then((value) {
                                    setState(() {
                                      _profileFuture =
                                          api.getAppointmentDetails(
                                              token,
                                              widget.appointmentId,
                                              _userLocation);
                                    });
                                  });
                                }
                              }
                            } else {
                              Widgets.showToast(
                                  "Please select any health condition");
                            }
                          },
                          title: 'Problems',
                        )
                      ],
                    )
                    // : SizedBox(),

                    )),
      ],
    );
  }

  editWidget({Function? onTap, required String title}) {
    return Row(
      children: [
        Expanded(
            child: Text(title, style: AppTextStyle.mediumStyle(fontSize: 15))),
        GestureDetector(
            onTap: onTap as void Function()?,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('images/edit_icon.png', height: 20),
            ))
      ],
    );
  }

  recreationaltitleWidget(String title, bool isDrugChecked) {
    return GestureDetector(
        onTap: () {
          setState(() {
            isEdit = !isEdit;
          });
        },
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isDrugChecked
                    ? Icons.keyboard_arrow_down_sharp
                    : Icons.keyboard_arrow_down_sharp,
                size: 20,
              ),
            ),
          ],
        ));
  }

  Widget timingSubWidget(
      String title, int index, int status, bool? isUserJoin, bool? isDoctorJoin,
      {bool? isRated}) {
    return Consumer<OverlayHandlerProvider>(
        builder: (context, overlayProvider, _) {
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
                        ? status == 4 || status == 3
                            ? userRating != null
                                ? 'images/trackChecked.png'
                                : 'images/trackCheckedCurrent.png'
                            : 'images/trackUnchecked.png'
                        : index == 1
                            ? isDoctorJoin!
                                ? status == 4 || status == 3
                                    ? 'images/trackChecked.png'
                                    : 'images/trackCheckedCurrent.png'
                                : 'images/trackUnchecked.png'
                            : index < 0
                                ? 'images/trackChecked.png'
                                : isDoctorJoin!
                                    ? 'images/trackChecked.png'
                                    : 'images/trackCheckedCurrent.png',
                height: 24,
              ),
              index == 3
                  ? SizedBox()
                  : index == 2
                      ? userRating != null
                          ? Container(
                              height: 45,
                              width: 1,
                              color: Colors.green,
                            )
                          : dottedLine()
                      : index == 1
                          ? status == 4 || status == 3
                              ? Container(
                                  height: 45,
                                  width: 1,
                                  color: Colors.green,
                                )
                              : dottedLine()
                          : index < 0
                              ? Container(
                                  height: 45,
                                  width: 1,
                                  color: Colors.green,
                                )
                              : isDoctorJoin!
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
                              Navigator.pushNamed(
                                  context, Routes.rateDoctorScreen,
                                  arguments: {
                                    'rateFrom': "2",
                                    'appointmentId': widget.appointmentId,
                                    'name': name,
                                    'avatar': avatar,
                                    'type': 2
                                  });
                            })
                        : SizedBox()
                    : index == 2
                        ? SizedBox()
                        : index < 0
                            ? SizedBox()
                            : index == 1
                                ? status == 4 || status == 3
                                    ? SizedBox()
                                    : !isDoctorJoin!
                                        ? SizedBox()
                                        : !isUserJoin!
                                            ? TrackingButton(
                                                title: 'I am ready',
                                                image: 'images/watch.png',
                                                onTap: () {
                                                  var appointmentId = {};
                                                  appointmentId[
                                                          'appointmentId'] =
                                                      widget.appointmentId;
                                                  api
                                                      .patientAvailableForCall(
                                                          token, appointmentId)
                                                      .then((value) {
                                                    _profileFuture = api
                                                        .getAppointmentDetails(
                                                            token,
                                                            widget
                                                                .appointmentId,
                                                            _userLocation);
                                                    setState(() {});
                                                  });
                                                })
                                            : overlayProvider.overlayEntry !=
                                                        null &&
                                                    overlayProvider
                                                        .overlayEntry!.mounted
                                                ? SizedBox()
                                                : TrackingButton(
                                                    title: 'Join Call',
                                                    image:
                                                        'images/ic_video_app.png',
                                                    onTap: () async {
                                                      Widgets.showCallDialog(
                                                          context: context,
                                                          isRejoin: false,
                                                          onEnterCall: (bool
                                                                  record,
                                                              bool
                                                                  video) async {
                                                            Navigator.pop(
                                                                context);
                                                            print(
                                                                '$record $video');
                                                            Map<
                                                                    Permission
                                                                        .Permission,
                                                                    Permission
                                                                        .PermissionStatus>
                                                                statuses =
                                                                await [
                                                              Permission
                                                                  .Permission
                                                                  .camera,
                                                              Permission
                                                                  .Permission
                                                                  .microphone
                                                            ].request();
                                                            if ((statuses[Permission
                                                                        .Permission
                                                                        .camera]!
                                                                    .isGranted) &&
                                                                (statuses[Permission
                                                                        .Permission
                                                                        .microphone]!
                                                                    .isGranted)) {
                                                              Map appointment =
                                                                  {};
                                                              appointment[
                                                                      "_id"] =
                                                                  widget
                                                                      .appointmentId;
                                                              appointment[
                                                                      'video'] =
                                                                  video;
                                                              appointment[
                                                                      'record'] =
                                                                  record;
                                                              OverlayService()
                                                                  .addVideosOverlay(
                                                                      context,
                                                                      CallPage(
                                                                          channelName:
                                                                              appointment));
                                                              //     .then(
                                                              //         (value) {
                                                              //   _profileFuture =
                                                              //       api.getAppointmentDetails(
                                                              //           token,
                                                              //           widget
                                                              //               .appointmentId,
                                                              //           _userLocation);
                                                              //   setState(() {});
                                                              // });
                                                            } else {
                                                              Widgets.showErrorialog(
                                                                  context:
                                                                      context,
                                                                  description:
                                                                      'Camera & Microphone permission Requied');
                                                            }
                                                          });
                                                    })
                                : Row(
                                    children: [
                                      isUserJoin! || isDoctorJoin!
                                          ? SizedBox()
                                          : appointmentTime
                                                      .difference(currentTime)
                                                      .inSeconds >
                                                  86400
                                              ? TrackingButton(
                                                  title: 'Reschedule',
                                                  image:
                                                      'images/trackReschedule.png',
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
                                                                        'data']
                                                                    ['doctor']
                                                                ['_id'],
                                                            locMap)
                                                        .then((value) {
                                                      _container
                                                          .setProviderData(
                                                              "providerData",
                                                              value);

                                                      _container
                                                          .setProjectsResponse(
                                                              'serviceType',
                                                              appointmentResponse[
                                                                          'data']
                                                                      ['type']
                                                                  .toString());
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      if (appointmentResponse[
                                                                  'subServices']
                                                              .length >
                                                          0) {
                                                        _container
                                                            .setServicesData(
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
                                                                    fromScreen:
                                                                        2,
                                                                    appointmentId:
                                                                        widget
                                                                            .appointmentId));
                                                      } else {
                                                        _container
                                                            .setServicesData(
                                                                "status", "0");
                                                        _container
                                                            .setServicesData(
                                                                "consultaceFee",
                                                                '10');
                                                        Navigator.of(context).pushNamed(
                                                            Routes
                                                                .selectAppointmentTimeScreen,
                                                            arguments:
                                                                SelectDateTimeArguments(
                                                                    fromScreen:
                                                                        2,
                                                                    appointmentId:
                                                                        widget
                                                                            .appointmentId));
                                                      }
                                                    });

                                                    var map = {};
                                                    map['appointmentId'] =
                                                        appointmentResponse[
                                                            'data']['_id'];
                                                  })
                                              : SizedBox(),
                                      isUserJoin || isDoctorJoin!
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
                                      isDoctorJoin!
                                          ? SizedBox()
                                          : !isUserJoin
                                              ? TrackingButton(
                                                  title: 'I am ready',
                                                  image: 'images/watch.png',
                                                  onTap: () {
                                                    var appointmentId = {};
                                                    appointmentId[
                                                            'appointmentId'] =
                                                        widget.appointmentId;
                                                    api
                                                        .patientAvailableForCall(
                                                            token,
                                                            appointmentId)
                                                        .then((value) {
                                                      _profileFuture = api
                                                          .getAppointmentDetails(
                                                              token,
                                                              widget
                                                                  .appointmentId,
                                                              _userLocation);
                                                      setState(() {});
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
    });
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
          _profileFuture = api.getAppointmentDetails(token, id, _userLocation);
        });
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
                                widget.appointmentId!, "5");
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
