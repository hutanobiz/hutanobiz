import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/utils/color_utils.dart';
import 'package:hutano/utils/localization/localization.dart';

showCommonUploadDialog(BuildContext context, String header, String subHeader,
    {Function? onTop, Function? onBottom, bool isForDocument = false}) {
  var yyDialog = YYDialog();
  yyDialog.build(context)
    ..width = 300
    ..backgroundColor = Colors.transparent
    ..barrierDismissible = false
    ..widget(Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: spacing20, vertical: spacing20),
            child: Column(children: [
              SizedBox(height: spacing10),
              Text(subHeader ,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colorPurple100,
                      fontSize: fontSize18,
                      fontWeight: fontWeightSemiBold)),
              SizedBox(height: spacing10),
              Divider(),
              InkWell(
                  onTap: () {
                    onTop!();
                  },
                  child: Padding(
                      padding: EdgeInsets.all(spacing10),
                      child: Text(
                          isForDocument
                              ? Localization.of(context)!.imageLabel
                              : Localization.of(context)!.camera,
                          style: const TextStyle(
                              color: colorLightBlack4,
                              fontWeight: fontWeightMedium,
                              fontSize: fontSize14),
                          textAlign: TextAlign.center))),
              SizedBox(height: spacing20),
              GestureDetector(
                  onTap: () {
                    onBottom!();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(spacing10),
                    child: Text(
                        isForDocument
                            ? Localization.of(context)!.pdfLabel
                            : Localization.of(context)!.gallery,
                        style: const TextStyle(
                            color: colorLightBlack4,
                            fontWeight: fontWeightMedium,
                            fontSize: fontSize14),
                        textAlign: TextAlign.center),
                  ))
            ]))))
    ..show();
}
