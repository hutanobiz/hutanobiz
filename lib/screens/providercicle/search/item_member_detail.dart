import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/text_style.dart';

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
                  radius: 20,
                  backgroundColor: AppColors.colorPurple.withOpacity(0.3),
                  child: Text(
                    member.fullName == null
                        ? ""
                        : member.fullName.substring(0, 1).toUpperCase(),
                    style: AppTextStyle.mediumStyle(
                      color: AppColors.colorPurple,
                    ),
                  ))
              : CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage('${ApiBaseHelper.imageUrl}${member.avatar}'),
                ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                member.fullName == null ? "" : member.fullName,
                style: titleStyle ??
                     AppTextStyle.mediumStyle(
                        color: AppColors.colorBlack,),
              ),
              if (member.phoneNumber != null)
                Text(
                  member.phoneNumber.toString(),
                  style: subTitleStyle ??
                       AppTextStyle.regularStyle(
                          color: AppColors.colorBlack70,
                          fontSize: 12,),
                ),
              if (member.relation != null)
                Text(
                  member.relation,
                  style: subTitleStyle ??
                       AppTextStyle.regularStyle(
                          color: AppColors.colorBlack70,
                          fontSize: 12,),
                )
            ],
          )
        ],
      ),
    );
  }
}
