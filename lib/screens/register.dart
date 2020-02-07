import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/models/user.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/register_email.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/password_widget.dart';
import 'package:hutano/widgets/widgets.dart';

import '../strings.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  String _genderGroup = "male";
  var _passKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final _passwordController = TextEditingController();

  bool checked = false;
  bool _obscureText = true;

  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  String email;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(() {
      setState(() {});
    });
    _lastNameController.addListener(() {
      setState(() {});
    });
    _emailController.addListener(() {
      setState(() {});
    });
    _addressController.addListener(() {
      setState(() {});
    });
    _cityController.addListener(() {
      setState(() {});
    });
    _stateController.addListener(() {
      setState(() {});
    });
    _codeController.addListener(() {
      setState(() {});
    });
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RegisterArguments args = ModalRoute.of(context).settings.arguments;
    email = args.email;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: getFormWidget(),
          padding: const EdgeInsets.fromLTRB(
              Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
        ),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(AppLogo());
    formWidget.add(
      Center(child: Text("Let's start creating your account.")),
    );

    formWidget.add(Widgets.sizedBox(height: 60.0));

    formWidget.add(Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            autofocus: true,
            controller: _firstNameController,
            decoration: InputDecoration(
                labelText: "First Name",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(5.0)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            keyboardType: TextInputType.text,
            onSaved: (value) {
              setState(() {});
            },
          ),
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 5.0, top: 5, bottom: 5),
            child: TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                  labelText: "Last Name",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(5.0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              keyboardType: TextInputType.text,
              onSaved: (value) {
                setState(() {});
              },
            ),
          ),
        ),
      ],
    ));

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      TextFormField(
        key: _emailKey,
        initialValue: email,
        autofocus: true,
        autovalidate: true,
        maxLines: 1,
        enabled: false,
        keyboardType: TextInputType.emailAddress,
        style: style,
        validator: Validations.validateEmail,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.grey),
          labelText: Strings.emailText,
          border: OutlineInputBorder(),
        ),
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
              labelText: "Phone",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(5.0)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          keyboardType: TextInputType.phone,
        ),
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      PasswordTextField(
          labelText: "Password",
          passwordController: _passwordController,
          passwordKey: _passwordKey,
          obscureText: _obscureText,
          style: style,
          suffixIcon: GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey),
          )),
    );

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      TextFormField(
        controller: _addressController,
        decoration: InputDecoration(
            labelText: "Address",
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(5.0)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        keyboardType: TextInputType.text,
        validator: Validations.validateEmpty,
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      TextFormField(
        controller: _cityController,
        decoration: InputDecoration(
            labelText: "City",
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300])),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          setState(() {});
        },
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: _stateController,
            decoration: InputDecoration(
                labelText: "State",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300])),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            keyboardType: TextInputType.emailAddress,
            // validator: validateEmail,
            onSaved: (value) {
              setState(() {});
            },
          ),
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: TextFormField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: "ZipCode",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300])),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onSaved: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    ));

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 5.0, top: 5, bottom: 5),
              child: GestureDetector(
                onTap: () => setState(() => _genderGroup = "male"),
                child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            color: _genderGroup == "male"
                                ? Colors.blue
                                : Colors.grey[300],
                            width: 1.0)),
                    child: Row(children: <Widget>[
                      Image(
                        image: AssetImage('images/male.png'),
                        height: 16.0,
                        width: 16.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Male",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ], mainAxisAlignment: MainAxisAlignment.center)),
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _genderGroup = "female"),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 1,
                      color: _genderGroup == "female"
                          ? Colors.blue
                          : Colors.grey[300],
                    )),
                child: Center(
                    child: Row(children: <Widget>[
                  Image(
                    image: AssetImage('images/female.png'),
                    height: 16.0,
                    width: 16.0,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Female",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ], mainAxisAlignment: MainAxisAlignment.center)),
              ),
            ),
          ),
        ],
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      TextFormField(
        key: _passKey,
        obscureText: true,
        decoration: InputDecoration(
            labelText: "Primary Language",
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300])),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 48.0));

    formWidget.add(
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 5),
        child: FancyButton(
          buttonHeight: Dimens.buttonHeight,
          title: "Next",
          onPressed: () {
            ApiBaseHelper api = new ApiBaseHelper();
            Map<String, String> loginData = Map();
            loginData["email"] = email;
            loginData["type"] = "1";
            loginData["step"] = "3";
            loginData["fullName"] = "user";
            loginData["password"] = _passwordController.text;

            api.register(loginData).then((dynamic response) {
              User user = User.fromJson(response);

              SharedPref().saveToken(user.tokens[0].token);
              SharedPref().saveValue("fullName", user.fullName);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.homeRoute, (Route<dynamic> route) => false);
            });
          },
        ),
      ),
    );

    return formWidget;
  }
}
