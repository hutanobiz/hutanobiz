import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/colors.dart';

class ProviderTileWidget extends StatelessWidget {
  const ProviderTileWidget({
    Key key,
    this.avatar,
    @required this.name,
    @required this.profession,
    @required this.onTap,
  }) : super(key: key);

  final String name, profession, avatar;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: AppColors.snow,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: avatar == ''
              ? Center(
                  child: Text(name[0]),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    ApiBaseHelper.imageUrl + avatar,
                    fit: BoxFit.cover,
                  ))),
      title: Text(name),
      subtitle: Text(profession),
      onTap: onTap,
    );
  }
}
