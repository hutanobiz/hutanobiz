import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/arrow_button.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/round_corners_background.dart';

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

  Future<List<dynamic>> _todoFuture;

  Map selecteddynamic = Map();

  List<dynamic> selecteddynamicList = List();
  InheritedContainerState conatiner;

  @override
  void initState() {
    Map<String, String> map = Map();

    map["professionalTitleId"] = widget.professionalId;
    _todoFuture = api.getProfessionalSpecility(map);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    conatiner = InheritedContainer.of(context);
    return RoundCornerBackground(scaffoldKey: _scaffoldKey, child: column());
  }

  Widget column() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Select Specialties",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 23.0),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _todoFuture,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> data = snapshot.data;

                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    mainAxisSpacing: 18.0,
                    crossAxisSpacing: 16.0,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
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
                          child: Image.network(
                            data[index]["cover"],
                            width: 66.0,
                            height: 64.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        title: Text(
                          data[index]["title"],
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
          ),
        ),
        SizedBox(height: 20.0),
        Align(
          alignment: FractionalOffset.bottomLeft,
          child: ArrowButton(
            iconData: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
