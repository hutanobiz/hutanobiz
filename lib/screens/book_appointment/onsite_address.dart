import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/loading_background.dart';

class OnsiteAddresses extends StatefulWidget {
  OnsiteAddresses({Key key, this.addressObject = false}) : super(key: key);
  final dynamic addressObject;

  @override
  _OnsiteAddressesState createState() => _OnsiteAddressesState();
}

class _OnsiteAddressesState extends State<OnsiteAddresses> {
  ApiBaseHelper api = new ApiBaseHelper();

  bool isLoading = false;

  Future<List<dynamic>> _addressesFuture;

  @override
  void initState() {
    super.initState();

    SharedPref().getToken().then((token) {
      token.debugLog();
      setState(() {
        _addressesFuture = api.getAddress(token);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackground(
        title: "Addresses",
        isAddBack: true,
        isAddAppBar: true,
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
          List addressList = snapshot.data;

          if (addressList == null || addressList.isEmpty) {
            return Center(
              child: Text('No address.'),
            );
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
                "${address['city']?.toString() ?? '---'}, ${address['zipCode']?.toString() ?? '---'}",
                style: style,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey[600],
                size: 20,
              ),
              elevation: 3.2,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                      )
                    : null;
              },
            ),
          ),
        )
      ],
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
