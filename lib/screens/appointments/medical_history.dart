import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/medicalHistory.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';

class MedicalHistoryScreen extends StatefulWidget {
  MedicalHistoryScreen({Key key}) : super(key: key);

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  Future<List<MedicalHistory>> _todoFuture;
  ApiBaseHelper api = ApiBaseHelper();
  bool isSelected = false;

  InheritedContainerState _container;
  List<dynamic> _diseaseList = List();
  List _medicalHistoryList = List();

  @override
  void initState() {
    _todoFuture = api.getDiseases();

    SharedPref().getToken().then((token) {
      api.getLastAppointmentDetails(token).then((response) {
        if (response != null) {
          if (response["medicalHistory"] != null) {
            for (dynamic medical in response["medicalHistory"]) {
              if (medical["_id"].toString() != null)
                _medicalHistoryList.add(medical["_id"].toString());
            }
          }
        }
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Medical History",
        isAddBack: false,
        addBottomArrows: true,
        onForwardTap: () {
          if (_diseaseList.length > 0) {
            _container.setConsentToTreatData("medicalHistory", _diseaseList);
          }

          Navigator.of(context).pushNamed(Routes.seekingCureScreen);
        },
        color: Colors.white,
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder<List<MedicalHistory>>(
          future: _todoFuture,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              List<MedicalHistory> data = snapshot.data;

              return ListView.builder(
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  MedicalHistory medicalHistory = data[index];

                  if (_medicalHistoryList != null &&
                      _medicalHistoryList.length > 0) {
                    if (_medicalHistoryList.contains(medicalHistory.sId)) {
                      medicalHistory.isSelected = true;
                    }
                  }

                  return CheckboxListTile(
                    title: Text(medicalHistory.name),
                    value: medicalHistory.isSelected,
                    activeColor: AppColors.goldenTainoi,
                    onChanged: (value) {
                      if (value)
                        _diseaseList.add(medicalHistory.sId);
                      else {
                        _diseaseList.remove(medicalHistory.sId);

                        if (_medicalHistoryList != null &&
                            _medicalHistoryList.length > 0) {
                          if (_medicalHistoryList
                              .contains(medicalHistory.sId)) {
                            _medicalHistoryList.remove(medicalHistory.sId);
                          }
                        }
                      }

                      setState(() => medicalHistory.isSelected = value);
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
      ),
    );
  }
}
