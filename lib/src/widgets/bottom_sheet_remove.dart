import 'package:flutter/material.dart';
import '../utils/constants/file_constants.dart';
import '../utils/dimens.dart';
import '../utils/localization/localization.dart';

import 'hutano_button.dart';

Future showBottomSheetRemove({BuildContext context,
Function onRemove,
Function onCancel,}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return Container(
          child: Wrap(
            children: <Widget>[
              HutanoButton(
                buttonType:HutanoButtonType.withPrefixIcon ,
                label: Localization.of(context).remove,
                color: Colors.white,
                labelColor: Colors.black,
                margin: spacing10,
                height: 60,
                onPressed: onRemove,
                fontSize:fontSize18 ,
                icon: FileConstants.icBin,
                iconSize: 20,
              ),
              HutanoButton(
                label: Localization.of(context).cancel,
                margin: spacing10,
                color: Colors.white,
                labelColor: Colors.black,
                height: 60,
                fontSize:fontSize18 ,
                onPressed: onCancel,
              ),
              SizedBox(
                height: spacing20,
              )

            ],
          ),
        );
      });
}
