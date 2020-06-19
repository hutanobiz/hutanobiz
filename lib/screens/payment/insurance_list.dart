import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';

class InsuranceListScreen extends StatefulWidget {
  final Map insuranceMap;
  InsuranceListScreen({Key key, this.insuranceMap}) : super(key: key);

  @override
  _InsuranceListScreenState createState() => _InsuranceListScreenState();
}

class _InsuranceListScreenState extends State<InsuranceListScreen> {
  int _radioValue;

  Future<List<dynamic>> _insuranceFuture;
  ApiBaseHelper _api = ApiBaseHelper();
  InheritedContainerState _container;
  Map _insuranceViewMap = {};
  List _selectedInsuranceList = [];
  List _alreadyInsuranceList = [];

  @override
  void initState() {
    super.initState();

    _insuranceViewMap['isPayment'] = widget.insuranceMap['isPayment'];
    _insuranceViewMap['isViewDetail'] = false;

    for (dynamic insurance in widget.insuranceMap['insuranceList']) {
      _alreadyInsuranceList.add(insurance['insuranceId'].toString());
    }

    setState(() {
      _insuranceFuture = _api.getInsuranceList().timeout(Duration(seconds: 10));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    if (_insuranceViewMap['isPayment']) {
      _selectedInsuranceList = _container.providerInsuranceList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Insurances",
        color: Colors.white,
        padding: EdgeInsets.zero,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  right: 15, left: 15, top: 15, bottom: 60),
              child: _buildList(),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                width: MediaQuery.of(context).size.width,
                child: FancyButton(
                  title: 'Save',
                  onPressed: () {
                    if (_radioValue == null) {
                      Widgets.showToast('Please select an insurance');
                    } else {
                      Navigator.of(context).pushNamed(
                        Routes.uploadInsuranceImagesScreen,
                        arguments: _insuranceViewMap,
                      );
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

  Widget _buildList() {
    return FutureBuilder<dynamic>(
      future: _insuranceFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List insuranceList = snapshot.data;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 50),
            itemCount: insuranceList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: insuranceWidget(insuranceList[index], index),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget insuranceWidget(dynamic insurance, int index) {
    return RadioListTile(
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: AppColors.goldenTainoi,
      value: index,
      groupValue: _radioValue,
      onChanged: _insuranceViewMap['isPayment']
          ? !_selectedInsuranceList.contains(insurance["_id"].toString())
              ? null
              : _insuranceAlreadyAdded(insurance)
          : _insuranceAlreadyAdded(insurance),
      title: Row(
        children: <Widget>[
          Image.asset(
            "images/insurancePlaceHolder.png",
            width: 60,
            height: 60,
          ),
          SizedBox(width: 14),
          Text(
            insurance["title"].toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Function _insuranceAlreadyAdded(dynamic insurance) {
    return _alreadyInsuranceList.contains(insurance["_id"].toString())
        ? null
        : (value) {
            setState(
              () => _radioValue = value,
            );

            _container.setInsuranceData(
                "insuranceId", insurance["_id"].toString());
          };
  }
}
