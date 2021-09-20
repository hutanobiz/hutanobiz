import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/arrow_button.dart';
import 'package:hutano/widgets/bottom_arrows.dart';
import 'package:hutano/widgets/custom_loader.dart';

class LoadingBackground extends StatelessWidget {
  LoadingBackground(
      {Key key,
      this.isLoading: false,
      @required this.title,
      this.isAddBack: true,
      this.padding,
      @required this.child,
      this.isAddAppBar: true,
      this.addBottomArrows: false,
      this.addBackButton: false,
      this.color: AppColors.snow,
      this.buttonColor = AppColors.goldenTainoi,
      this.isRightButton = false,
      this.onRightButtonTap,
      this.rightButton,
      this.onForwardTap})
      : super(key: key);

  final bool isLoading;
  final Widget child;
  final bool isAddBack;
  final title;
  final EdgeInsets padding;
  final bool isAddAppBar, addBottomArrows;
  final color;
  final bool addBackButton;
  final Function onForwardTap;
  final Color buttonColor;
  final bool isRightButton;
  final Widget rightButton;
  final Function onRightButtonTap;

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
                      padding: isAddBack
                          ? const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0)
                          : const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 16.0),
                      child: Row(
                        children: <Widget>[
                          isAddBack
                              ? InkWell(
                                  customBorder: CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () => Navigator.pop(context),
                                )
                              : Container(
                                  width: 10,
                                ),
                          isAddBack ? SizedBox(width: 10.0) : Container(),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isRightButton)
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: InkWell(
                                onTap: onRightButtonTap,
                                child: rightButton ?? Container(),
                              ),
                            )
                          else
                            Container(),
                        ],
                      ),
                    )
                  : Container(),
              Expanded(
                child: Container(
                    padding:
                        padding ?? const EdgeInsets.only(left: 20.0, right: 20),
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
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  child: CustomLoader(
                      // backgroundColor: Colors.grey[200],
                      ),
                )
              : Container(),
          addBackButton
              ? Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: ArrowButton(
                      iconData: Icons.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                )
              : Container(),
          addBottomArrows
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                  child: BottomArrows(onForwardTap: onForwardTap),
                )
              : Container(),
        ],
      ),
    );
  }
}
