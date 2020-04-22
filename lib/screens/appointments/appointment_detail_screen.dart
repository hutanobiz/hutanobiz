import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({Key key}) : super(key: key);

  @override
  _AppointmentDetailScreenState createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  Future<dynamic> _profileFuture;
  InheritedContainerState _container;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    SharedPref().getToken().then((token) {
      ApiBaseHelper api = ApiBaseHelper();
      token.debugLog();

      setState(() {
        _profileFuture = api.getAppointmentDetails(
            token, _container.appointmentIdMap["appointmentId"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackground(
          title: "Appointment Detail",
          isAddBack: false,
          addBackButton: true,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 60),
                child: FutureBuilder(
                    future: _profileFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map profileMap = snapshot.data;

                        return SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: profileWidget(profileMap),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
              Align(
                alignment: FractionalOffset.bottomRight,
                child: Container(
                  height: 55.0,
                  width: MediaQuery.of(context).size.width - 76.0,
                  padding: const EdgeInsets.only(right: 20.0, left: 40.0),
                  child: FancyButton(
                    title: "Treatment Summary",
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget profileWidget(Map _data) {
    Map _providerData = _data["data"];

    _container.getProviderData().clear();
    _container.setProviderData("providerData", _providerData);

    String name = "---",
        rating = "---",
        professionalTitle = "---",
        fee = "---",
        avatar,
        address = "---";

    LatLng latLng;

    rating = _data["averageRating"] ?? "---";

    if (_data["doctorData"] != null) {
      for (dynamic detail in _data["doctorData"]) {
        if (detail["averageRating"] != null) if (detail["professionalTitle"] !=
            null) {
          professionalTitle = detail["professionalTitle"]["title"] ?? "---";
        }

        if (detail["consultanceFee"] != null) {
          for (dynamic consultanceFee in detail["consultanceFee"]) {
            fee = consultanceFee["fee"].toString() ?? "---";
          }
        }

        if (detail["businessLocation"] != null) {
          address = detail["businessLocation"]["address"] ?? "---";

          if (detail["businessLocation"]["coordinates"] != null)
            latLng = LatLng(
              detail["businessLocation"]["coordinates"][0] ?? 28.5355,
              detail["businessLocation"]["coordinates"][1] ?? 77.3910,
            );
        }
      }
    }

    if (_providerData["doctor"] != null) {
      name = _providerData["doctor"]["fullName"] ?? "---";
      avatar = _providerData["doctor"]["avatar"];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 62.0,
                height: 62.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        avatar ?? 'http://i.imgur.com/QSev0hg.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: AppColors.goldenTainoi,
                          size: 12.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          "$rating \u2022 $professionalTitle",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    _providerData["consentToTreat"] == false
                        ? Container()
                        : RawMaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              _container.setAppointmentId(
                                  _providerData["_id"].toString());
                              Navigator.of(context)
                                  .pushNamed(Routes.consentToTreatScreen);
                            },
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    "View consent to treat",
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
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 62.0,
                        height: 23.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _providerData["status"].toString() == "1"
                              ? Colors.lightGreen.withOpacity(0.12)
                              : Colors.red.withOpacity(0.12),
                          shape: BoxShape.rectangle,
                        ),
                        child: Text(
                          _providerData["status"].toString() == "1"
                              ? "Completed"
                              : "Cancelled",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: _providerData["status"].toString() == "1"
                                ? Colors.lightGreen
                                : Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "\$$fee",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        rateWidget(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 11.0),
          child: Text(
            "Appointment Type",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        appoCard(
          _providerData["type"],
        ),
        divider(topPadding: 18.0),
        dateTimeWidget(
            DateFormat(
              'EEEE, dd MMMM, ',
            ).format(DateTime.parse(_providerData['date'])).toString(),
            _providerData["fromTime"].toString(),
            _providerData["toTime"].toString()),
        divider(topPadding: 8.0),
        locationWidget(address, latLng),
        divider(),
        paymentWidget("cardNumber"),
        divider(topPadding: 10.0),
      ],
    );
  }

  Widget rateWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      color: AppColors.goldenTainoi.withOpacity(0.06),
      child: Row(
        children: <Widget>[
          Text(
            'Not Rated Yet',
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FlatButton.icon(
                icon: Icon(
                  Icons.star,
                  color: AppColors.goldenTainoi,
                  size: 20.0,
                ),
                padding: const EdgeInsets.all(5.0),
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.rateDoctorScreen),
                label: Text(
                  "Rate Now",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.goldenTainoi,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget appoCard(int cardText) {
    return Container(
      width: 172.0,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[100]),
      ),
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage(
              cardText == 1
                  ? "images/office_appointment.png"
                  : cardText == 2
                      ? "images/video_chat_appointment.png"
                      : "images/onsite_appointment.png",
            ),
            height: 52.0,
            width: 52.0,
          ),
          SizedBox(width: 12.0),
          Text(
            cardText == 1
                ? "Office\nAppointment"
                : cardText == 2 ? "Video\nAppointment" : "Onsite\nAppointment",
            maxLines: 2,
            style: TextStyle(
              color: AppColors.midnight_express,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget dateTimeWidget(String dateTime, String fromTime, String toTime) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Date & Time",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              "ic_appointment_time".imageIcon(),
              SizedBox(width: 8.0),
              Text(
                dateTime +
                    fromTime.timeOfDay(context) +
                    " - " +
                    toTime.timeOfDay(context),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    "I need help with my Appiontment",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.windsor.withOpacity(0.85),
                      fontSize: 13.0,
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
          ).onClick(
            roundCorners: false,
            onTap: () => Widgets.showToast("help"),
          ),
        ],
      ),
    );
  }

  Widget locationWidget(String location, LatLng latLng) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
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
                margin: const EdgeInsets.only(top: 11.0),
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
                    initialCameraPosition: CameraPosition(
                      target: latLng,
                      zoom: 9.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {},
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget paymentWidget(String cardNumber) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Payment Method",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 18.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              "ic_dummy_card".imageIcon(width: 42, height: 42),
              SizedBox(width: 14.0),
              Expanded(
                child: Text(
                  "Paid via Card **** 2563", //TODO: card number
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
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
