import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/utils/extensions.dart';

class ChooseSpecialities extends StatefulWidget {
  ChooseSpecialities({Key key, @required this.professionalId})
      : super(key: key);

  final String professionalId;

  @override
  _ChooseSpecialitiesState createState() => _ChooseSpecialitiesState();
}

class _ChooseSpecialitiesState extends State<ChooseSpecialities> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiBaseHelper api = new ApiBaseHelper();

  Future<List<dynamic>> _specialityFuture;

  Map selecteddynamic = Map();

  List<dynamic> selecteddynamicList = List();
  InheritedContainerState conatiner;

  @override
  void initState() {
    super.initState();

    Map<String, String> map = Map();

    map["professionalTitleId"] = widget.professionalId;
    _specialityFuture = api.getProfessionalSpecility(map);
  }

  @override
  Widget build(BuildContext context) {
    conatiner = InheritedContainer.of(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Select Specialties",
        color: AppColors.snow,
        isAddBack: false,
        addBackButton: true,
        child: column(),
      ),
    );
  }

  Widget column() {
    return FutureBuilder<List<dynamic>>(
      future: _specialityFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data;

          if (data == null || data.length == 0) return Container();

          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              mainAxisSpacing: 18.0,
              crossAxisSpacing: 16.0,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (data == null || data.length == 0) return Container();

              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.0),
                  ),
                  border: Border.all(color: Colors.grey[300], width: 0.5),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: ClipRRect(
                    child: data[index]["cover"] == null
                        ? "onsite_appointment".imageIcon(
                            width: 66.0,
                            height: 64.0,
                          )
                        : Image.network(
                            ApiBaseHelper.imageUrl + data[index]["cover"],
                            width: 66.0,
                            height: 64.0,
                            fit: BoxFit.cover,
                          ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: Text(
                    data[index]["title"]?.toString() ?? "---",
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    conatiner.setProjectsResponse(
                        "specialtyId[]", data[index]["_id"]);

                    Navigator.pushNamed(
                      context,
                      Routes.appointmentTypeScreen,
                    );
                  },
                ),
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
}
