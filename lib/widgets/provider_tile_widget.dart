import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class ProviderTileWidget extends StatelessWidget {
  const ProviderTileWidget({
    Key key,
    @required this.name,
    @required this.profession,
    @required this.onTap,
  }) : super(key: key);

  final String name, profession;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          color: AppColors.snow,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Text(name[0]),
        ),
      ),
      title: Text(name),
      subtitle: Text(profession),
      onTap: onTap,
    );
  }
}
