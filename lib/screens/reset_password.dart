import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/password_widget.dart';
import 'package:hutano/widgets/widgets.dart';

import '../colors.dart';
import '../routes.dart';
import '../strings.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key key, @required this.args}) : super(key: key);

  final RegisterArguments args;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email;

  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmPassKey = GlobalKey<FormFieldState>();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscureText = true;
  bool isLoading = false;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _confirmPassController.addListener(() {
      setState(() {});
    });

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    email = widget.args.email;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          child: ListView(
            children: getFormWidget(),
            padding: const EdgeInsets.fromLTRB(
                Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
          ),
        ),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(AppLogo());

    formWidget.add(Widgets.sizedBox(height: 43.0));

    formWidget.add(Column(
      children: <Widget>[
        Text(
          "Reset Password",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Widgets.sizedBox(height: 10.0),
        Text(
          "Create your new password.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black26,
              fontSize: 13.0,
              fontWeight: FontWeight.bold),
        ),
      ],
    ));

    formWidget.add(Widgets.sizedBox(height: 60.0));

    formWidget.add(PasswordTextField(
      passwordKey: _passwordKey,
      obscureText: _obscureText,
      labelText: Strings.passwordText,
      passwordController: _passwordController,
      style: style,
      prefixIcon: Icon(Icons.lock, color: AppColors.windsor, size: 13.0),
      suffixIcon: GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey),
      ),
    ));

    formWidget.add(Widgets.sizedBox(height: 30.0));

    formWidget.add(PasswordTextField(
      passwordKey: _confirmPassKey,
      obscureText: _obscureText,
      labelText: "Confirm Password",
      passwordController: _confirmPassController,
      style: style,
      prefixIcon: Icon(Icons.lock, color: AppColors.windsor, size: 13.0),
      suffixIcon: GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey),
      ),
    ));

    formWidget.add(Widgets.sizedBox(height: 30.0));

    formWidget.add(
      FancyButton(
        title: "Next",
        onPressed: isButtonEnable()
            ? () {
                ApiBaseHelper api = new ApiBaseHelper();
                Map<String, String> loginData = Map();
                loginData["email"] = email;
                loginData["step"] = "3";
                loginData["password"] = _passwordController.text;
                api.resetPassword(loginData).then((dynamic user) {
                  Widgets.showToast("Password reset successfully!");

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.loginRoute, (Route<dynamic> route) => false);
                });
              }
            : null,
        buttonHeight: Dimens.buttonHeight,
      ),
    );

    return formWidget;
  }

  bool isButtonEnable() {
    if (_passwordController.text.isEmpty ||
        !_passwordKey.currentState.validate()) {
      return false;
    } else if (_confirmPassController.text.isEmpty ||
        !_confirmPassKey.currentState.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
