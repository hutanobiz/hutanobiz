import 'package:flutter/material.dart';

class OverlayHandlerProvider with ChangeNotifier {
  OverlayEntry overlayEntry;
  double _aspectRatio = 1.77;
  bool inPipMode = false;
  bool isHidden = false;
  BuildContext videCallContext;

  updateVideoCallContext(BuildContext context) {
    videCallContext = context;
    notifyListeners();
  }

  enablePip(double aspect) {
    inPipMode = true;
    _aspectRatio = aspect;
    print("$inPipMode enablePip");
    notifyListeners();
  }

  disablePip() {
    inPipMode = false;
    print("$inPipMode disablePip");
    notifyListeners();
  }

  hideOverlay() {
    isHidden = true;
    notifyListeners();
  }

  unHideOverlay() {
    isHidden = false;
    notifyListeners();
  }

  get overlayActive => overlayEntry != null;
  get aspectRatio => _aspectRatio;

  insertOverlay(BuildContext context, OverlayEntry overlay) {
    // if (overlayEntry != null) {
    //   overlayEntry.remove();
    // }
    overlayEntry = null;
    inPipMode = false;
    Overlay.of(context)?.insert(overlay);
    overlayEntry = overlay;
  }

  removeOverlay(BuildContext context) {
    if (overlayEntry != null) {
      overlayEntry?.remove();
    }
    overlayEntry = null;
  }
}
