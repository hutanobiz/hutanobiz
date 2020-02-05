import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/validations.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField(
      {@required this.passwordKey,
      @required this.obscureText,
      @required this.suffixIcon,
      @required this.style,
      @required this.labelText,
      @required this.passwordController});

  final GlobalKey<FormFieldState> passwordKey;
  final TextEditingController passwordController;
  final bool obscureText;
  final Widget suffixIcon;
  final TextStyle style;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: passwordKey,
      autovalidate: true,
      maxLines: 1,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      style: style,
      validator: Validations.validatePassword,
      controller: passwordController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey),
        labelText: labelText,
        suffixIcon: suffixIcon,
        prefixIcon: Icon(Icons.lock, color: AppColors.windsor, size: 13.0),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(),
      ),
    );
  }
}
