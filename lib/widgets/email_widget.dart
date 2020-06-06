import 'package:flutter/material.dart';
import 'package:hutano/utils/validations.dart';

import '../strings.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    this.emailKey,
    this.style,
    this.emailController,
    this.suffixIcon,
    this.prefixIcon,
    this.isEnabled = true,
    this.initialValue,
    this.autofocus = true,
  });

  final TextStyle style;
  final TextEditingController emailController;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final GlobalKey<FormFieldState> emailKey;
  final bool isEnabled, autofocus;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: emailKey,
      initialValue: initialValue,
      autofocus: autofocus,
      autovalidate: true,
      maxLines: 1,
      enabled: isEnabled,
      keyboardType: TextInputType.emailAddress,
      style: style,
      validator: Validations.validateEmail,
      controller: emailController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey),
        labelText: Strings.emailText,
        suffixIcon:
            emailController.text.isNotEmpty && emailKey.currentState.validate()
                ? suffixIcon
                : null,
        prefixIcon: prefixIcon != null ? prefixIcon : null,
        // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
        border: OutlineInputBorder(),
      ),
    );
  }
}
