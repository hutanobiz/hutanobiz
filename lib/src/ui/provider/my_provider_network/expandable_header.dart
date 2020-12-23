import 'package:flutter/material.dart';
import 'package:hutano/src/utils/app_config.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import 'model/provider_group.dart';

class ExpandableHeader extends StatelessWidget {
  final ProviderGroup providerGroup;

  const ExpandableHeader({Key key, this.providerGroup}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(width: spacing5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
                height: spacing40,
                fit: BoxFit.cover,
                width: spacing40,
                image: NetworkImage('$imageUrl${providerGroup.image}' ?? " "),
                placeholder: AssetImage(FileConstants.icDoctorSpecialist)),
          ),
          SizedBox(width: spacing10),
          Text(
            providerGroup.groupType,
            style: const TextStyle(color: colorBlack85, fontSize: fontSize14),
          ),
          SizedBox(width: spacing10),
          Container(
            alignment: Alignment.center,
            height: spacing25,
            width: spacing25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7), color: colorYellow),
            child: Text(
              providerGroup.count.toString(),
              style: TextStyle(fontSize: fontSize15),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
