import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/review_widget.dart';
import 'package:intl/intl.dart';

class AllReviewsScreen extends StatefulWidget {
  final Map reviewMap;

  const AllReviewsScreen({Key key, this.reviewMap}) : super(key: key);

  @override
  _AllReviewsScreenState createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: "Reviews",
        color: Colors.white,
        isAddBack: false,
        addBackButton: true,
        padding: EdgeInsets.zero,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(14.0),
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              color: AppColors.goldenTainoi.withOpacity(0.06),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Overall Rating '),
                          TextSpan(
                              text: widget.reviewMap['averageRating'],
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.goldenTainoi,
                                fontWeight: FontWeight.w600,
                              )),
                        ]),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RatingBar.builder(
                        initialRating:
                            double.parse(widget.reviewMap['averageRating']),
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
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 20),
                itemCount: widget.reviewMap['reviewsList'].length,
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
                itemBuilder: (context, index) {
                  dynamic response = widget.reviewMap['reviewsList'][index];

                  return ReviewWidget(
                    reviewerName:
                        response["user"]["fullName"]?.toString() ?? '---',
                    avatar: response["user"]["avatar"],
                    reviewDate: DateFormat(
                      'dd MMMM yyyy',
                    )
                        .format(DateTime.parse(
                            response["user"]["updatedAt"]?.toString() ?? '0'))
                        .toString(),
                    reviewerRating:
                        double.parse(response["rating"]?.toString() ?? "0"),
                    reviewText: response["review"]?.toString() ?? '---',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
