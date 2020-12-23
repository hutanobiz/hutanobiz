import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_config.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/localization/localization.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/no_data_found.dart';
import '../../provider/search/model/family_member.dart';
import 'model/res_add_member.dart';

class FamilyMemberList extends StatelessWidget {
  final List<FamilyNetwork> memberList;

  const FamilyMemberList({Key key, this.memberList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              FileConstants.icNetwork,
              height: spacing20,
              width: spacing20,
            ),
            SizedBox(width: spacing7),
            Text(
              Localization.of(context).myFamilyNetwork,
              style: TextStyle(
                  fontSize: fontSize14,
                  fontWeight: fontWeightBold,
                  color: colorPurple100),
            )
          ],
        ),
        Container(
          height: 150,
          padding: EdgeInsets.only(left: spacing15, top: spacing20),
          child: (memberList.length == 0)
              ? Center(child: NoDataFound(
                msg: Localization.of(context).noMemberFound,
              ))
              : ListView.separated(
                  separatorBuilder: (_, pos) {
                    return SizedBox(width: SizeConfig.screenWidth / 5);
                  },
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: memberList.length,
                  itemBuilder: (context, pos) {
                    return ItemFamilyMember(
                        member: FamilyMember(
                      avatar: memberList[pos].avatar,
                      fullName: memberList[pos].fullName,
                      relation: memberList[pos].relation,
                    ));
                  },
                ),
        ),
      ],
    );
  }
}

class ItemFamilyMember extends StatelessWidget {
  final FamilyMember member;

  const ItemFamilyMember({Key key, this.member}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        member.avatar == null
            ? CircleAvatar(
                radius: spacing30,
                backgroundColor: colorPurple.withOpacity(0.3),
                child: Text(
                  member.fullName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      color: colorPurple,
                      fontWeight: fontWeightMedium,
                      fontFamily: poppins),
                ))
            : CircleAvatar(
                radius: spacing30,
                backgroundImage: NetworkImage('$imageUrl${member.avatar}'),
              ),
        SizedBox(height: spacing10),
        Text(
          member.fullName,
          style: TextStyle(fontSize: fontSize13, color: colorBlack60),
        ),
        SizedBox(height: spacing5),
        Text(
          member.relation,
          style: TextStyle(
              fontSize: fontSize13,
              fontWeight: fontWeightBold,
              color: colorBlack60),
        )
      ],
    );
  }
}
