import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../utils/dimens.dart';

class TextWithImage extends StatelessWidget {
  final String image;
  final String label;
  final TextStyle textStyle;
  final double size;
  const TextWithImage({this.image, this.label, this.textStyle, this.size=spacing18});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: size,
          width: size,
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
