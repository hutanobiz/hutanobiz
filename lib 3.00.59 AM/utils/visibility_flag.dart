import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

enum VisibilityFlag {
  visible,
  invisible,
  gone,
}

class CustomVisibility extends StatelessWidget {
  final VisibilityFlag visibility;
  final Widget child;
  final Widget removedChild;

  CustomVisibility({
    @required this.child,
    @required this.visibility,
  }) : this.removedChild = Container();

  @override
  Widget build(BuildContext context) {
    if (visibility == VisibilityFlag.visible) {
      return child;
    } else if (visibility == VisibilityFlag.invisible) {
      return new IgnorePointer(
        ignoring: true,
        child: new Opacity(
          opacity: 0.0,
          child: child,
        ),
      );
    } else {
      return removedChild;
    }
  }
}
