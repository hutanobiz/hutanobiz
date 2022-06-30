import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_family_circle.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/localization/localization.dart';
import '../../../widgets/hutano_button.dart';
import 'family_member_model.dart';
import 'member_profile.dart';

class PermissionAccess extends StatefulWidget {
  final CircleMember? member;
  final List<int>? userPermissionsList;
  final Function? onPermissionDone;
  final int? index;
  const PermissionAccess({
    Key? key,
    this.member,
    this.userPermissionsList,
    this.onPermissionDone,
    this.index,
  }) : super(key: key);

  @override
  _PermissionAccessState createState() => _PermissionAccessState();
}

class _PermissionAccessState extends State<PermissionAccess> {
  final List<PermissionModel> permissions = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      permissions.add(PermissionModel(Localization.of(context)!.fullAccess,
          FileConstants.icFullAccess, false, 1));
      permissions.add(PermissionModel(Localization.of(context)!.appointments,
          FileConstants.icAppointments, false, 2));
      permissions.add(PermissionModel(Localization.of(context)!.documents,
          FileConstants.icDocuments, false, 3));
      permissions.add(PermissionModel(Localization.of(context)!.notifications,
          FileConstants.icNotifications, false, 4));

      if (widget.userPermissionsList != null) {
        for (var i = 0; i < widget.userPermissionsList!.length; i++) {
          var selectedIndex = permissions.indexWhere(
              (element) => element.value == widget.userPermissionsList![i]);
          if (selectedIndex != -1) {
            permissions[selectedIndex].isSelected = true;
          }
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(spacing15),
            child: MemberProfile(
              member: FamilyMember(
                  image: widget.member!.name,
                  name: widget.member!.name,
                  relation: widget.member!.relationName),
            ),
          ),
          Divider(
            color: colorBorder,
            height: 0.5,
          ),
          Padding(
            padding: EdgeInsets.all(spacing15),
            child: _buildPermissionList(context),
          )
        ],
      ),
    );
  }

  Widget _buildPermissionList(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Localization.of(context)!.permissions,
          style: const TextStyle(
              fontSize: fontSize16, fontWeight: fontWeightSemiBold),
          textAlign: TextAlign.start,
        ),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, pos) {
              var data = permissions[pos];
              return CheckboxListTile(
                  activeColor: colorYellow,
                  contentPadding: EdgeInsets.all(0),
                  title: Container(
                      child: Row(children: [
                    Image.asset(data.icon, height: spacing25, width: spacing25),
                    SizedBox(
                      width: spacing20,
                    ),
                    Text(
                      data.label,
                      style: const TextStyle(color: colorBlack85),
                    )
                  ])),
                  value: data.isSelected,
                  onChanged: (val) {
                    permissions[pos].isSelected = val;
                    setState(() {});
                  });
            },
            separatorBuilder: (_, pos) {
              return Divider(
                height: spacing15,
                color: colorBorder,
                thickness: 0.5,
              );
            },
            itemCount: permissions.length),
        HutanoButton(
          label: Localization.of(context)!.done,
          onPressed: () {
            var selectedPermission = <int>[];
            permissions.forEach((element) {
              if (element.isSelected!) {
                selectedPermission.add(element.value);
              }
            });
            widget.onPermissionDone!(selectedPermission ,widget.index);
          },
        )
      ],
    );
  }
}

class PermissionModel {
  final String label;
  final String icon;
  bool? isSelected;
  int value;

  PermissionModel(this.label, this.icon, this.isSelected, this.value);
}
