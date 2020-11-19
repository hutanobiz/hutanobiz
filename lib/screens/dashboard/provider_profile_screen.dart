import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide MapType;
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/review_widget.dart';
import 'package:intl/intl.dart';

class ProviderProfileScreen extends StatefulWidget {
  ProviderProfileScreen({Key key, this.selectedAppointmentType})
      : super(key: key);

  final String selectedAppointmentType;

  @override
  _ProviderProfileScreenState createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  Future<dynamic> _profileFuture;
  InheritedContainerState _container;
  Map profileMapResponse = Map();
  List speaciltyList = List();
  List reviewsList = [];

  final Set<Marker> _markers = {};
  BitmapDescriptor sourceIcon;
  Completer<GoogleMapController> _controller = Completer();
  List scheduleList = List();

  ScrollController _scrollController = new ScrollController();

  final _adddressColumnKey = GlobalKey();

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_destination_marker.png");
  }

  @override
  void initState() {
    super.initState();

    setSourceAndDestinationIcons();
  }

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    Map _providerData = _container.providerIdMap;

    ApiBaseHelper api = ApiBaseHelper();
    Map<String, String> locMap = {};
    LatLng _userLocation = LatLng(0.00, 0.00);
    if (_container.userLocationMap.isNotEmpty) {
      _userLocation =
          _container.userLocationMap['latLng'] ?? LatLng(0.00, 0.00);
    }
    locMap['lattitude'] = _userLocation.latitude.toStringAsFixed(2);
    locMap['longitude'] = _userLocation.longitude.toStringAsFixed(2);

    _profileFuture =
        api.getProviderProfile(_providerData["providerId"], locMap);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: FutureBuilder(
          future: _profileFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("NO data available");
                break;
              case ConnectionState.waiting:
                return Container(
                  color: AppColors.snow,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  profileMapResponse = snapshot.data;

                  if (profileMapResponse.isEmpty ||
                      profileMapResponse["data"] == null) {
                    return Container();
                  }

                  Map _providerData = profileMapResponse["data"][0];
                  String nameTitle = "Dr. ", name = "---";
                  if (_providerData['userId'] is Map) {
                    if (_providerData["userId"] != null) {
                      nameTitle =
                          _providerData["userId"]["title"]?.toString() ??
                              'Dr. ';
                      name = nameTitle +
                              _providerData["userId"]["fullName"]?.toString() ??
                          "---";
                    }
                  } else if (_providerData["User"] != null &&
                      _providerData["User"].length > 0) {
                    nameTitle =
                        (_providerData["User"][0]["title"]?.toString() ??
                            'Dr. ');
                    name = '$nameTitle ' +
                        (_providerData["User"][0]["fullName"]?.toString() ??
                            "---");
                  }

                  return LoadingBackground(
                      title: name,
                      color: Colors.white,
                      isAddBack: false,
                      addBackButton: true,
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widgetList(profileMapResponse),
                            ),
                          ),
                        ),
                        Divider(height: 0.5),
                        Align(
                          alignment: FractionalOffset.bottomRight,
                          child: Container(
                            height: 55.0,
                            width: MediaQuery.of(context).size.width - 76.0,
                            margin: const EdgeInsets.only(top: 10),
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 40.0),
                            child: FancyButton(
                              title: "Schedule Appointment",
                              onPressed: () {
                                Map _appointentTypeMap = {};

                                dynamic response =
                                    profileMapResponse["data"][0];

                                _appointentTypeMap["isOfficeEnabled"] =
                                    response["isOfficeEnabled"];
                                _appointentTypeMap["isVideoChatEnabled"] =
                                    response["isVideoChatEnabled"];
                                _appointentTypeMap["isOnsiteEnabled"] =
                                    response["isOnsiteEnabled"];
                                _container.providerResponse.clear();

                                _container.setProviderData(
                                    "providerData", profileMapResponse);

                                Navigator.of(context).pushNamed(
                                  Routes.appointmentTypeScreen,
                                  arguments: _appointentTypeMap,
                                );
                              },
                            ),
                          ),
                        )
                      ]));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                break;
            }
            return null;
          }),
    );
  }

  List<Widget> widgetList(Map profileResponse) {
    Map _providerData = profileResponse["data"][0];
    String nameTitle = "Dr. ", name = "---";
    if (_providerData['userId'] is Map) {
      if (_providerData["userId"] != null) {
        nameTitle = _providerData["userId"]["title"]?.toString() ?? 'Dr. ';
        name = nameTitle + _providerData["userId"]["fullName"]?.toString() ??
            "---";
      }
    } else if (_providerData["User"] != null &&
        _providerData["User"].length > 0) {
      nameTitle = (_providerData["User"][0]["title"]?.toString() ?? 'Dr. ');
      name = '$nameTitle ' +
          (_providerData["User"][0]["fullName"]?.toString() ?? "---");
    }

    List languagesList = List();

    String doctorEducation = "",
        address,
        todaysTimings = "",
        tomorrowsTimings = "",
        averageRating = "---",
        boardCerficationText = '';

    LatLng latLng = LatLng(0, 0);

    averageRating = profileResponse['averageRating']?.toStringAsFixed(2) ?? "0";

    if (_providerData["education"] != null) {
      for (dynamic education in _providerData["education"]) {
        doctorEducation += (education["degree"]?.toString() ?? "---") +
            "\n" +
            (education["institute"]?.toString() ?? "---") +
            "\n\n";
      }
    }

    if (_providerData["legalDocuments"] != null &&
        _providerData["legalDocuments"]["boardCertification"] != null) {
      List boardCerfication =
          _providerData["legalDocuments"]["boardCertification"];

      if (boardCerfication.length > 0) {
        for (dynamic b in boardCerfication) {
          if (b != null && b is String) {
            boardCerficationText += (b?.toString() ?? "---") + "\n\n";
          }
        }
      }
    }

    if (_providerData["User"][0] != null) {
      if (_providerData["User"][0]["language"] != null) {
        languagesList = _providerData["User"][0]["language"];
      }
    }

    if (_providerData['Specialties'] != null &&
        _providerData['Specialties'] is List) {
      speaciltyList = _providerData['Specialties'];
    }

    if (profileResponse['reviews'] != null) {
      reviewsList = profileResponse['reviews'];
    }

    if (_providerData['schedules'] != null &&
        _providerData['schedules'].length > 0) {
      scheduleList = _providerData['schedules'];

      DateTime now = DateTime.now();

      int i = 0;
      int j = 0;

      while (i < scheduleList.length) {
        List _scheduleDaysList = scheduleList[i]["day"];
        if (j < _scheduleDaysList.length) {
          String day = _scheduleDaysList[j].toString();
          var fromTime = DateTime.utc(
              DateTime.now().year,
              DateTime.now().month,
              9,
              int.parse(scheduleList[i]['fromTime'].toString().split(':')[0]),
              int.parse(scheduleList[i]['fromTime'].toString().split(':')[1]));
          var toTime = DateTime.utc(
              DateTime.now().year,
              DateTime.now().month,
              9,
              int.parse(scheduleList[i]['toTime'].toString().split(':')[0]),
              int.parse(scheduleList[i]['toTime'].toString().split(':')[1]));

          String from = DateFormat('HH:mm').format(fromTime.toLocal());
          // '${fromTime.toLocal().hour}:${fromTime.toLocal().minute}';
          String to = DateFormat('HH:mm').format(toTime.toLocal());
          //'${toTime.toLocal().hour}:${toTime.toLocal().minute}';

          if (now.weekday.toString() == day) {
            todaysTimings = todaysTimings + from + " - " + to + " ; ";
          }

          if ((now.weekday + 1).toString() == day) {
            tomorrowsTimings = tomorrowsTimings + from + " - " + to + " ; ";
          }

          j++;
        } else {
          i++;
          j = 0;
        }
      }
    }

    if (_providerData["businessLocation"] != null) {
      dynamic business = _providerData["businessLocation"];

      address = Extensions.addressFormat(
        business["address"]?.toString(),
        business["street"]?.toString(),
        business["city"]?.toString(),
        business["state"] is Map ? business["state"] : null,
        business["zipCode"]?.toString(),
      );

      if (_providerData["businessLocation"]["coordinates"] != null) {
        List location = _providerData["businessLocation"]["coordinates"];

        if (location.length > 0) {
          latLng = LatLng(
            double.parse(location[1].toString()),
            double.parse(location[0].toString()),
          );
        }
      }
    }

    List<Widget> formWidget = List();

    formWidget.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: ProviderWidget(
          data: _providerData,
          selectedAppointment: widget.selectedAppointmentType,
          averageRating: averageRating,
          isOptionsShow: false,
          isProverPicShow: true,
          onLocationClick: () =>
              Scrollable.ensureVisible(_adddressColumnKey.currentContext),
          onRatingClick: () =>
              _scrollListView(_scrollController.position.maxScrollExtent),
        ),
      ),
    );

    formWidget.add(Padding(
      padding: const EdgeInsets.only(left: 20, top: 0, bottom: 12, right: 20),
      child: Text(
        "About $name",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    ));

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 16),
        child: Text(
          _providerData['about'] ?? "---",
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
      ),
    );

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
        child: Text(
          "Medical Education",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 16),
        child: Text(
          doctorEducation == ""
              ? "No education available"
              : doctorEducation?.substring(0, doctorEducation.length - 2),
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
      ),
    );

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
        child: Text(
          "Board Certifications",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 16),
        child: Text(
          boardCerficationText == null ||
                  boardCerficationText == '---' ||
                  boardCerficationText.isEmpty
              ? "No board certifications available"
              : boardCerficationText?.substring(
                  0, boardCerficationText.length - 2),
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
      ),
    );

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
        child: Text(
          "Languages",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    formWidget.add(
      languagesList.length > 0
          ? SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: languagesList.length,
                padding: const EdgeInsets.only(left: 20, bottom: 16),
                itemBuilder: (context, index) {
                  return _chipWidget(languagesList[index]?.toString() ?? "---");
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 16),
              child: Text(
                "No languages.",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
    );

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
        child: Text(
          "Schedule",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: DateFormat('EEEE').format(DateTime.now()) + " "),
                  TextSpan(
                    text: todaysTimings != null && todaysTimings != ""
                        ? todaysTimings.substring(0, todaysTimings.length - 3)
                        : "Unavailable for today",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: DateFormat('EEEE')
                              .format(DateTime.now().add(Duration(days: 1))) +
                          " "),
                  TextSpan(
                    text: tomorrowsTimings != null && tomorrowsTimings != ""
                        ? tomorrowsTimings.substring(
                            0, tomorrowsTimings.length - 3)
                        : "Unavailable",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                _container.setProviderData("providerData", profileMapResponse);
                Navigator.of(context).pushNamed(
                  Routes.availableTimingsScreen,
                );
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "View schedule",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.windsor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10.0,
                    color: AppColors.windsor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    (_providerData["isOfficeEnabled"] ?? false)
        ? formWidget.add(divider())
        : SizedBox();

    (_providerData["isOfficeEnabled"] ?? false)
        ? formWidget.add(locationWidget(address, latLng))
        : SizedBox();

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding:
            const EdgeInsets.only(left: 20, top: 16, bottom: 12, right: 20),
        child: Text(
          "$name offers the following service options:",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    formWidget.add(Padding(
      padding: EdgeInsets.only(
        left: 20,
        bottom: _providerData["isOfficeEnabled"] ||
                _providerData["isVideoChatEnabled"] ||
                _providerData["isOnsiteEnabled"]
            ? 16
            : 0,
      ),
      child: Wrap(
        runSpacing: _providerData["isOfficeEnabled"] &&
                _providerData["isVideoChatEnabled"] &&
                _providerData["isOnsiteEnabled"]
            ? 20
            : 5,
        children: <Widget>[
          _providerData["isOfficeEnabled"]
              ? appoCard(
                  'images/office_appointment.png',
                  "Office\nAppointment",
                )
              : Container(),
          _providerData["isOfficeEnabled"] ? SizedBox(width: 20) : Container(),
          _providerData["isVideoChatEnabled"]
              ? appoCard(
                  'images/video_chat_appointment.png',
                  "Video\nAppointment",
                )
              : (!_providerData["isVideoChatEnabled"] &&
                      _providerData["isOnsiteEnabled"])
                  ? appoCard(
                      'images/onsite_appointment.png',
                      "Onsite\nAppointment",
                    )
                  : Container(),
          (_providerData["isVideoChatEnabled"] &&
                  _providerData["isOnsiteEnabled"])
              ? SizedBox(width: 20)
              : Container(),
          (_providerData["isVideoChatEnabled"] &&
                  _providerData["isOnsiteEnabled"])
              ? appoCard(
                  'images/onsite_appointment.png',
                  "Onsite\nAppointment",
                )
              : Container(),
        ],
      ),
    ));

    formWidget.add(divider());

    formWidget.add(Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Text(
        "$name is a specialist in the following areas:",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    ));

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(
      speaciltyList.length > 0
          ? SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: speaciltyList.length,
                padding: const EdgeInsets.only(left: 20, bottom: 16),
                itemBuilder: (context, index) {
                  return _chipWidget(
                      speaciltyList[index]["title"]?.toString() ?? "---");
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 16),
              child: Text(
                "NO languages available",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
    );

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 16, top: 16),
        child: Text(
          "Feedback for ${_providerData["User"][0]["fullName"]}",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    formWidget.add(Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(14.0),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      color: AppColors.goldenTainoi.withOpacity(0.06),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Overall Rating '),
                  TextSpan(
                      text: averageRating,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.goldenTainoi,
                        fontWeight: FontWeight.w600,
                      )),
                ]),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: RatingBar(
                initialRating: double.parse(averageRating),
                itemSize: 20.0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                glow: false,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: null,
              ),
            ),
          )
        ],
      ),
    ));

    formWidget.add(
      reviewsList == null || reviewsList.length == 0
          ? Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Text("NO reviews available yet!"),
            )
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 20),
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 20),
              reverse: true,
              shrinkWrap: true,
              itemCount: reviewsList.length >= 2 ? 2 : reviewsList.length,
              itemBuilder: (context, index) {
                dynamic response = reviewsList[index];

                return ReviewWidget(
                  reviewerName:
                      response["user"]["fullName"]?.toString() ?? '---',
                  avatar: response["user"]["avatar"],
                  reviewDate: response["user"]["updatedAt"] == null
                      ? '---'
                      : response["user"]["updatedAt"].toString().formatDate(),
                  reviewerRating:
                      double.parse(response["rating"]?.toString() ?? "0"),
                  reviewText: response["review"]?.toString() ?? "---",
                );
              },
            ),
    );

    Map _reviewMap = {};

    _reviewMap["averageRating"] = averageRating;
    _reviewMap["reviewsList"] = reviewsList;

    formWidget.add(
      (reviewsList != null && reviewsList.length >= 2)
          ? Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.allReviewsScreen,
                  arguments: _reviewMap,
                ),
                child: Text(
                  "View all reviews",
                  style: TextStyle(
                    color: AppColors.windsor,
                    fontSize: 13.0,
                  ),
                ),
              ),
            )
          : Container(),
    );

    return formWidget;
  }

  Widget locationWidget(String location, LatLng latLng) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
      child: Column(
        key: _adddressColumnKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Address",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.0),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  "ic_location_grey".imageIcon(),
                  SizedBox(width: 8.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      location,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: latLng == LatLng(0.0, 0.0)
                            ? null
                            : latLng.launchMaps,
                        child: Text(
                          "Get Directions",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.windsor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 155.0,
                margin: const EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: GoogleMap(
                    myLocationEnabled: false,
                    compassEnabled: false,
                    rotateGesturesEnabled: false,
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                      target: latLng,
                      zoom: 9.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);

                      setState(() {
                        _markers.add(
                          Marker(
                            markerId: MarkerId(latLng.toString()),
                            position: latLng,
                            icon: sourceIcon,
                          ),
                        );
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipWidget(String title) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(right: 10.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.windsor.withOpacity(0.05),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Text(
        title ?? "---",
        style: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget appoCard(String image, cardText) {
    return Container(
      width: 160.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[100]),
      ),
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage(image),
            height: 54.0,
            width: 54.0,
          ),
          SizedBox(width: 12.0),
          Text(
            cardText,
            maxLines: 2,
            style: TextStyle(
              color: AppColors.midnight_express,
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget divider({double topPadding}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 0.0),
      child: Divider(
        color: AppColors.white_smoke,
        thickness: 6.0,
      ),
    );
  }

  void _scrollListView(double value) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
