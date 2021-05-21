import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key key,
      @required this.labelText,
      this.inputType,
      this.initialValue,
      this.maxLength,
      this.controller,
      @required this.onChanged,
      this.autoFocus,
      this.autoValidate,
      this.validator})
      : super(key: key);

  final String labelText;
  final String initialValue;
  final TextInputType inputType;
  final int maxLength;
  final Function onChanged;
  final TextEditingController controller;
  final bool autoFocus;
  final bool autoValidate;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      initialValue: initialValue ?? null,
      autofocus: autoFocus ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator ?? null,
      onChanged: onChanged,
      controller: controller ?? null,
      maxLength: maxLength ?? null,
      decoration: InputDecoration(
        labelText: labelText,
        counterText: "",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(5.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      keyboardType: inputType ?? TextInputType.text,
    );
  }
}
