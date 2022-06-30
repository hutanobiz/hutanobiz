import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showDropDownSheet({required BuildContext context, Widget? list,isFromFamilyCircle=false}) {
  return showModalBottomSheet(
    backgroundColor: isFromFamilyCircle?Colors.transparent:null,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, setState) => list!,
            );
          },
        );
      },
      context: context);
}
