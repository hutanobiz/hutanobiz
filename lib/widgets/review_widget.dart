import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hutano/api/api_helper.dart';

class ReviewWidget extends StatelessWidget {
  final String reviewerName, reviewDate, dateOfReview, reviewText, avatar;
  final double reviewerRating;

  const ReviewWidget({
    Key key,
    this.reviewerName,
    this.reviewerRating,
    this.dateOfReview,
    this.reviewText,
    this.reviewDate,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 58.0,
              height: 58.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: avatar == null
                      ? AssetImage('images/profile_user.png')
                      : NetworkImage(ApiBaseHelper.imageUrl + avatar),
                  fit: BoxFit.cover,
                ),
                borderRadius: new BorderRadius.all(Radius.circular(50.0)),
                border: new Border.all(
                  color: Colors.grey[300],
                  width: 1.0,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      reviewerName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        reviewDate,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RatingBar(
                  initialRating: reviewerRating,
                  itemSize: 20.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  glow: false,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: null,
                ),
                Text(
                  reviewerRating.toString(),
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            reviewText,
            style: TextStyle(
              color: Colors.black.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
}
