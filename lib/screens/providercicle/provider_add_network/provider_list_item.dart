import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/widgets/custom_card.dart';

import '../../../widgets/placeholder_image.dart';
import 'model/provider_network.dart';

class GroupListItem extends StatelessWidget {
  final ProviderNetwork _item;
  final ProviderNetwork? selectedGroup;
  final Function onDeleteGroup;
  GroupListItem(this._item, this.selectedGroup, this.onDeleteGroup);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
              color: selectedGroup != null &&
                      selectedGroup!.doctorId == _item.doctorId
                  ? AppColors.windsor
                  : Colors.transparent),
          boxShadow: [
            BoxShadow(
                color: AppColors.windsor.withOpacity(0.01),
                offset: Offset(0, 2),
                spreadRadius: 5,
                blurRadius: 10)
          ]),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10),
          //   child: PlaceHolderImage(
          //     width: 34,
          //     height: 34,
          //     image: ' ',
          //     placeholder: FileConstants.icDoctorSpecialist,
          //   ),
          // ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Text(
                _item.groupName!,
                style: const TextStyle(
                    color: colorBlack85,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),

          GestureDetector(
            onTap: onDeleteGroup as void Function()?,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
                size: 24,
                color: AppColors.windsor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String image;
  final String text;

  RadioModel(this.isSelected, this.image, this.text);
}
