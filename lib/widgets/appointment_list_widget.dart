import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/widgets/appointment_status_widget.dart';
import 'package:hutano/widgets/appointment_type_chip_widget.dart';
import 'package:intl/intl.dart';
import 'package:hutano/utils/extensions.dart';

class AppointmentListWidget extends StatelessWidget {
  const AppointmentListWidget({
    Key? key,
    required this.context,
    required this.response,
    required this.avatar,
    required this.name,
    required this.averageRating,
    required this.professionalTitle,
    required this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final Map response;
  final String? avatar;
  final String? name;
  final String? averageRating;
  final String? professionalTitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 22.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: Colors.grey[300]!),
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
                              image: (avatar == null
                                  ? AssetImage('images/profile_user.png')
                                  : NetworkImage(
                                      ApiBaseHelper.imageUrl + avatar!)) as ImageProvider<Object>,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 0.0),
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
                                    Text(
                                      DateFormat(Strings.appointmentTimePattern)
                                              .format(dateTime(response)) +
                                          DateFormat('a')
                                              .format(dateTime(response))
                                              .toLowerCase(),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3.0,
                                ),
                                Text(
                                  name!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      professionalTitle!,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black.withOpacity(0.7),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Spacer(),
                                    'ic_forward'.imageIcon(
                                      width: 8,
                                      height: 14,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(children: [
                                  AppointmentTypeChipWidget(
                                      appointmentType: response["type"]),
                                  Spacer(),
                                  AppointmentStatusWidget(
                                      status: response["status"])
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
        ),
        Container(
          width: 75,
          height: 28,
          decoration: BoxDecoration(
              color: AppColors.windsor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topRight: Radius.circular(15))),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.goldenTainoi,
                  size: 12,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  " " + averageRating!,
                  // "4.5",
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  dateTime(response) {
    DateTime date = DateTime.utc(
            DateTime.parse(response['date']).year,
            DateTime.parse(response['date']).month,
            DateTime.parse(response['date']).day,
            int.parse(response['fromTime'].split(':')[0]),
            int.parse(response['fromTime'].split(':')[1]))
        .toLocal();
    return date;
  }
}
