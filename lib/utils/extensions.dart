import 'package:flutter/material.dart';

class Extensions {}

extension ImageIcon on String {
  imageIcon({double height, double width}) => Image(
        image: AssetImage(
          "images/$this.png",
        ),
        height: height ?? 14.0,
        width: width ?? 14.0,
      );
}

extension FutureError<T> on Future<T> {
  Future<T> futureError(Function onError) =>
      this.timeout(const Duration(seconds: 10)).catchError(onError);
}

extension DebugLog on String {
  debugLog() {
    return debugPrint(
        "\n******************************* DebugLog *******************************\n" +
            " $this",
        wrapWidth: 1024);
  }
}
