import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/routes.dart';
import 'package:hutano/widgets/inherited_widget.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/provider_tile_widget.dart';

class SeeAllSearchScreeen extends StatelessWidget {
  const SeeAllSearchScreeen({Key key, @required this.arguments})
      : super(key: key);

  final SearchArguments arguments;

  @override
  Widget build(BuildContext context) {
    List<dynamic> _list = arguments.list;
    String title = arguments.title;
    int type = arguments.type;

    debugPrint("List: ${_list.toString()}", wrapWidth: 1024);

    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: title,
        color: Colors.white,
        isAddBack: true,
        padding: const EdgeInsets.all(0.0),
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            itemCount: _list.length,
            itemBuilder: (context, index) {
              if (_list.isNotEmpty) {
                return title.toLowerCase().contains("provider")
                    ? ProviderTileWidget(
                        name: _list[index]["fullName"],
                        profession: _list[index]["fullName"],
                        onTap: () => Navigator.of(context).pushNamed(
                            Routes.searchInfoScreen,
                            arguments: _list[index]),
                      )
                    : ListTile(
                        title: Text(_list[index]["title"]),
                        onTap: () {
                          log(type.toString());
                          final container = InheritedContainer.of(context);

                          container.getProjectsResponse().clear();

                          if (type == 1) {
                            container.setProjectsResponse(
                                "specialityId", _list[index]["_id"]);
                          } else if (type == 3) {
                            InheritedContainer.of(context).setProjectsResponse(
                                "serviceId", _list[index]["_id"]);
                          }

                          Navigator.of(context)
                              .pushNamed(Routes.providerListScreen);
                        },
                      );
              }

              return Container();
            }),
      ),
    );
  }
}