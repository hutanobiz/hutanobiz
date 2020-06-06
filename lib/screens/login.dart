import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/registration/register.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/password_widget.dart';
import 'package:hutano/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  Map<String, String> _loginDataMap = Map();

  final GlobalKey<FormFieldState> _phoneNumberKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  final _mobileFormatter = UsNumberTextInputFormatter();

  bool checked = false;
  bool _obscureText = true;
  bool isLoading = false;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);

  @override
  void dispose() {
    super.dispose();

    _phoneNumberController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
     final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }
    _firebaseMessaging.getToken().then((String token) {
      SharedPref().setValue("deviceToken", token);
      print(token);
    });

    _phoneNumberController.addListener(() {
      setState(() {});
    });

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: LoadingView(
        isLoading: isLoading,
        child: ListView(
          physics: new ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
              Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
          children: widgetList(),
        ),
      ),
    );
  }

  List<Widget> widgetList() {
    List<Widget> formWidget = new List();

    formWidget.add(AppLogo());
    formWidget.add(Widgets.sizedBox(height: 51.0));
    formWidget.add(
      TextFormField(
        key: _phoneNumberKey,
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        validator: Validations.validatePhone,
        inputFormatters: [
          LengthLimitingTextInputFormatter(14),
          WhitelistingTextInputFormatter.digitsOnly,
          _mobileFormatter,
        ],
        autocorrect: true,
        decoration: InputDecoration(
            labelText: "Phone",
            prefix: Text(
              "+1",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(5.0)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );
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
              _loginDataMap["phoneNumber"] =
                  _phoneNumberController.text.toString();
              _loginDataMap["password"] = _passwordController.text.toString();
              _loginDataMap["type"] = "1";

              onLoginApi();
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

  void onLoginApi() {
    ApiBaseHelper api = ApiBaseHelper();

    setLoading(true);

    api.login(_loginDataMap).then((dynamic response) {
      Widgets.showToast(Strings.loggedIn);

      setLoading(false);
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.dashboardScreen, (Route<dynamic> route) => false);

      SharedPref().saveToken(response["tokens"][0]["token"].toString());
      SharedPref().setValue("fullName", response["fullName"].toString());
    }).futureError((error) {
      setLoading(false);
      error.toString().debugLog();
    });
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  bool isButtonEnable() {
    if (_phoneNumberController.text.isEmpty ||
        !_phoneNumberKey.currentState.validate()) {
      return false;
    } else if (_passwordController.text.isEmpty ||
        !_passwordKey.currentState.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
