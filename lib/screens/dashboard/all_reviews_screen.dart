import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:hutano/widgets/review_widget.dart';
import 'package:intl/intl.dart';

class AllReviewsScreen extends StatefulWidget {
  final List reviewsList;

  const AllReviewsScreen({Key key, this.reviewsList}) : super(key: key);

  @override
  _AllReviewsScreenState createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Reviews",
        color: Colors.white,
        isAddBack: false,
        addBackButton: true,
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(height: 20),
          itemCount: widget.reviewsList.length,
          itemBuilder: (context, index) {
            dynamic response = widget.reviewsList[index];

            return ReviewWidget(
              reviewerName: response["user"]["fullName"],
              avatar: response["user"]["avatar"],
              reviewDate: DateFormat(
                'dd MMMM yyyy',
              )
                  .format(DateTime.parse(response["user"]["updatedAt"]))
                  .toString(),
              reviewerRating:
                  double.parse(response["rating"]?.toString() ?? "0"),
              reviewText: response["review"],
            );
          },
        ),
      ),
    );
  }
}
