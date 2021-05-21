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
    this.autoValidate,
  });

  final TextStyle style;
  final TextEditingController emailController;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final GlobalKey<FormFieldState> emailKey;
  final bool isEnabled, autofocus;
  final String initialValue;
  final AutovalidateMode autoValidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: emailKey,
      initialValue: initialValue,
      autofocus: autofocus,
      autovalidateMode: autoValidate ?? AutovalidateMode.onUserInteraction,
      maxLines: 1,
      enabled: isEnabled,
      keyboardType: TextInputType.emailAddress,
      style: style,
      validator: Validations.validateEmail,
      controller: emailController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        labelText: Strings.emailText,
        suffixIcon: emailController.text.isNotEmpty &&
                emailKey.currentState != null &&
                emailKey.currentState.validate()
            ? suffixIcon
            : null,
        prefixIcon: prefixIcon != null ? prefixIcon : null,
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
        border: OutlineInputBorder(),
      ),
    );
  }
}
