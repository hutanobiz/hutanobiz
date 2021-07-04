import 'package:flutter/material.dart';
import 'package:hutano/screens/providercicle/search/item_member_detail.dart';
import 'package:hutano/screens/providercicle/search/model/family_member.dart';
import 'package:hutano/utils/file_constants.dart';
import 'package:hutano/widgets/ripple_effect.dart';

class MemberRow extends StatelessWidget {
  final FamilyMember member;
  final ValueSetter<FamilyMember> onAdd;

  const MemberRow({Key key, @required this.member, this.onAdd})
      : assert(member != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: MemberDetail(
            member: member,
          ),
        ),
        RippleEffect(
          onTap: () {
            onAdd(member);
          },
          child: Image.asset(
            FileConstants.icAdd,
            width: 40,
            height: 40,
          ),
        ),
      ],
    );
  }
}
