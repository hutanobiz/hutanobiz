import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/extensions.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/hutano_button.dart';
import '../../../widgets/text_with_image.dart';
import '../../provider/provider_search/model/provider_detail_model.dart';
import '../../provider/provider_search/provider_info.dart';
import 'model/res_appointment_list.dart';

class ItemAppointment extends StatelessWidget {
  final PresentRequest appointment;

  const ItemAppointment({
    Key key,
    this.appointment,
  }) : super(key: key);

  Widget _buildProviderInfo(context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: ProviderInfo(
                icon: FileConstants.icMedicalLocation,
                providerDetail: ProviderDetail(
                    name: appointment.doctor.fullName,
                    rating: appointment.averageRating.toString(),
                    painType: appointment.symptopmType,
                    image: appointment.doctor.avatar,
                    occupation:
                        'Member Since ${appointment.doctor.createdAt.getYear()}'),
              ),
            ),
            Container(
              height: spacing50,
              width: spacing100,
              margin: EdgeInsets.only(right: spacing10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    // '${appointment.appointmentType}',
                    'Upcoming',
                    style: const TextStyle(
                      color: colorDarkYellow,
                      fontSize: fontSize13,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: colorYellow12,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
            )
          ],
        )
      ],
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: _buildBottomContent(context),
                )
              ],
            ),
          ),
          _buildButton(context)
        ],
      ),
    );
  }

  Widget _buildBottomContent(context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextWithImage(
                image: FileConstants.icReview,
                label: Localization.of(context).reviewChart,
              ),
            ),
            IntrinsicWidth(
              child: TextWithImage(
                image: FileConstants.icMessagePatient,
                label: Localization.of(context).textPatient,
              ),
            ),
          ],
        ),
        SizedBox(
          height: spacing10,
        ),
        Row(
          children: [
            Expanded(
              child: TextWithImage(
                  image: FileConstants.icTime,
                  label: appointment.date.getDate()),
            ),
            IntrinsicWidth(
              child: TextWithImage(
                image: FileConstants.icCallPatient,
                label: Localization.of(context).callPatient,
              ),
            ),
          ],
        )
      ],
    );
  }

  RoundedRectangleBorder _getBorder() {
    return RoundedRectangleBorder(
        side: const BorderSide(color: colorLightGrey2, width: 0.5),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0)));
  }

  Widget _buildButton(context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: HutanoButton(
            onPressed: () {},
            label: Localization.of(context).rescheduleAppointment,
            height: 45,
            labelColor: colorBlack50,
            color: colorWhite5,
            buttonShape: _getBorder(),
          ),
        )
      ],
    );
  }
}
