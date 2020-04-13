import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/utils/extensions.dart';

class PaymentMethodScreen extends StatefulWidget {
  PaymentMethodScreen({Key key}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
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
                  title: "Continue",
                  onPressed: () {},
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
      (value) {},
    ));

    _widgetList.add(SizedBox(height: 14.0));

    _widgetList.add(addCard());

    _widgetList.add(SizedBox(height: 40.0));

    _widgetList.add(paymentCard(
      "ic_cash_payment",
      "Cash/Check",
      (value) {},
    ));

    return _widgetList;
  }

  Widget paymentCard(String imageIcon, String title, Function onChanged) {
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
                value: false,
                groupValue: true,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: onChanged,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget addCard() {
    return FlatButton.icon(
      onPressed: () => Navigator.of(context).pushNamed(Routes.addNewCardScreen),
      icon: "ic_add_card".imageIcon(
        width: 20.0,
        height: 20.0,
      ),
      label: Text(
        "Add New Card",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.93),
        ),
      ),
    );
  }
}
