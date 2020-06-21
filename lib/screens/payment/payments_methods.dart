import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/services.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class PaymentMethodScreen extends StatefulWidget {
  final bool isPayment;

  PaymentMethodScreen({Key key, this.isPayment}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _radioValue;
  int _listRadioValue;

  Future<List<dynamic>> _insuranceFuture;
  ApiBaseHelper _api = ApiBaseHelper();
  InheritedContainerState _container;
  String insuranceId, insuranceImage, insuranceName;

  bool _isLoading = false;
  Map providerMap;
  String name, avatar, cashPayment = "0";
  double totalFee = 0.0;

  Map _profileMap = {};

  List _providerInsuranceList = [];

  List _insuranceList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    if (widget.isPayment) {
      Map _providerData = _container.getProviderData();
      Map _servicesMap = _container.selectServiceMap;

      if (_providerData["providerData"]["data"] != null) {
        _providerData["providerData"]["data"].map((f) {
          _profileMap.addAll(f);
        }).toList();
      } else {
        _profileMap = _providerData["providerData"];
      }

      if (_servicesMap["status"].toString() == "1") {
        if (_servicesMap["services"] != null) {
          List<Services> _servicesList = _servicesMap["services"];

          totalFee = _servicesList.fold(
              0, (sum, item) => sum + double.parse(item.amount.toString()));
        }
      } else {
        List _consultaceList = _servicesMap["consultaceFee"];

        totalFee = _consultaceList[0]["fee"].toDouble();
      }

      if (_profileMap["paymentMethod"] != null) {
        cashPayment =
            _profileMap["paymentMethod"]["cashPayment"]?.toString() ?? "0";
      }

      if (_profileMap["insuranceId"] != null) {
        _providerInsuranceList = _profileMap["insuranceId"];
        _container.setProviderInsuranceMap(_providerInsuranceList);
      }
    }

    SharedPref().getToken().then((token) {
      setState(() {
        _insuranceFuture =
            _api.getUserDetails(token).timeout(Duration(seconds: 10));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        isLoading: _isLoading,
        title: widget.isPayment ? "Select Payment Methods" : "Payment Methods",
        isAddBack: !widget.isPayment,
        addBackButton: widget.isPayment,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: widget.isPayment ? 60.0 : 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _widgetList(),
                ),
              ),
            ),
            !widget.isPayment
                ? Container()
                : Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Container(
                      height: 55.0,
                      width: MediaQuery.of(context).size.width - 76.0,
                      padding: const EdgeInsets.only(right: 20.0, left: 40.0),
                      child: FancyButton(
                        title: "Continue",
                        onPressed: () {
                          Map _paymentMap = new Map();

                          if (_radioValue != null) {
                            if (_radioValue == 2) {
                              _paymentMap["paymentType"] = "1";
                            } else if (_radioValue == 1) {}

                            _container.setConsentToTreatData(
                                "paymentMap", _paymentMap);

                            Navigator.of(context)
                                .pushNamed(Routes.reviewAppointmentScreen);
                          } else if (_listRadioValue != null) {
                            _paymentMap["paymentType"] = "2";
                            _paymentMap["insuranceId"] = insuranceId;
                            _paymentMap["insuranceName"] = insuranceName;
                            _paymentMap["insuranceImage"] = insuranceImage;

                            _container.setConsentToTreatData(
                                "paymentMap", _paymentMap);

                            Navigator.of(context)
                                .pushNamed(Routes.reviewAppointmentScreen);
                          } else {
                            Widgets.showToast("Please select a payment method");
                          }
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  List<Widget> _widgetList() {
    List<Widget> _widgetList = List();

    _widgetList.add(
      Text(
        "Saved Cards",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.93),
        ),
      ),
    );

    _widgetList.add(SizedBox(height: 12.0));

    _widgetList.add(paymentCard("ic_dummy_card", "**** ***** **** 2563", 1,
        cardExpiryDate: "Expires 10/24"));
    //TODO: remove static card

    _widgetList.add(SizedBox(height: 22.0));

    _widgetList.add(addCard("ic_add_card", "Add New Card"));

    _widgetList.add(SizedBox(height: 40.0));

    _widgetList.add(Text(
      "Your Insurance",
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.93),
      ),
    ));

    _widgetList.add(SizedBox(height: 12.0));

    _widgetList.add(_insuranceFutureWidget());

    _widgetList.add(SizedBox(height: 10.0));

    _widgetList.add(addCard("ic_upload_insurance", "Upload Insurance Card"));

    _widgetList.add(SizedBox(height: 40.0));

    _widgetList.add(paymentCard(
      "ic_cash_payment",
      "Cash/Check",
      2,
    ));

    return _widgetList;
  }

  Widget _insuranceFutureWidget() {
    Map _insuranceViewMap = {};
    _insuranceViewMap['isPayment'] = widget.isPayment;
    _insuranceViewMap['isViewDetail'] = true;

    return FutureBuilder<List<dynamic>>(
      future: _insuranceFuture,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("NO data available");
            break;
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              _insuranceList = snapshot.data;

              if (_insuranceList == null || _insuranceList.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text("NO saved insurance available"),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: _insuranceList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        border: Border.all(color: Colors.grey[100]),
                      ),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.network(
                              ApiBaseHelper.imageUrl +
                                  _insuranceList[index]
                                      ["insuranceDocumentFront"],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 17.0),
                          Text(
                            _insuranceList[index]["insuranceName"],
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: !widget.isPayment
                                  ? Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: 16,
                                    )
                                  : Radio(
                                      activeColor: AppColors.persian_blue,
                                      value: index,
                                      groupValue: _listRadioValue,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onChanged: !_providerInsuranceList
                                              .contains(_insuranceList[index]
                                                      ["insuranceId"]
                                                  .toString())
                                          ? null
                                          : (int value) {
                                              setState(() {
                                                _radioValue = null;
                                                _listRadioValue = value;
                                              });

                                              insuranceId =
                                                  _insuranceList[index]["_id"];
                                              insuranceName =
                                                  _insuranceList[index]
                                                      ["insuranceName"];
                                              insuranceImage = _insuranceList[
                                                      index]
                                                  ["insuranceDocumentFront"];
                                            },
                                    ),
                            ),
                          )
                        ],
                      ).onClick(
                        onTap: widget.isPayment
                            ? null
                            : () {
                                _insuranceViewMap['insurance'] =
                                    _insuranceList[index];

                                if (_container.insuranceDataMap != null) {
                                  _container.insuranceDataMap.clear();
                                }

                                Navigator.of(context)
                                    .pushNamed(
                                  Routes.uploadInsuranceImagesScreen,
                                  arguments: _insuranceViewMap,
                                )
                                    .whenComplete(() {
                                  SharedPref().getToken().then((token) {
                                    setState(() {
                                      _insuranceFuture = _api
                                          .getUserDetails(token)
                                          .timeout(Duration(seconds: 10));
                                    });
                                  });
                                });
                              },
                      ),
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              snapshot.error.toString().debugLog();
              return Center(
                child: Text("NO data available"),
              );
            }

            break;
        }
        return Container();
      },
    );
  }

  Widget paymentCard(String imageIcon, String title, int value,
      {String cardExpiryDate}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        border: Border.all(color: Colors.grey[100]),
      ),
      child: Row(
        children: <Widget>[
          imageIcon.imageIcon(width: 70, height: 70),
          SizedBox(width: 17.0),
          title.toLowerCase().contains("cash")
              ? Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      cardExpiryDate,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
          widget.isPayment == false
              ? Container()
              : Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Radio(
                      activeColor: AppColors.persian_blue,
                      value: value,
                      groupValue: _radioValue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (title.toLowerCase().contains("cash") &&
                              cashPayment == "1")
                          ? _handleRadioValueChange
                          : null,
                      //TODO: check for cardPayment when it's done in API
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget addCard(String icon, String title) {
    return FlatButton.icon(
      onPressed: () {
        Map _insuranceMap = {};
        _insuranceMap['isPayment'] = widget.isPayment;
        _insuranceMap['insuranceList'] = _insuranceList;

        title.toLowerCase().contains("insurance")
            ? Navigator.of(context)
                .pushNamed(
                  Routes.insuranceListScreen,
                  arguments: _insuranceMap,
                )
                .whenComplete(
                  () => SharedPref().getToken().then(
                    (token) {
                      setState(() {
                        _listRadioValue = null;
                        _radioValue = null;

                        _insuranceFuture = _api
                            .getUserDetails(token)
                            .timeout(Duration(seconds: 20));
                      });
                    },
                  ),
                )
            : Navigator.of(context).pushNamed(Routes.addNewCardScreen);
      },
      icon: icon.imageIcon(
        width: 20.0,
        height: 20.0,
      ),
      label: Text(
        title,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.93),
        ),
      ),
    );
  }

  void showThankDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                14.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                "ic_feedback_done".imageIcon(
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 15),
                Text(
                  "Payment Completed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.90),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "\$$totalFee Paid on " +
                      DateFormat("dd").format(DateTime.now()) +
                      "th " +
                      DateFormat("MMMM").format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 26),
                ClipOval(
                  child: avatar == null
                      ? "profile_user".imageIcon(
                          height: 38,
                          width: 38,
                        )
                      : Image.network(
                          ApiBaseHelper.imageUrl + avatar,
                          height: 38,
                          width: 38,
                        ),
                ),
                SizedBox(height: 6),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
                SizedBox(height: 26),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: AppColors.goldenTainoi,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleRadioValueChange(int value) => setState(() {
        _radioValue = value;
        _listRadioValue = null;
      });
}
