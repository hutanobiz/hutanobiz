import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/medicalHistory.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/fancy_button.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/widgets.dart';

class MedicalHistoryScreen extends StatefulWidget {
  MedicalHistoryScreen({Key key, this.isBottomButtonsShow}) : super(key: key);

  final bool isBottomButtonsShow;

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  Future<List<MedicalHistory>> _medicalFuture;
  ApiBaseHelper api = ApiBaseHelper();

  List<dynamic> _diseaseList = [];

  bool isBottomButtonsShow = true;

  String token = '';

  bool _isLoading = false;

  TextEditingController _otherDiseaseController = TextEditingController();

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
                  FutureBuilder<List<MedicalHistory>>(
                    future: _medicalFuture,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        List<MedicalHistory> data = snapshot.data;

                        return ListView.builder(
                          padding: EdgeInsets.only(
                              bottom:
                                  _diseaseList.contains('Others') ? 10 : 65),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            MedicalHistory medicalHistory = data[index];

                            return CheckboxListTile(
                              title: Text(medicalHistory.name),
                              value: _diseaseList.contains(medicalHistory.name),
                              activeColor: AppColors.goldenTainoi,
                              onChanged: (value) {
                                setState(() {
                                  if (value) {
                                    if (!_diseaseList
                                        .contains(medicalHistory.name)) {
                                      _diseaseList.add(medicalHistory.name);
                                    }
                                  } else {
                                    setLoading(true);
                                    api
                                        .deletePatientMedicalHistory(
                                            token, medicalHistory.name)
                                        .then((value) {
                                      setLoading(false);
                                      _diseaseList.remove(medicalHistory.name);
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
                  _diseaseList.contains('Others')
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 75),
                          child: TextField(
                            controller: _otherDiseaseController,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              labelText: "Type your disease...",
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
    //TODO: send medical history code

    // Map<String, String> diseaseMap = {};

    if (_otherDiseaseController.text.isNotEmpty) {
      _diseaseList.add(_otherDiseaseController.text);
    }

    // if (_diseaseList.length > 0) {
    // setLoading(true);

    // for (int i = 0; i < _diseaseList.length; i++) {
    //   if (!diseaseMap.containsValue(_diseaseList[i])) {
    //     diseaseMap['medicalHistory[${i.toString()}]'] = _diseaseList[i];
    //   }
    // }

    // api.sendPatientMedicalHistory(token, diseaseMap).then((response) {
    //   if (response != null) {
    //     setLoading(false);

    if (isBottomButtonsShow) {
      Navigator.of(context).pushNamed(Routes.seekingCureScreen);
    }
    //   }
    // }).futureError((error) {
    //   setLoading(false);
    //   error.toString().debugLog();
    // });
    // } else {
    //   Widgets.showToast('Please select a disease');
    // }

    //TODO: send medical history code
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
