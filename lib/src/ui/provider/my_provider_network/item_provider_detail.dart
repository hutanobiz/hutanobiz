import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/ripple_effect.dart';
import '../../../widgets/text_with_image.dart';
import '../provider_search/model/provider_detail_model.dart';
import '../provider_search/provider_info.dart';

class ItemProviderDetail extends StatelessWidget {
  final ProviderDetail providerDetail;
  final int index;
  final int subIndex;
  final Function onShare;
  final Function onRemove;

  const ItemProviderDetail({
    Key key,
    this.providerDetail,
    this.index,
    this.subIndex,
    this.onShare,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: 11,
      elevation: 0,
      borderStyle:
          BorderSide(color: colorGrey3, width: 0.5, style: BorderStyle.solid),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: spacing10, vertical: spacing15),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProviderInfo(
                padding: EdgeInsets.all(0),
                providerDetail: ProviderDetail(
                    name: providerDetail.name,
                    rating: providerDetail.rating,
                    experience: providerDetail.experience,
                    image: providerDetail.image,
                    occupation: providerDetail.occupation),
              ),
              Divider(
                height: spacing20,
                color: colorGrey3,
                thickness: 0.5,
              ),
              SizedBox(height: spacing5),
              _buildBottomBar(context)
            ]),
      ),
    );
  }

  Widget _buildBottomBar(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IntrinsicWidth(
            child: TextWithImage(
                image: FileConstants.icAppointmentWhite,
                label: Localization.of(context).makeAppointment)),
        RippleEffect(
          onTap: () {
            onShare(index, subIndex);
          },
          child: IntrinsicWidth(
              child: TextWithImage(
                  image: FileConstants.icShareWhite,
                  label: Localization.of(context).share)),
        ),
        RippleEffect(
          onTap: () {
            onRemove(index, subIndex);
          },
          child: IntrinsicWidth(
              child: TextWithImage(
            image: FileConstants.icDelete,
            label: Localization.of(context).remove,
            textStyle: TextStyle(color: colorRed, fontSize: fontSize12),
          )),
        )
      ],
    );
  }
}