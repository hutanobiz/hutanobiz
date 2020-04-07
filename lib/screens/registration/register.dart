import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/user.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/password_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Register extends StatefulWidget {
  Register({Key key, @required this.args}) : super(key: key);

  final RegisterArguments args;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _zipController = TextEditingController();
  final _langController =
      TextEditingController(text: "Select Primary Language");
  List languages = ['English', 'Spanish', 'French', 'Mandarin', 'Tigalog'];

  String _genderGroup = "";
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+# (###) ###-####', filter: {"#": RegExp(r'[0-9]')});

  ApiBaseHelper api = new ApiBaseHelper();
  List stateList;

  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final _passwordController = TextEditingController();

  bool checked = false;
  bool _obscureText = true;

  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  String email;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    api.getStates().then((value) {
      stateList = value;
    });

    _firstNameController.addListener(() {
      setState(() {});
    });
    _lastNameController.addListener(() {
      setState(() {});
    });
    _emailController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
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
    _zipController.addListener(() {
      setState(() {});
    });
    _phoneController.addListener(() {
      setState(() {});
    });
    _langController.addListener(() {
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
    _zipController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    email = widget.args.email;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: LoadingView(
          isLoading: isLoading,
          widget: ListView(
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
          inputFormatters: [maskFormatter],
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
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(Row(
      children: <Widget>[
        Expanded(
            child: picker(_stateController, "State",
                () => listBottomDialog(stateList, _stateController))),
        SizedBox(width: 20.0),
        Expanded(
          child: TextFormField(
            controller: _zipController,
            decoration: InputDecoration(
              labelText: "Zip Code",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300])),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            keyboardType: TextInputType.number,
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
                                ? AppColors.female
                                : Colors.grey[300],
                            width: 1.0)),
                    child: Row(children: <Widget>[
                      Image(
                        image: AssetImage('images/male.png'),
                        height: 16.0,
                        width: 16.0,
                        color: _genderGroup == "male"
                            ? AppColors.female
                            : Colors.blue,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Male",
                        style: TextStyle(
                          color: _genderGroup == "male"
                              ? AppColors.female
                              : Colors.blue,
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
                          ? AppColors.female
                          : Colors.grey[300],
                    )),
                child: Center(
                    child: Row(children: <Widget>[
                  Image(
                    image: AssetImage('images/female.png'),
                    height: 16.0,
                    width: 16.0,
                    color: _genderGroup == "female"
                        ? AppColors.female
                        : Colors.blue,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Female",
                    style: TextStyle(
                      color: _genderGroup == "female"
                          ? AppColors.female
                          : Colors.blue,
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

    formWidget.add(picker(_langController, "Primary Language",
        () => languageBottomDialog(languages, _langController)));

    formWidget.add(Widgets.sizedBox(height: 48.0));

    formWidget.add(
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 5),
        child: FancyButton(
          buttonHeight: Dimens.buttonHeight,
          title: "Next",
          onPressed: isValidate()
              ? () {
                  setLoading(true);

                  Map<String, String> loginData = Map();
                  loginData["email"] = email;
                  loginData["type"] = "1";
                  loginData["step"] = "3";
                  loginData["fullName"] =
                      "${_firstNameController.text} ${_lastNameController.text}";
                  loginData["password"] = _passwordController.text;
                  loginData["address"] = _addressController.text;
                  loginData["city"] = _cityController.text;
                  loginData["state"] = _stateController.text;
                  loginData["zipCode"] = _zipController.text;
                  loginData["phoneNumber"] =
                      maskFormatter.getUnmaskedText().toString();
                  loginData["gender"] = _genderGroup.trim().toString();
                  loginData["language"] = _langController.text;

                  api
                      .register(loginData)
                      .then((dynamic response) {
                        setLoading(false);
                        SharedPref().saveToken(response["tokens"][0]["token"]);
                        SharedPref().setValue("fullName", response["fullName"]);

                        Widgets.showToast("Profile created successfully");

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.dashboardScreen,
                            (Route<dynamic> route) => false);
                      })
                      .timeout(Duration(seconds: 10))
                      .catchError((error) {
                        setLoading(false);
                        Widgets.showToast(error);
                      });
                }
              : null,
        ),
      ),
    );

    return formWidget;
  }

  Widget picker(final controller, String labelText, onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey[300],
        onTap: onTap,
        child: TextFormField(
          controller: controller,
          enabled: false,
          style: const TextStyle(fontSize: 14.0, color: Colors.black87),
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.nero,
            ),
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  void listBottomDialog(List<dynamic> list, TextEditingController controller) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Center(
                  child: Text(
                    list[index]["title"],
                    style: TextStyle(
                      color: list[index]["title"] == controller.text
                          ? AppColors.goldenTainoi
                          : Colors.black,
                      fontSize:
                          list[index]["title"] == controller.text ? 20.0 : 16.0,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    controller.text = list[index]["title"];
                    Navigator.pop(context);
                  });
                },
              );
            },
          );
        });
  }

  void languageBottomDialog(list, controller) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Center(
                  child: Text(
                    list[index],
                    style: TextStyle(
                      color: list[index] == controller.text
                          ? AppColors.goldenTainoi
                          : Colors.black,
                      fontSize: list[index] == controller.text ? 20.0 : 16.0,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    controller.text = list[index];
                    Navigator.pop(context);
                  });
                },
              );
            },
          );
        });
  }

  bool isValidate() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _zipController.text.isEmpty ||
        _langController.text.isEmpty)
      return false;
    else if (_passwordController.text.length < 6)
      return false;
    else
      return true;
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
