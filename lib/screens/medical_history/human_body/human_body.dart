import 'package:flutter/material.dart';
import 'package:hutano/dimens.dart';
import 'package:hutano/screens/medical_history/provider/appoinment_provider.dart';

import 'package:provider/provider.dart';
import 'package:touchable/touchable.dart';


import '../../../utils/color_utils.dart';
import '../../../utils/constants/file_constants.dart';
import '../../../utils/dimens.dart';
import '../../../utils/enum_utils.dart';
import '../../../utils/preference_key.dart';
import '../../../utils/preference_utils.dart';
import 'parser.dart';
import 'path_painter.dart';

class HumanBody extends StatefulWidget {
  final bool isClickable;
  final Function(String? bodyPart)? bodyPartSelected;
  final bool? selectedPartWithHighlight;
  final String? highlightPart;
  final int bodyImage;
  bool? resetStae = false;
  bool? initialData = false;

  HumanBody(
      {Key? key,
      required this.isClickable,
      this.bodyPartSelected,
      this.selectedPartWithHighlight,
      this.highlightPart,
      required this.bodyImage,
      this.resetStae,
      this.initialData})
      : super(key: key);

  @override
  _HumanBodyState createState() => _HumanBodyState();
}

const double svgWidth = 645;
const double svgHeight = 1226;

class _HumanBodyState extends State<HumanBody> {
  List<Path> _selectPaths = [];
  String svgPath = "";
  List<Path> paths = [];
  List<PathSegment> pathsegments = [];

  Offset? touchPosition;

  final GlobalKey _key = GlobalKey();

  String? bodyPart;
  String? selectedBodyPart;

  @override
  void didUpdateWidget(HumanBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.resetStae != null && widget.resetStae!) {
      touchPosition = null;
      _selectPaths = [];
      svgPath = "";
      paths = [];
      pathsegments = [];
      bodyPart = null;
      selectedBodyPart = null;
    }
  }

  @override
  void initState() {
    super.initState();
    // For adding body part highlight selection

    // if (widget.initialData != null && widget.initialData) {
    //   var provider = Provider.of<SymptomsInfoProvider>(context, listen: false);
    //   touchPosition = provider.touchPosition;
    //   bodyPart = provider.bodyPart;
    //   selectedBodyPart = provider.selectedBodyPart;

    //   setState(() {});
    // }
  }

  void setImage() {
    final isFemale =
        (GenderType.female.index == getInt(PreferenceKey.gender, 1));
    switch (widget.bodyImage) {
      case 0:
        svgPath =
            isFemale ? FileConstants.svgFemaleBack : FileConstants.svgMaleBack;
        break;
      case 1:
        svgPath = isFemale
            ? FileConstants.svgFemaleFront
            : FileConstants.svgMaleFront;
        break;
      default:
        svgPath = FileConstants.svgMaleFront;
    }
  }

  void setHighlightPart() {
    _selectPaths = [];
    if (widget.highlightPart != null &&
        widget.selectedPartWithHighlight == true) {
      for (var i = 0; i < pathsegments.length; i++) {
        if (pathsegments[i].pathname == widget.highlightPart) {
          if (!_selectPaths.contains(paths[i])) {
            _selectPaths.add(paths[i]);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setImage();
    parseSvgToPath();
    setHighlightPart();
    return AspectRatio(
      aspectRatio: svgWidth / svgHeight,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(spacing5),
            child: Container(
              key: _key,
              width: double.infinity,
              height: double.infinity,
              child: CanvasTouchDetector(
                builder: (context) => CustomPaint(
                  painter: PathPainter(
                    context: context,
                    paths: paths,
                    curPaths: _selectPaths,
                    segments: pathsegments,
                    selectedPartWithHighlight: widget.selectedPartWithHighlight,
                    onPressed: (curPath, details, pathname) {
                      // print(details.globalPosition);
                      // print(details.localPosition);
                      setState(() {
                        touchPosition = details.localPosition;
                        bodyPart = pathname;
                        selectedBodyPart = null;
                      });

                      widget.bodyPartSelected!(bodyPart);
                      setState(() {
                        selectedBodyPart = bodyPart;
                      });
                      Provider.of<SymptomsInfoProvider>(context, listen: false)
                          .setBodyPartOffset(
                              touchPosition, bodyPart, selectedBodyPart);
                    },
                  ),
                ),
              ),
            ),
          ),
          if (touchPosition != null)
            Builder(builder: (context) {
              var alignment = CrossAxisAlignment.start;
              var direction = VerticalDirection.down;
              var box = _key.currentContext!.findRenderObject() as RenderBox?;
              var width;
              var height;
              var xpos = touchPosition!.dx;
              var ypos = touchPosition!.dy;
              if (box != null) {
                width = box.size.width;
                height = box.size.height;
                if ((90 + touchPosition!.dx) > width) {
                  xpos = xpos - 90 + 15;
                  alignment = CrossAxisAlignment.end;
                }
                if ((40 + touchPosition!.dy) > height) {
                  ypos = ypos - 40 + 15;
                  direction = VerticalDirection.up;
                }
              }
              return Positioned(
                left: xpos - 4,
                top: ypos - 4,
                child: Container(
                  height: 40,
                  width: 90,
                  // color: Colors.redAccent,
                  child: Column(
                    crossAxisAlignment: alignment,
                    verticalDirection: direction,
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(height: 2),
                      InkWell(
                        onTap: () {
                          widget.bodyPartSelected!(bodyPart);
                          setState(() {
                            selectedBodyPart = bodyPart;
                          });
                        },
                        child: Container(
                          child: Text(
                            bodyPart == null ? '' : bodyPart!.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 10),
                          ),
                          alignment: Alignment.center,
                          height: 18,
                          width: 90,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              color: selectedBodyPart == bodyPart
                                  ? colorDarkgrey2
                                  : colorGrey3),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          if (!widget.isClickable)
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            )
        ],
      ),
    );
  }

  void parseSvgToPath() {
    var parser = SvgParser();
    parser.loadFromFile(svgPath).then((value) {
      setState(() {
        paths = parser.getPaths();
        pathsegments = parser.pathSegmentList;
      });
    });
  }
}
