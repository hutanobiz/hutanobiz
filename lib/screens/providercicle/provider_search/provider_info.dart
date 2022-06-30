import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/app_config.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import '../../../widgets/text_with_image.dart';
import 'model/provider_detail_model.dart';

class ProviderInfo extends StatelessWidget {
  final ProviderDetail providerDetail;
  final String? icon;
  final EdgeInsets? padding;

  const ProviderInfo(
      {Key? key, required this.providerDetail, this.icon, this.padding})
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
                    radius: spacing30,
                    backgroundColor: colorPurple.withOpacity(0.3),
                    child: Text(
                      providerDetail.name!.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          color: colorPurple,
                          fontWeight: fontWeightMedium,
                          fontFamily: poppins),
                    ))
                : CircleAvatar(
                    radius: spacing30,
                    backgroundImage:
                        NetworkImage('$imageUrl${providerDetail.image}'),
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
                          style: const TextStyle(
                              fontWeight: fontWeightBold, fontSize: fontSize13),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      if (icon != null)
                        Image.asset(
                          icon!,
                          height: 20,
                          width: 20,
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
                          Localization.of(context)!
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
