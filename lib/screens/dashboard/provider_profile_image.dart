import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:photo_view/photo_view.dart';

class ProviderImageScreen extends StatefulWidget {
  ProviderImageScreen({Key key, this.avatar}) : super(key: key);

  final String avatar;

  @override
  _ProviderImageScreenState createState() => _ProviderImageScreenState();
}

class _ProviderImageScreenState extends State<ProviderImageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackgroundNew(
        addHeader: true,
        title: "",
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: widget.avatar.toLowerCase().endsWith("pdf")
            ? Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  "Can't load PDF",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              )
            : PhotoView(
                minScale: PhotoViewComputedScale.contained,
                backgroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                imageProvider: (widget.avatar.contains('http') ||
                        widget.avatar.contains('https'))
                    ? NetworkImage(
                        widget.avatar,
                      )
                    : FileImage(
                        File(
                          widget.avatar,
                        ),
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
