import 'package:flutter/material.dart';
import 'package:hutano/utils/validations.dart';

import '../colors.dart';
import '../strings.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField(
      {this.emailKey, this.style, this.emailController, this.suffixIcon});

  final TextStyle style;
  final TextEditingController emailController;
  final Icon suffixIcon;
  final GlobalKey<FormFieldState> emailKey;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: emailKey,
      autofocus: true,
      autovalidate: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      style: style,
      validator: Validations.validateEmail,
      controller: emailController,
      decoration: InputDecoration(
        labelText: Strings.emailText,
        suffix:
            emailController.text.isNotEmpty && emailKey.currentState.validate()
                ? FittedBox(
                    child: suffixIcon,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center,
                  )
                : null,
        prefixIcon: const Icon(Icons.email, color: AppColors.windsor, size: 13.0),
        // contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
        border: OutlineInputBorder(),
      ),
    );
  }
}
