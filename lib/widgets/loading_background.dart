import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class LoadingBackground extends StatelessWidget {
  LoadingBackground(
      {Key key,
      this.isLoading: false,
      @required this.title,
      this.isAddBack: true,
      this.padding,
      @required this.child,
      this.isAddAppBar: true,
      this.color: AppColors.snow})
      : super(key: key);

  final bool isLoading;
  final Widget child;
  final bool isAddBack;
  final title;
  final EdgeInsets padding;
  final bool isAddAppBar;
  final color;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              isAddAppBar
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(21.0, 27.0, 0.0, 27.0),
                      child: Row(
                        children: <Widget>[
                          isAddBack
                              ? InkWell(
                                  customBorder: CircleBorder(),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                  onTap: () => Navigator.pop(context),
                                )
                              : Container(),
                          isAddBack ? SizedBox(width: 10.0) : Container(),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: padding ?? const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(22.0),
                        topRight: const Radius.circular(22.0),
                      ),
                    ),
                    child: child),
              ),
            ],
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
