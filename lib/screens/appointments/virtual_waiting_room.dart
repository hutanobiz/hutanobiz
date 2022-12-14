import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/circular_countdown_timer.dart';
import 'package:hutano/widgets/controller.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/simple_timer_text.dart';
import 'package:intl/intl.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;

class VirtualWaingRoom extends StatefulWidget {
  final String? appointmentId;
  const VirtualWaingRoom({Key? key, required this.appointmentId})
      : super(key: key);

  @override
  _VirtualWaingRoomState createState() => _VirtualWaingRoomState();
}

class _VirtualWaingRoomState extends State<VirtualWaingRoom> {
  Future<dynamic>? _profileFuture;
  ApiBaseHelper api = ApiBaseHelper();
  bool video = true;
  bool record = true;
  String _totalDistance = '';

  @override
  void initState() {
    SharedPref().getToken().then((token) {
      setState(() {
        _profileFuture = api.getAppointmentDetails(
          token,
          widget.appointmentId,
          LatLng(0.00, 0.00),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: "Telemedicine",
        isAddBack: true,
        addBackButton: false,
        color: Colors.white,
        padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
        child: Container(
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
                  Map profileMap = snapshot.data as Map;
                  return widgetList(profileMap);
                } else {
                  return Center(
                    child: new CustomLoader(),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget widgetList(Map appointment) {
    var appointmentTime = DateTime.utc(
            DateTime.parse(appointment['data']['date']).year,
            DateTime.parse(appointment['data']['date']).month,
            DateTime.parse(appointment['data']['date']).day,
            int.parse(appointment['data']['fromTime'].split(':')[0]),
            int.parse(appointment['data']['fromTime'].split(':')[1]))
        .toLocal();
    var currentTime = DateTime.now();

    return appointment['data']["isDoctorJoin"] ?? false
        ? availableWidget(appointment, appointmentTime, currentTime)
        : waitingWidget(appointment, appointmentTime, currentTime);
  }

  ListView availableWidget(Map appointment, appointmentTime, currentTime) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        profileWidget(appointment),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.containerBorderColor,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32),
              Text(
                'Virtual Waiting Room',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 24),
              Image.asset('images/videoAvailable.png'),
              SizedBox(height: 24),
              Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Text(
                    'Dr. ' +
                        appointment["data"]["doctorName"] +
                        ' Is ready for your appointment.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(height: 24),
              Container(
                height: MediaQuery.of(context).size.height * .05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      record
                          ? 'images/checkedCheck.png'
                          : 'images/uncheckedCheck.png',
                      height: 20,
                    ),
                    Text(
                      '  Record meeting',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ).onClick(onTap: () {
                  setState(() {
                    record = !record;
                  });
                }),
              ),
              SizedBox(height: 24),
              Container(
                  width: 190,
                  child: FancyButton(
                    buttonHeight: 55,
                    onPressed: () async {
                      Map<Permission.Permission, Permission.PermissionStatus>
                          statuses = await [
                        Permission.Permission.camera,
                        Permission.Permission.microphone
                      ].request();
                      if ((statuses[Permission.Permission.camera]!.isGranted) &&
                          (statuses[Permission.Permission.microphone]!
                              .isGranted)) {
                        Map appointment = {};
                        appointment["_appointmentStatus"] = "1";
                        appointment["_id"] = widget.appointmentId;
                        appointment['video'] = video;
                        appointment['record'] = record;
                         Navigator.of(context).pushNamed(
                          Routes.callPage,
                          arguments: appointment,
                        );
                      } else {
                        Widgets.showErrorialog(
                            context: context,
                            description:
                                'Camera & Microphone permission Requied');
                      }
                      // }).futureError((onError) {
                      //   Widgets.showErrorialog(
                      //       context: context, description: onError);
                      // });
                    },
                    title: 'Start meeting now',
                    buttonColor: AppColors.goldenTainoi,
                  )),
              SizedBox(height: 24),
              Divider(
                thickness: .5,
                color: AppColors.containerBorderColor,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      video
                          ? Icon(
                              Icons.radio_button_checked,
                              color: Color(0xFF1E36BA),
                            )
                          : Icon(Icons.radio_button_unchecked,
                              color: Colors.grey[300]),
                      Text(
                        '  Video & Audio',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ).onClick(onTap: () {
                    setState(() {
                      video = true;
                    });
                  }),
                  Row(
                    children: [
                      video
                          ? Icon(Icons.radio_button_unchecked,
                              color: Colors.grey[300])
                          : Icon(Icons.radio_button_checked,
                              color: Color(0xFF1E36BA)),
                      Text(
                        '  Audio Only',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ).onClick(onTap: () {
                    setState(() {
                      video = false;
                    });
                  }),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  ListView waitingWidget(Map appointment, appointmentTime, currentTime) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        profileWidget(appointment),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.containerBorderColor,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32),
              Text(
                'Upcoming Telemedicine Appointment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  border: Border.all(
                    color: AppColors.containerBorderColor,
                    width: .5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.info,
                      color: Color(0xFFA1A1A1),
                    ),
                    Text(
                      'Your appointment starts in 00:00',
                    )
                  ],
                ),
              ),
              SizedBox(height: 24),
              Image.asset('images/videoBusy.png', height: 60),
              SizedBox(height: 24),
              Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    'Dr. ' +
                        appointment["data"]["doctorName"] +
                        ' is busy helping another patient.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(height: 32),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  height: 55,
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 6),
                      Text('Exit'),
                    ],
                  )),
              SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Container profileWidget(Map appointment) {
    String practicingSince = '';
    Map response = appointment["data"];
    Map doctorData = appointment['doctorData'][0];

    practicingSince = doctorData["practicingSince"] != null
        ? ((DateTime.now()
                    .difference(DateTime.parse(doctorData["practicingSince"]))
                    .inDays /
                366))
            .toStringAsFixed(1)
        : "---";

    String? name = "---",
        rating = "---",
        professionalTitle = "---",
        avatar,
        address = "---",
        appointmentType = "---",
        dateTime;

    appointmentType = response["type"] == 1
        ? "Office response"
        : response["type"] == 2
            ? "Video response"
            : "Onsite response";

    rating = appointment["averageRating"]?.toStringAsFixed(1) ?? "0";

    if (appointment["doctorData"] != null) {
      for (dynamic detail in appointment["doctorData"]) {
        if (detail["professionalTitle"] != null) {
          professionalTitle =
              detail["professionalTitle"]["title"]?.toString() ?? "---";
        }

        if (detail["businessLocation"] != null) {
          dynamic business = detail["businessLocation"];

          address = Extensions.addressFormat(
            business["address"]?.toString(),
            business["street"]?.toString(),
            business["city"]?.toString(),
            business["state"],
            business["zipCode"]?.toString(),
          );
        }
      }
    }

    if (response["doctor"] != null) {
      String title = response["doctor"]["title"]?.toString() ?? "";
      name = title + ' ' + (response["doctor"]["fullName"]?.toString() ?? "---");
      avatar = response["doctor"]["avatar"];
    }

    if (appointment["doctorData"] != null) {
      for (dynamic detail in appointment["doctorData"]) {
        if (detail["businessLocation"] != null) {
          if (detail["businessLocation"]["coordinates"] != null) {
            List? location = detail["businessLocation"]["coordinates"];
          }
        }
      }
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 22.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(14.0),
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 18, left: 12, right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    splashColor: Colors.grey[200],
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).pushNamed(
                        Routes.providerImageScreen,
                        arguments: (ApiBaseHelper.imageUrl + avatar!),
                      );
                    },
                    child: Container(
                      width: 58.0,
                      height: 58.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (avatar == null
                              ? AssetImage('images/profile_user.png')
                              : NetworkImage(ApiBaseHelper.imageUrl + avatar)) as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(Radius.circular(50.0)),
                        border: new Border.all(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            bottom: 5.0,
                            right: 5.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage(
                                  "images/ic_experience.png",
                                ),
                                height: 14.0,
                                width: 11.0,
                              ),
                              SizedBox(width: 3.0),
                              Expanded(
                                child: Text(
                                  practicingSince + " yrs experience",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                "ic_rating_golden"
                                    .imageIcon(width: 12, height: 12),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  rating ?? "0",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                '\u2022 ' + professionalTitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            bottom: 5.0,
                            right: 5.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              doctorData['isOfficeEnabled']
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: 'ic_provider_office'.imageIcon(
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : Container(),
                              doctorData['isVideoChatEnabled']
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: 'ic_provider_video'.imageIcon(
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : Container(),
                              doctorData['isOnsiteEnabled']
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: 'ic_provider_onsite'.imageIcon(
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "\$${response['fees'].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    'ic_forward'.imageIcon(
                      width: 9,
                      height: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
            child: Row(
              children: <Widget>[
                'ic_location_grey'.imageIcon(height: 14.0, width: 11.0),
                SizedBox(width: 3.0),
                Expanded(
                  child: Text(
                    address!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      "ic_app_distance".imageIcon(),
                      SizedBox(width: 5.0),
                      Text(
                        _totalDistance == 'NO distance available'
                            ? '---'
                            : _totalDistance,
                        style: TextStyle(
                          color: AppColors.windsor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
