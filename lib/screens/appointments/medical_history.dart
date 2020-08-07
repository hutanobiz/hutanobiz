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

class MedicalHistoryScreen extends StatefulWidget {
  MedicalHistoryScreen({Key key, this.isBottomButtonsShow}) : super(key: key);

  final bool isBottomButtonsShow;

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  Future<List<dynamic>> _medicalFuture;
  ApiBaseHelper api = ApiBaseHelper();

  List<dynamic> _diseaseList = [];

  bool isBottomButtonsShow = true;

  String token = '';

  bool _isLoading = false;

  TextEditingController _otherDiseaseController = TextEditingController();

  InheritedContainerState _container;

  @override
  void initState() {
    super.initState();

    _otherDiseaseController.addListener(() {
      setState(() {});
    });

    if (widget.isBottomButtonsShow != null) {
      isBottomButtonsShow = widget.isBottomButtonsShow;
    }

    _medicalFuture = api.getDiseases();

    SharedPref().getToken().then((token) {
      setState(() {
        this.token = token;
      });

      api.getPatientDocuments(token).then((response) {
        if (response != null) {
          setLoading(false);

          if (response["medicalHistory"] != null) {
            setState(() {
              _diseaseList = response["medicalHistory"];
            });
          }
        }
      }).futureError((error) {
        setLoading(false);
        error.toString().debugLog();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _container = InheritedContainer.of(context);
  }

  @override
  void dispose() {
    _otherDiseaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
          isBottomButtonsShow ? AppColors.goldenTainoi : Colors.white,
      body: LoadingBackground(
        title: "Medical History",
        isLoading: _isLoading,
        isAddAppBar: isBottomButtonsShow,
        isAddBack: !isBottomButtonsShow,
        addBottomArrows: isBottomButtonsShow,
        onForwardTap: saveMedicalHistory,
        color: Colors.white,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  FutureBuilder<List<dynamic>>(
                    future: _medicalFuture,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == null) return Container();

                        List<dynamic> data = [];
                        data.clear();

                        for (dynamic medicalHistory in snapshot.data) {
                          data.add(medicalHistory['name']);
                        }

                        for (dynamic medicalHistory in _diseaseList) {
                          if (!data.contains(medicalHistory)) {
                            data.insert(0, medicalHistory);
                          }
                        }

                        return ListView.builder(
                          padding: EdgeInsets.only(
                              bottom: (_diseaseList.contains('Others') ||
                                      _diseaseList.contains('Other'))
                                  ? 10
                                  : 65),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            dynamic medicalHistory = data[index];

                            return CheckboxListTile(
                              title: Text(
                                medicalHistory,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              value: _diseaseList.contains(medicalHistory),
                              activeColor: AppColors.goldenTainoi,
                              onChanged: (value) {
                                setState(() {
                                  if (value) {
                                    if (!_diseaseList
                                        .contains(medicalHistory)) {
                                      _diseaseList.add(medicalHistory);
                                    }
                                  } else {
                                    setLoading(true);
                                    api
                                        .deletePatientMedicalHistory(
                                            token, medicalHistory)
                                        .then((value) {
                                      setLoading(false);
                                      _diseaseList.remove(medicalHistory);
                                    }).futureError((error) {
                                      setLoading(false);
                                      error.toString().debugLog();
                                    });
                                  }
                                });
                              },
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
                  ),
                  (_diseaseList.contains('Others') ||
                          _diseaseList.contains('Other'))
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 75),
                          child: TextField(
                            scrollPadding: EdgeInsets.only(
                              bottom: isBottomButtonsShow ? 100 : 0,
                            ),
                            controller: _otherDiseaseController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              labelText: "Other Medical Conditions",
                              alignLabelWithHint: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[300]),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            isBottomButtonsShow
                ? Container()
                : Container(
                    height: 55,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: FancyButton(
                      title: 'Save',
                      onPressed: saveMedicalHistory,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void saveMedicalHistory() {
    if (_diseaseList.length > 0) {
      Map<String, String> diseaseMap = {};

      if ((_diseaseList.contains('Others') || _diseaseList.contains('Other')) &&
          _otherDiseaseController.text.isEmpty) {
        Widgets.showToast('Please enter the disease');
      } else {
        FocusScope.of(context).requestFocus(FocusNode());

        if ((_diseaseList.contains('Others') ||
            _diseaseList.contains('Other'))) {
          _diseaseList.remove('Others');
          _diseaseList.remove('Other');
        }

        if (_otherDiseaseController.text.isNotEmpty) {
          _diseaseList.add(_otherDiseaseController.text);
        }

        setLoading(true);

        for (int i = 0; i < _diseaseList.length; i++) {
          if (!diseaseMap.containsValue(_diseaseList[i])) {
            diseaseMap['medicalHistory[${i.toString()}]'] = _diseaseList[i];
          }
        }

        api.sendPatientMedicalHistory(token, diseaseMap).then((response) {
          if (response != null) {
            setLoading(false);

            if (_otherDiseaseController.text.isNotEmpty) {
              _otherDiseaseController.text = '';
            }

            if (isBottomButtonsShow) {
              if (_diseaseList != null && _diseaseList.length > 0) {
                _container.setConsentToTreatData(
                    "medicalHistory", _diseaseList);
              }

              Navigator.of(context).pushNamed(Routes.seekingCureScreen);
            }
          }
        }).futureError((error) {
          setLoading(false);
          error.toString().debugLog();
        });
      }
    } else {
      Widgets.showToast('Please select a disease');
    }
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
