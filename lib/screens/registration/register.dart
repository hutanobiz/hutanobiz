import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:async/async.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:http/http.dart' as http;
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/dashboard/choose_location_screen.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/app_logo.dart';
import 'package:hutano/widgets/email_widget.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_widget.dart';
import 'package:hutano/widgets/password_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  String stateId = "";
  var uuid = new Uuid();
  String _sessionToken;
  List<dynamic> _placeList = [];
  bool isShowList = false;

  String _genderGroup = "";

  ApiBaseHelper api = new ApiBaseHelper();
  List stateList;

  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final _passwordController = TextEditingController();

  bool checked = false;
  bool _obscureText = true;

  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  String phoneNumber, token, deviceToken;
  File profileImage;
  bool isLoading = false;
  DateTime _selectedDate;
  bool isUpdateProfile = false;
  PlacesDetailsResponse detail;

  final _dobController = new TextEditingController();

  String avatar;

  @override
  void initState() {
    super.initState();

    SharedPref().getValue("deviceToken").then((value) {
      deviceToken = value;
    });

    phoneNumber = widget.args.phoneNumber;

    if (widget.args.isProfileUpdate != null) {
      isUpdateProfile = widget.args.isProfileUpdate;
    }

    _selectedDate = DateTime(
        DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);

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

    if (isUpdateProfile) {
      SharedPref().getToken().then((token) {
        setLoading(true);

        api.profile(token, Map()).then((dynamic response) {
          setLoading(false);
          setState(() {
            this.token = token;

            if (response['response'] != null) {
              dynamic res = response['response'];

              _firstNameController.text = res["firstName"]?.toString();
              _lastNameController.text = res["lastName"]?.toString();
              _emailController.text = res["email"]?.toString();

              if (res['phoneNumber'] != null) {
                _phoneController.text = res['phoneNumber'].toString();
              }

              _addressController.text = res['address']?.toString();
              _cityController.text = res['city']?.toString();

              if (res["state"] != null) {
                _stateController.text = res["state"]["title"]?.toString();
                stateId = res["state"]["_id"]?.toString();
              }

              _zipController.text = res["zipCode"]?.toString();
              _dobController.text = res["dob"]?.toString();

              setState(() {
                if (res["dob"] != null) {
                  _selectedDate =
                      DateFormat("MM/dd/yyyy").parse(res["dob"].toString());
                } else {
                  _selectedDate = DateTime(DateTime.now().year - 18,
                      DateTime.now().month, DateTime.now().day);
                }
              });

              avatar = res["avatar"]?.toString();
              _genderGroup =
                  res["gender"]?.toString() == "1" ? "male" : "female";
            }
          });
        }).futureError((error) {
          setLoading(false);
          error.toString().debugLog();
          Navigator.of(context).pop();
        });
      });
    }
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

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = kGoogleApiKey;
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&rankby=distance&location=31.45,77.1120762&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(request);
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isUpdateProfile
          ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.white_smoke,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 15.0,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
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
            shrinkWrap: true,
            children: getFormWidget(),
            padding: EdgeInsets.fromLTRB(
              Dimens.padding,
              isUpdateProfile ? 20 : 51.0,
              Dimens.padding,
              Dimens.padding,
            ),
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
          isUpdateProfile
              ? "Update your account"
              : "Let's start creating your account.",
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
            child: (avatar == null || avatar == "null")
                ? profileImage == null
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
                      )
                : ClipOval(
                    child: Image.network(
                      ApiBaseHelper.imageUrl + avatar,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  )),
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
        )
      ],
    ).onClick(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showPickerDialog();
      },
    ));

    formWidget.add(Widgets.sizedBox(height: 35.0));

    formWidget.add(Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            autofocus: !isUpdateProfile,
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
      EmailTextField(
        emailKey: _emailKey,
        autofocus: false,
        emailController: _emailController,
        style: style,
        prefixIcon: Icon(Icons.email, color: AppColors.windsor, size: 13.0),
        suffixIcon: Icon(
          Icons.check_circle,
          color: Colors.green,
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
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          onConfirm: (date) {
            if (date != null) {
              setState(() {
                _selectedDate = date;
                var aa = DateFormat('MM').format(date) +
                    '/' +
                    DateFormat('dd').format(date) +
                    '/' +
                    date.year.toString();

                if (((DateTime.now().difference(date).inDays) / 365).floor() >=
                    18) {
                  _dobController.text = aa;
                } else {
                  Widgets.showToast("Minimum age should be 18");
                }
              });
            }
          },
          currentTime: _selectedDate,
          minTime: DateTime(1880),
          maxTime: DateTime(DateTime.now().year - 18, DateTime.now().month,
              DateTime.now().day),
          locale: LocaleType.en,
        );
      }),
    );
    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: TextFormField(
          initialValue: phoneNumber,
          enabled: false,
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
          keyboardType: TextInputType.phone,
        ),
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      isUpdateProfile
          ? Container()
          : PasswordTextField(
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
                child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey),
              )),
    );

    formWidget
        .add(isUpdateProfile ? Container() : Widgets.sizedBox(height: 29.0));

    formWidget.add(
      TextFormField(
        controller: _addressController,
        onChanged: ((val) {
          if (_sessionToken == null) {
            setState(() {
              _sessionToken = uuid.v4();
            });
          }
          isShowList = true;
          getSuggestion(val);
        }),
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

    formWidget.add(isShowList
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _placeList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  detail = await _places
                      .getDetailsByPlaceId(_placeList[index]["place_id"]);
                  final lat = detail.result.geometry.location.lat;
                  final lng = detail.result.geometry.location.lng;
                  print(detail.result.adrAddress.toString());
                  PlacesDetailsResponse aa = detail;
                  print(aa);
                  List<double> coordinates = List();
                  coordinates.add(aa.result.geometry.location.lng);
                  coordinates.add(aa.result.geometry.location.lat);
                  print(aa.result.adrAddress);
                  if (aa.result.adrAddress.contains('locality')) {
                    final startIndex =
                        aa.result.adrAddress.indexOf('"locality">');
                    final endIndex = aa.result.adrAddress
                        .indexOf('</span>', startIndex + '"locality">'.length);
                    _cityController.text = aa.result.adrAddress
                        .substring(startIndex + '"locality">'.length, endIndex);
                    print(aa.result.adrAddress.substring(
                        startIndex + '"locality">'.length, endIndex));
                  } else {
                    _cityController.text = "";
                  }

                  if (aa.result.adrAddress.contains('postal-code')) {
                    final startIndex =
                        aa.result.adrAddress.indexOf('"postal-code">');
                    final endIndex = aa.result.adrAddress.indexOf(
                        '</span>', startIndex + '"postal-code">'.length);
                    _zipController.text = aa.result.adrAddress
                        .substring(
                            startIndex + '"postal-code">'.length, endIndex)
                        .substring(0, 5);
                    print(aa.result.adrAddress.substring(
                        startIndex + '"postal-code">'.length, endIndex));
                  } else {
                    _zipController.text = "";
                  }

                  if (aa.result.adrAddress.contains('region')) {
                    final startIndex =
                        aa.result.adrAddress.indexOf('"region">');
                    final endIndex = aa.result.adrAddress
                        .indexOf('</span>', startIndex + '"region">'.length);
                    print(aa.result.adrAddress
                        .substring(startIndex + '"region">'.length, endIndex));

                    for (dynamic state in stateList) {
                      if (state['title'] ==
                              aa.result.adrAddress.substring(
                                  startIndex + '"region">'.length, endIndex) ||
                          state['stateCode'] ==
                              aa.result.adrAddress.substring(
                                  startIndex + '"region">'.length, endIndex)) {
                        _stateController.text = state['title'];
                        stateId = state["_id"]?.toString();
                      }
                    }
                  } else {
                    _stateController.text = "";
                  }
                  _addressController.text = aa.result.name;
                  setState(() {
                    isShowList = false;
                  });
                },
                title: Text(_placeList[index]["description"]),
              );
            },
          )
        : SizedBox());

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
    log(_genderGroup);

    formWidget.add(
      Row(
        children: <Widget>[
          genderWidget("Male", "male", () {
            setState(() => _genderGroup = "male");
          }),
          SizedBox(width: 20.0),
          genderWidget("Female", "female", () {
            setState(() => _genderGroup = "female");
          }),
        ],
      ),
    );

    formWidget.add(Widgets.sizedBox(height: 29.0));

    formWidget.add(
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 5),
        child: FancyButton(
          buttonHeight: Dimens.buttonHeight,
          title: "Save",
          onPressed: isUpdateProfile
              ? _register
              : (isValidate()
                  ? () {
                      if (profileImage != null) {
                        _register();
                      } else {
                        Widgets.showToast("Please upload your profile pic");
                      }
                    }
                  : null),
        ),
      ),
    );

    return formWidget;
  }

  Widget genderWidget(String title, String imageIcon, Function onTap) {
    return Expanded(
      child: Container(
        height: 56,
        padding: EdgeInsets.only(right: 5.0, top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: imageIcon == "male" && _genderGroup == "male" ||
                        imageIcon == "female" && _genderGroup == "female"
                    ? AppColors.female
                    : Colors.grey[300],
                width: 1.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imageIcon.imageIcon(
              height: 16.0,
              width: 16.0,
              color: imageIcon == "male" && _genderGroup == "male" ||
                      imageIcon == "female" && _genderGroup == "female"
                  ? AppColors.female
                  : Colors.blue,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              title,
              style: TextStyle(
                color: imageIcon == "male" && _genderGroup == "male" ||
                        imageIcon == "female" && _genderGroup == "female"
                    ? AppColors.female
                    : Colors.blue,
              ),
            ),
          ],
        ),
      ).onClick(onTap: onTap),
    );
  }

  _register() async {
    Map<String, String> loginData = Map();
    loginData["email"] = _emailController.text;
    loginData["fullName"] =
        "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}";
    loginData["firstName"] = _firstNameController.text.trim();
    loginData["lastName"] = _lastNameController.text.trim();

    if (!isUpdateProfile) {
      loginData["type"] = "1";
      loginData["step"] = "3";
      loginData["password"] = _passwordController.text;
      loginData["deviceToken"] = deviceToken;
    }

    loginData["address"] = _addressController.text;
    loginData["city"] = _cityController.text;
    loginData["state"] = _stateController.text;
    loginData["zipCode"] = _zipController.text;
    loginData["phoneNumber"] = Validations.getCleanedNumber(phoneNumber);
    loginData["gender"] = _genderGroup.trim().toString() == "male" ? "1" : "2";
    loginData["state"] = stateId;

    if (isUpdateProfile) {
      loginData["dob"] =
          DateFormat("MM/dd/yyyy").format(_selectedDate).toString();
    } else {
      loginData["dob"] =
          DateFormat("MM/dd/yyyy").format(_selectedDate).toString();
    }

    try {
      setLoading(true);
      Uri uri = Uri.parse(ApiBaseHelper.base_url +
          (isUpdateProfile ? "api/profile/update" : "auth/api/register"));
      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      token.toString().debugLog();

      if (isUpdateProfile) {
        request.headers['authorization'] = token;
      }

      request.fields.addAll(loginData);

      if (profileImage != null) {
        var stream = http.ByteStream(DelegatingStream(profileImage.openRead()));
        var length = await profileImage.length();

        request.files.add(http.MultipartFile("avatar", stream.cast(), length,
            filename: profileImage.path));
      }

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

        if (isUpdateProfile) {
          Widgets.showToast("Profile updated successfully");
          Navigator.of(context).pop();
        } else {
          SharedPref()
              .saveToken(responseJson["response"]["tokens"][0]["token"]);
          SharedPref()
              .setValue("fullName", responseJson["response"]["fullName"]);
          SharedPref().setValue("complete", "0");

          Widgets.showToast(
              "Congratulations! Your profile as been successfully created");
          var verifyEmail = Map();
          //var phone=int.parse(widget.args.email);
          String phonenumber = widget.args.phoneNumber.substring(1, 4) +
              "" +
              widget.args.phoneNumber.substring(6, 9) +
              "" +
              widget.args.phoneNumber.substring(10, 14);
          verifyEmail["email"]=_emailController.text;
          verifyEmail["phoneNumber"]= phonenumber;

          api.sendEmailOtp(context, verifyEmail).then((dynamic response) {
            setLoading(false);
            //verifyEmail["otp"]= response["verificationCode"].toString();
            Widgets.showToast(response["verificationCode"].toString());

            Navigator.pushNamed(
              context,
              Routes.verifyEmailOtpRoute,
              arguments: verifyEmail,
            );
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     Routes.registerEducation, (Route<dynamic> route) => false);
          }).futureError((onError){
            Widgets.showErrorialog(
                title: "Error", context: context, description: "Error!");
          });
          // Map _insuranceMap = {};
          // _insuranceMap['isPayment'] = false;
          // _insuranceMap['isFromRegister'] = true;
          //
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //   Routes.insuranceListScreen,
          //   (Route<dynamic> route) => false,
          //   arguments: _insuranceMap,
          // );
        }

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

  Future<void> _onLocationTap() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.fullscreen,
        language: "en");
    if (p != null) {
      detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      print(detail.result.adrAddress.toString());
      PlacesDetailsResponse aa = detail;
      print(aa);
      List<double> coordinates = List();
      coordinates.add(aa.result.geometry.location.lng);
      coordinates.add(aa.result.geometry.location.lat);
      // businessLocation.coordinates = coordinates;
      print(aa.result.adrAddress);
      if (aa.result.adrAddress.contains('locality')) {
        final startIndex = aa.result.adrAddress.indexOf('"locality">');
        final endIndex = aa.result.adrAddress
            .indexOf('</span>', startIndex + '"locality">'.length);
        // businessLocation.city = aa.result.adrAddress
        // .substring(startIndex + '"locality">'.length, endIndex);
        _cityController.text = aa.result.adrAddress
            .substring(startIndex + '"locality">'.length, endIndex);
        print(aa.result.adrAddress
            .substring(startIndex + '"locality">'.length, endIndex));
      } else {
        // businessLocation.city = "";
        _cityController.text = "";
      }

      if (aa.result.adrAddress.contains('postal-code')) {
        final startIndex = aa.result.adrAddress.indexOf('"postal-code">');
        final endIndex = aa.result.adrAddress
            .indexOf('</span>', startIndex + '"postal-code">'.length);
        // businessLocation.zipCode = aa.result.adrAddress
        // .substring(startIndex + '"postal-code">'.length, endIndex)
        // .substring(0, 5);
        _zipController.text = aa.result.adrAddress
            .substring(startIndex + '"postal-code">'.length, endIndex)
            .substring(0, 5);
        print(aa.result.adrAddress
            .substring(startIndex + '"postal-code">'.length, endIndex));
      } else {
        // businessLocation.zipCode = "";
        _zipController.text = "";
      }

      if (aa.result.adrAddress.contains('region')) {
        final startIndex = aa.result.adrAddress.indexOf('"region">');
        final endIndex = aa.result.adrAddress
            .indexOf('</span>', startIndex + '"region">'.length);
        print(aa.result.adrAddress
            .substring(startIndex + '"region">'.length, endIndex));

        for (dynamic state in stateList) {
          if (state['title'] ==
                  aa.result.adrAddress
                      .substring(startIndex + '"region">'.length, endIndex) ||
              state['stateCode'] ==
                  aa.result.adrAddress
                      .substring(startIndex + '"region">'.length, endIndex)) {
            _stateController.text = state['title'];
            stateId = state["_id"]?.toString();

            // _stateController.text = res["state"]["title"]?.toString();
            //     stateId = res["state"]["_id"]?.toString();
            // businessLocation.state = state["_id"];
          }
        }
      } else {
        // businessLocation.state = "";
        _stateController.text = "";
      }
      // businessLocation.street = aa.result.name ?? "";
      // _stateController.text = aa.result.name ?? "";
      _addressController.text = aa.result.name;
    }
  }

  Future getImage(int source) async {
    ImagePicker _picker = ImagePicker();

    PickedFile image = await _picker.getImage(
        source: (source == 1) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);

      File croppedFile = await ImageCropper.cropImage(
        compressQuality: imageFile.lengthSync() > 100000 ? 25 : 100,
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.transparent,
            toolbarWidgetColor: Colors.transparent,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          // aspectRatioLockDimensionSwapEnabled: true,
        ),
      );
      if (croppedFile != null) {
        setState(
          () {
            profileImage = croppedFile;
            avatar = null;
          },
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

  bool isValidate() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _genderGroup.isEmpty ||
        _zipController.text.isEmpty)
      return false;
    else if (_zipController.text.length < 5)
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

class UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }

    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
