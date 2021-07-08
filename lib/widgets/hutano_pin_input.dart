import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class HutanoPinInput extends StatelessWidget {
  final double width;
  final int pinCount;
  final Function onChanged;
  final Function onCompleted;
  final TextEditingController controller;

  const HutanoPinInput({
    Key key,
    @required this.width,
    @required this.pinCount,
    this.onChanged,
    this.onCompleted, 
    this.controller,
  })  : assert(width != null),
        assert(pinCount != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    var boxSize = width / (pinCount + 3);
    return Container(
      width: width,
      child: PinCodeTextField(
        controller: controller,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        backgroundColor: Colors.transparent,
        length: pinCount,
        keyboardType: TextInputType.number,
        animationType: AnimationType.fade,
        textStyle:const TextStyle(fontSize: 18),
        pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderWidth: 0.5,
            borderRadius: BorderRadius.circular(14),
            fieldHeight: boxSize + 6,
            fieldWidth: boxSize,
            inactiveColor:colorGrey12,
            activeFillColor: colorPurple,
            activeColor: colorPurple),
        animationDuration: Duration(milliseconds: 300),
        onCompleted:onCompleted,
        onChanged: onChanged,
        appContext: null,
      ),
    );
  }
}
