import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide MapType;
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/review_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
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

    initializeDateFormatting('en');
    setSourceAndDestinationIcons();
  }

  Map _providerData;

  int _radioValue = 0;
  String _selectedAppointmentType = '1', _appointmentTypeKey;
  List<Services> servicesList;
  Map<String, Services> _selectedServicesMap = Map();
  List _serviceList;
  Map profileMap = Map();
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

    _container.setProjectsResponse("serviceType", "1");

    _providerData = _container.getProviderData();

    if (_container.projectsResponse != null) {
      _selectedAppointmentType =
          _container.projectsResponse['serviceType']?.toString() ?? '0';

      switch (_selectedAppointmentType) {
        case '1':
          _appointmentTypeKey = 'officeConsultanceFee';
          break;
        case '2':
          _appointmentTypeKey = 'vedioConsultanceFee';
          break;
        case '3':
          _appointmentTypeKey = 'onsiteConsultanceFee';
          break;
        default:
      }
    }

    if (_providerData["providerData"]["subServices"] != null) {
      if (_providerData["providerData"]["subServices"] is List) {
        _serviceList = _providerData["providerData"]["subServices"];
      }
    } else if (_providerData["providerData"]["services"] != null) {
      if (_providerData["providerData"]["services"] is List) {
        _serviceList = _providerData["providerData"]["services"];
      }
    } else if (_providerData["subServices"] != null) {
      if (_providerData["subServices"] is List) {
        _serviceList = _providerData["subServices"];
      }
    }

    if (_serviceList != null) {
      _serviceList = _serviceList
          .where((e) => e['serviceType'].toString() == _selectedAppointmentType)
          .toList();

      servicesList = _serviceList.map((m) => Services.fromJson(m)).toList();
    }

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
                    child: CustomLoader(),
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
                      addHeader: true,
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
                        // Expanded(
                        //   child: ListView(
                        //     shrinkWrap: true,
                        //     padding: const EdgeInsets.only(bottom: 70.0),
                        //     children: _widgetList(),
                        //   ),
                        // ),
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

    var practicingSince = _providerData["practicingSince"] != null
        ? ((DateTime.now()
                    .difference(
                        DateTime.parse(_providerData["practicingSince"]))
                    .inDays /
                366))
            .toStringAsFixed(1)
        : "---";

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
    DateTime todayFromTime;
    DateTime todayToTime;
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
            todayFromTime = fromTime;
            todayToTime = toTime;
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
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Text(
        "Specialties",
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorBlack.withOpacity(0.9),
            fontFamily: gilroySemiBold,
            fontStyle: FontStyle.normal,
            fontSize: 14.0),
      ),
    ));

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(
      speaciltyList.length > 0
          ? SizedBox(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: speaciltyList.length,
                padding: const EdgeInsets.only(left: 20, bottom: 16),
                itemBuilder: (context, index) {
                  return appoCard('images/office_appointment.png',
                      speaciltyList[index]["title"]?.toString() ?? "---");
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

    formWidget.add(Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Text(
        "Experience",
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorBlack.withOpacity(0.9),
            fontFamily: gilroySemiBold,
            fontStyle: FontStyle.normal,
            fontSize: 14.0),
      ),
    ));

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
      child: _rowCard("Professional Experience", "images/dummy_title_image.png",
          "${practicingSince} years of experience."),
    ));

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
        child: Text(
          "Education",
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
        child: doctorEducation.isEmpty
            ? Text(
                "No education available",
                style: TextStyle(
                  fontSize: 13.0,
                ),
              )
            : _addEducationList(_providerData["education"]),
      ),
    );

    formWidget.add(Padding(
      padding: const EdgeInsets.only(left: 20, top: 15, bottom: 12, right: 20),
      child: Text(
        "About",
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorBlack.withOpacity(0.9),
            fontFamily: gilroySemiBold,
            fontStyle: FontStyle.normal,
            fontSize: 14.0),
      ),
    ));

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 16),
        child: Text(
          _providerData['about'] ?? "---",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: gilroyMedium,
              fontStyle: FontStyle.normal,
              color: colorBlack2.withOpacity(0.85),
              fontSize: 13.0),
        ),
      ),
    );

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
        child: Text(
          "Speak",
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

    if (scheduleList != null && scheduleList.length > 0)
      formWidget.add(
        Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
            child: _setSchedule(scheduleList)),
      );

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
        child: Text(
          "Availibility",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    if (todayFromTime != null)
      formWidget.add(Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _chipWidget(
                DateFormat('hh:mm a').format(todayFromTime.toLocal()) ?? "---"),
            SizedBox(
              width: 5,
            ),
            Text("to ",
                style: const TextStyle(
                    color: const Color(0xff0c0b52),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Gilroy",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left),
            SizedBox(
              width: 5,
            ),
            _chipWidget(
                DateFormat('hh:mm a').format(todayToTime.toLocal()) ?? "---"),
          ],
        ),
      ));

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                      "View Entire schedule",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: gilroyMedium,
                        color: colorDarkBlue3,
                        fontStyle: FontStyle.normal,
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

    formWidget.add(Align(
      alignment: FractionalOffset.center,
      child: Container(
        height: 55.0,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
        child: FancyButton(
          title: "Book Appointment",
          onPressed: () {
            Map _appointentTypeMap = {};

            dynamic response = profileMapResponse["data"][0];

            _appointentTypeMap["isOfficeEnabled"] = response["isOfficeEnabled"];
            _appointentTypeMap["isVideoChatEnabled"] =
                response["isVideoChatEnabled"];
            _appointentTypeMap["isOnsiteEnabled"] = response["isOnsiteEnabled"];
            _container.providerResponse.clear();

            _container.setProviderData("providerData", profileMapResponse);

            Navigator.of(context).pushNamed(
              Routes.appointmentTypeScreen,
              arguments: _appointentTypeMap,
            );
          },
        ),
      ),
    ));

    formWidget.add(SizedBox(
      height: 15,
    ));
    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 16, top: 16),
        child: Text(
          "Feedback",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            fontFamily: gilroySemiBold,
            fontStyle: FontStyle.normal,
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
              GestureDetector(
                onTap: () {
                  (latLng == LatLng(0.0, 0.0)) ? null : latLng.launchMaps();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: const Color(0xff06082a), width: 0.5),
                      color: colorWhite),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 8.0),
                      "ic_location_grey".imageIcon(height: 40, width: 40),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _rowCard(title, image, subTitle) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: const Color(0x12372786), width: 0.5),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x148b8b8b),
                      offset: Offset(0, 2),
                      blurRadius: 30,
                      spreadRadius: 0)
                ],
                color: const Color(0xffffffff)),
            child: Image(
              image: AssetImage(image),
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: spacing25),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize14,
                  color: colorBlack.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  fontFamily: gilroySemiBold,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                subTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0,
                  color: colorBlue3,
                  fontFamily: gilroyRegular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chipWidget(String title) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      margin: const EdgeInsets.only(right: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.windsor.withOpacity(0.05),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Text(
        title ?? "---",
        textAlign: TextAlign.center,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage(image),
              height: 60,
              width: 60,
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Text(
              cardText,
              softWrap: true,
              maxLines: 2,
              style: TextStyle(
                  color: const Color(0xff160f3b),
                  fontWeight: FontWeight.w500,
                  fontFamily: gilroyMedium,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
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

  _addEducationList(data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _rowCard(data[index]['degree'], 'images/ic_education.png',
                        data[index]['institute'])
                  ],
                ),
              )
            ],
          ),
          width: double.infinity,
        );
      },
    );
  }

  _setSchedule(scheduleList) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        // padding: const EdgeInsets.only(left: 20, bottom: 16),
        itemBuilder: (context, index) {
          return Container(
            height: 60,
            width: 65,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              border: Border.all(
                  color: colorBlack.withOpacity(0.7),
                  width: (index == 0) ? 0 : 0.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: (index == 0) ? const Color(0xfffebf58) : colorWhite,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  index == 0
                      ? "Today"
                      : DateFormat('EEEE')
                          .format(DateTime.now().add(Duration(days: index)))
                          .toString()
                          .substring(0, 3),
                  style: TextStyle(
                      color: (index == 0)
                          ? colorWhite
                          : colorBlack.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontFamily: gilroyMedium,
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                ),
                Text(
                  DateTime.now().add(Duration(days: index)).day.toString(),
                  style: TextStyle(
                      color: (index == 0)
                          ? colorWhite
                          : colorBlack.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontFamily: gilroyRegular,
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _widgetList() {
    List<Widget> formWidget = new List();
    String averageRating = "0";

    if (_providerData["providerData"]["data"] != null) {
      if (_providerData["providerData"]["data"] is List) {
        _providerData["providerData"]["data"].map((f) {
          profileMap.addAll(f);
        }).toList();
      } else {
        profileMap = _providerData["providerData"]["data"];
      }

      averageRating =
          _providerData["providerData"]["averageRating"]?.toStringAsFixed(2) ??
              "0";
    } else {
      profileMap = _providerData["providerData"];
      averageRating = profileMap["averageRating"]?.toStringAsFixed(2) ?? "0";
    }

    formWidget.add(ProviderWidget(
      data: profileMap,
      selectedAppointment:
          _container.projectsResponse['serviceType'].toString(),
      isOptionsShow: false,
      averageRating: averageRating,
    ));

    formWidget.add(SizedBox(height: 26));

    formWidget.add(consultancyFeeWidget());

    formWidget.add(SizedBox(height: 26));

    formWidget
        .add(_selectedAppointmentType == '2' ? SizedBox() : servicesWidget());

    return formWidget;
  }

  Widget consultancyFeeWidget() {
    String fee = "0.00", duration = "0";

    if (profileMap[_appointmentTypeKey] != null &&
        profileMap[_appointmentTypeKey].length > 0) {
      fee = profileMap[_appointmentTypeKey][0]['fee'].toStringAsFixed(2) ??
          '0.00';
      duration =
          profileMap[_appointmentTypeKey][0]['duration'].toString() ?? '0';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Colors.grey[100],
        ),
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Consultation",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 7),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Fee \$ '),
                    TextSpan(
                      text: '$fee \u2022 ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: 'Duration '),
                    TextSpan(
                      text: '$duration min',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Radio(
                activeColor: AppColors.persian_blue,
                groupValue: _radioValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 0,
                onChanged: _handleRadioValueChange,
              ),
            ),
          )
        ],
      ),
    ).onClick(
      onTap: () => _handleRadioValueChange(0),
    );
  }

  Widget servicesWidget() {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Colors.grey[100],
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _radioValue == 0 ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Services",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Choose offered services",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Radio(
                      activeColor: AppColors.persian_blue,
                      groupValue: _radioValue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: 1,
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                ),
              ],
            ),
          ).onClick(
            onTap: () => _handleRadioValueChange(1),
          ),
          _radioValue == 0
              ? Container()
              : servicesList != null && servicesList.length > 0
                  ? ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: servicesList.length,
                      itemBuilder: (context, index) {
                        if (servicesList != null && servicesList.length > 0) {
                          Services services = servicesList[index];
                          return serviceSlotWidget(services);
                        }

                        return Container();
                      })
                  : Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(20),
                      child: Text("NO services available"),
                    ),
        ],
      ),
    );
  }

  Widget serviceSlotWidget(Services services) {
    return CheckboxListTile(
      dense: false,
      controlAffinity: ListTileControlAffinity.trailing,
      value: _selectedServicesMap.containsKey(services.subServiceId),
      activeColor: AppColors.goldenTainoi,
      onChanged: (value) {
        value
            ? _selectedServicesMap[services.subServiceId] = services
            : _selectedServicesMap.remove(services.subServiceId);

        setState(() {});
      },
      title: Text(
        services.subServiceName ?? "---",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Amount \$ ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: '${services.amount.toStringAsFixed(2)} \u2022 ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: 'Duration ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: '${services.duration} min',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() => _radioValue = value);

    if (value == 0) {
      _selectedServicesMap.clear();
    }
  }
}
