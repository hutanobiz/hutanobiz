import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/widgets/custom_card.dart';

import '../../../widgets/placeholder_image.dart';
import 'model/provider_network.dart';

class ListItem extends StatelessWidget {
  final ProviderNetwork _item;
  ListItem(this._item);
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: Container(
        padding: EdgeInsets.all(spacing10),
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
                  _item.groupName,
                  style: const TextStyle(
                      color: colorBlack85, fontSize: fontSize14),
                ),
              ),
            ),
            Image.asset(
              _item.isSelected
                  ? FileConstants.icCheck
                  : FileConstants.icUncheckSquare,
              height: 22,
              fit: BoxFit.cover,
              width: 22,
            )
          ],
        ),
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
