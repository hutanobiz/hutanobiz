import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  AppointmentsScreen({Key key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  ApiBaseHelper _api = ApiBaseHelper();

  List<dynamic> _pastList = List();
  List<dynamic> _upcomingList = List();

  Future<dynamic> _requestsFuture;
  InheritedContainerState _container;

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) {
      setState(() {
        _requestsFuture = _api.userAppointments(token);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Appointments",
        isAddBack: false,
        color: Colors.white,
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return FutureBuilder<dynamic>(
      future: _requestsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _upcomingList.clear();
          _pastList.clear();

          DateTime now = DateTime.now();

          if (snapshot.data is String) {
            return Center(
              child: Text(snapshot.data),
            );
          } else {
            List<dynamic> _scheduleList = snapshot.data["data"];

            for (dynamic schedule in _scheduleList) {
              if (now.isBefore(DateTime.parse(schedule["date"]))) {
                _upcomingList.add(schedule);
              } else {
                _pastList.add(schedule);
              }
            }

            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    heading("Upcoming", _upcomingList, 1),
                    _upcomingList.isNotEmpty
                        ? _listWidget(_upcomingList, 1)
                        : Container(),
                    heading("Past", _pastList, 2),
                    _pastList.isNotEmpty
                        ? _listWidget(_pastList, 2)
                        : Container(),
                  ]),
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget heading(String heading, List<dynamic> list, int type) {
    return list.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                heading,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 8.0),
              Divider(),
              SizedBox(height: 24.0),
            ],
          )
        : Container();
  }

  Widget _listWidget(List<dynamic> _list, int listType) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      reverse: true,
      shrinkWrap: true,
      itemCount: _list.length,
      itemBuilder: (context, index) {
        if (_list == null || _list.length == 0) return Container();

        return _requestList(_list[index], listType);
      },
    );
  }

  Widget _requestList(Map response, int listType) {
    String name = "---",
        avatar,
        address = "---",
        status = "---",
        userRating,
        averageRating = "---",
        appointmentType = "---",
        distance = "---",
        professionalTitle = "---";

    int paymentType = 0;

    if (response["insuranceId"] != null) {
      paymentType = 2;
    } else if (response["cashPayment"] != null) {
      paymentType = 1;
    } else if (response["cardPayment"] != null) {
      if (response["cardPayment"]["cardId"] != null &&
          response["cardPayment"]["cardNumber"] != null) {
        paymentType = 3;
      }
    } else {
      paymentType = 0;
    }

    if (response["type"] != null)
      switch (response["type"]) {
        case 1:
          appointmentType = "Office Appt.";
          break;
        case 2:
          appointmentType = "Video Chat Appt.";
          break;
        case 3:
          appointmentType = "Onsite Appt.";
          break;
        default:
      }

    status = response["status"]?.toString() ?? "---";
    averageRating = response["averageRating"]?.toStringAsFixed(2) ?? "0";

    if (response["reason"] != null && response["reason"].length > 0) {
      userRating = response["reason"][0]["rating"]?.toString();
    }

    if (response["doctor"] != null) {
      name = response["doctor"]["fullName"]?.toString() ?? "---";
      avatar = response["doctor"]["avatar"].toString();
    }

    if (response["doctorData"] != null) {
      for (dynamic detail in response["doctorData"]) {
        List providerInsuranceList = List();

        if (detail["insuranceId"] != null) {
          providerInsuranceList = detail["insuranceId"];
        }

        _container.setProviderInsuranceMap(providerInsuranceList);

        if (detail["professionalTitle"] != null) {
          professionalTitle =
              detail["professionalTitle"]["title"]?.toString() ?? "---";
        }

        if (detail["distance"] != null) {
          distance = detail["distance"]?.toString() ?? "0";
        }

        if (detail["businessLocation"] != null) {
          dynamic business = detail["businessLocation"];
          String state = "---";
          if (business["state"] != null) {
            state = business["state"]["title"]?.toString() ?? "---";
          }

          address = (business["address"]?.toString() ?? "---") +
              ", " +
              (business["city"]?.toString() ?? "---") +
              ", " +
              state +
              " - " +
              (business["zipCode"]?.toString() ?? "---");
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 22.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: Colors.grey[300]),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 14, right: 14.0),
            child: Stack(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 62.0,
                      height: 62.0,
                      margin: const EdgeInsets.only(top: 14.0),
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
                      padding: const EdgeInsets.only(top: 14.0, left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "$name",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: <Widget>[
                              Image.asset(
                                "images/ic_star_rating.png",
                                width: 12,
                                height: 12,
                                color: AppColors.goldenTainoi,
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
                          SizedBox(
                            height: 4.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: listType == 1 ? 25.0 : 20.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          appointmentType,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 13.0),
                      listType == 1
                          ? Container()
                          : Align(
                              alignment: Alignment.centerRight,
                              child: status?.appointmentStatus(),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Divider(
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      "ic_location_grey".imageIcon(width: 11.0),
                      SizedBox(width: 3.0),
                      Expanded(
                        child: Text(
                          "$address",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    "ic_app_distance".imageIcon(),
                    SizedBox(width: 5.0),
                    Text(
                      "$distance miles",
                      style: TextStyle(
                        color: AppColors.windsor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 14.0),
            child: Row(
              children: <Widget>[
                "ic_appointment_time".imageIcon(height: 12.0, width: 12.0),
                SizedBox(width: 3.0),
                Expanded(
                  child: Text(
                    (response['date'] != null
                            ? DateFormat('EEEE, dd MMMM, ')
                                .format(DateTime.parse(response['date']))
                                .toString()
                            : "---") +
                        (response["fromTime"] != null
                            ? response["fromTime"].toString().timeOfDay(context)
                            : "---") +
                        " - " +
                        (response["toTime"] != null
                            ? response["toTime"].toString().timeOfDay(context)
                            : "---"),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              listType == 1 && paymentType == 0
                  ? rightButton(listType, "Confirm Payment", () {
                      _container.setProviderData("providerData", response);
                      _container.setAppointmentId(response["_id"].toString());
                      _container.setProviderData("totalFee", null);
                      Navigator.of(context).pushNamed(
                        Routes.paymentMethodScreen,
                        arguments: true,
                      );
                    })
                  : listType == 2 && status == "4"
                      ? leftButton(userRating, "Treatment summary", () {
                          _container.setProviderData("providerData", response);
                          Navigator.of(context).pushNamed(
                              Routes.treatmentSummaryScreen,
                              arguments: response);
                        })
                      : Container(),
              listType == 2 && status == "4" && userRating == null
                  ? rightButton(listType, "Rate Now", () {
                      _container.setProviderData("providerData", response);
                      _container.setAppointmentId(response["_id"].toString());
                      Navigator.of(context).pushNamed(
                        Routes.rateDoctorScreen,
                        arguments: false,
                      );
                    })
                  : Container(),
            ],
          ),
        ],
      ).onClick(
        context: context,
        routeName: Routes.appointmentDetailScreen,
        onTap: () => _container.setAppointmentId(response["_id"].toString()),
      ),
    );
  }

  Widget leftButton(String userRating, String title, Function onPressed) {
    return Expanded(
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: userRating != null ? AppColors.windsor : Colors.white,
        splashColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight:
                userRating != null ? Radius.circular(12.0) : Radius.zero,
            bottomLeft: Radius.circular(12.0),
          ),
          side: BorderSide(width: 0.3, color: Colors.grey[300]),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: userRating != null ? Colors.white : AppColors.windsor,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget rightButton(int listType, String title, Function onPressed) {
    return Expanded(
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: AppColors.windsor,
        splashColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12.0),
            bottomLeft: listType == 1 ? Radius.circular(12.0) : Radius.zero,
          ),
          side: BorderSide(width: 0.3, color: Colors.grey[300]),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
