import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_tile_widget.dart';

class SeeAllSearchScreeen extends StatefulWidget {
  const SeeAllSearchScreeen({Key key, @required this.arguments})
      : super(key: key);

  final SearchArguments arguments;

  @override
  _SeeAllSearchScreeenState createState() => _SeeAllSearchScreeenState();
}

class _SeeAllSearchScreeenState extends State<SeeAllSearchScreeen> {
  InheritedContainerState _container;

  @override
  void didChangeDependencies() {
    _container = InheritedContainer.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> _list = widget.arguments.list;
    String title = widget.arguments.title;
    String professionalTitle = "---";

    int type = widget.arguments.type;

    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: title,
        color: Colors.white,
        isAddBack: true,
        padding: EdgeInsets.zero,
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(),
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          itemCount: _list.length,
          itemBuilder: (context, index) {
            if (_list.isNotEmpty) {
              if (_list[index]["UserDoctorDetails"] != null) {
                dynamic details = _list[index]["UserDoctorDetails"];
                if (details["professionalTitle"] != null) {
                  professionalTitle =
                      details["professionalTitle"]["title"]?.toString() ??
                          "---";
                }
              }

              return title.toLowerCase().contains("provider")
                  ? ProviderTileWidget(
                      avatar: _list[index]["avatar"] ?? '',
                      name: _list[index]["fullName"],
                      profession: professionalTitle,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Routes.providerProfileScreen,arguments: _list[index]["_id"].toString());
                      },
                    )
                  : ListTile(
                      title: Text(_list[index][type == 3 ? 'name' : "title"]),
                      onTap: () {
                        _container.projectsResponse.clear();

                        if (type == 1) {
                          _container.setProjectsResponse(
                              "specialtyId[${_list[index].toString()}]",
                              _list[index]["_id"]);
                        } else if (type == 3) {
                          _container.setProjectsResponse(
                              "subServices[${_list[index].toString()}]",
                              _list[index]["_id"]);
                        }

                        _container.setProjectsResponse("serviceType", '0');

                        Navigator.of(context)
                            .pushNamed(Routes.providerListScreen);
                      },
                    );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
