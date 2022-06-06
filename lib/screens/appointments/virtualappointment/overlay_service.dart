import 'package:flutter/material.dart';
import 'package:hutano/screens/appointments/virtualappointment/overlay_handler.dart';
import 'package:hutano/screens/appointments/virtualappointment/videos_overlay_widget.dart';
import 'package:provider/provider.dart';

class OverlayService {
  addVideosOverlay(BuildContext context, Widget widget) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => VideoOverlayWidget(
        onClear: () {
          // Provider.of<OverlayHandlerProvider>(context, listen: false)
          //     .removeOverlay(context);
        },
        widget: widget,
      ),
    );

    Provider.of<OverlayHandlerProvider>(context, listen: false)
        .insertOverlay(context, overlayEntry);
  }

}
