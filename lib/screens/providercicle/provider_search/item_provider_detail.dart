import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/custom_card.dart';

import '../../../widgets/hutano_button.dart';
import '../../../widgets/text_with_image.dart';
import 'model/doctor_data_model.dart';
import 'model/provider_detail_model.dart';
import 'provider_info.dart';

class ItemProviderDetail extends StatelessWidget {
  final DoctorData providerDetail;

  const ItemProviderDetail({Key key, this.providerDetail}) : super(key: key);

  RoundedRectangleBorder _getBorder({double bottomLeft, double bottomRight}) {
    return RoundedRectangleBorder(
        side: const BorderSide(color: colorPurple, width: 0.5),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0)));
  }

  Widget _buildButton(context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: HutanoButton(
              onPressed: () {
                final user = providerDetail.user[0];
                var occupation = "";
                if (providerDetail?.professionalTitle != null &&
                    providerDetail.professionalTitle.length > 0) {
                  occupation =
                      providerDetail?.professionalTitle[0]?.title ?? "";
                }
                var name = user?.fullName ?? "";
                if (occupation.isNotEmpty) {
                  name = 'Dr. $name , ${occupation.getInitials()}';
                }

                Navigator.of(context)
                    .pushNamed(Routes.providerAddNetwork, arguments: {
                  ArgumentConstant.doctorId: providerDetail.userId,
                  ArgumentConstant.doctorName: name,
                  ArgumentConstant.doctorAvatar: providerDetail.user[0].avatar
                });
              },
              label: Localization.of(context).addToNetwork,
              height: 45,
              fontSize: fontSize12,
              labelColor: colorWhite,
              color: colorPurple,
              buttonShape: _getBorder(bottomLeft: 14, bottomRight: 0),
            )),
      ],
    );
  }

  _getProviderDetail() {
    final user = providerDetail.user[0];
    final avatar = user?.avatar ?? "";
    final rating = providerDetail.averageRating ?? "0";
    var occupation = "";
    if (providerDetail?.professionalTitle?.length > 0) {
      occupation = providerDetail?.professionalTitle[0]?.title ?? "";
    }
    var name = user?.fullName ?? "";
    if (occupation.isNotEmpty) {
      name = '$name , ${occupation.getInitials()}';
    }
    final experience = providerDetail.practicingSince == null
        ? '0'
        : providerDetail.practicingSince.getYearCount();
    return ProviderDetail(
        image: avatar,
        rating: rating,
        name: name,
        occupation: occupation,
        experience: experience);
  }

  _getFee() {
    var fee = "0";
    if (providerDetail.officeConsultanceFee != null &&
        providerDetail.officeConsultanceFee.length > 0) {
      fee = providerDetail.officeConsultanceFee[0].fee == null
          ? '0.00'
          : providerDetail.officeConsultanceFee[0].fee.toStringAsFixed(2) ??
              '0.00';
    }

    if (providerDetail.onsiteConsultanceFee != null &&
        providerDetail.onsiteConsultanceFee.length > 0) {
      fee = providerDetail.onsiteConsultanceFee[0].fee == null
          ? '0.00'
          : min(
              double.parse(fee),
              double.parse(
                providerDetail.onsiteConsultanceFee[0].fee.toStringAsFixed(2),
              ),
            ).toStringAsFixed(2);
    }

    if (providerDetail.vedioConsultanceFee != null &&
        providerDetail.vedioConsultanceFee.length > 0) {
      fee = providerDetail.vedioConsultanceFee[0].fee == null
          ? '0.00'
          : min(
              double.parse(fee),
              double.parse(
                providerDetail.vedioConsultanceFee[0].fee.toStringAsFixed(2),
              ),
            ).toStringAsFixed(2);
    }
    return fee ?? '0';
  }

  Widget _buildProviderInfo(context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: ProviderInfo(
                providerDetail: _getProviderDetail(),
              ),
            ),
            Container(
              height: spacing50,
              margin: EdgeInsets.only(top: 20, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${_getFee()}',
                    style: const TextStyle(
                        color: colorBlack2,
                        fontWeight: FontWeight.w600,
                        fontFamily: gilroySemiBold,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ),
                  Text(
                    Localization.of(context).consultationFee,
                    style: const TextStyle(
                      color: colorBlack2,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: gilroyRegular,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  _getLocation() {
    var address = "";
    if (providerDetail.businessLocation != null) {
      dynamic business = providerDetail.businessLocation;

      var _state;

      if (business.state is Map && business.state.length > 0) {
        _state = business.state;
      } else if (providerDetail.state != null &&
          providerDetail.state.length > 0) {
        _state = providerDetail.state[0].toJson();
      }

      address = Extensions.addressFormat(
        business.address?.toString(),
        business.street?.toString(),
        business.city?.toString(),
        _state,
        business.zipCode?.toString(),
      );
    }
    return address;
  }

  _buildLocationInfo(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextWithImage(
              image: FileConstants.icMarker,
              label: _getLocation(),
            ),
          ),
          IntrinsicWidth(
            child: TextWithImage(
              image: FileConstants.icLocation,
              label: Localization.of(context)
                  .miles
                  .format([providerDetail.distance.toStringAsFixed(2) ?? '0']),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Column(
              children: [
                _buildProviderInfo(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    color: colorBorder,
                    height: 0.5,
                  ),
                ),
                _buildLocationInfo(context)
              ],
            ),
          ),
          // _buildButton(context)
        ],
      ),
    );
  }
}
