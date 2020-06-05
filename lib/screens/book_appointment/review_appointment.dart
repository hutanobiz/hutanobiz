import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/dashboard/choose_location_screen.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class ReviewAppointmentScreen extends StatefulWidget {
  @override
  _ReviewAppointmentScreenState createState() =>
      _ReviewAppointmentScreenState();
}

class _ReviewAppointmentScreenState extends State<ReviewAppointmentScreen> {
  InheritedContainerState _container;
  Map _appointmentData;
  Map _providerData, _userLocationMap;
  bool _isLoading = false;
  String _timeHours, _timeMins;
  DateTime _bookedDate;
  String _bookedTime;
  List<Services> _servicesList = new List();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  String averageRating = "0";

  PolylinePoints _polylinePoints = PolylinePoints();

  List<LatLng> latlng = [];
  LatLng _initialPosition, _middlePoint;
  LatLng _desPosition = LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor _sourceIcon;
  BitmapDescriptor _destinationIcon;

  String _totalDistance = "";
  String _totalDuration = "";
  Map _profileMap = new Map();
  Map _servicesMap = new Map();
  Map<String, String> _reviewAppointmentData = Map();
  Map _consentToTreatMap;
  String paymentType, insuranceName, insuranceImage, insuranceId;

  List<dynamic> _consultaceList = List();

  setPolylines() async {
    PolylineResult polylineResult =
        await _polylinePoints?.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(_initialPosition.latitude, _initialPosition.longitude),
      PointLatLng(_desPosition.latitude, _desPosition.longitude),
    );

