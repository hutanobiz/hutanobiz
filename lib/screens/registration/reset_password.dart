import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/forgotpassword/model/req_reset_password.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/hutano_button.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/password_widget.dart';
import 'package:hutano/widgets/widgets.dart';

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

  bool _obscureText = true, _confirmObscureText = true;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();

    _passwordController.dispose();
    _confirmPassController.dispose();
  }

  @override
  void initState() {
    super.initState();

    email = widget.args.phoneNumber;

    _confirmPassController.addListener(() {
      setState(() {});
    });

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoadingView(
        isLoading: isLoading,
        child: ListView(
          children: resetPasswordWidget(),
          padding: const EdgeInsets.fromLTRB(
            Dimens.padding,
            51.0,
            Dimens.padding,
            Dimens.padding,
          ),
        ),
      ),
    );
  }

  List<Widget> resetPasswordWidget() {
    List<Widget> widgetList = new List();

    widgetList.add(AppLogo());

    widgetList.add(Widgets.sizedBox(height: 43.0));

    widgetList.add(Column(
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

    widgetList.add(Widgets.sizedBox(height: 60.0));

    widgetList.add(PasswordTextField(
      passwordKey: _passwordKey,
      obscureText: _obscureText,
      labelText: Strings.passwordText,
      passwordController: _passwordController,
      style: AppTextStyle.regularStyle(fontSize: 14),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Image.asset('images/lock.png', height: 12),
      ),
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

    widgetList.add(Widgets.sizedBox(height: 30.0));

    widgetList.add(PasswordTextField(
      passwordKey: _confirmPassKey,
      obscureText: _confirmObscureText,
      labelText: "Confirm Password",
      passwordController: _confirmPassController,
      style: AppTextStyle.regularStyle(fontSize: 14),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Image.asset('images/lock.png', height: 12),
      ),
      suffixIcon: GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onTap: () {
          setState(() {
            _confirmObscureText = !_confirmObscureText;
          });
        },
        child: Icon(
            _confirmObscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey),
      ),
    ));

    widgetList.add(Widgets.sizedBox(height: 30.0));

    widgetList.add(
      HutanoButton(
        label: "Next",
        onPressed: isButtonEnable()
            ? () {
                setLoading(true);
                ApiBaseHelper api = new ApiBaseHelper();
                // Map<String, String> loginData = Map();
                // loginData["phoneNumber"] = email;
                // loginData["step"] = "3";
                // loginData["password"] = _passwordController.text;
                var loginData = ReqResetPassword(
                    phoneNumber: email,
                    step: 3,
                    password: _passwordController.text);
                api.resetPassword(loginData).then((dynamic user) {
                  setLoading(false);
                  Widgets.showToast("Password reset successfully!");
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.resetPasswordSuccess);
                }).futureError((error) {
                  setLoading(false);
                  error.toString().debugLog();
                });
              }
            : null,
        height: Dimens.buttonHeight,
      ),
    );

    return widgetList;
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

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
