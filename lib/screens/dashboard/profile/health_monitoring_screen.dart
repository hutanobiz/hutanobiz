import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/loading_background_new.dart';

class Prefrence {
  int? id;
  String? name;
  int? type;
  String? description;
  String? image;
  int? status;
  String? sId;
  int? iV;
  bool? isChecked;
  String? route;

  Prefrence(
      {this.id,
      this.name,
      this.type,
      this.description,
      this.image,
      this.status,
      this.sId,
      this.iV,
      this.isChecked,
      this.route});

  Prefrence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    sId = json['_id'];
    iV = json['__v'];
    isChecked = json['isChecked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['description'] = this.description;
    data['image'] = this.image;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    data['isChecked'] = this.isChecked;
    return data;
  }
}

class HealthMonitoringScreen extends StatefulWidget {
  HealthMonitoringScreen({Key? key, this.profileData}) : super(key: key);
  var profileData;

  @override
  _HealthMonitoringScreenState createState() => _HealthMonitoringScreenState();
}

class _HealthMonitoringScreenState extends State<HealthMonitoringScreen> {
  ApiBaseHelper api = new ApiBaseHelper();
  List<Prefrence> healthMonitoring = [
    Prefrence(
        name: 'Blood pressure',
        description: 'Monitor blood pressure',
        image: 'images/blood_pressure.png',
        route: Routes.bloodPressureChart),
    Prefrence(
        name: 'Blood sugar',
        description: 'Control your blood sugar',
        image: 'images/special.png',
        route: Routes.bloodSugarChart),
    Prefrence(
        name: 'Weight',
        description: 'Manage your weight',
        image: 'images/vital.png',
        route: Routes.weightChart),
    Prefrence(
        name: 'Heart Rate',
        description: 'Manage your heart rate',
        image: 'images/heart_lung.png',
        route: Routes.heartRateChart),
    Prefrence(
        name: 'Oxygen Saturation',
        description: 'Manage',
        image: 'images/oxygen_saturation.png',
        route: Routes.oxygenSaturationChart),
    Prefrence(
        name: 'Temperature',
        description: 'Manage',
        image: 'images/vital.png',
        route: Routes.temperatureChart)
  ];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      resizeToAvoidBottomInset: true,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: "",
        padding: EdgeInsets.only(bottom: spacing70),
        isAddBack: true,
        isAddAppBar: true,
        addBottomArrows: false,
        isLoading: isLoading,
        child: ListView(
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 20, left: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: healthMonitoring.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, healthMonitoring[index].route!);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 15, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(3, 3),
                              spreadRadius: 3,
                              blurRadius: 5)
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(healthMonitoring[index].image!,
                                height: 50, width: 50)),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          healthMonitoring[index].name!,
                          style: AppTextStyle.semiBoldStyle(fontSize: 14),
                        ),
                        Text(
                          healthMonitoring[index].description ?? '',
                          style: AppTextStyle.regularStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
