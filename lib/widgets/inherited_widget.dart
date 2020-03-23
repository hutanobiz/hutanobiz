import 'package:flutter/material.dart';

class InheritedContainer extends StatefulWidget {
  final Widget child;
  final String data;

  InheritedContainer({@required this.child, this.data});

  static InheritedContainerState of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<InheritedStateContainer>()
        .data);
  }

  @override
  InheritedContainerState createState() => new InheritedContainerState();
}

class InheritedContainerState extends State<InheritedContainer> {
  Map response = Map();

  void setProjectsResponse(String key, String data) {
    response[key] = data;
  }

  Map getProjectsResponse() {
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class InheritedStateContainer extends InheritedWidget {
  final InheritedContainerState data;

  InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedStateContainer oldWidget) =>
      data != oldWidget.data;
}
