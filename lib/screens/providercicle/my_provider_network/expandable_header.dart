import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/file_constants.dart';
import 'model/provider_group.dart';

class ExpandableHeader extends StatelessWidget {
  final ProviderGroup providerGroup;

  const ExpandableHeader({Key key, this.providerGroup}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(width: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
                height: 40,
                fit: BoxFit.cover,
                width: 40,
                image: NetworkImage(
                    '${ApiBaseHelper.imageUrl}${providerGroup.image}' ?? " "),
                placeholder: AssetImage(FileConstants.icDoctorSpecialist)),
          ),
          SizedBox(width: 10),
          Text(
            providerGroup.groupType,
            style: const TextStyle(color:  AppColors.colorBlack85, fontSize: 14),
          ),
          SizedBox(width:10),
          Container(
            alignment: Alignment.center,
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7), color:  AppColors.colorYellow),
            child: Text(
              providerGroup.count.toString(),
              style: TextStyle(fontSize: 15),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
