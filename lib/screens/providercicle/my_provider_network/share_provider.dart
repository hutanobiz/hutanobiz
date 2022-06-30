import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/app_config.dart';
import 'package:hutano/utils/argument_const.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/size_config.dart';
import 'package:hutano/widgets/ripple_effect.dart';

import '../../familynetwork/add_family_member/model/res_add_member.dart';
import '../search/model/family_member.dart';
import 'bottom_option_list.dart';

class ShareProvider extends StatelessWidget {
  final List<FamilyNetwork>? memberList;
  final String? shareMessage;

  const ShareProvider({Key? key, this.memberList, this.shareMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing20, horizontal: spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 80,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: memberList!.length,
                separatorBuilder: (_, pos) {
                  return SizedBox(width: SizeConfig.screenWidth! / 6);
                },
                itemBuilder: (_, pos) {
                  return RippleEffect(
                    onTap: () {
                      Navigator.of(context).pushNamed( Routes.memberMessage,
                          arguments: {
                            ArgumentConstant.member: memberList![pos],
                            ArgumentConstant.shareMessage: shareMessage
                          });
                    },
                    child: Member(FamilyMember(
                      avatar: memberList![pos].avatar ?? "",
                      fullName: memberList![pos].fullName,
                      sId: memberList![pos].sId,
                    )),
                  );
                }),
          ),
          Divider(
            color: colorGrey3,
            thickness: 0.5,
            height: 30,
          ),
          SizedBox(height: spacing15),
          BottomOptionList(shareMessage: shareMessage)
        ],
      ),
    );
  }
}

class Member extends StatelessWidget {
  final FamilyMember _member;
  const Member(this._member);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: FadeInImage(
              height: spacing50,
              fit: BoxFit.cover,
              width: spacing50,
              image: NetworkImage('$imageUrl${_member.avatar}'),
              placeholder: AssetImage(FileConstants.icUser)),
        ),
        SizedBox(
          height: spacing12,
        ),
        Text(
          _member.fullName!,
          style: const TextStyle(fontSize: fontSize11, color: colorBlack60),
        )
      ],
    );
  }
}
