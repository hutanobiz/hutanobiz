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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ProviderInfo(
                      padding: EdgeInsets.all(0),
                      providerDetail: ProviderDetail(
                          name: providerDetail.name,
                          rating: providerDetail.rating,
                          experience: providerDetail.experience,
                          image: providerDetail.image,
                          occupation: providerDetail.occupation),
                    ),
                  ),
                  RippleEffect(
                    onTap: () {
                      onShare(index, subIndex);
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          child: Image.asset(
                            FileConstants.icShare,
                            height: 15,
                            width: 15,
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: colorBlack2.withOpacity(0.1))),
                  )
                ],
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
        Spacer(),
        RippleEffect(
          onTap: () {
            onRemove(index, subIndex);
          },
          child: IntrinsicWidth(
              child: TextWithImage(
            image: FileConstants.icRemoveBlack,
            label: Localization.of(context).remove,
            textStyle: TextStyle(color: colorBlack2.withOpacity(0.85), fontSize: fontSize12),
          )),
        ),
        SizedBox(
          width: 15,
        ),
        IntrinsicWidth(
          child: TextWithImage(
            
               textStyle: TextStyle(color: colorPurple100, fontSize: fontSize12),
              image: FileConstants.icAppointmentBlue,
              label: Localization.of(context).makeAppointment),
        ),
      ],
    );
  }
}
