import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:intl/intl.dart';

class TrackingProviderWidget extends StatelessWidget {
  const TrackingProviderWidget({
    Key key,
    @required this.avatar,
    @required this.name,
    @required this.stringStatus,
    @required this.appointment,
  }) : super(key: key);

  final String avatar;
  final String name;
  final String stringStatus;
  final dynamic appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300])),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 14),
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: avatar == null
                        ? AssetImage('images/profile_user.png')
                        : NetworkImage(ApiBaseHelper.imageUrl + avatar),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(28.0)),
                  border: Border.all(
                    color: Colors.grey[300],
                    width: 1.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 14.0),
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[100]),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'images/trackingStatusTick.png',
                              height: 14,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              stringStatus,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.70),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 7.0),
                    ],
                  ),
                ),
              ),
              appointment['averageRating'] != null
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.windsor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.goldenTainoi,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            appointment['averageRating'].toStringAsFixed(1),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ))
                  : SizedBox()
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Divider(),
          ),
          Row(
            children: [
              Image.asset(
                appointment['data']['type'] == 1
                    ? 'images/ic_office_app.png'
                    : appointment['data']['type'] == 2
                        ? 'images/ic_video_app.png'
                        : 'images/ic_onsite_app.png',
                width: 20,
              ),
              SizedBox(width: 4),
              Text(appointment['data']['type'] == 1
                  ? 'Office Appointment'
                  : appointment['data']['type'] == 2
                      ? 'Telemedicine Appointment'
                      : 'Onsite Appointment'),
              Spacer(),
              Image.asset(
                'images/watch.png',
                height: 18,
              ),
              SizedBox(width: 4),
              Text(
                DateFormat('MMM dd, hh:mma')
                    .format(DateTime.utc(
                            DateTime.parse(appointment['data']['date']).year,
                            DateTime.parse(appointment['data']['date']).month,
                            DateTime.parse(appointment['data']['date']).day,
                            int.parse(
                                appointment['data']['fromTime'].split(':')[0]),
                            int.parse(
                                appointment['data']['fromTime'].split(':')[1]))
                        .toLocal())
                    .toString(),
              ),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }
}
