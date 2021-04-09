import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';

class AllTitlesSpecialtesScreen extends StatefulWidget {
  AllTitlesSpecialtesScreen({Key key}) : super(key: key);

  @override
  _AllTitlesSpecialtesScreenState createState() =>
      _AllTitlesSpecialtesScreenState();
}

class _AllTitlesSpecialtesScreenState extends State<AllTitlesSpecialtesScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiBaseHelper api = new ApiBaseHelper();

  Future<List<dynamic>> _titleSpecialtyFuture;

  InheritedContainerState conatiner;

  @override
  void initState() {
    super.initState();

    _titleSpecialtyFuture = api.getAllTitleSpecilities();
  }

  @override
  Widget build(BuildContext context) {
    conatiner = InheritedContainer.of(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Choose Speciality",
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        color: AppColors.snow,
        isAddBack: false,
        addHeader: true,
        addTitle:true,
        child: column(),
      ),
    );
  }

  Widget column() {
    return FutureBuilder<List<dynamic>>(
      future: _titleSpecialtyFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data;

          if (data == null || data.length == 0) return Container();

          Map _titlesMap = {};
          List _titlesList = [];

          for (dynamic title in data) {
            _titlesMap[title['professionalTitleId']] = title;
          }

          _titlesList = _titlesMap.values.toList();

          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: 26),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _titlesList.length,
            itemBuilder: (context, titleIndex) {
              if (_titlesList == null || _titlesList.length == 0)
                return Container();

              dynamic title = _titlesList[titleIndex];
              List titleSpecialtyList = [];

              for (dynamic specialty in data) {
                if (title['professionalTitleId'] ==
                    specialty['professionalTitleId']) {
                  titleSpecialtyList.add(specialty);
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      title['title'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    height: 72,
                    margin: const EdgeInsets.only(top: 16),
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(width: 13),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: titleSpecialtyList.length,
                      itemBuilder: (context, index) {
                        if (titleSpecialtyList == null ||
                            titleSpecialtyList.isEmpty) {
                          return Text('No professional titles available');
                        }

                        dynamic specialty = titleSpecialtyList[index];

                        return Container(
                          height: 72,
                          width: 145,
                          padding: EdgeInsets.all(7),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                            border:
                                Border.all(color: Colors.grey[300], width: 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image(
                                  image: AssetImage(
                                      'images/dummy_title_image.png'),
                                  width: 60.0,
                                  height: 60.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  specialty['specialtyName']?.toString() ??
                                      "---",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).onClick(
                          onTap: () {
                            conatiner.projectsResponse.removeWhere(
                              (key, value) =>
                                  !key.toString().contains('serviceType'),
                            );

                            conatiner.setProjectsResponse(
                                "specialtyId[${index.toString()}]",
                                specialty["specialtyId"]);
                            conatiner.setProjectsResponse(
                                "professionalTitleId[${titleIndex.toString()}]",
                                specialty["professionalTitleId"]);

                            Navigator.pushNamed(
                              context,
                              Routes.providerListScreen,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: CustomLoader(),
        );
      },
    );
  }
}
