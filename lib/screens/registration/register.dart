import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
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
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Register extends StatefulWidget {
  Register({Key key, @required this.args}) : super(key: key);

  final RegisterArguments args;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<Register> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _zipController = TextEditingController();
  // final _langController =
  //     TextEditingController(text: "Select Primary Language");
  // List languages = ['English', 'Spanish', 'French', 'Mandarin', 'Tigalog'];
  String stateId = "";

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
  File profileImage;
  bool isLoading = false;
  DateTime _selectedDate;

  final _dobController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedDate = DateTime.now();

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
    // _langController.addListener(() {
    //   setState(() {});
    // });
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
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    email = widget.args.email;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: LoadingView(
          isLoading: isLoading,
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
    formWidget.add(
      Center(
          child: Text(
        "Let's start creating your account.",
        style: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
        ),
      )),
    );

    formWidget.add(Widgets.sizedBox(height: 26.0));

    formWidget.add(Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 100.0,
          height: 100.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[300],
            ),
          ),
          child: profileImage == null
              ? "ic_profile".imageIcon(
                  height: 27,
                  width: 27,
                )
              : ClipOval(
                  child: Image.file(
                    profileImage,
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "images/ic_upload.png",
                height: 14.0,
                width: 17.0,
                color: AppColors.persian_indigo,
              ),
              SizedBox(width: 6),
              Text(
                "Upload photo",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ).onClick(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            showPickerDialog();
          },
        )
      ],
    ));

    formWidget.add(Widgets.sizedBox(height: 35.0));

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
      TextFormField(
        enabled: false,
        controller: _dobController,
        decoration: InputDecoration(
          suffixIcon: Container(
            height: 16,
            width: 16,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: "ic_calendar".imageIcon(
              width: 16,
              height: 16,
              color: AppColors.persian_indigo,
            ),
          ),
          labelText: "Date of Birth",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ).onClick(onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showDatePicker(
          context: context,
          initialDate: DateTime(DateTime.now().year - 18, DateTime.now().month,
              DateTime.now().day),
          firstDate: DateTime(1880),
          lastDate: DateTime(DateTime.now().year - 18, DateTime.now().month,
              DateTime.now().day),
        ).then((date) {
          if (date != null)
            setState(() {
              _selectedDate = date;
              var aa = DateFormat('dd').format(date) +
                  ' ' +
                  DateFormat('MMMM').format(date) +
                  ' ' +
                  date.year.toString();

              if (((DateTime.now().difference(date).inDays) / 365).floor() >=
                  18) {
                _dobController.text = aa;
              } else {
                Widgets.showToast("Minimum age should be 18");
              }
            });
        });
      }),
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
            child: picker(_stateController, "State", () {
          FocusScope.of(context).requestFocus(FocusNode());
          listBottomDialog(stateList, _stateController);
        })),
        SizedBox(width: 20.0),
        Expanded(
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
            ],
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

    // formWidget.add(picker(_langController, "Primary Language", () {
    //   FocusScope.of(context).requestFocus(FocusNode());
    //   languageBottomDialog(languages, _langController);
    // }));

    // formWidget.add(Widgets.sizedBox(height: 48.0));

    formWidget.add(
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 5),
        child: FancyButton(
          buttonHeight: Dimens.buttonHeight,
          title: "Next",
          onPressed: isValidate()
              ? () {
                  Map<String, String> loginData = Map();
                  loginData["email"] = email;
                  loginData["type"] = "1";
                  loginData["step"] = "3";
                  loginData["fullName"] =
                      "${_firstNameController.text} ${_lastNameController.text}";
                  loginData["firstName"] = _firstNameController.text;
                  loginData["lastName"] = _lastNameController.text;
                  loginData["password"] = _passwordController.text;
                  loginData["address"] = _addressController.text;
                  loginData["city"] = _cityController.text;
                  loginData["state"] = _stateController.text;
                  loginData["zipCode"] = _zipController.text;
                  loginData["phoneNumber"] =
                      maskFormatter.getUnmaskedText().toString();
                  loginData["gender"] =
                      _genderGroup.trim().toString() == "male" ? "1" : "2";
                  // loginData["language"] = _langController.text;
                  loginData["state"] = stateId;
                  loginData["dob"] =
                      DateFormat("MM/dd/yyyy").format(_selectedDate).toString();

                  if (profileImage != null) {
                    _register(loginData);
                  } else {
                    Widgets.showToast("Please upload your profile pic");
                  }
                }
              : null,
        ),
      ),
    );

    return formWidget;
  }

  _register(Map<String, String> loginData) async {
    try {
      setLoading(true);
      Uri uri = Uri.parse(ApiBaseHelper.base_url + "auth/api/register");
      http.MultipartRequest request = http.MultipartRequest('POST', uri);

      request.fields.addAll(loginData);

      var stream = http.ByteStream(DelegatingStream(profileImage.openRead()));
      var length = await profileImage.length();

      request.files.add(http.MultipartFile("avatar", stream.cast(), length,
          filename: profileImage.path));

      http.StreamedResponse response = await request.send();
      final int statusCode = response.statusCode;
      log("Status code: $statusCode");

      JsonDecoder _decoder = new JsonDecoder();

      String respStr = await response.stream.bytesToString();
      var responseJson = _decoder.convert(respStr);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        setLoading(false);
        if (responseJson["response"] is String)
          Widgets.showToast(responseJson["response"]);
        else if (responseJson["response"] is Map)
          Widgets.showToast(responseJson);
        else {
          responseJson["response"]
              .map((m) => Widgets.showToast(m.toString()))
              .toList();
        }

        responseJson["response"].toString().debugLog();
        throw Exception(responseJson);
      } else {
        responseJson["response"].toString().debugLog();

        SharedPref()
            .saveToken(responseJson["response"][0]["tokens"][0]["token"]);
        SharedPref()
            .setValue("fullName", responseJson["response"][0]["fullName"]);
        SharedPref().setValue("complete", "0");

        Widgets.showToast("Profile created successfully");

        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.dashboardScreen, (Route<dynamic> route) => false);

        setLoading(false);
      }
    } on Exception catch (error) {
      setLoading(false);
      error.toString().debugLog();
    }
  }

  void showPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Picker"),
          content: new Text("Select image picker type."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Camera"),
              onPressed: () {
                getImage(1);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Gallery"),
              onPressed: () {
                getImage(2);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future getImage(int source) async {
    var image = await ImagePicker.pickImage(
        source: (source == 1) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.transparent,
            toolbarWidgetColor: Colors.transparent,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      if (croppedFile != null) {
        setState(
          () => profileImage = croppedFile,
        );
      }
    }
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
                    stateId = list[index]["_id"];
                    Navigator.pop(context);
                  });
                },
              );
            },
          );
        });
  }

  // void languageBottomDialog(list, controller) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: list.length,
  //           itemBuilder: (context, index) {
  //             return ListTile(
  //               title: Center(
  //                 child: Text(
  //                   list[index],
  //                   style: TextStyle(
  //                     color: list[index] == controller.text
  //                         ? AppColors.goldenTainoi
  //                         : Colors.black,
  //                     fontSize: list[index] == controller.text ? 20.0 : 16.0,
  //                   ),
  //                 ),
  //               ),
  //               onTap: () {
  //                 setState(() {
  //                   controller.text = list[index];
  //                   Navigator.pop(context);
  //                 });
  //               },
  //             );
  //           },
  //         );
  //       });
  // }

  bool isValidate() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _genderGroup.isEmpty ||
        _zipController.text.isEmpty)
      // ||
      // (_langController.text.isEmpty ||
      //     _langController.text == "Select Primary Language")
      return false;
    else if (_zipController.text.length != 5)
      return false;
    else if (_passwordController.text.length < 6)
      return false;
    else if (((DateTime.now().difference(_selectedDate).inDays) / 365).floor() <
        18) {
      return false;
    } else
      return true;
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
