import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../utils/dimens.dart';

Future showBottomSheet(
    {BuildContext context, Widget child, Color color = colorWhite}) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: color,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (ctx) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: spacing20,
              ),
              Container(
                height: 6,
                width: spacing50,
                decoration: BoxDecoration(
                    color: colorGrey, borderRadius: BorderRadius.circular(10)),
              ),
              child
            ],
          ));
}
