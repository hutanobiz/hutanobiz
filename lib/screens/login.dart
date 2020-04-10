import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/email_widget.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/password_widget.dart';
import 'package:hutano/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  Map<String, String> loginData = Map();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool checked = false;
  bool _obscureText = true;
  bool isLoading = false;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setState(() {});
    });

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LoadingView(
            isLoading: isLoading,
            widget: ListView(
              physics: new ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                  Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
              children: widgetList(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = new List();

    formWidget.add(AppLogo());
    formWidget.add(Widgets.sizedBox(height: 51.0));
    formWidget.add(EmailTextField(
      emailKey: _emailKey,
      emailController: _emailController,
      style: style,
      prefixIcon: Icon(Icons.email, color: AppColors.windsor, size: 13.0),
      suffixIcon: Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
    ));
    formWidget.add(Widgets.sizedBox(height: 30.0));
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
    formWidget.add(Widgets.sizedBox(height: 5.0));

    formWidget.add(Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
          onPressed: () =>
              Navigator.pushNamed(context, Routes.forgotPasswordRoute),
          child: Text(
            "Forgot Password?",
            style: TextStyle(color: AppColors.windsor, fontSize: 12.0),
          )),
    ));

    formWidget.add(Widgets.sizedBox(height: 16.0));

    formWidget.add(FancyButton(
      buttonHeight: Dimens.buttonHeight,
      title: Strings.logIn,
      onPressed: isButtonEnable()
          ? () {
              _formKey.currentState.save();

              loginData["email"] = _emailController.text.toString();
              loginData["password"] = _passwordController.text.toString();
              loginData["type"] = "1";

              onClick();
            }
          : null,
    ));

    formWidget.add(Widgets.sizedBox(height: 13.0));

    formWidget.add(
      FlatButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.registerEmailRoute);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Don't have an account.",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 14.0),
            ),
            SizedBox(width: 2.0),
            Text(
              "Register",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: AppColors.sunglow,
                  fontSize: 14.0),
            )
          ],
        ),
      ),
    );

    return formWidget;
  }

  void onClick() {
    ApiBaseHelper api = ApiBaseHelper();

    setLoading(true);

    try {
      api
          .login(loginData)
          .then((dynamic response) {
            Widgets.showToast(Strings.loggedIn);

            setLoading(false);
            Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.dashboardScreen, (Route<dynamic> route) => false);

            InheritedContainer.of(context).setUserData(response);
            SharedPref().saveToken(response["tokens"][0]["token"].toString());
          })
          .timeout(const Duration(seconds: 10))
          .catchError((onError) {
            setLoading(false);
            print(onError);
          });
    } on TimeoutException catch (_) {
      Widgets.showToast("Timeout!");
    }
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  bool isButtonEnable() {
    if (_emailController.text.isEmpty || !_emailKey.currentState.validate()) {
      return false;
    } else if (_passwordController.text.isEmpty ||
        !_passwordKey.currentState.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
