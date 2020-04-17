import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';

class RequestAppointmentsScreen extends StatefulWidget {
  const RequestAppointmentsScreen({Key key}) : super(key: key);

  @override
  _RequestAppointmentsScreenState createState() =>
      _RequestAppointmentsScreenState();
}

class _RequestAppointmentsScreenState extends State<RequestAppointmentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiBaseHelper _api = ApiBaseHelper();

  List<dynamic> _pastList = List();
  List<dynamic> _presentList = List();

  Future<dynamic> _requestsFuture;

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) {
      setState(() {
        token.toString().debugLog();
        _requestsFuture = _api.appointmentRequests(token);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Requests",
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
              _presentList = snapshot.data["presentRequest"];
              _pastList = snapshot.data["pastRequest"];

              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      heading("Pending", _presentList, 1),
                      _presentList.isNotEmpty
                          ? _listWidget(_presentList, 1)
                          : Container(),
                      heading("Past", _pastList, 2),
                      _pastList.isNotEmpty
                          ? _listWidget(_pastList, 2)
                          : Container(),
                    ]),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
        }
        return null;
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
      shrinkWrap: true,
      itemCount: _list.length,
      itemBuilder: (context, index) {
        return _requestList(_list[index], listType);
      },
    );
  }

  Widget _requestList(Map response, int listType) {
    String name = "---",
        address = "---",
        appointmentType = "---",
        degree = "---",
        status = "---",
        professionalTitle = "---";

    status = response["status"].toString();

    switch (response["type"]) {
      case 1:
        appointmentType = "Office Appt.";
        break;
      case 2:
        appointmentType = "Video Chat Appt.";
        break;
      case 1:
        appointmentType = "Onsite Appt.";
        break;
      default:
    }

    name = response["doctor"]["fullName"] ?? "--";
    address = response["doctor"]["address"] ?? "---";

    if (response["DoctorProfessionalDetail"] != null)
      for (dynamic detail in response["DoctorProfessionalDetail"]) {
        professionalTitle = detail["professionalTitle"]["title"];

        for (dynamic eduResponse in detail["education"]) {
          degree = eduResponse["degree"].toString();
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
          Container(
            padding: EdgeInsets.only(top: 18, left: 12, right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 58.0,
                  height: 58.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('http://i.imgur.com/QSev0hg.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: Colors.grey[300],
                      width: 1.0,
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
                          "$name, $degree",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        listType == 1
                            ? Text(
                                "---",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              )
                            : Row(
                                children: <Widget>[
                                  Icon(
                                    status == "1"
                                        ? Icons.check_circle_outline
                                        : Icons.error_outline,
                                    size: 12.0,
                                    color: status == "1"
                                        ? Colors.lightGreen
                                        : Colors.red,
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    status == "1" ? "Accepted" : "Rejected",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: status == "1"
                                          ? Colors.lightGreen
                                          : Colors.red,
                                    ),
                                  )
                                ],
                              ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Row(
                          children: <Widget>[
                            listType == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      "$professionalTitle \u2022",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Text(
                              "\$---",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.goldenTainoi,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    appointmentType,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage(
                          "images/ic_location_grey.png",
                        ),
                        height: 14.0,
                        width: 11.0,
                      ),
                      SizedBox(width: 3.0),
                      Expanded(
                        child: Text(
                          "$address",
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
                    Image(
                      image: AssetImage(
                        "images/ic_distance.png",
                      ),
                      height: 14.0,
                      width: 14.0,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      "0.0 miles",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          listType == 1
              ? InkWell(
                  onTap: () {
                    Widgets.showAlertDialog(
                      context,
                      "Cancel Appointment",
                      "Are you sure you want to cancel this appointment?",
                      () {
                        SharedPref().getToken().then((token) {
                          Map appointmentIdAmp = Map();

                          appointmentIdAmp["appointmentId"] =
                              response["_id"].toString();
                          // appointmentIdAmp["cancelledReason"] =
                          //     "Booked by mistake";
                          // appointmentIdAmp["cancellationFees"] = "20";
                          _api
                              .deleteRequestAppointment(token, appointmentIdAmp)
                              .then((deleteResponse) {
                            Widgets.showToast(
                                "Appointment cancelled successfully");

                            setState(() {
                              _requestsFuture = _api.appointmentRequests(token);
                            });
                          }).futureError(
                                  (onError) => onError.toString().debugLog());
                        });
                      },
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      color: AppColors.tundora.withOpacity(0.05),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(14.0),
                        bottomRight: Radius.circular(14.0),
                      ),
                    ),
                    child: Text(
                      "Cancel Request",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
