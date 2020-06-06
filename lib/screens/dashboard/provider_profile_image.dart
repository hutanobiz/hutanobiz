import 'package:flutter/material.dart';
import 'package:hutano/api/api_helper.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/loading_background.dart';
import 'package:photo_view/photo_view.dart';

class ProviderImageScreen extends StatelessWidget {
  ProviderImageScreen({Key key, this.avatar}) : super(key: key);

  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "Provider Image",
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: PhotoView(
          minScale: PhotoViewComputedScale.contained,
          backgroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          imageProvider: NetworkImage(
            ApiBaseHelper.imageUrl + avatar,
          ),
          loadingBuilder: (context, event) {
            if (event == null) {
              return const Center(
                child: Text("Loading"),
              );
            }
            final value =
                event.cumulativeBytesLoaded / event.expectedTotalBytes;

            final percentage = (100 * value).floor();
            return Center(
              child: Text(
                "$percentage%",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
