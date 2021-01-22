import 'package:flutter/material.dart';
import 'package:hutano/src/ui/medical_history/provider/appoinment_provider.dart';
import 'package:hutano/src/utils/preference_key.dart';
import 'package:hutano/src/utils/preference_utils.dart';
import 'package:provider/provider.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/constants/key_constant.dart';
import '../../../utils/dimens.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/navigation.dart';
import '../../../widgets/custom_card.dart';
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

                Navigator.of(context).pushNamed( routeProviderAddNetwork,
                    arguments: {
                      ArgumentConstant.doctorId: providerDetail.userId,
                      ArgumentConstant.doctorName: name,
                      ArgumentConstant.doctorAvatar:
                          providerDetail.user[0].avatar
                    });
              },
              label: Localization.of(context).addToNetwork,
              height: 45,
              fontSize: fontSize12,
              color: colorWhite,
              labelColor: colorPurple,
              buttonShape: _getBorder(bottomLeft: 14, bottomRight: 0),
            )),
        Expanded(
          flex: 1,
          child: HutanoButton(
            onPressed: () {
              Provider.of<SymptomsInfoProvider>(context, listen: false)
                  .setAppoinmentData(
                      providerDetail.userId, getString(PreferenceKey.id));
              Navigator.of(context).pushNamed( routeMyMedicalHistory);
            },
            label: Localization.of(context).bookAppointment,
            height: 45,
            fontSize: fontSize12,
            color: colorPurple,
            buttonShape: _getBorder(bottomLeft: 0, bottomRight: 14),
          ),
        )
      ],
    );
  }

  _getProviderDetail() {
    final user = providerDetail.user[0];
    final avatar = user?.avatar ?? "";
    final rating = "4";
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
    if (providerDetail.followUpFee != null &&
        providerDetail.followUpFee.length > 0) {
      return providerDetail?.followUpFee[0]?.fee ?? '0';
    }
    return '0';
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
              width: spacing100,
              margin: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '\$${_getFee()}',
                    style: const TextStyle(
                        color: colorLightBlack,
                        fontSize: fontSize13,
                        fontWeight: fontWeightBold),
                  ),
                  Text(
                    Localization.of(context).consultationFee,
                    style: const TextStyle(
                        color: colorLightBlack, fontSize: fontSize10),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: colorLightPink,
                border: Border.all(width: 1, color: colorBorder3),
                borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
              ),
            )
          ],
        )
      ],
    );
  }

  _buildLocationInfo(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextWithImage(
              image: FileConstants.icMarker,
              label: providerDetail.businessLocation?.street ?? "",
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
          _buildButton(context)
        ],
      ),
    );
  }
}
