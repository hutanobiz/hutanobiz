import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/widgets/loading_background.dart';
// import 'package:pdf_viewer_jk/pdf_viewer_jk.dart';
import 'package:photo_view/photo_view.dart';

class ProviderImageScreen extends StatefulWidget {
  ProviderImageScreen({Key key, this.avatar}) : super(key: key);

  final String avatar;

  @override
  _ProviderImageScreenState createState() => _ProviderImageScreenState();
}

class _ProviderImageScreenState extends State<ProviderImageScreen> {
  // PDFDocument pdfDocument;

  @override
  void initState() {
    super.initState();

    // loadPdf();
  }

  // void loadPdf() {
  //   if (widget.avatar.toLowerCase().endsWith("pdf")) {
  //     PDFDocument.fromURL(widget.avatar).then((value) {
  //       setState(() {
  //         pdfDocument = value;
  //       });
  //     }).futureError((error) {
  //       error.toString().debugLog();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenTainoi,
      body: LoadingBackground(
        title: "",
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: widget.avatar.toLowerCase().endsWith("pdf")
            ? 
            // (pdfDocument == null
            //     ?
                 Container(
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
                // : PDFViewer(
                //     document: pdfDocument,
                //   ))
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
