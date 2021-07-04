import 'package:flutter/material.dart';
import '../utils/dimens.dart';

import 'app_logo.dart';

class HutanoHeader extends StatelessWidget {
  final Widget headerInfo;
  final Widget headerLabel;
  final double spacing;

  const HutanoHeader({
    Key key, 
    this.headerInfo,
    this.headerLabel,
    this.spacing =40
    })
      : assert(headerInfo != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppLogo(),
        if(headerLabel!=null) headerLabel,
        SizedBox(
          height: 35,
        ),
        headerInfo,
        SizedBox(
          height: spacing,
        ),
      ],
    );
  }
}
