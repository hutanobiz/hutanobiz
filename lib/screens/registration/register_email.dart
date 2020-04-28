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

class RegisterEmail extends StatefulWidget {
  RegisterEmail({Key key}) : super(key: key);

  @override
  _RegisterEmailState createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
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
      resizeToAvoidBottomPadding: false,
      body: LoadingView(
        isLoading: isLoading,
        child: ListView(
            children: getFormWidget(),
            padding: const EdgeInsets.fromLTRB(
                Dimens.padding, 51.0, Dimens.padding, Dimens.padding)),
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(AppLogo());

    formWidget.add(Widgets.sizedBox(height: 51.0));

    formWidget.add(Column(
      children: <Widget>[
        Text(
          "Welcome To Hutano",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Widgets.sizedBox(height: 10.0),
        Text(
          "Please enter your Email.\n A 6 digit OTP will be sent to verify your email!",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black26,
              fontSize: 13.0,
              fontWeight: FontWeight.bold),
        ),
      ],
    ));

    formWidget.add(Widgets.sizedBox(height: 42.0));

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

    formWidget.add(Widgets.sizedBox(height: 42.0));

    formWidget.add(
      FancyButton(
        title: "Next",
        onPressed: isButtonEnable()
            ? () {
                setLoading(true);
                
                ApiBaseHelper api = new ApiBaseHelper();

                Map<String, String> loginData = Map();
                loginData["email"] = _emailController.text.toString();
                loginData["type"] = "1";
                loginData["step"] = "1";
                loginData["fullName"] = "user";
                api.register(loginData).then((dynamic user) {
                  setLoading(false);

                  Widgets.showToast(user.toString());

                  Navigator.pushNamed(
                    context,
                    Routes.verifyOtpRoute,
                    arguments: RegisterArguments(_emailController.text, false),
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

    return formWidget;
  }

  bool isButtonEnable() {
    if (_emailController.text.isEmpty || !_emailKey.currentState.validate()) {
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
