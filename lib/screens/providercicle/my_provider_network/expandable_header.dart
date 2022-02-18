import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/providercicle/provider_add_network/model/provider_network.dart';
import 'package:hutano/utils/app_config.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/progress_dialog.dart';
import 'package:hutano/widgets/controller.dart';
import 'model/provider_group.dart';

class ExpandableHeader extends StatelessWidget {
  final ProviderGroup providerGroup;
  final Function onDelete;
  final int pos;

  const ExpandableHeader({Key key, this.providerGroup, this.onDelete, this.pos})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // SizedBox(width: spacing5),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10),
          //   child: FadeInImage(
          //       height: spacing40,
          //       fit: BoxFit.cover,
          //       width: spacing40,
          //       image: NetworkImage('$imageUrl${providerGroup.image}' ?? " "),
          //       placeholder: AssetImage(FileConstants.icDoctorSpecialist)),
          // ),
          // SizedBox(width: spacing10),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    providerGroup.groupType,
                    style: const TextStyle(
                        color: colorBlack85, fontSize: fontSize14),
                  ),
                ),
                SizedBox(width: spacing10),
                Container(
                  alignment: Alignment.center,
                  height: spacing25,
                  width: spacing25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: colorYellow),
                  child: Text(
                    providerGroup.count.toString(),
                    style: TextStyle(fontSize: fontSize15),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onPressed: () {
              onDelete(pos);
            },
          )
        ],
      ),
    );
  }
}
