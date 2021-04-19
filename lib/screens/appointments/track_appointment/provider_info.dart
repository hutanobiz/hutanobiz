import 'package:flutter/material.dart';

import 'package:hutano/api/api_helper.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/appointments/track_appointment/model/res_tracking_appointment.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/constants.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/widgets/text_with_image.dart';

class ProviderInfo extends StatelessWidget {
  final ProviderData providerData;

  const ProviderInfo({Key key, this.providerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0x1f8b8b8b), width: 0.5),
          boxShadow: [
            BoxShadow(
                color: const Color(0x148b8b8b),
                offset: Offset(0, 2),
                blurRadius: 30,
                spreadRadius: 0)
          ],
          color: const Color(0xffffffff)),
      height: 150,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        splashColor: Colors.grey[200],
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.of(context).pushNamed(
                            Routes.providerImageScreen,
                            arguments:
                                (ApiBaseHelper.imageUrl + providerData.avatar),
                          );
                        },
                        child: Container(
                          width: 58.0,
                          height: 58.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: providerData.avatar == null
                                  ? AssetImage('images/profile_user.png')
                                  : NetworkImage(ApiBaseHelper.imageUrl +
                                      providerData.avatar),
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
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dr. ${providerData.firstName} ${providerData.lastName}",
                              style: const TextStyle(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: gilroySemiBold,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                              textAlign: TextAlign.left),
                          SizedBox(
                            height: 5,
                          ),
                          IntrinsicWidth(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              height: 24,
                              child: TextWithImage(
                                image: FileConstants.icAdd,
                                label: "Arrived at Office",
                                textStyle: TextStyle(
                                    color: colorBlack2,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: gilroyRegular,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: colorBlack2.withOpacity(0.06),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Divider(
                  height: 40,
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                Row(
                  children: [
                    IntrinsicWidth(
                      child: TextWithImage(
                        imageSpacing: 10,
                        image: FileConstants.icAdd,
                        label: "Office Appointment",
                        textStyle: TextStyle(
                            color: colorBlack70,
                            fontWeight: FontWeight.w400,
                            fontFamily: gilroyRegular,
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                      ),
                    ),
                    Spacer(),
                    IntrinsicWidth(
                      child: TextWithImage(
                        imageSpacing: 10,
                        image: FileConstants.icAdd,
                        label: "June 10, 12:30pm",
                        textStyle: TextStyle(
                            color: colorBlack70,
                            fontWeight: FontWeight.w400,
                            fontFamily: gilroyRegular,
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                      ),
                    ),
                  ],
                )
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
                      providerData.averageRating ?? "0",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
