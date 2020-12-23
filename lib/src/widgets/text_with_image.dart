import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../utils/dimens.dart';

class TextWithImage extends StatelessWidget {
  final String image;
  final String label;
  final TextStyle textStyle;
  const TextWithImage({this.image, this.label, this.textStyle});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: spacing18,
          width: spacing18,
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            label,
            style: textStyle ??
                const TextStyle(color: colorBlack70, fontSize: fontSize12),
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
