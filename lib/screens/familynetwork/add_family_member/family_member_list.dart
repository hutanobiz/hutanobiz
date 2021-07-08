import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/familynetwork/add_family_member/family_provider.dart';
import 'package:hutano/screens/providercicle/search/model/family_member.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/size_config.dart';
import 'package:hutano/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

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
                Navigator.of(context).pushNamed(Routes.familyCircle);
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
  final int memberIndex;
  final Contact contact;

  const ItemFamilyMember({Key key, this.member,this.memberIndex=0,this.contact}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            member.avatar != null
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
                    backgroundImage: NetworkImage(''),
                  ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: () {
                  // Provider.of<FamilyProvider>(context,listen: false).updateReqProviderMember(_finalMemberList);
                  Provider.of<FamilyProvider>(context,listen: false).removeRedProviderMember(memberIndex);
                  Iterable<Item> v = [];
                  List<Item> c = [];
                  c.add(Item(label: "mobile",value: member.phoneNumber));
                  Provider.of<FamilyProvider>(context,listen: false).addProviderContacts(Contact(displayName: member.fullName,phones: c));
                  Provider.of<FamilyProvider>(context,listen: false).addFilteredProviderContacts(Contact(displayName: member.fullName,phones: c));
                },
                child: Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    Icons.cancel,
                    color: AppColors.persian_blue,
                    size: 17,
                  ),
                ),
              ),
            )
          ],
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
