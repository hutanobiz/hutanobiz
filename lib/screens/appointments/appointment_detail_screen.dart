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
  List feeList = List();
  double totalFee = 0;

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
                    onPressed: () => Navigator.of(context)
                        .pushNamed(Routes.treatmentSummaryScreen),
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
    _container.setAppointmentId(_providerData["_id"].toString());

    int paymentType = 0;

    if (_providerData["insuranceId"] != null) {
      paymentType = 2;
    } else if (_providerData["cashPayment"] != null) {
      paymentType = 1;
    } else {
      paymentType = 0;
    }
    _container.setProviderData("providerData", _data);

    String name = "---",
        rating = "---",
        professionalTitle = "---",
        fee = "0.0",
        avatar,
        address = "---",
        inOfficeFee = "0.0", //TODO: in-office charge
        officeVisitFee = "0.0",
        insuranceName = "---",
        insuranceImage;

    LatLng latLng = new LatLng(0, 0);

    rating = _data["averageRating"] ?? "---";

    if (_data["subServices"] != null) {
      feeList = _data["subServices"];
    }

    if (_data["insuranceData"] != null) {
      insuranceName = _data["insuranceData"]["insuranceName"];
      insuranceImage = _data["insuranceData"]["insuranceDocumentFront"];
    }

    if (_data["doctorData"] != null) {
      for (dynamic detail in _data["doctorData"]) {
        if (detail["averageRating"] != null) if (detail["professionalTitle"] !=
            null) {
          professionalTitle = detail["professionalTitle"]["title"] ?? "---";
        }

        List providerInsuranceList = List();

        if (detail["insuranceId"] != null) {
          providerInsuranceList = detail["insuranceId"];
        }

        _container.setProviderInsuranceMap(providerInsuranceList);

        if (detail["consultanceFee"] != null) {
          for (dynamic consultanceFee in detail["consultanceFee"]) {
            fee = consultanceFee["fee"].toString() ?? "---";
          }
        }

        if (detail["businessLocation"] != null) {
          address = detail["businessLocation"]["address"] ?? "---";

          if (detail["businessLocation"]["coordinates"] != null) {
            List location = detail["businessLocation"]["coordinates"];

            if (location.length > 0) {
              latLng = LatLng(
                location[0],
                location[1],
              );
            }
          }
        }
      }
    }

    if (_providerData["doctor"] != null) {
      name = _providerData["doctor"]["fullName"] ?? "---";
      avatar = _providerData["doctor"]["avatar"];
    }

    if (_providerData["parking"] != null) {
      officeVisitFee = _providerData["parking"]["fee"] ?? "0.0";
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
                    RawMaterialButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          _providerData["consentToTreat"] == false
                              ? Routes.consentToTreatScreen
                              : Routes.paymentMethodScreen,
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(
                              _providerData["consentToTreat"] == false
                                  ? "View consent to treat"
                                  : "Confirm payment",
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
                      _providerData["status"].toString()?.appointmentStatus(),
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
        feeWidget(fee, officeVisitFee, inOfficeFee),
        divider(),
        paymentType == 0
            ? SizedBox(height: 1)
            : paymentWidget(
                "cardNumber", paymentType, insuranceName, insuranceImage),
        paymentType == 0 ? Container() : divider(topPadding: 10.0),
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

  Widget feeWidget(
      String generalFee, String officeVisitCharge, String inOfficeCharge) {
    if (feeList.length > 0) {
      totalFee = feeList.fold(
          0,
          (sum, item) =>
              sum + double.parse(item["subService"]["amount"].toString()));
    } else {
      totalFee = (double.parse(generalFee) +
          double.parse(inOfficeCharge) +
          double.parse(officeVisitCharge));
    }

    _container.setProviderData("totalFee", totalFee.toString());

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
                          inOfficeCharge == "0.0"
                              ? Container()
                              : subFeeWidget(
                                  "In-office Charge", "\$$inOfficeCharge"),
                          officeVisitCharge == "0.0"
                              ? Container()
                              : subFeeWidget("Office Visit charge",
                                  "\$$officeVisitCharge"),
                        ],
                      ),
                SizedBox(height: 16),
                Divider(),
                subFeeWidget("Total", "\$" + totalFee.toString()),
                SizedBox(height: 16),
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
            feeMap["subServiceName"]?.toString() ?? "---",
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
                "\$" + feeMap["subService"]["amount"]?.toString() ?? "---",
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

  Widget paymentWidget(String cardNumber, int paymentType, String insuranceName,
      String insuranceImage) {
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
              // FlatButton(
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return AlertDialog(
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(14.0),
              //             ),
              //             content: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               mainAxisSize: MainAxisSize.min,
              //               children: <Widget>[
              //                 Row(
              //                   children: <Widget>[
              //                     Expanded(
              //                       child: Text(
              //                         'Insurance Info',
              //                         style: TextStyle(
              //                           color: Colors.black,
              //                           fontSize: 18.0,
              //                           fontWeight: FontWeight.bold,
              //                         ),
              //                       ),
              //                     ),
              //                     InkWell(
              //                       onTap: () => Navigator.of(context).pop(),
              //                       child: Container(
              //                           decoration: BoxDecoration(
              //                               borderRadius: BorderRadius.all(
              //                                   Radius.circular(16.0)),
              //                               color: AppColors.goldenTainoi),
              //                           child: Icon(Icons.close,
              //                               color: Colors.white)),
              //                     ),
              //                   ],
              //                 ),
              //                 SizedBox(height: 16.0),
              //                 Text('Front'),
              //                 SizedBox(height: 4.0),
              //                 Image.asset("images/driving_license.png"),
              //                 SizedBox(height: 16.0),
              //                 Text('Back'),
              //                 SizedBox(height: 4.0),
              //                 Image.asset("images/driving_license.png")
              //               ],
              //             ),
              //           );
              //         },
              //       );
              //     },
              //     child: Icon(Icons.info_outline))
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
