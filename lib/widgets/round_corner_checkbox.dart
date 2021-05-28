import 'package:flutter/material.dart';

class RoundCornerCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onCheck;
  final String title;
  final TextStyle textStyle;
  final double textPadding;

  RoundCornerCheckBox({
    Key key,
    @required this.value,
    @required this.onCheck,
    this.title,
    this.textStyle,
    this.textPadding = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onCheck(!value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 24,
              width: 24,
              child: value
                  ? Image.asset("images/checkedCheck.png")
                  : Image.asset("images/uncheckedCheck.png"),
            ),
          ),
          title == null ? Container() : SizedBox(width: textPadding),
          title == null
              ? Container()
              : Flexible(
                  child: Text(
                    title,
                    style: textStyle ??
                        TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
        ],
      ),
    );
  }
}
