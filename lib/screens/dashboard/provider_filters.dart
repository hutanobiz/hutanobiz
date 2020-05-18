import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/filter_radio_model.dart';
import 'package:hutano/models/medicalHistory.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/utils/extensions.dart';

class ProviderFiltersScreen extends StatefulWidget {
  ProviderFiltersScreen({Key key}) : super(key: key);

  @override
  _ProviderFiltersScreenState createState() => _ProviderFiltersScreenState();
}

class _ProviderFiltersScreenState extends State<ProviderFiltersScreen> {
  Future<List<MedicalHistory>> _todoFuture;
  ApiBaseHelper api = ApiBaseHelper();

  InheritedContainerState _container;
  List<dynamic> _diseaseList = List();

  List<RadioModel> filtersList = new List<RadioModel>();

  @override
  void initState() {
    _todoFuture = api.getDiseases();

    filtersList.add(RadioModel(false, "Professional Title"));
    filtersList.add(RadioModel(false, "Speciality"));
    filtersList.add(RadioModel(false, "Degree"));
    filtersList.add(RadioModel(false, "Experience"));
    filtersList.add(RadioModel(false, "Appointment Type"));
    filtersList.add(RadioModel(false, "Distance"));
    filtersList.add(RadioModel(false, "Language"));

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
        title: "Filters",
        isAddBack: false,
        color: Colors.white,
        padding: EdgeInsets.zero,
        child: Row(
          children: <Widget>[
            Material(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF3F2F8).withOpacity(0.50),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(22.0),
                  ),
                ),
                width: 140,
                child: ListView.builder(
                  itemCount: filtersList.length,
                  itemBuilder: (context, index) {
                    RadioModel model = filtersList[index];
                    return filterWidget(model).onClick(onTap: () {
                      setState(() {
                        filtersList
                            .forEach((element) => element.isSelected = false);
                        model.isSelected = true;
                      });
                    });
                  },
                ),
              ),
            ),
            Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget filterWidget(RadioModel model) {
    return Container(
      height: 70,
      padding: EdgeInsets.all(20),
      child: Text(model.text),
      decoration: BoxDecoration(
        color: model.isSelected ? Colors.white : Colors.transparent,
        borderRadius: model.isSelected
            ? BorderRadius.only(
                bottomRight: const Radius.circular(22.0),
                topRight: const Radius.circular(22.0),
              )
            : BorderRadius.all(Radius.zero),
      ),
    );
  }
}
