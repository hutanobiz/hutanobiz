import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final EdgeInsets margin;
  final double size;
  final Function onTap;

  const CustomBackButton({Key key, this.margin, this.size = 32, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? onTap
          : () {
              Navigator.pop(context);
            },
      child: Container(
          margin: margin ?? const EdgeInsets.only(top: 15, left: 15),
          width: size,
          height: size,
          child: Icon(Icons.chevron_left_rounded),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: const Color(0x12372786), width: 0.5),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x4f8b8b8b),
                    offset: Offset(0, 2),
                    blurRadius: 30,
                    spreadRadius: 0)
              ],
              color: const Color(0xffffffff))),
    );
  }
}
