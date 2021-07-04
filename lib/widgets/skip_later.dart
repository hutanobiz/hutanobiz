import 'package:flutter/widgets.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/text_style.dart';
import 'package:hutano/utils/file_constants.dart';

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
          Text('Skip for later',
              style:  AppTextStyle.semiBoldStyle(
                  color: AppColors.colorBlack2,
                  fontSize: 14),
              textAlign: TextAlign.left)
        ],
      ),
    );
  }
}
