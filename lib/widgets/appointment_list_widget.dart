import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/appointment_status_widget.dart';
import 'package:hutano/widgets/appointment_type_chip_widget.dart';
import 'package:intl/intl.dart';
import 'package:hutano/utils/extensions.dart';

class AppointmentListWidget extends StatelessWidget {
  const AppointmentListWidget({
    Key key,
    @required this.context,
    @required this.response,
    @required this.avatar,
    @required this.name,
    @required this.averageRating,
    @required this.professionalTitle,
    @required this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final Map response;
  final String avatar;
  final String name;
  final String averageRating;
  final String professionalTitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: Colors.grey[300]),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.0),
          splashColor: Colors.grey[200],
          onTap: () {
            onTap();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: avatar == null
                              ? AssetImage('images/profile_user.png')
                              : NetworkImage(ApiBaseHelper.imageUrl + avatar),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              children: [
                                Image(
                                  image: AssetImage(
                                      "images/ic_appointment_time.png"),
                                  height: 16.0,
                                  width: 16.0,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    DateFormat('EEE, dd/MM/yyyy, hh:mm a')
                                        .format(DateTime.utc(
                                                DateTime.parse(response['date'])
                                                    .year,
                                                DateTime.parse(response['date'])
                                                    .month,
                                                DateTime.parse(response['date'])
                                                    .day,
                                                int.parse(response['fromTime']
                                                    .split(':')[0]),
                                                int.parse(response['fromTime']
                                                    .split(':')[1]))
                                            .toLocal())
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                AppointmentStatusWidget(
                                    status: response["status"])
                              ],
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                averageRating == ""
                                    ? Container()
                                    : Icon(
                                        Icons.star,
                                        color: AppColors.goldenTainoi,
                                        size: 16,
                                      ),
                                averageRating == ""
                                    ? Container()
                                    : Text(
                                        averageRating,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              professionalTitle,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(children: [
                              AppointmentTypeChipWidget(
                                  appointmentType: response["type"]),
                              Spacer(),
                              'ic_forward'.imageIcon(
                                width: 8,
                                height: 14,
                              ),
                            ]),
                            SizedBox(
                              height: 12.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
