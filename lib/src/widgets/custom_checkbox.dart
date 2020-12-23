import 'package:flutter/material.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/utils/dimens.dart';
import 'package:hutano/src/utils/localization/localization.dart';

class CustomCheckBox extends StatefulWidget {
   CustomCheckBox({
    Key key,
    @required this.onSelect,
    this.selected =false
  }) : super(key: key);

  final ValueChanged<bool> onSelect;
   bool selected;

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {

  void _onTap() {
    setState(() {
      widget.selected = !widget.selected;
    });
    widget.onSelect(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onTap();
      },
      child: Row(
        children: [
          if (!widget.selected)
            Container(
              height: 13,
              width: 13,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(width: 0.1, color: colorBorderCheckbox),
                    boxShadow: [
                      BoxShadow(
                        color: colorShadowCheckbox,
                        blurRadius: 1,
                        spreadRadius: 0.6,
                        offset: Offset(0, 0.8),
                      )
                    ],
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
          if (widget.selected) Image.asset(FileConstants.icCheckBox, width: 16),
          Padding(
            padding: const EdgeInsets.only(left: spacing15),
            child: Center(
              child: Text(
                Localization.of(context).remembermeTitle,
                style: TextStyle(color: colorBlack45, fontSize: fontSize12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
