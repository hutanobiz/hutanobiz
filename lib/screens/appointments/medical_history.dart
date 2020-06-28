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
  Future<List<MedicalHistory>> _medicalFuture;
  ApiBaseHelper api = ApiBaseHelper();

  InheritedContainerState _container;
  List<dynamic> _diseaseList = List();

  @override
  void initState() {
    _medicalFuture = api.getDiseases();

    SharedPref().getToken().then((token) {
      api.getLastAppointmentDetails(token).then((response) {
        if (response != null) {
          if (response["medicalHistory"] != null) {
            for (dynamic medical in response["medicalHistory"]) {
              if (medical["_id"].toString() != null)
                _diseaseList.add(medical["_id"].toString());
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
                    value: _diseaseList.contains(medicalHistory.sId),
                    activeColor: AppColors.goldenTainoi,
                    onChanged: (value) {
                      setState(() {
                        value == true
                            ? _diseaseList.add(medicalHistory.sId)
                            : _diseaseList.remove(medicalHistory.sId);
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
      ),
    );
  }
}
