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

class _AppointmentsScreenState extends State<AppointmentsScreen>
// with TickerProviderStateMixin
{
  // List<Widget> tabList = List();
  // TabController _tabController;

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

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // _tabController = TabController(vsync: this, length: 3);
    // _tabController.addListener(() => setState(() {}));

    // tabList.clear();
    // tabList.add(
    //   customTab("Office", 0),
    // );
    // tabList.add(
    //   customTab("Video Chat", 1),
    // );
    // tabList.add(
    //   customTab("Onsite", 2),
    // );

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
      shrinkWrap: true,
      itemCount: _list.length,
      itemBuilder: (context, index) {
        return _requestList(_list[index], listType);
      },
    );
  }

  Widget _requestList(Map response, int listType) {
    String name = "---", address = "---", status = "---";

    status = response["status"].toString();
    name = response["doctor"]["fullName"].toString();

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
                                      Icons.star,
                                      color: AppColors.goldenTainoi,
                                      size: 12.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      "4.5 ---",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    //TODO: doctor rating, speciality
                                  ],
                                ),
                          SizedBox(
                            height: 4.0,
                          ),
                          // listType == 1 && response["consentToTreat"] == false
                          //     ? Container()
                          //     : Row(
                          //         children: <Widget>[
                          //           Padding(
                          //             padding: const EdgeInsets.only(right: 4.0),
                          //             child: Text(
                          //               "View consent to treat",
                          //               overflow: TextOverflow.ellipsis,
                          //               style: TextStyle(
                          //                 color: AppColors.windsor,
                          //                 fontSize: 12.0,
                          //                 fontWeight: FontWeight.w500,
                          //               ),
                          //             ),
                          //           ),
                          //           Icon(
                          //             Icons.arrow_forward_ios,
                          //             size: 10.0,
                          //             color: AppColors.windsor,
                          //           ),
                          //         ],
                          //       ),
                        ],
                      ),
                    ),
                  ],
                ),
                listType == 1
                    ? Container()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 84.0,
                          height: 40.0,
                          alignment: Alignment.center,
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
                          decoration: BoxDecoration(
                            color: status == "1"
                                ? Colors.lightGreen.withOpacity(0.12)
                                : Colors.red.withOpacity(0.12),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(7.0),
                              bottomLeft: Radius.circular(7.0),
                            ),
                          ),
                          child: Text(
                            status == "1" ? "Completed" : "Cancelled",
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: status == "1"
                                  ? Colors.lightGreen
                                  : Colors.red,
                            ),
                          ),
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
                      "0.0 miles",
                      style: TextStyle(
                        color: AppColors.windsor,
                      ),
                    ),
                    //TODO: doctor distance
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
                    DateFormat('EEEE, dd MMMM, hh:mm aa')
                        .format(DateTime.parse(response['date']))
                        .toString(),
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
              listType == 1 && response["consentToTreat"] == false
                  ? leftButton(listType, response, "Add consent", () {
                      _container.setAppointmentId(response["_id"].toString());
                      Navigator.of(context)
                          .pushNamed(Routes.consentToTreatScreen);
                    })
                  : listType == 2
                      ? leftButton(
                          listType, response, "Treatment summary", () {})
                      : Container(),
              // listType == 1
              //     ? rightButton(
              //         listType,
              //         response,
              //         "View Details",
              //         () {
              //           _container.setAppointmentId(response["_id"]);
              //           Navigator.of(context)
              //               .pushNamed(Routes.appointmentDetailScreen);
              //         },
              //       )
              //     :
              listType == 2 && status == "1"
                  ? rightButton(listType, response, "Rate Now", () {
                      _container.setAppointmentId(response["_id"].toString());
                      Navigator.of(context).pushNamed(Routes.rateDoctorScreen);
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

  // List<Widget> widgetList() {
  //   List<Widget> formWidget = new List();

  // formWidget.add(
  //   TabBar(
  //     controller: _tabController,
  //     indicatorColor: Colors.transparent,
  //     tabs: tabList,
  //   ),
  // );

  // formWidget.add(
  //   Expanded(
  //     child: TabBarView(
  //       controller: _tabController,
  //       children: <Widget>[
  //         DashboardScreen(),
  //         DashboardScreen(),
  //         DashboardScreen(),
  //       ],
  //     ),
  //   ),
  // );

  //   return formWidget;
  // }

  // Widget customTab(String title, int index) {
  //   return Container(
  //     width: 101.0,
  //     height: 60.0,
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //       color: _tabController.index == index
  //           ? AppColors.goldenTainoi
  //           : Colors.white,
  //       shape: BoxShape.rectangle,
  //       borderRadius: BorderRadius.circular(14.0),
  //     ),
  //     child: Text(
  //       title,
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontSize: 13.0,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   );
  // }

  Widget leftButton(
      int listType, Map response, String title, Function onPressed) {
    return Expanded(
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: AppColors.tundora.withOpacity(0.05),
        splashColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12.0),
          ),
          side: BorderSide(width: 0.3, color: Colors.grey[300]),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget rightButton(
      int listType, Map response, String title, Function onPressed) {
    return Expanded(
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: AppColors.goldenTainoi.withOpacity(0.1),
        splashColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12.0),
          ),
          side: BorderSide(width: 0.3, color: Colors.grey[300]),
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.goldenTainoi),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
