import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/email_widget.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/widgets.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool checked = false;
  bool _obscureText = true;

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
      key: _scaffoldKey,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            physics: new ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
                Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
            children: widgetList(),
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
      suffixIcon: Icon(
        Icons.check_circle,
        color: Colors.green,
        // size: 18.0,
      ),
    ));
    formWidget.add(Widgets.sizedBox(height: 30.0));
    formWidget.add(passwordField());
    formWidget.add(Widgets.sizedBox(height: 30.0));
    formWidget.add(FancyButton(
      buttonHeight: Dimens.buttonHeight,
      title: Strings.logIn,
      onPressed: () {
        if (_emailController.text.isNotEmpty &&
            _formKey.currentState.validate()) {
          _formKey.currentState.save();
          Navigator.pushNamed(context, "/second");
        }
      },
    ));
    formWidget.add(Widgets.sizedBox(height: 30.0));

    return formWidget;
  }

  Widget passwordField() => TextFormField(
        autovalidate: true,
        maxLines: 1,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _obscureText,
        style: style,
        validator: Validations.validatePassword,
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: Strings.passwordText,
          suffixIcon: GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          prefixIcon: Icon(Icons.lock, color: AppColors.windsor, size: 13.0),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(),
        ),
      );
}
