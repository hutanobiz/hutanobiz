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

  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: Stack(
          children: <Widget>[
            FutureBuilder<List<MedicalHistory>>(
              future: _medicalFuture,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  List<MedicalHistory> data = snapshot.data;

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 65),
                    shrinkWrap: true,
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
                              if (!_diseaseList.contains(medicalHistory.name)) {
                                _diseaseList.add(medicalHistory.name);
                              }
                            } else {
                              _diseaseList.remove(medicalHistory.name);
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
            isBottomButtonsShow
                ? Container()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 55,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: FancyButton(
                        title: 'Save',
                        onPressed: saveMedicalHistory,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void saveMedicalHistory() {
    Map diseaseMap = {};

    if (_diseaseList.length > 0) {
      setLoading(true);

      for (int i = 0; i < _diseaseList.length; i++) {
        if (!diseaseMap.containsValue(_diseaseList[i])) {
          diseaseMap['medicalHistory[${i.toString()}]'] = _diseaseList[i];
        }
      }

      api.sendPatientMedicalHistory(token, diseaseMap).then((response) {
        if (response != null) {
          setLoading(false);

          if (isBottomButtonsShow) {
            Navigator.of(context).pushNamed(Routes.seekingCureScreen);
          }
        }
      }).futureError((error) {
        setLoading(false);
        error.toString().debugLog();
      });
    } else {
      Widgets.showToast('Please select a disease');
    }
  }

  void setLoading(bool value) {
    setState(() => _isLoading = value);
  }
}
