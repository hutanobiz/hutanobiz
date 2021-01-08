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
  List _providerInsuranceList = [];
  List _alreadyAddedInsuranceList = [];
  List _notAcceptednsuranceList = [];
  List<dynamic> searchList = [];
  List insuranceList = [];
  String _searchText = '';
  dynamic selectedInsurance;

  bool isFromRegister = false;

  @override
  void initState() {
    super.initState();

    if (widget.insuranceMap['isFromRegister'] != null) {
      isFromRegister = widget.insuranceMap['isFromRegister'];
    }

    _insuranceViewMap['isFromRegister'] = isFromRegister;

    _insuranceViewMap['isPayment'] = widget.insuranceMap['isPayment'];
    _insuranceViewMap['isViewDetail'] = false;

    if (widget.insuranceMap['insuranceList'] != null &&
        widget.insuranceMap['insuranceList'].isNotEmpty) {
      for (dynamic insurance in widget.insuranceMap['insuranceList']) {
        _alreadyAddedInsuranceList.add(insurance['insuranceId'].toString());
      }
    }

    setState(() {
      _insuranceFuture = _api.getInsuranceList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);

    if (_insuranceViewMap['isPayment']) {
      _providerInsuranceList = _container.providerInsuranceList;
    }
  }

  void filterSearch(String searchKey) {
    searchList.clear();

    if (searchKey.isNotEmpty) {
      for (dynamic f in insuranceList) {
        if (f != null) {
          if (f['title'].toLowerCase().contains(searchKey.toLowerCase())) {
            searchList.add(f);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: !_insuranceViewMap['isPayment'] && isFromRegister
            ? 'Add Insurance'
            : "Insurances",
        color: Colors.white,
        padding: EdgeInsets.zero,
        rightButtonText: 'I do not have insurance',
        onRightButtonTap: !_insuranceViewMap['isPayment'] && isFromRegister
            ? () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.dashboardScreen, (Route<dynamic> route) => false,arguments: 0);
              }
            : null,
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                        filterSearch(value);
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintMaxLines: 1,
                      isDense: true,
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(Icons.search),
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.goldenTainoi, width: 0.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.goldenTainoi, width: 0.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.goldenTainoi),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 15, left: 15, top: 15, bottom: 60),
                    child: _buildList(),
                  ),
                ),
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                height: 55.0,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                width: MediaQuery.of(context).size.width,
                child: FancyButton(
                  title: 'Next',
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
          if (insuranceList.isNotEmpty) insuranceList.clear();
          if (_notAcceptednsuranceList.isNotEmpty)
            _notAcceptednsuranceList.clear();

          for (dynamic insurance in snapshot.data) {
            if (_insuranceViewMap['isPayment']) {
              if (_providerInsuranceList
                  .contains(insurance['_id'].toString())) {
                insuranceList.add(insurance);
              } else {
                _notAcceptednsuranceList.add(insurance);
              }
            } else {
              insuranceList.add(insurance);
            }

            if (_alreadyAddedInsuranceList.isNotEmpty &&
                _alreadyAddedInsuranceList
                    .contains(insurance['_id'].toString())) {
              insuranceList.remove(insurance);
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  !_insuranceViewMap['isPayment'] || insuranceList.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 20),
                          child: Text(
                            'Insurance accepted by Provider',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  insuranceList.isEmpty
                      ? Container()
                      : ListView.separated(
                          physics: ClampingScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(height: 15),
                          shrinkWrap: true,
                          itemCount: _searchText == null || _searchText == ''
                              ? insuranceList.length
                              : searchList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                              child: insuranceWidget(
                                _searchText == null || _searchText == ''
                                    ? insuranceList[index]
                                    : searchList[index],
                                index,
                                isAcceptedByProvider: true,
                              ),
                            );
                          },
                        ),
                  !_insuranceViewMap['isPayment']
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.fromLTRB(
                              4, insuranceList.isEmpty ? 4 : 30, 4, 4),
                          child: Text(
                            'Insurance not accepted by Provider',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  !_insuranceViewMap['isPayment']
                      ? Container()
                      : ListView.separated(
                          physics: ClampingScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(height: 10),
                          shrinkWrap: true,
                          itemCount: _notAcceptednsuranceList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(4, 6, 4, 4),
                              child: insuranceWidget(
                                _notAcceptednsuranceList[index],
                                index,
                                isAcceptedByProvider: false,
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
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

  Widget insuranceWidget(dynamic insurance, int index,
      {bool isAcceptedByProvider}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.asset(
              "images/insurancePlaceHolder.png",
              width: 60,
              height: 60,
            ),
            SizedBox(width: 14),
            Expanded(
              flex: 4,
              child: Text(
                insurance["title"].toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 10),
            !isAcceptedByProvider ? Container() : checkBox(index, insurance),
          ],
        ),
      ],
    );
  }

  Widget checkBox(int index, dynamic insurance) => Expanded(
        child: Radio(
          activeColor: AppColors.persian_blue,
          value: index,
          groupValue: _searchText == null || _searchText == ''
              ? insuranceList.indexOf(selectedInsurance)
              : searchList.indexOf(selectedInsurance),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: _insuranceAlreadyAdded(insurance),
        ),
      );

  Function _insuranceAlreadyAdded(dynamic insurance) {
    return (value) {
      setState(
        () {
          selectedInsurance = insurance;
          return _radioValue = value;
        },
      );

      _container.setInsuranceData("insuranceId", insurance["_id"].toString());
    };
  }
}
