import 'package:flutter_svg/flutter_svg.dart';

class Extensions {}

extension SvgIcon on String {
  svgIcon() => SvgPicture.asset("images/$this.svg");
}
