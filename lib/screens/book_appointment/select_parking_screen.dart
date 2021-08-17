import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/widgets.dart';

class SelectParkingScreen extends StatefulWidget {
  SelectParkingScreen({Key key}) : super(key: key);

  @override
  _SelectParkingScreenState createState() => _SelectParkingScreenState();
}

class _SelectParkingScreenState extends State<SelectParkingScreen> {
  String _selectedParking;
  double _parkingFee;

  InheritedContainerState _container;

  List _parkingList = ['Driveway', 'Street', 'Designated', 'Parking Garage'];
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _bayNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _instructionsController.addListener(() {
      setState(() {});
    });
    _bayNumberController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    _bayNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        title: 'Where do I park?',
        isAddBack: false,
        addHeader: true,
        addBackButton: true,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 60.0),
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
                width: 212,
                child: FancyButton(
                  title: "Proceed to payment",
                  onPressed: () {
                    if (_selectedParking == null) {
                      Widgets.showErrorDialog(
                        context: context,
                        description: 'Please select a parking type',
                      );
                      return;
                    }
                    if (_selectedParking == '3' &&
                        _bayNumberController.text.trim() == '') {
                      Widgets.showErrorDialog(
                        context: context,
                        description: 'Please enter the bay number',
                      );
                      return;
                    }

                    Map _paymentMap = new Map();

                    _paymentMap["parkingType"] = _selectedParking;
                    _paymentMap["parkingFee"] = _parkingFee ?? 0;
                    _paymentMap["parkingBay"] = _bayNumberController.text;

                    if (_instructionsController.text != null ||
                        _instructionsController.text.isNotEmpty) {
                      _paymentMap["instructions"] =
                          _instructionsController.text;
                    }

                    _container.setConsentToTreatData("parkingMap", _paymentMap);

                    Navigator.of(context).pushNamed(
                      Routes.paymentMethodScreen,
                      arguments: true,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationTypeWidget(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: spacing5, bottom: spacing20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            Localization.of(context).locationTypeLabel,
            style: TextStyle(
                fontSize: fontSize18,
                fontWeight: fontWeightSemiBold,
                color: colorDarkBlack),
          ),
        ),
      );

  List<Widget> _widgetList() {
    List<Widget> _widgetList = List();
    _widgetList.add(_locationTypeWidget(context));
    _widgetList.add(_containerWidget(parkingWidget()));

    _widgetList.add(SizedBox(height: 8.0));

    _widgetList.add(
      Container(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        margin: const EdgeInsets.only(bottom: 20, right: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 0.5, color: Colors.grey[300]),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Parking Fee',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialValue:
                          _parkingFee == null ? "" : _parkingFee.toString(),
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87),
                      onChanged: (fee) {
                        setState(() {
                          if (fee == '') {
                            _parkingFee = 0;
                          } else {
                            _parkingFee = double.parse(fee);
                          }
                        });
                      },
                      decoration: InputDecoration(
                        prefix: Text("\$ ",
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87)),
                        suffix: Text(" /hr",
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87)),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );

    _widgetList.add(
      Text(
        "Other Parking Instructions",
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );

    _widgetList.add(SizedBox(height: 14.0));

    _widgetList.add(Container(
      height: 150.0,
      child: TextField(
        controller: _instructionsController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 10,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.grey),
          labelText: "Type something here...",
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
              color: Colors.grey[300],
              width: 0.5,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
              color: Colors.grey[300],
              width: 0.5,
            ),
          ),
        ),
      ),
    ));

    _widgetList.add(SizedBox(height: 40.0));

    return _widgetList;
  }

  Widget _containerWidget(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(width: 0.5, color: Colors.grey[300]),
      ),
      child: child,
    );
  }

  Widget parkingWidget() {
    return ListView.separated(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => Divider(),
      shrinkWrap: true,
      itemCount: _parkingList.length,
      itemBuilder: (context, int index) {
        String _icon = 'ic_driveway';

        switch (index) {
          case 0:
            _icon = 'ic_driveway';
            break;
          case 1:
            _icon = 'ic_street';
            break;
          case 2:
            _icon = 'ic_designated';
            break;
          case 3:
            _icon = 'ic_parking_garage';
            break;
          default:
        }

        return Container(
          color: index == 2 && _selectedParking == '3'
              ? Colors.grey[100]
              : Colors.white,
          child: Column(
            children: [
              ListTile(
                dense: true,
                title: Row(
                  children: [
                    Image.asset(
                      "images/$_icon.png",
                      height: 19,
                      width: 19,
                    ),
                    SizedBox(width: 18),
                    Text(
                      _parkingList[index],
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: (index + 1).toString() == _selectedParking
                      ? Image.asset("images/checkedCheck.png",
                          height: 24, width: 24)
                      : Image.asset(
                          "images/uncheckedCheck.png",
                          height: 24,
                          width: 24,
                        ),
                ),
                onTap: () {
                  setState(
                    () => _selectedParking = (index + 1).toString(),
                  );
                },
              ),
              if (index == 2 && _selectedParking == '3')
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        'Bay Number',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 70,
                            color: Colors.white,
                            child: TextField(
                              maxLines: 1,
                              controller: _bayNumberController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              else
                Container(),
            ],
          ),
        );
      },
    );
  }
}
