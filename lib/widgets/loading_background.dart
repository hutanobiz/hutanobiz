import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/widgets/arrow_button.dart';
import 'package:hutano/widgets/bottom_arrows.dart';
import 'package:hutano/widgets/circular_loader.dart';

class LoadingBackground extends StatelessWidget {
  LoadingBackground({
    Key? key,
    this.isLoading: false,
    required this.title,
    this.isAddBack: true,
    this.padding,
    required this.child,
    this.isAddAppBar: true,
    this.addBottomArrows: false,
    this.addBackButton: false,
    this.color: AppColors.snow,
    this.buttonColor = AppColors.goldenTainoi,
    this.onForwardTap,
    this.rightButtonText,
    this.onRightButtonTap,
  }) : super(key: key);

  final bool isLoading;
  final Widget child;
  final bool isAddBack;
  final String? title, rightButtonText;
  final EdgeInsets? padding;
  final bool isAddAppBar, addBottomArrows;
  final color;
  final bool addBackButton;
  final Function? onForwardTap;
  final Color buttonColor;
  final Function? onRightButtonTap;

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
                          ? const EdgeInsets.fromLTRB(11.0, 17.0, 0.0, 17.0)
                          : (rightButtonText != null &&
                                  onRightButtonTap != null)
                              ? const EdgeInsets.fromLTRB(21.0, 17.0, 0.0, 17.0)
                              : const EdgeInsets.fromLTRB(
                                  21.0, 27.0, 0.0, 27.0),
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
                              : Container(),
                          isAddBack ? SizedBox(width: 10.0) : Container(),
                          Expanded(
                            child: Text(
                              title!,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (rightButtonText != null &&
                              onRightButtonTap != null)
                            InkWell(
                              onTap: onRightButtonTap as void Function()?,
                              child: rightButtonText!.contains('Skip')
                                  ? Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.windsor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        rightButtonText!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        rightButtonText!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                        ),
                                      ),
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
          isLoading ? CircularLoader() : Container(),
          addBackButton
              ? Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: ArrowButton(
                      iconData: Icons.arrow_back,
                      buttonColor: buttonColor,
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
