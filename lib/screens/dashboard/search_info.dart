import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/loading_background.dart';

class SearchInfoScreen extends StatelessWidget {
  const SearchInfoScreen({Key key, @required this.map}) : super(key: key);

  final Map map;

  @override
  Widget build(BuildContext context) {
    debugPrint(map.toString(), wrapWidth: 1024);

    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
          title: map["title"] ?? map["fullName"],
          color: Colors.white,
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Container()),
    );
  }
}
