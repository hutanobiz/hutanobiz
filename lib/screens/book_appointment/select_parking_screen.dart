import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';

class SelectParkingScreen extends StatefulWidget {
  SelectParkingScreen({Key key}) : super(key: key);

  @override
  _SelectParkingScreenState createState() => _SelectParkingScreenState();
}

class _SelectParkingScreenState extends State<SelectParkingScreen> {
  String _selectedParking;
  double _parkingFee = 30;

  InheritedContainerState _container;

  List _parkingList = ['Driveway', 'Street', 'Designated', 'Parking Garage'];
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _instructionsController.addListener(() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: 'Where do I park?',
        isAddBack: false,
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
                    if (_parkingFee == null) {
                      Widgets.showErrorDialog(
                        context: context,
                        description: 'Please select parking fee',
                      );
                      return;
                    }

                    Map _paymentMap = new Map();

                    _paymentMap["parkingType"] = _selectedParking;
                    _paymentMap["parkingFee"] = _parkingFee;

                    if (_instructionsController.text != null) {
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

  List<Widget> _widgetList() {
    List<Widget> _widgetList = List();

    _widgetList.add(_containerWidget(parkingWidget()));

    _widgetList.add(SizedBox(height: 8.0));

    _widgetList.add(
      Container(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 0.5, color: Colors.grey[300]),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: Row(
                children: [
                  Text(
                    'Parking Fee',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(7),
                          border:
                              Border.all(width: 0.5, color: Colors.grey[300]),
                        ),
                        child: Text(
                          "\$${_parkingFee.round().toString()}  /hr",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.goldenTainoi,
                inactiveTrackColor: Colors.grey[300],
                thumbColor: AppColors.goldenTainoi,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 12,
                  disabledThumbRadius: 12,
                ),
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorColor: Colors.transparent,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.black.withOpacity(0.90),
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0,
                ),
              ),
              child: Slider.adaptive(
                value: _parkingFee,
                min: 0,
                max: 100,
                label: "\$${_parkingFee.round().toString()}",
                onChanged: (v) {
                  setState(() {
                    _parkingFee = v;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Free',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.67),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "\$100",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.67),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
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
                _parkingList[index],
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          trailing: Padding(
            padding: EdgeInsets.only(right: 12),
            child: (index + 1).toString() == _selectedParking
                ? Image.asset("images/checkedCheck.png", height: 24, width: 24)
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
        );
      },
    );
  }
}
