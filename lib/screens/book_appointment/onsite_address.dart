import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';

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
      body: LoadingBackground(
        title: "Addresses",
        padding: const EdgeInsets.fromLTRB(20, 20, 5, 20),
        isAddBack: !widget.isBookAppointment,
        isAddAppBar: true,
        rightButtonText: 'Add Address',
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
                  Navigator.of(context).pushNamed(
                    Routes.paymentMethodScreen,
                    arguments: true,
                  );
                }
              },
        onRightButtonTap: () => Navigator.pushNamed(
          context,
          Routes.onsiteEditAddress,
        ).then((value) {
          if (value != null && value) {
            setState(() {
              _addressesFuture = api.getAddress(_token);
            });
          }
        }),
        isLoading: isLoading,
        child: _buildList(),
      ),
    );
  }

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

          addressList.clear();

          for (var aa in snapshot.data) {
            if (aa != null) {
              addressList.add(aa);
            }
          }

          return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(
                    color: AppColors.haiti.withOpacity(0.20),
                  ),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: addressList.length,
              itemBuilder: (context, index) {
                dynamic address = addressList[index];
                return addressWidget(address, index);
              });
        } else if (snapshot.hasError) {
          return Text('No address.');
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget addressWidget(dynamic address, int index) {
    TextStyle style = TextStyle(
      color: Colors.black.withOpacity(0.6),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    if (address['state'] is Map &&
        address['state'] != null &&
        address['state']['title'] != null) {
      state = address['state']['title'].toString();
    } else {
      state = '---';
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0 ? Container() : SizedBox(height: 20),
              Text(
                address['title']?.toString() ?? '---',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Text(
                address['address']?.toString() ?? '---',
                style: style,
              ),
              SizedBox(height: 10),
              Text(
                address['street']?.toString() ?? '---',
                style: style,
              ),
              SizedBox(height: 10),
              Text(
                state +
                    ', ' +
                    (address['city']?.toString() ?? '---') +
                    ', ' +
                    (address['zipCode']?.toString() ?? '---'),
                style: style,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                widget.isBookAppointment
                    ? Radio(
                        activeColor: AppColors.persian_blue,
                        value: index,
                        groupValue: _radioValue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: _selectAddress(address),
                      )
                    : Container(),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  elevation: 3.2,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: '1',
                      height: 40,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '2',
                      height: 40,
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  onSelected: (val) {
                    val == '1'
                        ? Navigator.pushNamed(
                            context,
                            Routes.onsiteEditAddress,
                            arguments: address,
                          ).then((value) {
                            if (value != null && value) {
                              setState(() {
                                _addressesFuture = api.getAddress(_token);
                              });
                            }
                          })
                        : _deleteAddress(address['_id'].toString());
                  },
                ),
              ],
            ),
          ),
        )
      ],
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
    setLoading(true);
    api.deleteAddress(_token, id).whenComplete(() {
      setLoading(false);
      setState(() {
        _addressesFuture = api.getAddress(_token);
      });
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
