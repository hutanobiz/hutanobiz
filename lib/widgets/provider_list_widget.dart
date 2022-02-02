import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/app_constants.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/constants/key_constant.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/text_with_image.dart';

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
      this.showPaymentProcced = false,
      this.appointmentTime,
      this.servicesPrize,
      this.isService = false,
      this.searchedSubService})
      : assert(data != null),
        super(key: key);

  final data;
  final String averageRating, selectedAppointment;
  final Function bookAppointment;
  final bool isOptionsShow, isProverPicShow, isService;
  final EdgeInsets margin;
  final Function onRatingClick, onLocationClick;
  List<Services> searchedSubService;
  // Show extra details in confirm and pay screen
  final bool showPaymentProcced;
  final String appointmentTime;
  final String servicesPrize;

  @override
  Widget build(BuildContext context) {
    String nameTitle = "Dr. ",
        name = "---",
        avatar,
        fee = "0.00",
        officeConsultationFee = "0.00",
        telemedicineConsultationFee = "0.00",
        onsiteConsultationFee = "0.00",
        practicingSince = "---",
        professionalTitle = "---",
        distance = "0",
        address;
    bool isOnline = false;

    isOnline = data['ondemandavailabledoctor'] != null
        ? data['ondemandavailabledoctor']['isOnline']
        : false;

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
        officeConsultationFee =
            data["officeConsultanceFee"][0]['fee'].toStringAsFixed(2) ?? '0.00';
      }
      if (data["vedioConsultanceFee"] != null &&
          data["vedioConsultanceFee"].length > 0) {
        telemedicineConsultationFee =
            data["vedioConsultanceFee"][0]['fee'].toStringAsFixed(2) ?? '0.00';
      }
      if (data["onsiteConsultanceFee"] != null &&
          data["onsiteConsultanceFee"].length > 0) {
        onsiteConsultationFee =
            data["onsiteConsultanceFee"][0]['fee'].toStringAsFixed(2) ?? '0.00';
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

    if (data["education"] != null && data["education"].isNotEmpty) {
      name += ', ' + data["education"][0]["degree"]?.toString() ?? '---̥';
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
      if (business['zipCode'] == null) {
        address = null;
      } else {
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
    }

    return Stack(
      children: [
        Container(
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
                padding: EdgeInsets.only(top: 18, left: 12, right: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: [
                        Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            splashColor: Colors.grey[200],
                            onTap: isProverPicShow
                                ? () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    Navigator.of(context).pushNamed(
                                      Routes.providerImageScreen,
                                      arguments:
                                          (ApiBaseHelper.imageUrl + avatar),
                                    );
                                  }
                                : null,
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: avatar == null
                                      ? AssetImage(
                                          FileConstants.icImgPlaceHolder)
                                      : NetworkImage(
                                          ApiBaseHelper.imageUrl + avatar),
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
                        Positioned(
                            top: 0,
                            right: spacing10,
                            child: isOnline
                                ? CircleAvatar(
                                    backgroundColor: Color(0xff009900),
                                    radius: spacing10)
                                : SizedBox())
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: spacing8, right: spacing8, top: spacing10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: colorBlack,
                                    fontWeight: fontWeightSemiBold,
                                    fontSize: fontSize14),
                              ),
                            ),
                            SizedBox(height: spacing8),
                            Row(
                              children: <Widget>[
                                Image(
                                    image: AssetImage(
                                      FileConstants.icExperience,
                                    ),
                                    height: 15.0,
                                    width: 15.0),
                                // '\u2022 '
                                SizedBox(width: 3),
                                Expanded(
                                    child: Text(professionalTitle,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: fontSize12,
                                            fontWeight: fontWeightRegular))),
                                if (selectedAppointment != '0' &&
                                    !isService &&
                                    appointmentTime == null)
                                  Text(
                                    servicesPrize == null ||
                                            servicesPrize == '0.0' ||
                                            servicesPrize == 'null'
                                        ? "\$$fee"
                                        : "\$$servicesPrize",
                                    style: TextStyle(
                                      fontSize: fontSize16,
                                      fontWeight: fontWeightSemiBold,
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: spacing10,
                                bottom: 5.0,
                                right: 5.0,
                              ),
                              child: showPaymentProcced
                                  ? SizedBox()
                                  : Wrap(
                                      runSpacing: 6,
                                      children: <Widget>[
                                        data['isOfficeEnabled']
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6),
                                                child: 'ic_provider_office'
                                                    .imageIcon(
                                                  width: 25,
                                                  height: 25,
                                                ),
                                              )
                                            : Container(),
                                        data['isVideoChatEnabled']
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6),
                                                child: AppConstants
                                                    .icProviderVideoStr
                                                    .imageIcon(
                                                  width: imageSize25,
                                                  height: imageSize25,
                                                ),
                                              )
                                            : Container(),
                                        data['isOnsiteEnabled']
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6),
                                                child: 'ic_provider_onsite'
                                                    .imageIcon(
                                                  width: imageSize25,
                                                  height: imageSize25,
                                                ),
                                              )
                                            : Container(),
                                        // Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(right: 6),
                                        //   child: AppConstants
                                        //       .icProviderGreenMessageStr
                                        //       .imageIcon(
                                        //     width: imageSize25,
                                        //     height: imageSize25,
                                        //   ),
                                        // )
                                      ],
                                    ),
                            ),
                            isService
                                ? Text(
                                    searchedSubService.first.subServiceName,
                                    style: TextStyle(
                                        fontWeight: fontWeightMedium,
                                        fontSize: fontSize13),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              address == null
                  ? SizedBox(
                      height: 12,
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[300],
                      ),
                    ),
              if (appointmentTime != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 3.0, 8.0, 15.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Appointment Details",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Gilroy",
                          fontStyle: FontStyle.normal,
                          fontSize: 13.0),
                    ),
                  ),
                ),
              isService
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Column(children: [
                        searchedSubService.any((item) => item.serviceType == 1)
                            ? officePriceWidget()
                            : SizedBox(),
                        searchedSubService.any((item) => item.serviceType == 3)
                            ? onsitePriceWidget()
                            : SizedBox(),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[300],
                          ),
                        ),
                      ]),
                    )
                  : selectedAppointment == '0'
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Column(children: [
                            officeConsultationFee != "0.00"
                                ? consultationPriceWidget(
                                    'Office price', officeConsultationFee)
                                : SizedBox(),
                            telemedicineConsultationFee != "0.00"
                                ? consultationPriceWidget('Telemedicine price',
                                    telemedicineConsultationFee)
                                : SizedBox(),
                            onsiteConsultationFee != "0.00"
                                ? consultationPriceWidget(
                                    'Onsite price', onsiteConsultationFee)
                                : SizedBox(),

                            // searchedSubService
                            //         .any((item) => item.serviceType == 1)
                            //     ? officePriceWidget()
                            //     : SizedBox(),
                            // searchedSubService
                            //         .any((item) => item.serviceType == 3)
                            //     ? onsitePriceWidget()
                            //     : SizedBox(),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[300],
                              ),
                            ),
                          ]),
                        )
                      : SizedBox(),
              address == null
                  ? SizedBox()
                  : Padding(
                      padding: isOptionsShow
                          ? const EdgeInsets.only(left: 12.0, right: 12.0)
                          : const EdgeInsets.only(
                              left: spacing12,
                              right: spacing12,
                              bottom: spacing10,
                              top: spacing10),
                      child: Row(
                        children: <Widget>[
                          if (appointmentTime == null) ...[
                            'ic_location_grey'
                                .imageIcon(height: 14.0, width: 11.0),
                            SizedBox(width: 3.0),
                            Expanded(
                              child: Text(
                                address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: fontWeightRegular,
                                    fontSize: fontSize12),
                              ).onClick(
                                onTap: onLocationClick != null
                                    ? onLocationClick
                                    : null,
                              ),
                            )
                          ],
                          if (appointmentTime != null) ...[
                            Expanded(
                              child: TextWithImage(
                                  size: 20,
                                  imageSpacing: 3,
                                  textStyle: TextStyle(
                                      color: colorBlack.withOpacity(0.7),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: gilroyRegular,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                  label: appointmentTime,
                                  image: FileConstants.icCalendarGrey),
                            ),
                          ],
                          SizedBox(width: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: <Widget>[
                                Image.asset(FileConstants.icMilesPointer,
                                    width: 15, height: 15),
                                SizedBox(width: 5.0),
                                Text(
                                  distance,
                                  style: TextStyle(
                                      fontWeight: fontWeightRegular,
                                      fontSize: fontSize12),
                                ),
                              ],
                            ),
                          ),
                          if (appointmentTime != null) SizedBox(width: 35),
                        ],
                      ),
                    ),
              if (appointmentTime != null)
                address == null
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 8.0, 15.0),
                        child: Row(
                          children: [
                            'ic_location_grey'
                                .imageIcon(height: 14.0, width: 11.0),
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
                                onTap: onLocationClick != null
                                    ? onLocationClick
                                    : null,
                              ),
                            )
                          ],
                        ),
                      ),
              isOptionsShow
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(top: 12.0),
                            child: FlatButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              color: Colors.transparent,
                              splashColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(13.0),
                                ),
                                side: BorderSide(
                                    width: 0.5,
                                    color: AppColors.persian_indigo),
                              ),
                              child: Text(
                                Localization.of(context).addToNetwork,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                final user = data["User"][0];
                                var name = "";
                                var occupation = "";
                                if (user == null) {
                                  return;
                                }
                                name = user["fullName"];
                                if (data["Specialties"].length > 0) {
                                  occupation = data["Specialties"][0]["title"];
                                  name =
                                      'Dr. $name , ${occupation.getInitials()}';
                                }

                                // Navigator.of(context).pushNamed(
                                //     Routes.myProviderGroups,
                                //     arguments: {
                                //       ArgumentConstant.showBack: false,
                                //       ArgumentConstant.doctorId: data["userId"],
                                //       ArgumentConstant.doctorName: name,
                                //       ArgumentConstant.doctorAvatar:
                                //           data["User"][0]["avatar"]
                                //     });

                                Navigator.of(context).pushNamed(
                                    Routes.providerAddToNetwork,
                                    arguments: {
                                      ArgumentConstant.doctorId: data["userId"],
                                      ArgumentConstant.doctorName: name,
                                      ArgumentConstant.doctorAvatar:
                                          data["User"][0]["avatar"],
                                      'isOnBoarding': false,
                                      "onCompleteRoute":Routes.providerListScreen
                                    });

                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(top: 12.0),
                            child: FlatButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              color: AppColors.persian_indigo,
                              splashColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(13.0),
                                ),
                                side: BorderSide(
                                    width: 0.5,
                                    color: AppColors.persian_indigo),
                              ),
                              child: Text(
                                isService ? "Book Service" : "Book Appointment",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: bookAppointment,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: colorPurple100,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    FileConstants.icStarPoints,
                    height: 14,
                    width: 14,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    averageRating ?? "0",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: onRatingClick != null
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }

  Row consultationPriceWidget(String title, String price) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontWeight: fontWeightMedium, fontSize: fontSize13),
          ),
        ),
        Text(
          "\$$price",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              TextStyle(fontWeight: fontWeightSemiBold, fontSize: fontSize14),
        ),
      ],
    );
  }

  Row officePriceWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Office Price',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontWeight: fontWeightMedium, fontSize: fontSize13),
          ),
        ),
        Text(
          "\$${searchedSubService[searchedSubService.indexWhere((element) => element.serviceType == 1)].amount.toStringAsFixed(2)}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              TextStyle(fontWeight: fontWeightSemiBold, fontSize: fontSize14),
        ),
      ],
    );
  }

  Row onsitePriceWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Onsite Price',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontWeight: fontWeightMedium, fontSize: fontSize13),
          ),
        ),
        Text(
          "\$${searchedSubService[searchedSubService.indexWhere((element) => element.serviceType == 3)].amount.toStringAsFixed(2)}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              TextStyle(fontWeight: fontWeightSemiBold, fontSize: fontSize14),
        ),
      ],
    );
  }
}
