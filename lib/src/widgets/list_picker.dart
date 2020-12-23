import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showDropDownSheet({BuildContext context, Widget list}) {
  return showModalBottomSheet(
      builder: (context) {
        return list;
      },
      context: context);
}
