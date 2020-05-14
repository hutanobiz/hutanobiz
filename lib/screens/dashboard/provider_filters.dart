import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/models/medicalHistory.dart';
import 'package:hutano/utils/shared_prefrences.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/vertical_tabs.dart';

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

  @override
  void initState() {
    _todoFuture = api.getDiseases();

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
        // onForwardTap: () {
        //   if (_diseaseList.length > 0) {
        //     _container.setConsentToTreatData("medicalHistory", _diseaseList);
        //   }

        //   Navigator.of(context).pushNamed(Routes.seekingCureScreen);
        // },
        color: Colors.white,
        padding: EdgeInsets.zero,
        child: VerticalTabs(
          tabsWidth: 150,
          tabs: <Tab>[
            Tab(child: Text('Professional Title')),
            Tab(child: Text('Dart')),
            Tab(child: Text('NodeJS')),
            Tab(child: Text('PHP')),
            Tab(child: Text('HTML 5')),
          ],
          contents: <Widget>[
            Container(child: Text('Flutter'), padding: EdgeInsets.all(20)),
            Container(child: Text('Dart'), padding: EdgeInsets.all(20)),
            Container(child: Text('NodeJS'), padding: EdgeInsets.all(20)),
            Container(child: Text('PHP'), padding: EdgeInsets.all(20)),
            Container(child: Text('HTML 5'), padding: EdgeInsets.all(20))
          ],
        ),
        // FutureBuilder<List<MedicalHistory>>(
        //   future: _todoFuture,
        //   builder: (_, snapshot) {
        //     if (snapshot.hasData) {
        //       List<MedicalHistory> data = snapshot.data;

        //       return ListView.builder(
        //         padding: const EdgeInsets.all(0.0),
        //         shrinkWrap: true,
        //         itemCount: data.length,
        //         itemBuilder: (context, index) {
        //           MedicalHistory medicalHistory = data[index];

        //           return CheckboxListTile(
        //             title: Text(medicalHistory.name),
        //             value: _diseaseList.contains(medicalHistory.sId),
        //             activeColor: AppColors.goldenTainoi,
        //             onChanged: (value) {
        //               setState(() {
        //                 value == true
        //                     ? _diseaseList.add(medicalHistory.sId)
        //                     : _diseaseList.remove(medicalHistory.sId);
        //               });
        //             },
        //           );
        //         },
        //       );
        //     } else if (snapshot.hasError) {
        //       return Text("${snapshot.error}");
        //     }
        //     return Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   },
        // ),
      ),
    );
  }
}
