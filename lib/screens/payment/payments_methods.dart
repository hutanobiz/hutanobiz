import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';
import 'package:intl/intl.dart';

class PaymentMethodScreen extends StatefulWidget {
  PaymentMethodScreen({Key key}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _radioValue;

  Future<List<dynamic>> _insuranceFuture;
  ApiBaseHelper _api = ApiBaseHelper();
  InheritedContainerState _container;
  String insuranceId, totalFee;

  bool _isLoading = false;
  Map appointmentData = new Map();
  Map providerMap;
  String name, avatar, cashPayment = "0";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    if (_container.providerResponse != null) {
      providerMap = _container.providerResponse;

      if (providerMap["providerData"] != null) {
        if (providerMap["providerData"]["data"] != null) {
          appointmentData = providerMap["providerData"]["data"];
        } else {
          appointmentData = providerMap["providerData"];
        }
      }

      if (providerMap["totalFee"] != null) {
        totalFee = providerMap["totalFee"];
      }

      if (appointmentData["doctor"] != null) {
        name = appointmentData["doctor"]["fullName"] ?? "---";
        avatar = appointmentData["doctor"]["avatar"];
      }
    }

    if (appointmentData["doctorData"] != null) {
      for (dynamic detail in appointmentData["doctorData"]) {
        if (detail["paymentMethod"] != null) {
          cashPayment =
              detail["paymentMethod"]["cashPayment"]?.toString() ?? "0";
        }
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
        title: "Select Payment Methods",
        isAddBack: false,
        addBackButton: true,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 60.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _widgetList(),
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                width: MediaQuery.of(context).size.width - 76.0,
                padding: const EdgeInsets.only(right: 20.0, left: 40.0),
                child: FancyButton(
                  title: "Pay \$$totalFee",
                  onPressed: () {
                    if (_radioValue != null) {
                      _loading(true);
                      Map map = new Map();

                      if (_radioValue == 3) {
                        map["cashPayment"] = "1";
                      } else if (_radioValue == 1) {
                      } else {
                        map["insuranceId"] = insuranceId;
                      }
                      SharedPref().getToken().then((token) {
                        _api
                            .postPayment(
                                token,
                                _container.appointmentIdMap["appointmentId"]
                                    .toString(),
                                map)
                            .then((value) {
                          _loading(false);
                          showThankDialog();
                        }).futureError((error) {
                          _loading(false);
                          Widgets.showToast(error.toString());
                          error.toString().debugLog();
                        });
                      });
                    } else {
                      Widgets.showToast("Please select a payment method");
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _widgetList() {
    List<Widget> _widgetList = List();

    _widgetList.add(Text(
      "Saved Cards",
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.93),
      ),
    ));

    _widgetList.add(SizedBox(height: 12.0));

    _widgetList.add(paymentCard(
      "ic_dummy_card",
      "**** ***** **** 2563",
      1,
    ));

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

    _widgetList.add(_futureWidget());

    _widgetList.add(SizedBox(height: 22.0));

    _widgetList.add(addCard("ic_upload_insurance", "Upload Insurance Card"));

    _container.providerInsuranceList == null ||
            _container.providerInsuranceList.isEmpty
        ? Container()
        : _widgetList.add(SizedBox(height: 40.0));

    _widgetList.add(paymentCard(
      "ic_cash_payment",
      "Cash/Check",
      3,
    ));

    return _widgetList;
  }

  Widget _futureWidget() {
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
              List data = snapshot.data;

              return ListView.builder(
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
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
                                data[index]["insuranceDocumentFront"],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 17.0),
                        Text(
                          data[index]["insuranceName"],
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Radio(
                              activeColor: AppColors.persian_blue,
                              value: index,
                              groupValue: _radioValue,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: !_container.providerInsuranceList
                                      .contains(
                                          data[index]["insuranceId"].toString())
                                  ? null
                                  : (int value) {
                                      setState(() => _radioValue = value);
                                      insuranceId = data[index]["_id"];
                                    },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              snapshot.error.toString().debugLog();
              return Center(
                child: Text("NO slots available"),
              );
            }

            break;
        }
        return Container();
      },
    );
  }

  Widget paymentCard(String imageIcon, String title, int value) {
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
                      "Expires 10/24",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Radio(
                activeColor: AppColors.persian_blue,
                value: value,
                groupValue: _radioValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged:
                    (title.toLowerCase().contains("cash") && cashPayment == "1")
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
      onPressed: () => Navigator.of(context)
          .pushNamed(title.toLowerCase().contains("insurance")
              ? Routes.insuranceListScreen
              : Routes.addNewCardScreen)
          .whenComplete(
            () => SharedPref().getToken().then(
              (token) {
                setState(() {
                  _insuranceFuture =
                      _api.getUserDetails(token).timeout(Duration(seconds: 10));
                });
              },
            ),
          ),
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
                      "Done",
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

  void _loading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  void _handleRadioValueChange(int value) =>
      setState(() => _radioValue = value);
}
