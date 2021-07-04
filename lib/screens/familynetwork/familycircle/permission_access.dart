import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/screens/familynetwork/familycircle/model/res_family_circle.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/file_constants.dart';
import '../../../widgets/hutano_button.dart';
import 'family_member_model.dart';
import 'member_profile.dart';

class PermissionAccess extends StatefulWidget {
  final CircleMember member;
  final List<int> userPermissionsList;
  final Function onPermissionDone;
  final int index;
  const PermissionAccess({
    Key key,
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
      permissions.add(PermissionModel(Strings.fullAccess,
          FileConstants.icFullAccess, false, 1));
      permissions.add(PermissionModel(Strings.appointments,
          FileConstants.icAppointments, false, 2));
      permissions.add(PermissionModel(Strings.documents,
          FileConstants.icDocuments, false, 3));
      permissions.add(PermissionModel(Strings.notifications,
          FileConstants.icNotifications, false, 4));

      if (widget.userPermissionsList != null) {
        for (var i = 0; i < widget.userPermissionsList.length; i++) {
          var selectedIndex = permissions.indexWhere(
              (element) => element.value == widget.userPermissionsList[i]);
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
            padding: const EdgeInsets.all(15),
            child: MemberProfile(
              member: FamilyMember(
                  image: widget.member.name,
                  name: widget.member.name,
                  relation: widget.member.relationName),
            ),
          ),
          Divider(
            color: AppColors.colorBorder,
            height: 0.5,
          ),
          Padding(
            padding: EdgeInsets.all(15),
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
          Strings.permissions,
          style:  AppTextStyle.semiBoldStyle(
              fontSize: 16, ),
          textAlign: TextAlign.start,
        ),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, pos) {
              var data = permissions[pos];
              return CheckboxListTile(
                  activeColor: AppColors.colorYellow,
                  contentPadding: EdgeInsets.all(0),
                  title: Container(
                      child: Row(children: [
                    Image.asset(data.icon, height: 25, width: 25),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      data.label,
                      style: const TextStyle(color: AppColors.colorBlack85),
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
                height: 15,
                color: AppColors.colorBorder,
                thickness: 0.5,
              );
            },
            itemCount: permissions.length),
        HutanoButton(
          label: Strings.done,
          onPressed: () {
            var selectedPermission = <int>[];
            permissions.forEach((element) {
              if (element.isSelected) {
                selectedPermission.add(element.value);
              }
            });
            widget.onPermissionDone(selectedPermission ,widget.index);
          },
        )
      ],
    );
  }
}

class PermissionModel {
  final String label;
  final String icon;
  bool isSelected;
  int value;

  PermissionModel(this.label, this.icon, this.isSelected, this.value);
}
