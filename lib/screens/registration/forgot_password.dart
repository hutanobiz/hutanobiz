import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/email_widget.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/widgets.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final _emailController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);

  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
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
          physics: new ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
              Dimens.padding, 51.0, Dimens.padding, Dimens.padding),
          children: getFormWidget(),
        ),
      ),
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(AppLogo());
    formWidget.add(Widgets.sizedBox(height: 51.0));

    formWidget.add(Column(
      children: <Widget>[
        Text(
          "Forgot Password",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Widgets.sizedBox(height: 10.0),
        Text(
          "Please enter your e-mail address.\nWe will send you link to reset your password.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black26,
              fontSize: 13.0,
              fontWeight: FontWeight.normal),
        ),
      ],
    ));

    formWidget.add(Widgets.sizedBox(height: 42.0));

    formWidget.add(EmailTextField(
      emailKey: _emailKey,
      emailController: _emailController,
      style: style,
      suffixIcon: Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
    ));

    formWidget.add(Widgets.sizedBox(height: 42.0));

    formWidget.add(
      FancyButton(
        title: "Confirm",
        onPressed: isButtonEnable()
            ? () {
                setLoading(true);

                ApiBaseHelper api = new ApiBaseHelper();
                Map<String, String> loginData = Map();
                loginData["email"] = _emailController.text.toString();
                loginData["step"] = "1";
                api.resetPassword(loginData).then((dynamic user) {
                  setLoading(false);
                  
                  Widgets.showToast(user.toString());

                  Navigator.pushNamed(
                    context,
                    Routes.verifyOtpRoute,
                    arguments: RegisterArguments(_emailController.text, true),
                  );
                }).futureError((error) {
                  setLoading(false);
                  error.toString().debugLog();
                });
              }
            : null,
        buttonHeight: Dimens.buttonHeight,
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 13.0));

    formWidget.add(
      FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.arrow_back,
              color: AppColors.windsor,
              size: 17.0,
            ),
            SizedBox(width: 5.0),
            Text(
              "Return to Log In.",
              style: TextStyle(color: AppColors.windsor, fontSize: 14.0),
            )
          ],
        ),
      ),
    );

    return formWidget;
  }

  bool isButtonEnable() {
    if (_emailController.text.isEmpty || !_emailKey.currentState.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
