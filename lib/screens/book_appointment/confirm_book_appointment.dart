import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hutano/apis/api_constants.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/payment/utils/card_utils.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/hutano_textfield.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/provider_list_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'morecondition/providers/health_condition_provider.dart';

class ConfirmBookAppointmentScreen extends StatefulWidget {
  @override
  _ConfirmBookAppointmentScreenState createState() =>
      _ConfirmBookAppointmentScreenState();
}

class _ConfirmBookAppointmentScreenState
    extends State<ConfirmBookAppointmentScreen> {
  InheritedContainerState _container;
  Map _appointmentData;
  Map _providerData, _userLocationMap;
  bool _isLoading = false;
  String _timeHours, _timeMins;
  DateTime _bookedDate;
  String _bookedTime;
  List<Services> _servicesList = new List();
  String _timezone = 'Unknown';

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
  double _totalAmount = 0;

  setPolylines() async {
    PolylineResult polylineResult =
        await _polylinePoints?.getRouteBetweenCoordinates(
      Strings.kGoogleApiKey,
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

    StripePayment.setOptions(
      StripeOptions(
        publishableKey: kstripePublishKey,
      ),
    );
    setSourceAndDestinationIcons();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _container = InheritedContainer.of(context);

    _providerData = _container.getProviderData();
    _appointmentData = _container.appointmentData;
    if (_container.userLocationMap != null &&
        _container.userLocationMap.isNotEmpty) {
      _userLocationMap = _container.userLocationMap;
    } else {
      _userLocationMap = _container.userLocationMap;
      initPlatformState();
    }
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

    if (_container.projectsResponse["serviceType"].toString() == '3') {
      if (Provider.of<HealthConditionProvider>(context, listen: false)
              .addressDetails !=
          null) {
        _desPosition = LatLng(
            Provider.of<HealthConditionProvider>(context, listen: false)
                .coordinatesDetails
                .longitude,
            Provider.of<HealthConditionProvider>(context, listen: false)
                .coordinatesDetails
                .latitude);
      } else {
        _desPosition = LatLng(
            _consentToTreatMap["userAddress"]['coordinates'][1],
            _consentToTreatMap["userAddress"]['coordinates'][0]);
      }
    } else if (_container.projectsResponse["serviceType"].toString() == '1') {
      if (_profileMap["businessLocation"] != null) {
        if (_profileMap["businessLocation"]["coordinates"].length > 0) {
          _desPosition = LatLng(
              double.parse(
                  _profileMap["businessLocation"]["coordinates"][1].toString()),
              double.parse(_profileMap["businessLocation"]["coordinates"][0]
                  .toString()));
        }
      }
    } else {}
    if (_initialPosition != null) {
      _middlePoint = LatLng(
          (_initialPosition.latitude + _desPosition.latitude) / 2,
          (_initialPosition.longitude + _desPosition.longitude) / 2);

      if (_initialPosition != null) {
        getDistanceAndTime(_initialPosition, _desPosition);
      }
    }

    _setBookingTime(_appointmentData["time"]);
    _bookedDate = _appointmentData["date"];

    _servicesMap = _container.selectServiceMap;

    _reviewAppointmentData["statusType"] = _servicesMap["status"].toString();

    if (_servicesList.length > 0) _servicesList.clear();

    if (_servicesMap["status"].toString() == "1") {
      if (_servicesMap["services"] != null) {
        _servicesList = _servicesMap["services"];

        for (int i = 0; i < _servicesList.length; i++) {
          _totalAmount =
              double.parse(_servicesList[i].amount.toString()) + _totalAmount;
          _reviewAppointmentData["services[${i.toString()}][subServiceId]"] =
              _servicesList[i].subServiceId;
          _reviewAppointmentData["services[${i.toString()}][amount]"] =
              _servicesList[i].amount.toString();
        }
      }
    } else {
      _consultaceList = _servicesMap["consultaceFee"];

      for (int i = 0; i < _consultaceList.length; i++) {
        _totalAmount =
            double.parse(_consultaceList[i]["fee"].toString()) + _totalAmount;
        _reviewAppointmentData["consultanceFee[${i.toString()}][fee]"] =
            _consultaceList[i]["fee"].toString();
      }
    }
    if (_consentToTreatMap != null &&
        _consentToTreatMap["parkingMap"] != null &&
        _consentToTreatMap["parkingMap"]["parkingFee"] != null)
      _totalAmount += _consentToTreatMap["parkingMap"]["parkingFee"];
  }

  initPlatformState() async {
    Location _location = Location();
    PermissionStatus _permission;

    _permission = await _location.requestPermission();
    print("Permission: $_permission");

    switch (_permission) {
      case PermissionStatus.granted:
        bool serviceStatus = await _location.serviceEnabled();
        print("Service status: $serviceStatus");

        if (serviceStatus) {
          Widgets.showToast("Getting Location. Please wait..");

          try {
            LocationData locationData = await _location.getLocation();

            _initialPosition =
                LatLng(locationData.latitude, locationData.longitude);
            _middlePoint = LatLng(
                (_initialPosition.latitude + _desPosition.latitude) / 2,
                (_initialPosition.longitude + _desPosition.longitude) / 2);

            if (_initialPosition != null) {
              getDistanceAndTime(_initialPosition, _desPosition);
            }
          } on PlatformException catch (e) {
            Widgets.showToast(e.message.toString());
            e.toString().debugLog();

            log(e.code);

            _location = null;
          }
        } else {
          bool serviceStatusResult = await _location.requestService();
          print("Service status activated after request: $serviceStatusResult");
          initPlatformState();
        }

        break;
      case PermissionStatus.denied:
        initPlatformState();
        break;
      case PermissionStatus.deniedForever:
        break;
    }
  }

  void _setBookingTime(String bookTime) {
    if (bookTime.length < 4) {
      if (bookTime[0] != "0") {
        bookTime = bookTime.substring(0, 2) + "0" + bookTime.substring(2);
      } else {
        bookTime = "0" + bookTime;
      }
    }

    var fromTime = new DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        9,
        int.parse(bookTime.split(':')[0]),
        int.parse(bookTime.split(':')[1]));

    _timeHours = DateFormat('HH').format(fromTime);
    _timeMins = DateFormat('mm').format(fromTime);
    _bookedTime = '$_timeHours:$_timeMins';
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
      body: LoadingBackgroundNew(
          title: "Review Appointment",
          color: AppColors.snow,
          isLoading: _isLoading,
          isAddAppBar: true,
          addHeader: true,
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: SingleChildScrollView(
            child: _confirmAndPay(),
          )),
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
              paymentType == "3"
                  ? Image.asset("images/ic_cash_payment.png",
                      height: 42, width: 42)
                  : paymentType == "1"
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
                  paymentType == "3"
                      ? "Cash"
                      : paymentType == "1"
                          ? "Card **** **** **** ${_consentToTreatMap["paymentMap"]["selectedCard"]['card']['last4']}"
                          : insuranceName,
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

  Widget _buildCardWidget() {
    var _card;
    var title;
    var image;
    if (paymentType == "1") {
      _card = _consentToTreatMap["paymentMap"]["selectedCard"]['card'];
      title = "**** **** **** ${_card['last4']}";
    } else if (paymentType == "2") {
      image = "images/insurancePlaceHolder.png";
      title = insuranceName;
    } else {
      title = "Cash";
      image = "images/ic_cash_payment.png";
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                paymentType == "1"
                    ? getCardIcon(CardType.Master)
                    : (paymentType == "2" && insuranceImage == null)
                        ? Image.network(
                            ApiBaseHelper.imageUrl + insuranceImage,
                            height: 42,
                            width: 42,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            image,
                            width: 28,
                            height: 28,
                          ),
                SizedBox(width: spacing25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: fontSize14,
                          color: colorBorder2,
                          fontWeight: fontWeightSemiBold),
                    ),
                    if (paymentType == "1") ...[
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        'Expires ${_card["exp_month"]}/${_card["exp_year"].toString().substring(2, 4)}',
                        style: TextStyle(
                            fontSize: fontSize12,
                            color: colorBorder2,
                            fontWeight: fontWeightRegular),
                      ),
                    ]
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.popUntil(context,
                        ModalRoute.withName(Routes.paymentMethodScreen));
                  },
                  child: Text("Change",
                      style: const TextStyle(
                          color: const Color(0xff1e36ba),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 13.0),
                      textAlign: TextAlign.right),
                )
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: spacing5),
            padding: EdgeInsets.all(spacing15),
            width: double.infinity,
            height: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 30,
                  color: colorLightGrey.withOpacity(0.2),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildHutanoCashWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "images/ic_cash_payment.png",
                  width: 28,
                  height: 28,
                ),
                SizedBox(width: spacing25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Hutano Cash Applied (\$${_consentToTreatMap['hutanoCash'].toString()})',
                        style: TextStyle(
                            fontSize: fontSize14,
                            color: colorBorder2,
                            fontWeight: fontWeightSemiBold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: spacing5),
            padding: EdgeInsets.all(spacing15),
            width: double.infinity,
            height: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 30,
                  color: colorLightGrey.withOpacity(0.2),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _bookAppointment() async {
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    if (mounted) {
      setState(() {});
    }
    try {
      SharedPref().getToken().then((token) async {
        _loading(true);
        Uri uri = Uri.parse(
            ApiBaseHelper.base_url + "api/patient/appointment-booking");
        http.MultipartRequest request = http.MultipartRequest('POST', uri);
        request.headers['authorization'] = token;

        token.toString().debugLog();

        String doctorId = '';

        if (_profileMap["userId"] != null && _profileMap["userId"] is Map) {
          doctorId = _profileMap["userId"]["_id"].toString();
        } else if (_profileMap["User"] != null is Map) {
          doctorId = _profileMap["User"][0]["_id"].toString();
        }

        _reviewAppointmentData["type"] =
            _container.getProjectsResponse()["serviceType"]?.toString() ?? "1";
        _reviewAppointmentData["date"] =
            DateFormat("MM/dd/yyyy").format(_bookedDate).toString();
        _reviewAppointmentData["fromTime"] = _bookedTime;
        _reviewAppointmentData["timeZonePlace"] = _timezone;
        _reviewAppointmentData["doctor"] = doctorId;

        request.fields.addAll(_reviewAppointmentData);

        if (_reviewAppointmentData["type"] == '3') {
          if (Provider.of<HealthConditionProvider>(context, listen: false)
                  .addressDetails !=
              null) {
            request.fields['userAddressId'] =
                Provider.of<HealthConditionProvider>(context, listen: false)
                    .addressDetails
                    .sId;
          } else {
            request.fields['userAddressId'] =
                _consentToTreatMap["userAddress"]["_id"].toString();
          }
          if (_consentToTreatMap["parkingMap"]["parkingType"] == null) {
            request.fields['parkingType'] = "";
            request.fields['parkingFee'] = "";
            request.fields['parkingBay'] = "";
          } else {
            request.fields['parkingType'] =
                _consentToTreatMap["parkingMap"]["parkingType"].toString();
            request.fields['parkingFee'] =
                _consentToTreatMap["parkingMap"]["parkingFee"].toString();
            request.fields['parkingBay'] =
                _consentToTreatMap["parkingMap"]["parkingBay"].toString();
          }

          if (_consentToTreatMap["parkingMap"]["instructions"].toString() !=
              null) {
            request.fields['instructions'] =
                _consentToTreatMap["parkingMap"]["instructions"].toString();
          }
        }

        request.fields['consentToTreat'] = '1';
        //TODO : Temp code added for appointment book

        // request.fields['problemTimeSpan'] =
        //     _consentToTreatMap["problemTimeSpan"];
        // request.fields['isProblemImproving'] =
        //     _consentToTreatMap["isProblemImproving"];
        // request.fields['isTreatmentReceived'] =
        //     _consentToTreatMap["isTreatmentReceived"];
        // request.fields['description'] =
        //     _consentToTreatMap["description"].toString().trim();

        request.fields['problemTimeSpan'] = "2";
        request.fields['isProblemImproving'] = "1";
        request.fields['isTreatmentReceived'] = "0";
        request.fields['description'] = "Treatment";

        if (paymentType != null) {
          if (paymentType == "3") {
            request.fields['cashPayment'] = "3";
            request.fields['paymentMethod'] = "3";
          } else if (paymentType == "2") {
            request.fields['paymentMethod'] = "2";
            request.fields['insuranceId'] = insuranceId;
          } else {
            request.fields['paymentMethod'] = "1";
            request.fields['cardId'] =
                _consentToTreatMap["paymentMap"]["selectedCard"]['id'];
          }
        }

        // If hutano cash is selecetd from payment method
        if (_consentToTreatMap['hutanoCashApplied'] != null &&
            _consentToTreatMap['hutanoCashApplied'] != 0) {
          request.fields['isHutanoCashApplied'] = "1";
        }

        if (_consentToTreatMap["imagesList"] != null &&
            _consentToTreatMap["imagesList"].length > 0) {
          List<Map> imagesList = _consentToTreatMap["imagesList"];
          if (imagesList != null && imagesList.length > 0) {
            for (int i = 0; i < imagesList.length; i++) {
              request.fields["medicalImages[$i][images]"] =
                  imagesList[i]["images"];
              request.fields["medicalImages[$i][name]"] = imagesList[i]["name"];
            }
          }
        }

        if (_consentToTreatMap["docsList"] != null &&
            _consentToTreatMap["docsList"].length > 0) {
          List<Map> imagesList = _consentToTreatMap["docsList"];
          if (imagesList != null && imagesList.length > 0) {
            for (int i = 0; i < imagesList.length; i++) {
              request.fields["medicalDocuments[$i][type]"] =
                  imagesList[i]["type"];
              request.fields["medicalDocuments[$i][name]"] =
                  imagesList[i]["name"];
              request.fields["medicalDocuments[$i][medicalDocuments]"] =
                  imagesList[i]["medicalDocuments"];
              request.fields["medicalDocuments[$i][date]"] =
                  imagesList[i]["date"];
            }
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

        request.fields.toString().debugLog();

        var response = await request.send().futureError((e) {
          _loading(false);
          e.toString().debugLog();
        });

        if (response == null) {
          return;
        }
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
          if (responseJson["response"] is String) {
            _loading(false);
            Widgets.showErrorialog(
              context: context,
              description: responseJson["response"],
            );
            //  } else if (responseJson["response"]['paymentIntent'] != null) {
            //   String _clientSecret =
            //       responseJson["response"]['paymentIntent']['client_secret'];

            //   PaymentIntent _paymentIntent = PaymentIntent(
            //     paymentMethodId: _consentToTreatMap["paymentMap"]["selectedCard"]
            //         ['id'],
            //     clientSecret: _clientSecret,
            //   );

            //   StripePayment.confirmPaymentIntent(
            //     _paymentIntent,
            //   ).then((PaymentIntentResult value) {
            //     _loading(false);
            //     showConfirmDialog();
            //   }).futureError((error) {
            //     _loading(false);

            //     Widgets.showErrorialog(
            //       context: context,
            //       description: error.toString(),
            //     );
            //   });
          } else {
            _loading(false);

            responseJson["response"].toString().debugLog();

            showConfirmDialog();
          }
          _loading(false);
        }
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
                  _container.projectsResponse["serviceType"].toString() == '1'
                      ? "Office Request Sent!"
                      : _container.projectsResponse["serviceType"].toString() ==
                              '2'
                          ? "Video Request Sent!"
                          : "Onsite Request Sent!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.90),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Your request has been sent. You will be notified when the "
                  "provider accepts your appointment request.",
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

      dynamic _state;

      if (business["state"] is Map && business["state"].length > 0) {
        _state = business["state"];
      } else if (_profileMap['State'] != null &&
          _profileMap["State"].length > 0) {
        _state = _profileMap['State'][0];
      }

      if (_container.projectsResponse["serviceType"].toString() == '3') {
        if (Provider.of<HealthConditionProvider>(context, listen: false)
                .addressDetails !=
            null) {
          address = Extensions.addressFormat(
            Provider.of<HealthConditionProvider>(context, listen: false)
                .addressDetails
                .address,
            Provider.of<HealthConditionProvider>(context, listen: false)
                .addressDetails
                .street,
            Provider.of<HealthConditionProvider>(context, listen: false)
                .addressDetails
                .city,
            Provider.of<HealthConditionProvider>(context, listen: false)
                .addressDetails
                .state,
            Provider.of<HealthConditionProvider>(context, listen: false)
                .addressDetails
                .zipCode,
          );
        } else {
          address = Extensions.addressFormat(
            _consentToTreatMap["userAddress"]["address"]?.toString(),
            _consentToTreatMap["userAddress"]["street"]?.toString(),
            _consentToTreatMap["userAddress"]["city"]?.toString(),
            _consentToTreatMap["userAddress"]['state'],
            _consentToTreatMap["userAddress"]["zipCode"]?.toString(),
          );
        }
      } else if (_container.projectsResponse["serviceType"].toString() == '1') {
        address = Extensions.addressFormat(
          business["address"]?.toString(),
          business["street"]?.toString(),
          business["city"]?.toString(),
          _state,
          business["zipCode"]?.toString(),
        );
      } else {}
    }

    _widgetList.add(
      Padding(
        padding: const EdgeInsets.only(
          right: 20.0,
          left: 20.0,
        ),
        child: ProviderWidget(
          data: _profileMap,
          showPaymentProcced: true,
          appointmentTime:
              '${DateFormat('EEEE, dd MMMM').format(_bookedDate).toString()}',
          selectedAppointment:
              _container.projectsResponse['serviceType'].toString(),
          isOptionsShow: false,
          averageRating: averageRating,
        ),
      ),
    );
    _widgetList.add(Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 11.0),
      child: Text(
        "Appointment Type",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    ));
    _widgetList.add(appoCard(
      _container.projectsResponse["serviceType"].toString(),
    ));

    _widgetList.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          child: Text(
            "Payment Method",
            style: TextStyle(
                color: colorBlack.withOpacity(0.9),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 13.0),
          ),
        ),
        _buildCardWidget(),
      ],
    ));
    _container.projectsResponse["serviceType"].toString() == '2'
        ? _widgetList.add(recordingInfoWidget())
        : _widgetList.add(Container());

    _widgetList.add(paymentType == "3" ? duePaymentWidget() : Container());

    _widgetList.add(Container(
      height: 55.0,
      width: double.infinity,
    ));

    return _widgetList;
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    c.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  void getDistanceAndTime(LatLng initialPosition, LatLng desPosition) {
    ApiBaseHelper _apiHelper = ApiBaseHelper();
    _apiHelper
        .getDistanceAndTime(initialPosition, desPosition, Strings.kGoogleApiKey)
        .then((value) {
      _totalDistance =
          value["rows"][0]["elements"][0]["distance"]["text"].toString();
      _totalDuration =
          value["rows"][0]["elements"][0]["duration"]["text"].toString();
      ("DISTANCE AND TIME: " + value["rows"][0]["elements"][0].toString())
          .toString()
          .debugLog();
      setState(() {});
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

  Widget recordingInfoWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      padding: const EdgeInsets.all(15),
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
            "Video appointments are recorded and securely stored for you and your provider's to review on demand.",
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
                            Navigator.of(context)
                                .pushNamed(
                              Routes.selectAppointmentTimeScreen,
                              arguments: true,
                            )
                                .then((value) {
                              if (value != null) {
                                Map _editDateTimeData = value;

                                setState(() {
                                  _setBookingTime(_editDateTimeData["time"]);
                                  _bookedDate = _editDateTimeData["date"];
                                });
                              }
                            });
                          },
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: 12.0),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14.0,
              ),
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: icon.imageIcon(),
                  ),
                ),
                TextSpan(text: subtitle),
              ],
            ),
          ),
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
            "Checkout",
            style: TextStyle(
                color: colorBlack.withOpacity(0.93),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
          ),
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(color: const Color(0x1f8b8b8b), width: 0.5),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x148b8b8b),
                    offset: Offset(0, 2),
                    blurRadius: 30,
                    spreadRadius: 0)
              ],
              color: colorWhite,
            ),
            child: Column(
              children: [
                Container(
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
                            return consultationSlotWidget("Consultation Fee",
                                ('\$ ${consultance["fee"]?.toStringAsFixed(2)}'));
                          }),
                ),
                SizedBox(
                  height: 13,
                ),
                if (_consentToTreatMap != null &&
                    _consentToTreatMap["parkingMap"] != null &&
                    _consentToTreatMap["parkingMap"]["parkingFee"] != null)
                  Container(
                      child: serviceSlotWidget(Services(
                          amount: _consentToTreatMap["parkingMap"]
                              ["parkingFee"],
                          duration: 60,
                          subServiceName: "Parking Fee"))),
                Divider(
                  height: 30,
                ),
                (_servicesList != null && _servicesList.length > 0)
                    ? consultationSlotWidget(
                        "Total", '\$ ${_totalAmount.toStringAsFixed(2)}',
                        isBold: true)
                    : consultationSlotWidget(
                        "Total", '\$ ${_totalAmount.toStringAsFixed(2)}',
                        isBold: true)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceSlotWidget(Services services) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(
              services.subServiceName ?? "---",
              style: TextStyle(
                color: colorBlack2.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 14.0,
              ),
            ),
          ),
          Text(
            '\$${(services.amount.toStringAsFixed(2) ?? '0.00')}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
              color: colorBlack2.withOpacity(0.85),
            ),
          )
        ],
      ),
    );
  }

  Widget consultationSlotWidget(title, subTitle, {isBold: false}) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(
              title ?? "Consultation Fee",
              style: TextStyle(
                color: colorBlack2.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: isBold ? 16 : 14.0,
              ),
            ),
          ),
          Text(
            subTitle ?? '\$0.00}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 14.0,
              color: colorBlack2.withOpacity(0.85),
            ),
          )
        ],
      ),
    );
  }

  void _loading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  Widget appoCard(String cardText) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          border: Border.all(
              color: colorShadowCheckbox.withOpacity(0.5), width: 0.5),
          boxShadow: [
            BoxShadow(
                color: const Color(0x148b8b8b),
                offset: Offset(0, 2),
                blurRadius: 30,
                spreadRadius: 0)
          ],
          color: colorWhite),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardText == '1'
                      ? "Office Appointment"
                      : cardText == '2'
                          ? "Virtual Care"
                          : "Onsite Appointment",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: colorBlack2,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  '\$${_totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: colorGolden,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
              ],
            ),
          ),
          Image(
            image: AssetImage(
              cardText == '1'
                  ? "images/office_appointment.png"
                  : cardText == '2'
                      ? "images/video_chat_appointment.png"
                      : "images/onsite_appointment.png",
            ),
            height: 52.0,
            width: 52.0,
          ),
        ],
      ),
    );
  }

  _confirmAndPay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text("Confirm and Pay",
              style: const TextStyle(
                  color: const Color(0xff040238),
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0),
              textAlign: TextAlign.left),
        ),
        servicesWidget(),
        // paymentWidget(paymentType, insuranceName, insuranceImage),
        _buildCardWidget(),
        if (_consentToTreatMap['hutanoCashApplied'] != null &&
            _consentToTreatMap['hutanoCashApplied'] == 1)
          _buildHutanoCashWidget(),
        _buildRefCodeField(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: FancyButton(
            title: "Pay \$${_totalAmount.toStringAsFixed(2)}",
            onPressed: () {
              // showPaymentConfirmDialog();
              Navigator.of(context)
                  .pushNamed(Routes.reviewAppointmentScreenDetail);
            },
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  final _refCodeController = TextEditingController();
  Widget _buildRefCodeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Discount",
              style: TextStyle(
                  color: colorBlack.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left),
          SizedBox(
            height: 14,
          ),
          Container(
              child: HutanoTextField(
                  focusedBorderColor: colorBlack20,
                  labelTextStyle:
                      TextStyle(fontSize: fontSize14, color: colorGrey60),
                  onValueChanged: (value) {},
                  controller: _refCodeController,
                  labelText: Localization.of(context).refCode,
                  textInputAction: TextInputAction.done)),
        ],
      ),
    );
  }

  showPaymentConfirmDialog() {
    var yyDialog = YYDialog();
    yyDialog.build(context)
      ..width = (MediaQuery.of(context).size.width - 35)
      ..backgroundColor = Colors.transparent
      ..barrierDismissible = false
      ..widget(
        Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgetList(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  height: 55,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 55.0,
                    width: double.infinity,
                    padding: const EdgeInsets.only(right: 14, left: 20.0),
                    child: FancyButton(
                      title: "OK",
                      onPressed: () {
                        _bookAppointment();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            )),
      )
      ..show();
  }
}
