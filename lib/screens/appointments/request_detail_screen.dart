import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/loading_background.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({Key key, this.detailData}) : super(key: key);

  final Map detailData;

  @override
  _RequestDetailScreenState createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  List feeList = List();
  double totalFee = 0;
  String _appointmentStatus = "0";

  Map profileMap = {};

  Map _medicalHistoryMap = {};

  final Set<Marker> _markers = {};
  BitmapDescriptor sourceIcon;
  Completer<GoogleMapController> _controller = Completer();

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "images/ic_destination_marker.png");
  }

  @override
  void initState() {
    super.initState();

    setSourceAndDestinationIcons();

    if (widget.detailData != null) {
      profileMap = widget.detailData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackground(
          title: "Request Detail",
          isAddBack: false,
          addBackButton: true,
          color: Colors.white,
          rightButtonText: "Medical History",
          onRightButtonTap: () {
            _medicalHistoryMap['isBottomButtonsShow'] = false;
            _medicalHistoryMap['isFromAppointment'] = true;

            Navigator.of(context).pushNamed(
              Routes.updateMedicalHistory,
              arguments: _medicalHistoryMap,
            );
          },
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 75),
            child: profileWidget(profileMap),
          ),
        ),
      ),
    );
  }

  Widget profileWidget(Map _data) {
    int paymentType = 0;

    if (_data["insuranceId"] != null) {
      paymentType = 2;
    } else if (_data["cashPayment"] != null) {
      paymentType = 1;
    } else if (_data["cardPayment"] != null) {
      if (_data["cardPayment"]["cardId"] != null &&
          _data["cardPayment"]["cardNumber"] != null) {
        paymentType = 3;
      }
    } else {
      paymentType = 0;
    }

    String name = "---",
        averageRating = "---",
        professionalTitle = "---",
        fee = "0.00",
        parkingFee = "0.00",
        avatar,
        address = "---",
        officeVisitFee = "0.00",
        insuranceName = "---",
        insuranceImage;

    LatLng latLng = new LatLng(0, 0);

    _appointmentStatus = _data['status']?.toString() ?? '0';

    averageRating = _data["averageRating"]?.toStringAsFixed(2) ?? "0";

    if (_data['medicalHistory'] != null && _data['medicalHistory'].length > 0) {
      this._medicalHistoryMap['medicalHistory'] = _data['medicalHistory'];
    }
    if (_data['medicalImages'] != null && _data['medicalImages'].length > 0) {
      this._medicalHistoryMap['medicalImages'] = _data['medicalImages'];
    }
    if (_data['medicalDocuments'] != null &&
        _data['medicalDocuments'].length > 0) {
      this._medicalHistoryMap['medicalDocuments'] = _data['medicalDocuments'];
    }

    if (_data["services"] != null) {
      feeList = _data["services"];
    }

    if (_data["insuranceData"] != null) {
      insuranceName = _data["insuranceData"]["insuranceName"];
      insuranceImage = _data["insuranceData"]["insuranceDocumentFront"];
    }

    if (_data["DoctorProfessionalDetail"] != null) {
      dynamic detail = _data["DoctorProfessionalDetail"];
      if (detail["professionalTitle"] != null) {
        professionalTitle = detail["professionalTitle"]["title"] ?? "---";
      }

      if (detail["consultanceFee"] != null) {
        for (dynamic consultanceFee in detail["consultanceFee"]) {
          fee = consultanceFee["fee"]?.toStringAsFixed(2) ?? "0.00";
        }
      }

      if (_data["type"].toString() == '3') {
        if (_data['parking'] != null && _data['parking']['fee'] != null) {
          parkingFee = _data['parking']['fee'].toStringAsFixed(2);
        }

        address = Extensions.addressFormat(
          _data["userAddress"]["address"]?.toString(),
          _data["userAddress"]["street"]?.toString(),
          _data["userAddress"]["city"]?.toString(),
          _data["userAddress"]["state"] is Map
              ? _data["userAddress"]["state"]
              : _data["userAddress"]["stateCode"],
          _data["userAddress"]["zipCode"]?.toString(),
        );

        if (_data["userAddress"]["coordinates"] != null) {
          List location = _data["userAddress"]["coordinates"];

          if (location.length > 0) {
            latLng = LatLng(
              location[1],
              location[0],
            );
          }
        }
      } else {
        if (detail["businessLocation"] != null) {
          dynamic business = detail["businessLocation"];

          address = Extensions.addressFormat(
            business["address"]?.toString(),
            business["street"]?.toString(),
            business["city"]?.toString(),
            business["state"],
            business["zipCode"]?.toString(),
          );

          if (detail["businessLocation"]["coordinates"] != null) {
            List location = detail["businessLocation"]["coordinates"];

            if (location.length > 0) {
              latLng = LatLng(
                location[1],
                location[0],
              );
            }
          }
        }
      }
    }

    if (_data["doctor"] != null) {
      name = _data["doctor"]["fullName"]?.toString() ?? "---";
      avatar = _data["doctor"]["avatar"];
    }

    if (_data["parking"] != null) {
      officeVisitFee = _data["parking"]["fee"]?.toStringAsFixed(2) ?? "0.00";
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
                    image: avatar == null
                        ? AssetImage('images/profile_user.png')
                        : NetworkImage(ApiBaseHelper.imageUrl + avatar),
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
                          "$averageRating \u2022 $professionalTitle",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
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
                      _appointmentStatus?.appointmentStatus(),
                      SizedBox(height: 5.0),
                      Text(
                        "\$${totalFee.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
          _data["type"],
        ),
        _data["type"] == 2?recordingInfoWidget():SizedBox(),
        divider(topPadding: 18.0),
        dateTimeWidget(
            _data['date'].toString().formatDate(
                  dateFormat: "${Strings.datePattern}, ",
                ),
            _data["fromTime"].toString(),
            _data["toTime"].toString()),
        _data["type"] == 2?SizedBox():
        divider(topPadding: 8.0),
        _data["type"] == 2?SizedBox():
        locationWidget(address, latLng, _data['distance']),
        divider(),
        seekingCareWidget(_data),
        divider(),
        feeWidget(fee, officeVisitFee, parkingFee, _data["type"].toString()),
        divider(),
        paymentType == 0
            ? Container()
            : paymentWidget(paymentType, insuranceName, insuranceImage),
        paymentType == 0 ? Container() : divider(topPadding: 10.0),
      ],
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
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
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
        ],
      ),
    );
  }

  Widget locationWidget(String location, LatLng latLng, dynamic distance) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 0, 10.0),
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
                  Expanded(
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
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () => latLng.launchMaps(),
                        child: Text(
                          Extensions.getDistance(distance),
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
                margin: const EdgeInsets.only(top: 11.0, right: 20),
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

  Widget feeWidget(String generalFee, String officeVisitCharge,
      String parkingFee, String appType) {
    if (feeList.length > 0) {
      totalFee = feeList.fold(
          0, (sum, item) => sum + double.parse(item["amount"].toString()));
    } else {
      totalFee = (double.parse(generalFee) + double.parse(officeVisitCharge));
    }

    if (appType == '3') {
      totalFee += double.parse(officeVisitCharge);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Consultation Fee Breakdown",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 18.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: Colors.grey[100],
              ),
            ),
            child: Column(
              children: <Widget>[
                feeList.length > 0
                    ? ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: feeList.length,
                        itemBuilder: (context, index) {
                          return subServicesFeeWidget(feeList[index]);
                        })
                    : Column(
                        children: <Widget>[
                          subFeeWidget(
                              "General Medicine Consult", "\$$generalFee"),
                          officeVisitCharge == "0.00"
                              ? Container()
                              : subFeeWidget("Office Visit charge",
                                  "\$$officeVisitCharge"),
                        ],
                      ),
                appType != '3'
                    ? Container()
                    : subFeeWidget("Parking charge", "\$$parkingFee"),
                SizedBox(height: 16),
                Divider(),
                subFeeWidget("Total", "\$" + totalFee.toStringAsFixed(2)),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget seekingCareWidget(dynamic _data) {
    String timeSpan = "---";
    if (_data["problemTimeSpan"] != null) {
      timeSpan = _data["problemTimeSpan"].toString();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Description of problem",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 18.0),
          Text(
            _data['description']?.toString() ?? '---',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: Colors.grey[200])),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Problem duration: ",
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      timeSpan == "1"
                          ? "Hours"
                          : timeSpan == "2"
                              ? "Days"
                              : timeSpan == "3"
                                  ? "Weeks"
                                  : timeSpan == "4" ? "Months" : "---",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _data["isTreatmentReceived"]
                            ? "Treatment for this complaint is taken in the past 3 months."
                            : "No treatment for this complaint in the past 3 months.",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _data["isProblemImproving"]
                          ? "The problem is NOT improving."
                          : "The problem is NOT improving.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget subServicesFeeWidget(Map feeMap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: <Widget>[
          Text(
            feeMap["subServiceId"]?.toString() ?? "---",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.80),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "\$" + feeMap["amount"]?.toStringAsFixed(2) ?? "0.00",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.80),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget subFeeWidget(String title, String fee) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: title.toLowerCase().contains("total")
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: Colors.black.withOpacity(0.80),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                fee,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.80),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentWidget(
      int paymentType, String insuranceName, String insuranceImage) {
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
              paymentType == 1
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
                  paymentType == 1 ? "Cash" : insuranceName,
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
   Widget recordingInfoWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
            "As per regulatory requirements, all audio & video calls done during an online consultation with the doctor, will be recorded & stored in a secure manner.",
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
}
