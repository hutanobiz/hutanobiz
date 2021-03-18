import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/src/utils/constants/constants.dart';

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
    return Container(
      decoration: new BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Color(0x148b8b8b),
              offset: Offset(0, 2),
              blurRadius: 30,
              spreadRadius: 0)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              Localization.of(context).myFamilyNetwork,
              style: TextStyle(
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  color: colorBlack2),
            ),
          ),
          Container(
            height: 150,
            padding: EdgeInsets.only(left: spacing20, top: spacing20),
            child: (memberList.length == 0)
                ? Center(
                    child: NoDataFound(
                    msg: Localization.of(context).noMemberFound,
                  ))
                : ListView.separated(
                    separatorBuilder: (_, pos) {
                      return SizedBox(width: SizeConfig.screenWidth / 5);
                    },
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: memberList.length + 1,
                    itemBuilder: (context, pos) {
                      if (pos == memberList.length) {
                        return AddMore();
                      }
                      return ItemFamilyMember(
                          member: FamilyMember(
                        avatar: memberList[pos].avatar,
                        fullName: memberList[pos].fullName,
                        relation: memberList[pos].relation,
                      ));
                    },
                  ),
          ),
          Divider(
            height: 2,
            thickness: 1,
          ),
          if ((memberList.length != 0))
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(routeFamilyCircle);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("View all members".toUpperCase(),
                        style: TextStyle(
                          color: colorPurple100,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        )),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: colorPurple100,
                      size: 30,
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class AddMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  width: 1,
                  color: colorPurple100,
                )),
            child: Center(
              child: Image.asset(FileConstants.icAddUser),
            ),
          ),
          SizedBox(height: spacing10),
          Text(
            "Add \n More",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize13,
              color: colorPurple100,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
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
          style: TextStyle(
            fontSize: fontSize13,
            color: colorBlack2,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
        SizedBox(height: spacing5),
        Text(
          member.relation,
          style: TextStyle(
            fontSize: fontSize13,
            color: colorBlack2,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        )
      ],
    );
  }
}