    List<PointLatLng> result = polylineResult.points;

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        latlng.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      _polyline.add(
        Polyline(
          polylineId: PolylineId(_initialPosition.toString()),
          color: AppColors.persian_indigo,
          points: latlng,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    setSourceAndDestinationIcons();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    _providerData = _container.getProviderData();
    _appointmentData = _container.appointmentData;
    _userLocationMap = _container.userLocationMap;
    _consentToTreatMap = _container.consentToTreatMap;

    if (_consentToTreatMap["paymentMap"] != null) {
      paymentType = _consentToTreatMap["paymentMap"]["paymentType"];

      if (_consentToTreatMap["paymentMap"]["insuranceId"] != null) {
        insuranceId = _consentToTreatMap["paymentMap"]["insuranceId"];
      }
      if (_consentToTreatMap["paymentMap"]["insuranceName"] != null) {
        insuranceName = _consentToTreatMap["paymentMap"]["insuranceName"];
      }
      if (_consentToTreatMap["paymentMap"]["insuranceImage"] != null) {
        insuranceImage = _consentToTreatMap["paymentMap"]["insuranceImage"];
      }
    }

    if (_providerData["providerData"]["data"] != null) {
      averageRating =
          _providerData["providerData"]["averageRating"]?.toStringAsFixed(2) ??
              "0";

      _providerData["providerData"]["data"].map((f) {
        _profileMap.addAll(f);
      }).toList();
    } else {
      _profileMap = _providerData["providerData"];
      averageRating = _profileMap["averageRating"]?.toStringAsFixed(2) ?? "0";
    }

    _initialPosition = _userLocationMap["latLng"];
    if (_profileMap["businessLocation"] != null) {
      if (_profileMap["businessLocation"]["coordinates"].length > 0) {
        _desPosition = LatLng(_profileMap["businessLocation"]["coordinates"][1],
            _profileMap["businessLocation"]["coordinates"][0]);
      }
    }

    _middlePoint = LatLng(
        (_initialPosition.latitude + _desPosition.latitude) / 2,
        (_initialPosition.longitude + _desPosition.longitude) / 2);

    if (_initialPosition != null) {
      getDistanceAndTime(_initialPosition, _desPosition);
    }

    _bookedTime = _appointmentData["time"];
    _bookedDate = _appointmentData["date"];

    if (_bookedTime.length < 4) {
      if (_bookedTime[0] != "0") {
        _bookedTime =
            _bookedTime.substring(0, 2) + "0" + _bookedTime.substring(2);
      } else {
        _bookedTime = "0" + _bookedTime;
      }
    }
    _timeHours = _bookedTime.substring(0, 2);
    _timeMins = _bookedTime.substring(3);

    _servicesMap = _container.selectServiceMap;

    _reviewAppointmentData["statusType"] = _servicesMap["status"].toString();

    if (_servicesList.length > 0) _servicesList.clear();

    if (_servicesMap["status"].toString() == "1") {
      if (_servicesMap["services"] != null) {
        _servicesList = _servicesMap["services"];

        for (int i = 0; i < _servicesList.length; i++) {
          _reviewAppointmentData["services[${i.toString()}][subServiceId]"] =
              _servicesList[i].subServiceId;
          _reviewAppointmentData["services[${i.toString()}][amount]"] =
              _servicesList[i].amount.toString();
        }
      }
    } else {
      _consultaceList = _servicesMap["consultaceFee"];

      for (int i = 0; i < _consultaceList.length; i++) {
        _reviewAppointmentData["consultanceFee[${i.toString()}][fee]"] =
            _consultaceList[i]["fee"].toString();
      }
    }
  }

  void setSourceAndDestinationIcons() async {
    _sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_initial_marker.png");
    _destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_destination_marker.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Review Appointment",
        color: AppColors.snow,
        isLoading: _isLoading,
        addBackButton: true,
        buttonColor: AppColors.windsor,
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgetList(),
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                width: MediaQuery.of(context).size.width - 76.0,
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: FancyButton(
                  title: "Book Appointment",
                  buttonIcon: "ic_send_request",
                  buttonColor: AppColors.windsor,
                  onPressed: () {
                    _bookAppointment();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentWidget(
      String paymentType, String insuranceName, String insuranceImage) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
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
              paymentType == "1"
                  ? Image.asset("images/ic_cash_payment.png",
                      height: 42, width: 42)
                  : insuranceImage == null
                      ? Image.asset("images/insurancePlaceHolder.png",
                          height: 42, width: 42)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            ApiBaseHelper.imageUrl + insuranceImage,
                            height: 42,
                            width: 42,
                            fit: BoxFit.cover,
                          ),
                        ),
              SizedBox(width: 14.0),
              Expanded(
                child: Text(
                  paymentType == "1" ? "Cash" : insuranceName,
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

  _bookAppointment() async {
    try {
      SharedPref().getToken().then((token) async {
        _loading(true);
        Uri uri = Uri.parse(
            ApiBaseHelper.base_url + "api/patient/appointment-booking");
        http.MultipartRequest request = http.MultipartRequest('POST', uri);
        request.headers['authorization'] = token;

        String doctorId = _profileMap["userId"]["_id"].toString();

        _reviewAppointmentData["type"] =
            _container.getProjectsResponse()["serviceType"]?.toString() ?? "1";
        _reviewAppointmentData["date"] =
            DateFormat("MM/dd/yyyy").format(_bookedDate).toString();

        _reviewAppointmentData["fromTime"] = _bookedTime;
        _reviewAppointmentData["doctor"] = doctorId;

        request.fields.addAll(_reviewAppointmentData);

        request.fields['consentToTreat'] = '1';
        request.fields['problemTimeSpan'] =
            _consentToTreatMap["problemTimeSpan"];
        request.fields['isProblemImproving'] =
            _consentToTreatMap["isProblemImproving"];
        request.fields['isTreatmentReceived'] =
            _consentToTreatMap["isTreatmentReceived"];
        request.fields['description'] =
            _consentToTreatMap["description"].toString().trim();

        if (paymentType != null) {
          if (paymentType == "1") {
            request.fields['cashPayment'] = "1";
          } else if (paymentType == "2") {
            request.fields['insuranceId'] = insuranceId;
          }
        }

        if (_consentToTreatMap["medicalHistory"] != null &&
            _consentToTreatMap["medicalHistory"].length > 0) {
          for (int i = 0;
              i < _consentToTreatMap["medicalHistory"].length;
              i++) {
            request.fields["medicalHistory[$i]"] =
                _consentToTreatMap["medicalHistory"][i];
          }
        }

        if (_consentToTreatMap["imagesList"] != null &&
            _consentToTreatMap["imagesList"].length > 0) {
          List<String> imagesList = _consentToTreatMap["imagesList"];
          if (imagesList != null && imagesList.length > 0) {
            for (int i = 0; i < imagesList.length; i++) {
              File imageFile = File(imagesList[i].toString());
              var stream =
                  http.ByteStream(DelegatingStream(imageFile.openRead()));
              var length = await imageFile.length();
              var multipartFile = http.MultipartFile(
                  "images", stream.cast(), length,
                  filename: imageFile.path);
              request.files.add(multipartFile);
            }
          }
        }
        if (_consentToTreatMap["docsList"] != null &&
            _consentToTreatMap["docsList"].length > 0) {
          List<File> imagesList = _consentToTreatMap["docsList"];
          if (imagesList != null && imagesList.length > 0) {
            for (int i = 0; i < imagesList.length; i++) {
              File imageFile = imagesList[i];
              var stream =
                  http.ByteStream(DelegatingStream(imageFile.openRead()));
              var length = await imageFile.length();
              var multipartFile = http.MultipartFile(
                  "medicalDocuments", stream.cast(), length,
                  filename: imageFile.path);
              request.files.add(multipartFile);
            }
          }
        }

        var response = await request.send();
        final int statusCode = response.statusCode;
        log("Status code: $statusCode");

        JsonDecoder _decoder = new JsonDecoder();

        String respStr = await response.stream.bytesToString();
        var responseJson = _decoder.convert(respStr);

        if (statusCode < 200 || statusCode > 400 || json == null) {
          _loading(false);
          if (responseJson["response"] is String)
            Widgets.showToast(responseJson["response"]);
          else if (responseJson["response"] is Map)
            Widgets.showToast(responseJson);
          else {
            responseJson["response"]
                .map((m) => Widgets.showToast(m.toString()))
                .toList();
          }

          responseJson["response"].toString().debugLog();
          throw Exception(responseJson);
        } else {
          _loading(false);

          responseJson["response"].toString().debugLog();

          showConfirmDialog();
        }

        _loading(false);
      });
    } on Exception catch (error) {
      _loading(false);
      error.toString().debugLog();
    }
  }

  void showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  "Office Request Sent!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.90),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "You'll be notified when the provider accepts your request.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
                SizedBox(height: 26),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: AppColors.goldenTainoi,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      _container.consentToTreatMap.clear();
                      _container.getProviderData().clear();
                      _container.appointmentData.clear();

                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.dashboardScreen,
                        (Route<dynamic> route) => false,
                        arguments: true,
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> widgetList() {
    List<Widget> _widgetList = new List();
    String address;

    if (_profileMap["businessLocation"] != null) {
      dynamic business = _profileMap["businessLocation"];

      String state = "---";
      if (business["state"] != null) {
        state = business["state"]["title"]?.toString() ?? "---";
      }

      address = (business["address"]?.toString() ?? "---") +
          ", " +
          (business["street"]?.toString() ?? "---") +
          ", " +
          (business["city"]?.toString() ?? "---") +
          ", " +
          state +
          " - " +
          (business["zipCode"]?.toString() ?? "---");
    }

    _widgetList.add(Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: ProviderWidget(
        data: _profileMap,
        degree: _providerData["degree"].toString(),
        isOptionsShow: false,
        averageRating: averageRating,
      ),
    ));

    _widgetList.add(SizedBox(height: 26.0));

    _widgetList.add(container(
        "Date & Time",
        "${DateFormat('EEEE, dd MMMM').format(_bookedDate).toString()} " +
            TimeOfDay(hour: int.parse(_timeHours), minute: int.parse(_timeMins))
                .format(context),
        "ic_calendar"));

    _widgetList.add(SizedBox(height: 12.0));

    _widgetList.add(container("Office Address", address, "ic_office_address"));

    _widgetList.add(
      servicesWidget(),
    );

    _widgetList.add(
      paymentWidget(paymentType, insuranceName, insuranceImage),
    );

    _widgetList.add(_initialPosition == null
        ? Container()
        : Stack(
            children: <Widget>[
              Container(
                height: 155.0,
                margin: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: GoogleMap(
                    myLocationEnabled: false,
                    compassEnabled: false,
                    rotateGesturesEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: _middlePoint,
                      zoom: 8,
                    ),
                    polylines: _polyline,
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        setPolylines();

                        _controller.complete(controller);

                        _markers.add(Marker(
                          markerId: MarkerId(_initialPosition.toString()),
                          position: _initialPosition,
                          icon: _sourceIcon,
                        ));

                        _markers.add(Marker(
                          markerId: MarkerId(_desPosition.toString()),
                          position: _desPosition,
                          icon: _destinationIcon,
                        ));
                      });
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(60.0, 33.0, 0.0, 0.0),
                padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    "ic_map_clock".imageIcon(width: 30.0, height: 30.0),
                    SizedBox(width: 5.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _totalDuration,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _totalDistance,
                          style: TextStyle(
                            fontSize: 11.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ));

    _widgetList.add(paymentType == "3" ? duePaymentWidget() : Container());

    return _widgetList;
  }

  void getDistanceAndTime(LatLng initialPosition, LatLng desPosition) {
    ApiBaseHelper _apiHelper = ApiBaseHelper();
    _apiHelper
        .getDistanceAndTime(initialPosition, desPosition, kGoogleApiKey)
        .then((value) {
      _totalDistance =
          value["rows"][0]["elements"][0]["distance"]["text"].toString();
      _totalDuration =
          value["rows"][0]["elements"][0]["duration"]["text"].toString();
      ("DISTANCE AND TIME: " + value["rows"][0]["elements"][0].toString())
          .toString()
          .debugLog();
    }).futureError((error) {
      setState(() {
        _totalDuration = "NO duration available";
        _totalDistance = "NO distance available";
      });
      error.toString().debugLog();
    });
  }

  Widget duePaymentWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.sunglow.withOpacity(0.20),
        border: Border.all(
          width: 1.0,
          color: AppColors.sunglow,
        ),
        borderRadius: BorderRadius.circular(
          14.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Note",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "You will only be charged when the request has been accepted.",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget container(String heading, String subtitle, String icon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                heading,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              heading.toLowerCase().contains("date")
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.edit,
                                size: 10.0,
                                color: AppColors.jade,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                "Edit",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.jade.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ).onClick(
                          roundCorners: false,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              icon.imageIcon(),
              SizedBox(width: 8.0),
              Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget servicesWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Selected Services",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: Colors.grey[200],
                width: 0.5,
              ),
            ),
            child: _servicesList != null && _servicesList.length > 0
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _servicesList.length,
                    itemBuilder: (context, index) {
                      Services services = _servicesList[index];
                      return serviceSlotWidget(services);
                    })
                : ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _consultaceList.length,
                    itemBuilder: (context, index) {
                      dynamic consultance = _consultaceList[index];
                      return consultationSlotWidget(consultance);
                    }),
          ),
          SizedBox(height: 6.0),
        ],
      ),
    );
  }

  Widget serviceSlotWidget(Services services) {
    return ListTile(
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
              text: '${services.amount} \u2022 ',
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

  Widget consultationSlotWidget(Map consultaion) {
    return ListTile(
      title: Text(
        "Consultation Fee",
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
              text: 'Fee \$ ',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.85),
              ),
            ),
            TextSpan(
              text: (consultaion["fee"]?.toString() ?? "---") + ' \u2022 ',
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
              text: consultaion["duration"]?.toString() ?? "---" + ' min',
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

  void _loading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }
}
