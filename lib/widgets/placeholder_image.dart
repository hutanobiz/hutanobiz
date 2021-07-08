import 'package:flutter/material.dart';
import 'package:hutano/apis/api_helper.dart';

class PlaceHolderImage extends StatelessWidget {
  final double height;
  final double width;
  final String image;
  final String placeholder;

  const PlaceHolderImage(
      {Key key, this.height, this.width, this.image, this.placeholder})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeInImage(
        height: height,
        fit: BoxFit.cover,
        width: width,
        image: NetworkImage('${ApiBaseHelper.imageUrl}$image'),
        placeholder: AssetImage(placeholder));
  }
}
