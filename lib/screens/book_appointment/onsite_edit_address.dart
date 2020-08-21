import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/textform_widget.dart';
import 'package:hutano/widgets/widgets.dart';

class OnsiteEditAddress extends StatefulWidget {
  OnsiteEditAddress({Key key, this.addressObject = false}) : super(key: key);
  final dynamic addressObject;

  @override
  _OnsiteEditAddressState createState() => _OnsiteEditAddressState();
}

class _OnsiteEditAddressState extends State<OnsiteEditAddress> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);

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

  Map _addressMap = {};

  String _token;
  LatLng _latLng = LatLng(0, 0);

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) {
      _token = token;
    });

    api.getStates().then((value) {
      stateList = value;
    });

    _titleController.addListener(() {
      setState(() {});
    });
    _businessstateController.addListener(() {
      setState(() {});
    });
    _addressController.addListener(() {
      setState(() {});
    });
    _cityController.addListener(() {
      setState(() {});
    });
    _zipController.addListener(() {
      setState(() {});
    });
    _streetController.addListener(() {
      setState(() {});
    });

    if (widget.addressObject != null) {
      _addressMap = widget.addressObject;

      if (_addressMap['coordinates'] != null &&
          _addressMap['coordinates'].toString().length > 0) {
        List coordinatesList = _addressMap['coordinates'];

        _latLng = LatLng(
          double.parse(coordinatesList.last.toString()),
          double.parse(coordinatesList.first.toString()),
        );

        getLocationAddress(_latLng);
      }
      // _addressController.text = _addressMap['address'];
      // _streetController.text = _addressMap['street'];
      // _cityController.text = _addressMap['city'];
      // _businessstateController.text = _addressMap['state'];
      // _zipController.text = _addressMap['zipCode'];
      //TODO: edit address
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _businessstateController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackground(
        title: 'Add address',
        isAddBack: true,
        isAddAppBar: true,
        isLoading: isLoading,
        child: screenWidgetList(),
      ),
    );
  }

  screenWidgetList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        primaryLocationExpandedWidget(),
        nextButton(),
        SizedBox(
          height: 20,
        )
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

  _navigateToMap(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.chooseLocation,
      arguments: _latLng,
    );

    if (result is LatLng) {
      _latLng = result;
      getLocationAddress(_latLng);

      _addressMap['coordinates[0]'] = _latLng.longitude;
      _addressMap['coordinates[1]'] = _latLng.latitude;
    } else {
      PlacesDetailsResponse aa = result;
      print(aa);

      _addressMap['coordinates[1]'] = aa.result.geometry.location.lat;
      _addressMap['coordinates[0]'] = aa.result.geometry.location.lng;

      print(aa.result.adrAddress);
      if (aa.result.adrAddress.contains('locality')) {
        final startIndex = aa.result.adrAddress.indexOf('"locality">');
        final endIndex = aa.result.adrAddress
            .indexOf('</span>', startIndex + '"locality">'.length);
        _addressMap['city'] = aa.result.adrAddress
            .substring(startIndex + '"locality">'.length, endIndex);
        _cityController.text = aa.result.adrAddress
            .substring(startIndex + '"locality">'.length, endIndex);
        print(aa.result.adrAddress
            .substring(startIndex + '"locality">'.length, endIndex));
      } else {
        _addressMap['city'] = "";
        _cityController.text = "";
      }

      if (aa.result.adrAddress.contains('postal-code')) {
        final startIndex = aa.result.adrAddress.indexOf('"postal-code">');
        final endIndex = aa.result.adrAddress
            .indexOf('</span>', startIndex + '"postal-code">'.length);
        _addressMap['zipCode'] = aa.result.adrAddress
            .substring(startIndex + '"postal-code">'.length, endIndex)
            .substring(0, 5);
        _zipController.text = aa.result.adrAddress
            .substring(startIndex + '"postal-code">'.length, endIndex)
            .substring(0, 5);
        print(aa.result.adrAddress
            .substring(startIndex + '"postal-code">'.length, endIndex));
      } else {
        _addressMap['zipCode'] = "";
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
            _businessstateController.text = state['title'];
            _addressMap['state'] = state["_id"];
            _addressMap['stateCode'] = state["stateCode"];
          }
        }
      } else {
        _addressMap['state'] = "";
        _addressMap['stateCode'] = "";
        _businessstateController.text = "";
      }
      _addressMap['street'] = aa.result.name ?? "";
      _streetController.text = aa.result.name ?? "";
      _addressController.text = aa.result.formattedAddress;
    }
  }

  getLocationAddress(LatLng latLng) async {
    final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    _addressMap['city'] = first.locality;
    _cityController.text = first.locality;
    _addressMap['zipCode'] = first.postalCode;
    _zipController.text = first.postalCode;
    _addressMap['street'] = (first.featureName ?? "") +
        (first.featureName != null && first.thoroughfare != null ? " " : "") +
        (first.thoroughfare ?? "");
    _streetController.text = (first.featureName ?? "") +
        (first.featureName != null && first.thoroughfare != null ? " " : "") +
        (first.thoroughfare ?? "");

    _addressController.text = first.addressLine;

    for (dynamic state in stateList) {
      if (state['title'] == first.adminArea ||
          state['stateCode'] == first.adminArea) {
        _businessstateController.text = state['title'];
        _addressMap['state'] = state["_id"];
        _addressMap['stateCode'] = state["stateCode"];
      }
    }
    return first;
  }

  Widget primaryLocationExpandedWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView(
          children: <Widget>[
            CustomTextField(
                controller: _titleController,
                labelText: "Title",
                onChanged: (v) {
                  _addressMap['title'] = v;
                }),
            Widgets.sizedBox(height: 29.0),
            Material(
              color: AppColors.snow,
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _navigateToMap(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextFormField(
                    controller: _addressController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Location",
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
            ),
            Widgets.sizedBox(height: 29.0),
            CustomTextField(
                initialValue: _addressMap['address'],
                labelText: "Suite",
                onChanged: (address) {
                  _addressMap['address'] = address;
                }),
            Widgets.sizedBox(height: 29.0),
            CustomTextField(
                controller: _streetController,
                labelText: "Street",
                onChanged: (street) {
                  _addressMap['street'] = street;
                }),
            Widgets.sizedBox(height: 29.0),
            CustomTextField(
                labelText: "City",
                controller: _cityController,
                onChanged: (city) {
                  _addressMap['city'] = city;
                }),
            Widgets.sizedBox(height: 29.0),
            Row(
              children: <Widget>[
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
                SizedBox(width: 20.0),
                Expanded(
                  child: CustomTextField(
                      inputType: TextInputType.number,
                      maxLength: 5,
                      controller: _zipController,
                      labelText: "Zip Code",
                      onChanged: (zipCode) {
                        _addressMap['zipCode'] = zipCode;
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateAddress() {
    Map map = {};
    map['userAddress[title]'] = _addressMap['title'];
    map['userAddress[address]'] = _addressMap['address'];
    map['userAddress[street]'] = _addressMap['street'];
    map['userAddress[city]'] = _addressMap['city'];
    map['userAddress[state]'] = _addressMap['state'];
    map['userAddress[stateCode]'] = _addressMap['stateCode'];
    map['userAddress[zipCode]'] = _addressMap['zipCode'];
    map['userAddress[coordinates[0]]'] = _latLng.longitude.toString();
    map['userAddress[coordinates[1]]'] = _latLng.latitude.toString();

    if (isFormFilled()) {
      map.toString().debugLog();

      setLoading(true);
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

  bool isFormFilled() {
    if (_titleController.text.isEmpty) {
      Widgets.showErrorialog(
          context: context, description: "Enter Location Title");

      return false;
    } else if (_addressMap != null && _addressMap['address'] == null) {
      Widgets.showErrorialog(context: context, description: "Enter Suite");

      return false;
    } else if (_cityController.text.isEmpty) {
      Widgets.showErrorialog(
          context: context, description: "Enter Business City");

      return false;
    } else if (_addressController.text.isEmpty) {
      Widgets.showErrorialog(
          context: context, description: "Select Business Location");

      return false;
    } else if (_businessstateController.text.isEmpty) {
      Widgets.showErrorialog(
          context: context, description: "Enter Business State");

      return false;
    } else if (_zipController.text.isEmpty) {
      Widgets.showErrorialog(
          context: context, description: "Enter Business Postal Code");

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
                    _addressMap['state'] = list[index]["_id"];
                    _addressMap['stateCode'] = list[index]["stateCode"];

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
