import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/screens/book_appointment/model/res_onsite_address_model.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/constants/file_constants.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/text_with_image.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'morecondition/providers/health_condition_provider.dart';

class OnsiteAddresses extends StatefulWidget {
  OnsiteAddresses({Key key, this.isBookAppointment = false}) : super(key: key);
  final dynamic isBookAppointment;

  @override
  _OnsiteAddressesState createState() => _OnsiteAddressesState();
}

class _OnsiteAddressesState extends State<OnsiteAddresses> {
  ApiBaseHelper api = new ApiBaseHelper();

  bool isLoading = false;

  Future<List<dynamic>> _addressesFuture;

  String _token;
  List addressList = [];
  String state = '---';

  int _radioValue;

  InheritedContainerState _container;
  dynamic _selectedAddress;

  bool isAddressAdded = false;

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) {
      _token = token;
      token.debugLog();
      setState(() {
        _addressesFuture = api.getAddress(token);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: "",
        padding: EdgeInsets.only(bottom: spacing70),
        isAddBack: !widget.isBookAppointment,
        isAddAppBar: true,
        addBottomArrows: widget.isBookAppointment,
        onForwardTap: !widget.isBookAppointment
            ? null
            : () {
                if (_selectedAddress == null) {
                  Widgets.showErrorDialog(
                      context: context,
                      description: 'Please select an address');
                } else {
                  _container.setConsentToTreatData(
                      "userAddress", _selectedAddress);
                  _selectedAddress['coordinates']
                      .elementAt(0)
                      .runtimeType
                      .toString()
                      .debugLog();
                  LatLng latLng = LatLng(
                      _selectedAddress['coordinates'][0].toDouble(),
                      _selectedAddress['coordinates'][1].toDouble());
                  Provider.of<HealthConditionProvider>(context, listen: false)
                      .updateAddressData(
                          ResponseDetailsDetails.fromJson(_selectedAddress));
                  Provider.of<HealthConditionProvider>(context, listen: false)
                      .updateCoordinatesData(latLng);
                  Provider.of<HealthConditionProvider>(context, listen: false)
                      .updateOfficeId(_selectedAddress['_id']);
                  Navigator.of(context).pushNamed(Routes.parkingScreen);
                }
              },
        // onRightButtonTap: () => Navigator.pushNamed(
        //   context,
        //   Routes.onsiteEditAddress,
        // ).then((value) {
        //   if (value != null && value) {
        //     setState(() {
        //       _addressesFuture = api.getAddress(_token);
        //       isAddressAdded = true;
        //     });
        //   }
        // }),
        isLoading: isLoading,
        child: ListView(
          children: [
            _treatmentLocationWidget(context),
            _buildList(),
            _newAddAddressButton(context)
          ],
        ),
      ),
    );
  }

  Widget _treatmentLocationWidget(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
            left: spacing20,
            right: spacing20,
            top: spacing20,
            bottom: spacing30),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            widget.isBookAppointment
                ? Localization.of(context).treatmentLocationLabel
                : 'Addresses',
            style: TextStyle(
                fontSize: fontSize18,
                fontWeight: fontWeightSemiBold,
                color: AppColors.midnight_express),
          ),
        ),
      );

  Widget _newAddAddressButton(BuildContext context) => Center(
        child: IntrinsicWidth(
          child: TextWithImage(
            imageSpacing: spacing10,
            image: FileConstants.icLocationPin,
            label: Localization.of(context).addNewAddressLabel,
            size: 18,
            textStyle: TextStyle(
                color: Color(0xff1d36b9),
                fontWeight: fontWeightSemiBold,
                fontSize: fontSize14),
          ),
        ).onClick(onTap: () {
          Navigator.pushNamed(
            context,
            Routes.onsiteEditAddress,
          ).then((value) {
            if (value != null && value) {
              setState(() {
                _addressesFuture = api.getAddress(_token);
                isAddressAdded = true;
              });
            }
          });
        }),
      );

  Widget _buildList() {
    return FutureBuilder<List<dynamic>>(
      future: _addressesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null ||
              snapshot.data.isEmpty ||
              snapshot.data is String) {
            return Center(
              child: Text('No address.'),
            );
          }

          addressList = snapshot.data;

          return ListView.separated(
              padding: EdgeInsets.only(bottom: 65),
              separatorBuilder: (BuildContext context, int index) => Divider(
                    color: AppColors.haiti.withOpacity(0.20),
                  ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: addressList.length,
              itemBuilder: (context, index) {
                Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
                  if (isAddressAdded) {
                    _radioValue = addressList.length - 1;
                    _selectedAddress = addressList[addressList.length - 1];
                    setState(() {});
                  }

                  isAddressAdded = false;
                });

                dynamic address = addressList[index];
                return addressWidget(address, index);
              });
        } else if (snapshot.hasError) {
          return Text('No address.');
        }
        return Center(
          child: CustomLoader(),
        );
      },
    );
  }

  Widget addressWidget(dynamic address, int index) {
    TextStyle style = TextStyle(
      color: Color(0xff0b0e23),
      fontSize: fontSize12,
      fontWeight: fontWeightMedium,
    );

    if (address['state'] is Map &&
        address['state'] != null &&
        address['state']['title'] != null) {
      state = address['state']['title'].toString();
    } else {
      state = '---';
    }

    String _icon = 'ic_onsite_app', _roomNumb = '---', _addresstype = '1';

    if (address['addresstype'] != null) {
      _addresstype = address['addresstype'].toString();

      switch (_addresstype) {
        case '1':
          _icon = 'ic_onsite_app';
          break;
        case '2':
          _icon = 'ic_apartment';
          _roomNumb = 'apt# ';
          break;
        case '3':
          _icon = 'ic_condo';
          _roomNumb = 'unit# ';
          break;
        case '4':
          _icon = 'ic_hotel';
          _roomNumb = 'room# ';
          break;
        default:
      }

      _roomNumb += (address['number']?.toString() ?? '---');
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing20),
      child: PopupMenuButton(
        offset: Offset(300, 50),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          _popMenuCommonItem(
              context, Localization.of(context).edit, FileConstants.icEdit),
          _popMenuCommonItem(context, Localization.of(context).remove,
              FileConstants.icRemoveBlack)
        ],
        child: Container(
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: widget.isBookAppointment
                ? Radio(
                    activeColor: AppColors.windsor,
                    value: index,
                    groupValue: _radioValue,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: _selectAddress(address),
                  )
                : null,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0 ? Container() : SizedBox(height: spacing20),
                Row(children: [
                  Image.asset("images/$_icon.png",
                      height: spacing20, width: spacing20),
                  SizedBox(width: spacing10),
                  Text(address['title']?.toString() ?? '---',
                      style: TextStyle(
                          color: Color(0xff0b0e23),
                          fontSize: fontSize14,
                          fontWeight: fontWeightSemiBold))
                ]),
                _addresstype == '1' ? Container() : SizedBox(height: spacing10),
                _addresstype == '1'
                    ? Container()
                    : Text(_roomNumb?.toString() ?? '---', style: style),
                SizedBox(height: spacing10),
                Text(address['street']?.toString() ?? '---', style: style),
                SizedBox(height: spacing10),
                Text(address['address']?.toString() ?? '---', style: style),
                SizedBox(height: spacing10),
                Text(
                    state +
                        ', ' +
                        (address['city']?.toString() ?? '---') +
                        ', ' +
                        (address['zipCode']?.toString() ?? '---'),
                    style: style),
                SizedBox(height: spacing20),
              ],
            ),
            trailing: Icon(Icons.more_vert),
          ),
        ),
        onSelected: (value) {
          if (value == Localization.of(context).edit) {
            Navigator.pushNamed(
              context,
              Routes.onsiteEditAddress,
              arguments: address,
            ).then((value) {
              if (value != null && value) {
                setState(() {
                  _addressesFuture = api.getAddress(_token);
                });
              }
            });
          } else {
            showConfirmationDialog(address);
          }
        },
      ),
    );
  }

  Widget _popMenuCommonItem(BuildContext context, String value, String image) =>
      PopupMenuItem<String>(
        value: value,
        textStyle: const TextStyle(
            color: colorBlack2,
            fontWeight: fontWeightRegular,
            fontSize: spacing12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 15,
              width: 15,
            ),
            SizedBox(
              width: spacing5,
            ),
            Text(value)
          ],
        ),
      );

  // Widget addressWidget(dynamic address, int index) {
  //   TextStyle style = TextStyle(
  //     color: Colors.black.withOpacity(0.6),
  //     fontSize: 12,
  //     fontWeight: FontWeight.w500,
  //   );

  //   if (address['state'] is Map &&
  //       address['state'] != null &&
  //       address['state']['title'] != null) {
  //     state = address['state']['title'].toString();
  //   } else {
  //     state = '---';
  //   }

  //   String _icon = 'ic_onsite_app', _roomNumb = '', _addresstype = '1';

  //   if (address['addresstype'] != null) {
  //     _addresstype = address['addresstype'].toString();

  //     switch (_addresstype) {
  //       case '1':
  //         _icon = 'ic_onsite_app';
  //         _roomNumb = 'room# ';
  //         break;
  //       case '2':
  //         _icon = 'ic_apartment';
  //         _roomNumb = 'apt# ';
  //         break;
  //       case '3':
  //         _icon = 'ic_condo';
  //         _roomNumb = 'unit# ';
  //         break;
  //       case '4':
  //         _icon = 'ic_hotel';
  //         _roomNumb = 'room# ';
  //         break;
  //       default:
  //     }

  //     _roomNumb += (address['number']?.toString() ?? '---');
  //   }

  //   return Row(
  //     children: [
  //       Expanded(
  //         flex: 4,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             index == 0 ? Container() : SizedBox(height: 20),
  //             Row(
  //               children: [
  //                 Image.asset(
  //                   "images/$_icon.png",
  //                   height: 19,
  //                   width: 19,
  //                 ),
  //                 SizedBox(width: 10),
  //                 Text(
  //                   address['title']?.toString() ?? '---',
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Text(
  //               _roomNumb,
  //               style: style,
  //             ),
  //             SizedBox(height: 10),
  //             Text(
  //               address['address']?.toString() ?? '---',
  //               style: style,
  //             ),
  //             SizedBox(height: 10),
  //             Text(
  //               (address['city']?.toString() ?? '---'),
  //               style: style,
  //             ),
  //             SizedBox(height: 10),
  //             Text(
  //               state + ', ' + (address['zipCode']?.toString() ?? '---'),
  //               style: style,
  //             ),
  //             SizedBox(height: 20),
  //           ],
  //         ),
  //       ),
  //       Expanded(
  //         child: Align(
  //           alignment: Alignment.centerRight,
  //           child: Column(
  //             children: [
  //               widget.isBookAppointment
  //                   ? Radio(
  //                       activeColor: AppColors.windsor,
  //                       value: index,
  //                       groupValue: _radioValue,
  //                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                       onChanged: _selectAddress(address),
  //                     )
  //                   : Container(),
  //               PopupMenuButton(
  //                 icon: Icon(
  //                   Icons.more_vert,
  //                   color: Colors.grey[600],
  //                   size: 20,
  //                 ),
  //                 elevation: 3.2,
  //                 itemBuilder: (BuildContext context) =>
  //                     <PopupMenuEntry<String>>[
  //                   PopupMenuItem<String>(
  //                     value: '1',
  //                     height: 40,
  //                     child: Text(
  //                       'Edit',
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                   PopupMenuItem<String>(
  //                     value: '2',
  //                     height: 40,
  //                     child: Text(
  //                       'Delete',
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //                 onSelected: (val) {
  //                   val == '1'
  //                       ? Navigator.pushNamed(
  //                           context,
  //                           Routes.onsiteEditAddress,
  //                           arguments: address,
  //                         ).then((value) {
  //                           if (value != null && value) {
  //                             setState(() {
  //                               _addressesFuture = api.getAddress(_token);
  //                             });
  //                           }
  //                         })
  //                       : showConfirmationDialog(address);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  showConfirmationDialog(dynamic address) {
    Widgets.showConfirmationDialog(
      context: context,
      description: "Are you sure to delete this address?",
      onLeftPressed: () => _deleteAddress(
        address['_id'].toString(),
      ),
    );
  }

  Function _selectAddress(dynamic address) {
    return (value) {
      setState(
        () => _radioValue = value,
      );

      _selectedAddress = address;
    };
  }

  void _deleteAddress(String id) {
    Navigator.pop(context);

    setLoading(true);
    api.deleteAddress(_token, id).whenComplete(() {
      setLoading(false);

      if (_selectedAddress['_id'].toString() == id) _selectedAddress = null;

      addressList.removeWhere((element) => element['_id'].toString() == id);
      setState(() {});
    }).futureError((e) {
      setLoading(false);
      e.toString().debugLog();
    });
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
