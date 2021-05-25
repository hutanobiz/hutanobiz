import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';

class ProviderWidget extends StatelessWidget {
  ProviderWidget(
      {Key key,
      @required this.data,
      this.selectedAppointment,
      this.bookAppointment,
      this.isOptionsShow = true,
      this.averageRating,
      this.isProverPicShow = false,
      this.margin,
      this.onRatingClick,
      this.onLocationClick,
      this.totalDistance})
      : assert(data != null),
        super(key: key);

  final data;
  final String averageRating, selectedAppointment;
  final Function bookAppointment;
  final bool isOptionsShow, isProverPicShow;
  final EdgeInsets margin;
  final Function onRatingClick, onLocationClick;
  final String totalDistance;

  @override
  Widget build(BuildContext context) {
    String nameTitle = "Dr. ",
        name = "---",
        avatar,
        fee = "0.00",
        practicingSince = "---",
        professionalTitle = "---",
        distance = "0",
        address = '---';

    if (data['distance'] != null) {
      distance =
          ((double.parse(data['distance']?.toString() ?? 0) * 0.000621371)
                  .toStringAsFixed(0)) +
              ' mi';

      if (distance == '0 mi') {
        distance = ((data['distance'] is double)
                ? data['distance'].toStringAsFixed(0)
                : data['distance'].toString()) +
            ' m';
      }
    }

    if (selectedAppointment != null && selectedAppointment != '0') {
      switch (selectedAppointment) {
        case '1':
          if (data["officeConsultanceFee"] != null &&
              data["officeConsultanceFee"].length > 0) {
            fee = data["officeConsultanceFee"][0]['fee'].toStringAsFixed(2) ??
                '0.00';
          }
          break;
        case '2':
          if (data["vedioConsultanceFee"] != null &&
              data["vedioConsultanceFee"].length > 0) {
            fee = data["vedioConsultanceFee"][0]['fee'].toStringAsFixed(2) ??
                '0.00';
          }
          break;
        case '3':
          if (data["onsiteConsultanceFee"] != null &&
              data["onsiteConsultanceFee"].length > 0) {
            fee = data["onsiteConsultanceFee"][0]['fee'].toStringAsFixed(2) ??
                '0.00';
          }
          break;
        default:
      }
    } else {
      if (data["officeConsultanceFee"] != null &&
          data["officeConsultanceFee"].length > 0) {
        fee = data["officeConsultanceFee"][0]['fee'] == null
            ? '0.00'
            : data["officeConsultanceFee"][0]['fee'].toStringAsFixed(2) ??
                '0.00';
      }

      if (data["onsiteConsultanceFee"] != null &&
          data["onsiteConsultanceFee"].length > 0) {
        fee = data["onsiteConsultanceFee"][0]['fee'] == null
            ? '0.00'
            : min(
                double.parse(fee),
                double.parse(
                  data["onsiteConsultanceFee"][0]['fee'].toStringAsFixed(2),
                ),
              ).toStringAsFixed(2);
      }

      if (data["vedioConsultanceFee"] != null &&
          data["vedioConsultanceFee"].length > 0) {
        fee = data["vedioConsultanceFee"][0]['fee'] == null
            ? '0.00'
            : min(
                double.parse(fee),
                double.parse(
                  data["vedioConsultanceFee"][0]['fee'].toStringAsFixed(2),
                ),
              ).toStringAsFixed(2);
      }
    }

    if (data['userId'] is Map) {
      if (data["userId"] != null) {
        nameTitle = data["userId"]["title"]?.toString() ?? 'Dr. ';
        name = nameTitle + data["userId"]["fullName"]?.toString() ?? "---";
        avatar = data["userId"]["avatar"]?.toString();
      }
    } else if (data["User"] != null && data["User"].length > 0) {
      nameTitle = (data["User"][0]["title"]?.toString() ?? 'Dr. ');
      name = '$nameTitle ' + (data["User"][0]["fullName"]?.toString() ?? "---");
      avatar = data["User"][0]["avatar"]?.toString();
    }

    practicingSince = data["practicingSince"] != null
        ? ((DateTime.now()
                    .difference(DateTime.parse(data["practicingSince"]))
                    .inDays /
                366))
            .toStringAsFixed(1)
        : "---";

    if (data['professionalTitle'] is Map) {
      if (data['professionalTitle'] != null) {
        professionalTitle =
            data['professionalTitle']['title']?.toString() ?? "----";
        name += Extensions.getSortProfessionTitle(professionalTitle);
      }
    } else if (data['ProfessionalTitle'] != null &&
        data["ProfessionalTitle"].length > 0) {
      professionalTitle =
          data['ProfessionalTitle'][0]['title']?.toString() ?? "----";
      name += Extensions.getSortProfessionTitle(professionalTitle);
    }

    if (data["businessLocation"] != null) {
      dynamic business = data["businessLocation"];

      dynamic _state;

      if (business["state"] is Map && business["state"].length > 0) {
        _state = business["state"];
      } else if (data['State'] != null && data["State"].length > 0) {
        _state = data['State'][0];
      }

      address = Extensions.addressFormat(
        business["address"]?.toString(),
        business["street"]?.toString(),
        business["city"]?.toString(),
        _state,
        business["zipCode"]?.toString(),
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 22.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(14.0),
        ),
        border: Border.all(color: Colors.grey[300]),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 18, left: 12, right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    splashColor: Colors.grey[200],
                    onTap: isProverPicShow
                        ? () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(context).pushNamed(
                              Routes.providerImageScreen,
                              arguments: (ApiBaseHelper.imageUrl + avatar),
                            );
                          }
                        : null,
                    child: Container(
                      width: 58.0,
                      height: 58.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: avatar == null
                              ? AssetImage('images/profile_user.png')
                              : NetworkImage(ApiBaseHelper.imageUrl + avatar),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(Radius.circular(50.0)),
                        border: new Border.all(
                          color: Colors.grey[300],
                          width: 1.0,
                        ),
                      ),
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
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            bottom: 5.0,
                            right: 5.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage(
                                  "images/ic_experience.png",
                                ),
                                height: 14.0,
                                width: 11.0,
                              ),
                              SizedBox(width: 3.0),
                              Expanded(
                                child: Text(
                                  practicingSince + " yrs experience",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                "ic_rating_golden"
                                    .imageIcon(width: 12, height: 12),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  averageRating ?? "0",
                                  style: TextStyle(
                                    decoration: onRatingClick != null
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ).onClick(
                              onTap:
                                  onRatingClick != null ? onRatingClick : null,
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                '\u2022 ' + professionalTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            bottom: 5.0,
                            right: 5.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              data['isOfficeEnabled']
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: 'ic_provider_office'.imageIcon(
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : Container(),
                              data['isVideoChatEnabled']
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: 'ic_provider_video'.imageIcon(
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : Container(),
                              data['isOnsiteEnabled']
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: 'ic_provider_onsite'.imageIcon(
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "\$$fee",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selectedAppointment != null && selectedAppointment != '0'
                        ? Container()
                        : SizedBox(height: 5),
                    selectedAppointment != null && selectedAppointment != '0'
                        ? Container()
                        : Text(
                            "Starting from",
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                    SizedBox(
                      height: selectedAppointment != null &&
                              selectedAppointment != '0'
                          ? 40
                          : 25,
                    ),
                    isOptionsShow
                        ? 'ic_forward'.imageIcon(
                            width: 9,
                            height: 15,
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding: isOptionsShow
                ? const EdgeInsets.only(left: 12.0, right: 12.0)
                : const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
            child: Row(
              children: <Widget>[
                'ic_location_grey'.imageIcon(height: 14.0, width: 11.0),
                SizedBox(width: 3.0),
                Expanded(
                  child: Text(
                    address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      decoration: onLocationClick != null
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ).onClick(
                    onTap: onLocationClick != null ? onLocationClick : null,
                  ),
                ),
                SizedBox(width: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      "ic_app_distance".imageIcon(),
                      SizedBox(width: 5.0),
                      Text(
                        totalDistance ?? distance,
                        style: TextStyle(
                          color: AppColors.windsor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isOptionsShow
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 12.0),
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: AppColors.persian_indigo,
                    splashColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(13.0),
                        bottomLeft: Radius.circular(13.0),
                      ),
                      side: BorderSide(
                          width: 0.5, color: AppColors.persian_indigo),
                    ),
                    child: Text(
                      "Book Appointment",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: bookAppointment,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
