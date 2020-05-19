import 'package:flutter/material.dart';

class RoundCornerCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onCheck;
  final String title;
  final TextStyle textStyle;

  RoundCornerCheckBox({
    Key key,
    @required this.value,
    @required this.onCheck,
    this.title,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onCheck(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
          title == null ? Container() : SizedBox(width: 10),
          title == null
              ? Container()
              : Text(
                  title,
                  style: textStyle ??
                      TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
        ],
      ),
    );
  }
}

// class RoundCornerCheckBox extends StatefulWidget {
//   final bool value;
//   final Function onCheck;
//   final Text title;

//   RoundCornerCheckBox({
//     Key key,
//     @required this.value,
//     @required this.onCheck,
//     this.title,
//   }) : super(key: key);

//   @override
//   _RoundCornerCheckBoxState createState() => _RoundCornerCheckBoxState();
// }

// class _RoundCornerCheckBoxState extends State<RoundCornerCheckBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         InkWell(
//           child: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: SizedBox(
//               height: 24,
//               width: 24,
//               child: widget.value
//                   ? Image.asset("images/checkedCheck.png")
//                   : Image.asset("images/uncheckedCheck.png"),
//             ),
//           ),
//           onTap: widget.onCheck,
//         ),
//       title==null?Container():  SizedBox(width: 10),
//         Text(
//           "I Agree",
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }
