import 'package:flutter/material.dart';

import '../../../utils/app_config.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/dimens.dart';
import 'model/family_member.dart';

class MemberDetail extends StatelessWidget {
  final FamilyMember member;
  final TextStyle titleStyle;
  final TextStyle subTitleStyle;

  const MemberDetail(
      {Key key, this.member, this.titleStyle, this.subTitleStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          member.avatar == null
              ? CircleAvatar(
                  radius: spacing20,
                  backgroundColor: colorPurple.withOpacity(0.3),
                  child: Text(
                    member.fullName == null
                        ? ""
                        : member.fullName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                        color: colorPurple,
                        fontWeight: fontWeightMedium,
                        fontFamily: poppins),
                  ))
              : CircleAvatar(
                  radius: spacing20,
                  backgroundImage: NetworkImage('$imageUrl${member.avatar}'),
                ),
          SizedBox(
            width: spacing20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                member.fullName == null
                    ? ""
                    : member.fullName,
                style: titleStyle ??
                    const TextStyle(
                        color: colorBlack,
                        fontWeight: fontWeightMedium,
                        fontFamily: poppins),
              ),
              if (member.phoneNumber != null)
                Text(
                  member.phoneNumber.toString(),
                  style: subTitleStyle ??
                      const TextStyle(
                          color: colorBlack70,
                          fontSize: fontSize12,
                          fontFamily: poppins),
                ),
              if (member.relation != null)
                Text(
                  member.relation,
                  style: subTitleStyle ??
                      const TextStyle(
                          color: colorBlack70,
                          fontSize: fontSize12,
                          fontFamily: poppins),
                )
            ],
          )
        ],
      ),
    );
  }
}
