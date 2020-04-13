import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background.dart';

class AddNewCardScreen extends StatefulWidget {
  AddNewCardScreen({Key key}) : super(key: key);

  @override
  _AddNewCardScreenState createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _cardNoController = TextEditingController();
  final _holderNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNoController.dispose();
    _holderNameController.dispose();
    _cvvController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _cardNoController.addListener(() {
      setState(() {});
    });

    _holderNameController.addListener(() {
      setState(() {});
    });

    _expiryDateController.addListener(() {
      setState(() {});
    });

    _cvvController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Add New Card",
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: ListView(
                shrinkWrap: true,
                children: _widgetList(),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                child: FancyButton(
                  title: "Add",
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

    _widgetList.add(textField("Card no.", _cardNoController));

    _widgetList.add(SizedBox(height: 20.0));

    _widgetList.add(textField("Card holder name", _holderNameController));

    _widgetList.add(SizedBox(height: 20.0));

    _widgetList.add(Row(
      children: <Widget>[
        Expanded(child: textField("Expire date", _expiryDateController)),
        SizedBox(width: 16.0),
        Expanded(child: textField("CVV", _cvvController)),
      ],
    ));

    return _widgetList;
  }

  Widget textField(String lable, final controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey),
        labelText: lable,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[300],
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
