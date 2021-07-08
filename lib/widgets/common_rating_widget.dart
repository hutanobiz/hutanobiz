import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hutano/utils/constants/file_constants.dart';

class CommonRatingWidget extends StatefulWidget {
  final double initRating;
  final bool isIgnoreGesture;
  final Function onRatingTap;
  final bool isFromRating;
  CommonRatingWidget(
      {this.initRating = 0.0,
      this.isIgnoreGesture = true,
      this.onRatingTap,
      this.isFromRating = false});

  @override
  _CommonRatingWidgetState createState() => _CommonRatingWidgetState();
}

class _CommonRatingWidgetState extends State<CommonRatingWidget> {
  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: widget.initRating,
      minRating: 0,
      ignoreGestures: widget.isIgnoreGesture,
      itemCount: 5,
      itemSize: widget.isFromRating ? 40 : 12,
      allowHalfRating: true,
      itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
      ratingWidget: RatingWidget(
        full: image(FileConstants.icRatingFilledStar),
        half: image(FileConstants.icRatingStar),
        empty: image(FileConstants.icRatingStar),
      ),
      onRatingUpdate: (rating) => widget.onRatingTap(rating) ?? () {},
    );
  }
}

Widget image(String str) {
  return Image.asset(str);
}
