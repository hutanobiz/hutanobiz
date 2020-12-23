import 'package:flutter/material.dart';

import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../widgets/ripple_effect.dart';
import '../../provider/search/item_member_detail.dart';
import '../../provider/search/model/family_member.dart';

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
            width: spacing40,
            height: spacing40,
          ),
        ),
      ],
    );
  }
}
