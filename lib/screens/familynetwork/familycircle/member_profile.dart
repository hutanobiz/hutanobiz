import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/text_style.dart';
import 'family_member_model.dart';

class MemberProfile extends StatelessWidget {
  final FamilyMember member;

  const MemberProfile({Key key, this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          member.name != null
              ? CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.colorPurple.withOpacity(0.3),
                  child: Text(
                    member.name?.substring(0, 1).toUpperCase(),
                    style: AppTextStyle.mediumStyle(
                      color: AppColors.colorPurple,
                    ),
                  ))
              : CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      NetworkImage('${ApiBaseHelper.base_url}${member.image}'),
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
                member.name,
                style:  AppTextStyle.semiBoldStyle(
                    color: AppColors.colorBlack,),
              ),
              Text(
                member.relation,
                style:
                    const TextStyle(color: AppColors.colorBlack70, fontSize: 13),
              )
            ],
          )
        ],
      ),
    );
  }
}
