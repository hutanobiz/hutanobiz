import 'package:flutter/material.dart';

import '../../../utils/app_config.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/dimens.dart';
import 'family_member_model.dart';

class MemberProfile extends StatelessWidget {
  final FamilyMember member;

  const MemberProfile({Key key, this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          member.image == null
              ? CircleAvatar(
                  radius: spacing25,
                  backgroundColor: colorPurple.withOpacity(0.3),
                  child: Text(
                    member.name?.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                        color: colorPurple,
                        fontWeight: fontWeightMedium,
                        fontFamily: poppins),
                  ))
              : CircleAvatar(
                  radius: spacing25,
                  backgroundImage: NetworkImage('$imageUrl${member.image}'),
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
                member.name,
                style: const TextStyle(
                    color: colorBlack, fontWeight: fontWeightSemiBold),
              ),
              Text(
                member.relation,
                style:
                    const TextStyle(color: colorBlack70, fontSize: fontSize13),
              )
            ],
          )
        ],
      ),
    );
  }
}
