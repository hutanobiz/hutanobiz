import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  ProviderProfileScreen({Key key}) : super(key: key);

  @override
  _ProviderProfileScreenState createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  Future<dynamic> _profileFuture;
  Map _containerMap;
  InheritedContainerState _container;
  Map profileMapResponse = Map();
  String degree;
  List speaciltyList = List();
  List reviewsList = List();

  final Set<Marker> _markers = {};
  BitmapDescriptor sourceIcon;
  Completer<GoogleMapController> _controller = Completer();
  List scheduleList = List();

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
    _containerMap = _container.getProjectsResponse();

    ApiBaseHelper api = ApiBaseHelper();

    _profileFuture = api.getProviderProfile(_providerData["providerId"]);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Provider Profile",
        color: Colors.white,
        isAddBack: false,
        addBackButton: true,
        padding: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: FutureBuilder(
                  future: _profileFuture,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("NO data available");
                        break;
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.active:
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          profileMapResponse = snapshot.data;

                          if (profileMapResponse.isEmpty) return Container();

                          return SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widgetList(profileMapResponse),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        break;
                    }
                    return null;
                  }),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                width: MediaQuery.of(context).size.width - 76.0,
                padding: const EdgeInsets.only(right: 20.0, left: 40.0),
                child: FancyButton(
                  title: "Schedule Appointment",
                  onPressed: () {
                    _container.getProviderData().clear();

                    _container.setProviderData(
                        "providerData", profileMapResponse);
                    _container.setProviderData("degree", degree);

                    if (_containerMap.containsKey("specialityId") ||
                        _containerMap.containsKey("serviceId"))
                      Navigator.of(context)
                          .pushNamed(Routes.appointmentTypeScreen);
                    else
                      Navigator.of(context)
                          .pushNamed(Routes.selectServicesScreen);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> widgetList(Map profileResponse) {
    List response = profileResponse["data"];
    Map _providerData = Map();

    response.map((f) {
      _providerData.addAll(f);
    }).toList();

    String institute,
        address,
        todaysTimings = "---",
        tomorrowsTimings = "---",
        averageRating = "---";

    LatLng latLng = LatLng(0, 0);

    averageRating = profileResponse['averageRating']?.toString() ?? "0";

    for (dynamic education in _providerData["education"]) {
      institute = education["institute"] ?? "---";
      degree = education["degree"] ?? "---";
    }

    if (_providerData['specialties'] != null) {
      speaciltyList = _providerData['specialties'];
    }

    if (profileResponse['reviews'] != null) {
      reviewsList = profileResponse['reviews'];
    }

    if (_providerData['schedules'] != null) {
      scheduleList = _providerData['schedules'];
      Map scheduleMap = Map();

      scheduleList.map((f) => scheduleMap.addAll(f)).toList();

      List dayList = scheduleMap["day"];

      for (dynamic days in dayList) {
        if (DateTime.now().weekday.toString() == days.toString()) {
          todaysTimings =
              scheduleMap["fromTime"] + " - " + scheduleMap["toTime"] + " ; ";
        }

        if ((DateTime.now().weekday + 1).toString() == days.toString()) {
          tomorrowsTimings =
              scheduleMap["fromTime"] + " - " + scheduleMap["toTime"] + " ; ";
        }
      }

      scheduleMap["day"].toString().debugLog();
    }

    if (_providerData["businessLocation"] != null) {
      address =
          _providerData["businessLocation"]["address"]?.toString() ?? "---";

      if (_providerData["businessLocation"]["coordinates"] != null) {
        List location = _providerData["businessLocation"]["coordinates"];

        if (location.length > 0) {
          latLng = LatLng(
            location[0],
            location[1],
          );
        }
      }
    }

    List<Widget> formWidget = List();

    formWidget.add(Padding(
      padding: const EdgeInsets.all(20.0),
      child: ProviderWidget(
        data: _providerData,
        degree: degree.toString(),
        averageRating: averageRating,
        isOptionsShow: false,
      ),
    ));

    formWidget.add(Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        "Specialities",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    ));

    formWidget.add(SizedBox(height: 12.0));

    formWidget.add(
      GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          mainAxisSpacing: 18.0,
          crossAxisSpacing: 16.0,
        ),
        itemCount: speaciltyList.length,
        itemBuilder: (context, index) {
          if (speaciltyList == null || speaciltyList.length == 0)
            return Container();

          return appoCard(
            'images/office_appointment.png',
            speaciltyList[index]["title"],
          );
        },
      ),
    );

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
        child: Text(
          "$institute, ${degree.toString()}",
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
      ),
    );

    formWidget.add(divider());

    formWidget.add(Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
      child: Text(
        "About ${_providerData["userId"]["fullName"]}",
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
          "Language Known",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    formWidget.add(
      Container(
        margin: const EdgeInsets.only(left: 20, bottom: 16),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.windsor.withOpacity(0.05),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Text(
          _providerData["userId"]["language"]?.toString() ?? "---",
          style: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        ),
      ),
    );

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
        child: Text(
          "Available Timings",
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
                  TextSpan(text: 'Today '),
                  TextSpan(
                    text:
                        todaysTimings.substring(0, todaysTimings.length - 3) ??
                            "---",
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
                  TextSpan(text: 'Tomorrow '),
                  TextSpan(
                    text: tomorrowsTimings.substring(
                            0, tomorrowsTimings.length - 3) ??
                        "---",
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
                // Navigator.of(context).pushNamed(
                //   Routes.availableTimingsScreen,
                // );
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "View all timings",
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

    formWidget.add(divider());

    formWidget.add(locationWidget(address, latLng));

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
        child: Text(
          "Care by ${_providerData["userId"]["fullName"]}",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    formWidget.add(Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 16),
      child: Row(
        children: <Widget>[
          _providerData["isOfficeEnabled"]
              ? appoCard(
                  'images/office_appointment.png',
                  "Office\nAppointment",
                )
              : Container(),
          SizedBox(width: 20),
          _providerData["isVideoChatEnabled"]
              ? appoCard(
                  'images/video_chat_appointment.png',
                  "Video\nAppointment",
                )
              : Container()
        ],
      ),
    ));

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 16),
        child: _providerData["isOnsiteEnabled"]
            ? appoCard(
                'images/onsite_appointment.png',
                "Onsite\nAppointment",
              )
            : Container(),
      ),
    );

    formWidget.add(divider());

    formWidget.add(
      Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 16, top: 16),
        child: Text(
          "Feedback for ${_providerData["userId"]["fullName"]}",
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
          : ListView.builder(
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              reverse: true,
              shrinkWrap: true,
              itemCount: reviewsList.length,
              itemBuilder: (context, index) {
                dynamic response = reviewsList[index];

                return ReviewWidget(
                  reviewerName: response["user"]["fullName"],
                  avatar: response["user"]["avatar"],
                  reviewDate: DateFormat(
                    'dd MMMM yyyy',
                  )
                      .format(DateTime.parse(response["user"]["updatedAt"]))
                      .toString(),
                  reviewerRating:
                      double.parse(response["rating"]?.toString() ?? "0"),
                  reviewText: response["review"],
                );
              },
            ),
    );
    // formWidget.add(
    //   Padding(
    //     padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
    //     child: ReviewWidget(
    //       reviewerName: "Chris Hemsworth",
    //       reviewDate: "03 Dec 2019",
    //       reviewerRating: 5.0,
    //       reviewText:
    //           "Ann is one of the best nurses I have ever encountered.She has a great sense of humor: but she is very compassionate and serious about her work. I will definitely seek her out next time I need care.",
    //     ),
    //   ),
    // );

    return formWidget;
  }

  Widget locationWidget(String location, LatLng latLng) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Location",
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
                  Column(
                    children: <Widget>[
                      Text(
                        location,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 30.0),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {},
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

                      _markers.add(Marker(
                        markerId: MarkerId(latLng.toString()),
                        position: latLng,
                        icon: sourceIcon,
                      ));
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
}
