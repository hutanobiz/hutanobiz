import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/widgets/custom_card.dart';
import 'package:hutano/widgets/ripple_effect.dart';


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
          BorderSide(color:  AppColors.colorGrey3, width: 0.5, style: BorderStyle.solid),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 15),
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
                            color:  AppColors.colorBlack2.withOpacity(0.1))),
                  )
                ],
              ),
              Divider(
                height: 20,
                color:  AppColors.colorGrey3,
                thickness: 0.5,
              ),
              SizedBox(height: 5),
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
            label: Strings.remove,
            textStyle: TextStyle(color:  AppColors.colorBlack2.withOpacity(0.85), fontSize: 12),
          )),
        ),
        SizedBox(
          width: 15,
        ),
        IntrinsicWidth(
          child: TextWithImage(
            
               textStyle: TextStyle(color:  AppColors.colorPurple100, fontSize: 12),
              image: FileConstants.icAppointmentBlue,
              label: Strings.makeAppointment),
        ),
      ],
    );
  }
}
