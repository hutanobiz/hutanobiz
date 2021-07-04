import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import '../../../widgets/text_with_image.dart';
import 'model/provider_detail_model.dart';

class ProviderInfo extends StatelessWidget {
  final ProviderDetail providerDetail;
  final String icon;
  final EdgeInsets padding;

  const ProviderInfo(
      {Key key, @required this.providerDetail, this.icon, this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            providerDetail.image == null
                ? CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.colorPurple.withOpacity(0.3),
                    child: Text(
                      providerDetail.name.substring(0, 1).toUpperCase(),
                      style: AppTextStyle.mediumStyle(
                        color: AppColors.colorPurple,
                      ),
                    ))
                : CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        '${ApiBaseHelper.imageUrl}${providerDetail.image}'),
                  ),
            SizedBox(
              width: 7,
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Dr ${providerDetail.name}',
                          style:  AppTextStyle.boldStyle( fontSize: 13),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      if (icon != null)
                        Image.asset(
                          icon,
                          height: 30,
                          width: 30,
                        )
                    ],
                  ),
                  TextWithImage(
                    image: FileConstants.icRating,
                    label:
                        '${providerDetail.rating}   ${providerDetail.occupation}',
                  ),
                  TextWithImage(
                      image: FileConstants.icExperience,
                      label: providerDetail.painType ??
                          Strings
                              .yearsOfExpereince
                              .format([providerDetail.experience]))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
