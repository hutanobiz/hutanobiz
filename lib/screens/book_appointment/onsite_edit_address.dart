import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/strings.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/utils/validations.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/textform_widget.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class OnsiteEditAddress extends StatefulWidget {
  OnsiteEditAddress({Key key, this.addressObject}) : super(key: key);
  final Map addressObject;

  @override
  _OnsiteEditAddressState createState() => _OnsiteEditAddressState();
}

class _OnsiteEditAddressState extends State<OnsiteEditAddress> {
  ApiBaseHelper api = new ApiBaseHelper();

  List stateList = List();
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _businessstateController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _zipController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _residenceTypeController = TextEditingController();
  TextEditingController _roomNoController = TextEditingController();
  TextEditingController _securityNumberController = TextEditingController();

  Map _addressMap = {};

  String _token;
  LatLng _latLng = LatLng(0, 0);

  List<String> typeList = ['Home', 'Apartment', 'Condo', 'Hotel'];
  var uuid = new Uuid();
  bool isShowList = false;
  String _sessionToken;
  List<dynamic> _placeList = [];
  PlacesDetailsResponse detail;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Strings.kGoogleApiKey);

  String stateId = "";

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) {
      _token = token;
    });

    api.getStates().then((value) {
      stateList = value;
    });

    if (widget.addressObject != null) {
      _addressMap = widget.addressObject;

      if (_addressMap['number'] != null) {
        _roomNoController.text = _addressMap['number'].toString();
      }

      if (_addressMap['securityGate'] != null) {
        _securityNumberController.text = _addressMap['securityGate'].toString();
      }

      if (_addressMap['title'] != null) {
        _titleController.text = _addressMap['title'].toString();
      }

      if (_addressMap['address'] != null) {
        _addressController.text = _addressMap['address'].toString();
      }
      if (_addressMap['state'] != null &&
          _addressMap['state']['title'] != null) {
        _businessstateController.text = _addressMap['state']['title'];
        stateId = _addressMap['state']['_id'];
        _addressMap['stateCode'] =
            widget.addressObject['state']['stateCode']?.toString();
      }
      if (_addressMap['city'] != null) {
        _cityController.text = _addressMap['city'].toString();
      }

      if (_addressMap['addresstype'] != null) {
        switch (_addressMap['addresstype']) {
          case 1:
            _residenceTypeController.text = 'Home';
            break;
          case 2:
            _residenceTypeController.text = 'Apartment';
            break;
          case 3:
            _residenceTypeController.text = 'Condo';
            break;
          case 4:
            _residenceTypeController.text = 'Hotel';
            break;
          default:
        }
      }

      _zipController.text = widget.addressObject['zipCode'].toString();

      if (_addressMap['coordinates'] != null &&
          _addressMap['coordinates'].toString().length > 0) {
        List coordinatesList = _addressMap['coordinates'];

        _latLng = LatLng(
          double.parse(coordinatesList.last.toString()),
          double.parse(coordinatesList.first.toString()),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: 'Add address',
        isAddBack: true,
        isAddAppBar: true,
        isLoading: isLoading,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: screenWidgetList(),
      ),
    );
  }

  screenWidgetList() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            primaryLocationExpandedWidget(),
            SizedBox(height: 20),
            nextButton(),
            SizedBox(height: 20),
          ],
        ),
        isShowList
            ? Container(
                margin: EdgeInsets.only(top: 100),
                color: Colors.white,
                child: ListView.builder(
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
                        _addressMap['coordinates'] = coordinates;
                        print(aa.result.adrAddress);
                        if (aa.result.adrAddress.contains('locality')) {
                          final startIndex =
                              aa.result.adrAddress.indexOf('"locality">');
                          final endIndex = aa.result.adrAddress.indexOf(
                              '</span>', startIndex + '"locality">'.length);
                          _cityController.text = aa.result.adrAddress.substring(
                              startIndex + '"locality">'.length, endIndex);
                          _addressMap['city'] = _cityController.text;
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
                              .substring(startIndex + '"postal-code">'.length,
                                  endIndex)
                              .substring(0, 5);
                          _addressMap['zipCode'] = _zipController.text;
                          print(aa.result.adrAddress.substring(
                              startIndex + '"postal-code">'.length, endIndex));
                        } else {
                          _zipController.text = "";
                        }

                        if (aa.result.adrAddress.contains('region')) {
                          final startIndex =
                              aa.result.adrAddress.indexOf('"region">');
                          final endIndex = aa.result.adrAddress.indexOf(
                              '</span>', startIndex + '"region">'.length);
                          print(aa.result.adrAddress.substring(
                              startIndex + '"region">'.length, endIndex));

                          for (dynamic state in stateList) {
                            if (state['title'] ==
                                    aa.result.adrAddress.substring(
                                        startIndex + '"region">'.length,
                                        endIndex) ||
                                state['stateCode'] ==
                                    aa.result.adrAddress.substring(
                                        startIndex + '"region">'.length,
                                        endIndex)) {
                              _businessstateController.text = state['title'];
                              stateId = state["_id"]?.toString();
                            }
                          }
                        } else {
                          _businessstateController.text = "";
                        }
                        _addressController.text = aa.result.name;
                        _addressMap['address'] = aa.result.name;
                        // businessLocation.street = aa.result.name;
                        setState(() {
                          isShowList = false;
                        });
                      },
                      title: Text(_placeList[index]["description"]),
                    );
                  },
                ),
              )
            : SizedBox(),
      ],
    );
  }

  FancyButton nextButton() {
    return FancyButton(
      title: "Save",
      onPressed: () {
        if (isFormFilled()) {
          updateAddress();
        }
      },
      buttonHeight: Dimens.buttonHeight,
    );
  }

  void getSuggestion(String input) async {
    String kPLACESAPIKEY = Strings.kGoogleApiKey;
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&rankby=distance&location=31.45,77.1120762&key=$kPLACESAPIKEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Widget primaryLocationExpandedWidget() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        children: <Widget>[
          Material(
            color: AppColors.snow,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
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
                // enabled: false,
                validator: Validations.requiredValue,
                decoration: InputDecoration(
                  labelText: "Address",
                  hintText: 'Enter your address',
                  labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
          Widgets.sizedBox(height: 29.0),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                    validator: Validations.requiredValue,
                    labelText: "City",
                    controller: _cityController,
                    onChanged: (city) {
                      _addressMap['city'] = city;
                    }),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: picker(
                  _businessstateController,
                  "State",
                  () => stateBottomDialog(
                    stateList,
                    _businessstateController,
                  ),
                ),
              ),
            ],
          ),
          Widgets.sizedBox(height: 29.0),
          CustomTextField(
              validator: Validations.requiredValue,
              controller: _titleController,
              labelText: "Save as",
              onChanged: (v) {
                _addressMap['title'] = v;
              }),
          Widgets.sizedBox(height: 29.0),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                    validator: Validations.requiredValue,
                    inputType: TextInputType.number,
                    maxLength: 5,
                    controller: _zipController,
                    labelText: "Zip Code",
                    onChanged: (zipCode) {
                      _addressMap['zipCode'] = zipCode;
                    }),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: CustomTextField(
                    controller: _roomNoController,
                    inputType: TextInputType.number,
                    labelText: "Appt or unit number",
                    onChanged: (value) {
                      _addressMap['number'] = value;
                    }),
              ),
            ],
          ),
          Widgets.sizedBox(height: 29.0),
          picker(
            _residenceTypeController,
            "Residence Type",
            () => residenceTypeBottomDialog(
              typeList,
              _residenceTypeController,
            ),
          ),
        ],
      ),
    );
  }

  void updateAddress() {
    Map copyMap = _addressMap;
    copyMap['state'] = stateId;
    Map map = {};

    map['userAddress'] = copyMap;

//     {userAddress: {title: "My Address", residencyType: "1", addressNumber: "",…}}
// userAddress: {title: "My Address", residencyType: "1", addressNumber: "",…}
// address: "4110 S Bowdish Rd, Spokane Valley, WA 99206, USA"
// addressNumber: ""
// addresstype: "1"
// city: "Spokane Valley"
// coordinates: [-117.2510115, 47.6185299]
// location: "4110 S Bowdish Rd, Spokane Valley, WA 99206, USA"
// number: ""
// residencyType: "1"
// state: "6090f4d858adf55f8b70e50f"
// street: "4110"

    if (isFormFilled()) {
      setLoading(true);

      map.toString().debugLog();

      if (_addressMap['title'] == null || _addressMap['title'] == '') {
        _addressMap['title'] = _addressMap['address'];
      }

      if (widget.addressObject != null) {
        map['id'] = _addressMap['_id'];

        api.editAddress(_token, map).then((dynamic response) {
          Widgets.showToast("Address updated successfully");
          Navigator.of(context).pop(true);
          setLoading(false);
        }).futureError((e) {
          setLoading(false);
          e.toString().debugLog();
        });
      } else {
        api.addAddress(_token, map).then((dynamic response) {
          Widgets.showToast("Address added successfully");
          Navigator.of(context).pop(true);
          setLoading(false);
        }).futureError((e) {
          setLoading(false);
          e.toString().debugLog();
        });
      }
    }
  }

  bool isFormFilled() {
    // if (_titleController.text.isEmpty) {
    //   Widgets.showErrorialog(context: context, description: "Enter Save as");

    //   return false;
    // } else
    if (_residenceTypeController.text.isEmpty ||
        _addressMap['addresstype'] == null) {
      Widgets.showErrorialog(
          context: context, description: "Select Residence type");

      return false;
      // } else if (_roomNoController.text.isEmpty) {
      //   Widgets.showErrorialog(
      //       context: context, description: "Enter Appt or unit");

      //   return false;
    } else if (_cityController.text.isEmpty) {
      Widgets.showErrorialog(context: context, description: "Enter City");

      return false;
    } else if (_addressController.text.isEmpty) {
      Widgets.showErrorialog(context: context, description: "Select Location");

      return false;
    } else if (_businessstateController.text.isEmpty) {
      Widgets.showErrorialog(context: context, description: "Select State");

      return false;
    } else if (_zipController.text.isEmpty) {
      Widgets.showErrorialog(context: context, description: "Enter Zip Code");

      return false;
    } else {
      return true;
    }
  }

  Widget picker(final controller, String labelText, onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey[300],
        onTap: () {
          FocusScope.of(context).unfocus();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: TextFormField(
            controller: controller,
            enabled: false,
            style: const TextStyle(fontSize: 14.0, color: Colors.black87),
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[400],
              ),
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void residenceTypeBottomDialog(
      List<String> list, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Select Residence Type",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    String _icon = 'ic_onsite_app';

                    switch (index) {
                      case 0:
                        _icon = 'ic_onsite_app';
                        break;
                      case 1:
                        _icon = 'ic_apartment';
                        break;
                      case 2:
                        _icon = 'ic_condo';
                        break;
                      case 3:
                        _icon = 'ic_hotel';
                        break;
                      default:
                    }

                    return ListTile(
                      title: Row(
                        children: [
                          Image.asset(
                            "images/$_icon.png",
                            height: 19,
                            width: 19,
                          ),
                          SizedBox(width: 18),
                          Text(
                            list[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: typeList[index] == controller.text
                            ? Image.asset("images/checkedCheck.png",
                                height: 24, width: 24)
                            : Image.asset("images/uncheckedCheck.png",
                                height: 24, width: 24),
                      ),
                      onTap: () {
                        setState(
                          () {
                            controller.text = list[index];
                            _addressMap['addresstype'] = (index + 1).toString();
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void stateBottomDialog(List<dynamic> list, TextEditingController controller) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
            shrinkWrap: true,
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
                    // _addressMap['state'] = list[index]["_id"];
                    _addressMap['stateCode'] = list[index]["stateCode"];
                    stateId = list[index]["_id"];

                    Navigator.pop(context);
                  });
                },
              );
            },
          );
        });
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
