import 'package:flutter/material.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/validations.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField(
      {required this.passwordKey,
      required this.obscureText,
      required this.suffixIcon,
      required this.style,
      required this.labelText,
      required this.passwordController,
      this.autoValidate,
      this.isDense,
      this.prefixIcon,
      this.validator});

  final GlobalKey<FormFieldState> passwordKey;
  final TextEditingController passwordController;
  final bool obscureText;
  final Widget suffixIcon;
  final Widget? prefixIcon;
  final TextStyle style;
  final bool? isDense;
  final String labelText;
  final String Function(String?)? validator;
  final AutovalidateMode? autoValidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: passwordKey,
      autovalidateMode: autoValidate ?? AutovalidateMode.onUserInteraction,
      maxLines: 1,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      style: style,
      validator: validator ?? Validations.validatePassword as String? Function(String?)?,
      controller: passwordController,
      decoration: InputDecoration(
        isDense: isDense ?? false,
        labelStyle: AppTextStyle.regularStyle(fontSize: 14),
        labelText: labelText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon != null ? prefixIcon : null,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
