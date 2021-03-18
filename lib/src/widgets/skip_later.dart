import 'package:flutter/widgets.dart';
import 'package:hutano/src/utils/color_utils.dart';
import 'package:hutano/src/utils/constants/file_constants.dart';
import 'package:hutano/src/utils/localization/localization.dart';

class SkipLater extends StatelessWidget {
  final VoidCallback onTap;

  const SkipLater({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            FileConstants.icSkipBlack,
            height: 30,
            width: 30,
          ),
          SizedBox(
            width: 5,
          ),
          Text(Localization.of(context).skipForLater,
              style: const TextStyle(
                  color: colorBlack2,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left)
        ],
      ),
    );
  }
}
