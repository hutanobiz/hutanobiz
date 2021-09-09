import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hutano/apis/api_helper.dart';
import 'package:hutano/apis/api_manager.dart';
import 'package:hutano/apis/error_model.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/appointments/model/res_uploaded_document_images_model.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/localization/localization.dart';
import 'package:hutano/widgets/custom_loader.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:hutano/widgets/loading_background_new.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes.dart';

class ViewAllDocumentImages extends StatefulWidget {
  final bool isForImage;
  ViewAllDocumentImages({this.isForImage = true});
  @override
  _ViewAllDocumentImagesState createState() => _ViewAllDocumentImagesState();
}

class _ViewAllDocumentImagesState extends State<ViewAllDocumentImages> {
  List<MedicalImages> _allImages = List();
  List<MedicalDocuments> _allDocuments = List();
  bool _getData = false;
  bool _indicatorLoading = true;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _getUploadedImages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBackgroundNew(
      title: "",
      addHeader: false,
      isAddAppBar: false,
      padding: EdgeInsets.only(top: spacing5),
      child: _indicatorLoading
          ? Center(
              child: CustomLoader(),
            )
          : !_getData && !_indicatorLoading
              ? Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.isForImage
                              ? Localization.of(context).noMedicalImagesFound
                              : Localization.of(context)
                                  .noMedicalDocumentsFound,
                          style: TextStyle(
                              fontSize: fontSize16,
                              color: colorBlack2,
                              fontWeight: fontWeightSemiBold),
                        ),
                      ),
                    ),
                  ],
                )
              : GridView.builder(
                  itemCount: widget.isForImage
                      ? _allImages.length
                      : _allDocuments.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    String imageFile = widget.isForImage
                        ? _allImages[index].images
                        : _allDocuments[index].medicalDocuments;
                    return Padding(
                      padding: const EdgeInsets.all(spacing5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.network(
                                  widget.isForImage
                                      ? ApiBaseHelper.imageUrl +
                                          _allImages[index].images
                                      : ApiBaseHelper.imageUrl +
                                          _allDocuments[index].medicalDocuments,
                                  fit: BoxFit.cover,
                                )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height:
                                    widget.isForImage ? spacing60 : spacing70,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: spacing10, vertical: 5),
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        widget.isForImage
                                            ? _allImages[index].name
                                            : _allDocuments[index].name,
                                        style: TextStyle(
                                            fontSize: fontSize14,
                                            fontWeight: fontWeightSemiBold,
                                            color: Color(0xff1b1200)),
                                      ),
                                    ),
                                    if (!widget.isForImage)
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          _allDocuments[index].type,
                                          style: TextStyle(
                                              fontSize: fontSize12,
                                              fontWeight: fontWeightRegular,
                                              color: Colors.black),
                                        ),
                                      ),
                                    if (!widget.isForImage)
                                      SizedBox(width: spacing5),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        widget.isForImage
                                            ? _allImages[index].date ??
                                                '---+---'
                                            : _allDocuments[index].date ??
                                                "---+---",
                                        style: TextStyle(
                                            fontSize: fontSize12,
                                            fontWeight: fontWeightRegular,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ).onClick(
                          onTap: imageFile.toLowerCase().endsWith("pdf")
                              ? () async {
                                  var url = imageFile;
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                }
                              : () {
                                  Navigator.of(context).pushNamed(
                                    Routes.providerImageScreen,
                                    arguments:
                                        ApiBaseHelper.imageUrl + imageFile,
                                  );
                                },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void setLoading(bool value) {
    setState(() => _indicatorLoading = value);
  }

  void _getUploadedImages(BuildContext context) async {
    setLoading(true);
    await ApiManager().getPatientUploadedDocumentImages().then((result) {
      if (result is ResUploadedDocumentImagesModel) {
        if (widget.isForImage) {
          setState(() {
            _allImages = result.response.medicalImages;
          });
          _getData = _allImages.isNotEmpty;
        } else {
          setState(() {
            _allDocuments = result.response.medicalDocuments;
          });
          _getData = _allDocuments.isNotEmpty;
        }
        setLoading(false);
      }
    }).catchError((dynamic e) {
      setLoading(false);
      if (e is ErrorModel) {
        e.toString().debugLog();
      }
    });
  }
}
