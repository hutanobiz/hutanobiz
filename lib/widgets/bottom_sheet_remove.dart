import 'package:flutter/material.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/constants/file_constants.dart';

import 'hutano_button.dart';

Future showBottomSheetRemove({
  required BuildContext context,
  Function? onRemove,
  Function? onCancel,
}) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return Container(
          child: Wrap(
            children: <Widget>[
              HutanoButton(
                buttonType: HutanoButtonType.withPrefixIcon,
                label: Strings.remove,
                color: Colors.white,
                labelColor: Colors.black,
                margin: 10,
                height: 60,
                onPressed: onRemove,
                fontSize: 18,
                icon: FileConstants.icBin,
                iconSize: 20,
              ),
              HutanoButton(
                label: Strings.cancel,
                margin: 10,
                color: Colors.white,
                labelColor: Colors.black,
                height: 60,
                fontSize: 18,
                onPressed: onCancel,
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      });
}
