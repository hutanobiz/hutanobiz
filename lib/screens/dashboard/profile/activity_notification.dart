import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:intl/intl.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/loading_widgets.dart';

class ActivityNotifications extends StatefulWidget {
  @override
  _ActivityNotificationsState createState() => _ActivityNotificationsState();
}

class _ActivityNotificationsState extends State<ActivityNotifications> {
  List<dynamic> appointmentNotification = List();
  ApiBaseHelper api = new ApiBaseHelper();
  Future<Map> _requestsFuture;
  String userToken = "";
  void initState() {
    SharedPref().getToken().then((token) {
      userToken = token;
      setState(() {
        _requestsFuture = api.getAllNotifications(context, token);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.goldenTainoi,
        body: LoadingBackground(
            title: "Activity",
            isAddBack: true,
            color: AppColors.snow,
            child: _buildList()));
  }

  Widget _buildList() {
    return FutureBuilder<dynamic>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: new CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            if (snapshot.data == null) {
              return Center(child: Text('No Activity'));
            } else {
              appointmentNotification.clear();
              api.readNotifications(context, userToken);

              appointmentNotification.addAll(snapshot.data['response']);

              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      appointmentNotification.isNotEmpty
                          ? _listWidget(appointmentNotification, 'notification')
                          : Container(),
                    ]),
              );
            }
          } else {
            return Center(
              child: new CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _listWidget(List<dynamic> _list, String type) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _list.length,
      itemBuilder: (context, index) {
        return _requestList(_list[index]);
      },
    );
  }

  Widget _requestList(Map response) {
    String userImage = '';
    if (response["doctor"]["avatar"] != null) {
      userImage = ApiBaseHelper.image_base_url + response["doctor"]["avatar"];
    }

    String capitalize() {
      return response["message"];
    }

    return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.appointmentDetailScreen,
            arguments: response["appointmentId"],
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 22.0),
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62.0,
                height: 62.0,
                margin: const EdgeInsets.only(
                    top: 10.0, bottom: 10, left: 5, right: 5),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: userImage == ''
                        ? AssetImage('images/ic_profile.png')
                        : NetworkImage(userImage),
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
                  padding:
                      const EdgeInsets.only(top: 14.0, left: 5.0, right: 5),
                  child: Column(
                    //direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE MMM, dd yyyy, hh:mm a')
                            .format(dateTime(response)),
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        capitalize() ?? "---",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: appointmentType(response["appointmentType"]),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  appointmentType(dynamic appointmentType) {
    String appointmentTypeString;
    switch (appointmentType) {
      case 1:
        appointmentTypeString = "Office Appt.";
        break;
      case 2:
        appointmentTypeString = "Video Appt.";
        break;
      default:
        appointmentTypeString = "Onsite Appt.";
    }
    return Text(
      appointmentTypeString,
      style: TextStyle(
        fontSize: 12.0,
        color: Color(0xFF3D0086),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  dateTime(response) {
    DateTime date = DateTime.utc(
            DateTime.parse(response['createdAt']).year,
            DateTime.parse(response['createdAt']).month,
            DateTime.parse(response['createdAt']).day,
            DateTime.parse(response['createdAt']).hour,
            DateTime.parse(response['createdAt']).minute)
        .toLocal();
    return date;
  }
}
