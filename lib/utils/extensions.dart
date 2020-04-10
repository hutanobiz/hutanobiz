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

extension InkWellTap on Widget {
  onClick({
    BuildContext context,
    String routeName,
    Function onTap,
    bool roundCorners = true,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: roundCorners
            ? BorderRadius.circular(14.0)
            : BorderRadius.circular(0.0),
        splashColor: Colors.grey[200],
        onTap: () {
          if (context != null && routeName != null)
            Navigator.of(context).pushNamed(routeName);

          onTap();
        },
        child: this,
      ),
    );
  }
}
