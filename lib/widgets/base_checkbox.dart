// import 'dart:math' as math;

// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';

// class BaseCheckBox extends StatefulWidget {
//   const BaseCheckBox({
//     Key key,
//     @required this.value,
//     this.tristate = false,
//     @required this.onChanged,
//     this.mouseCursor,
//     this.activeColor,
//     this.checkColor,
//     this.focusColor,
//     this.hoverColor,
//     this.materialTapTargetSize,
//     this.visualDensity,
//     this.focusNode,
//     this.autofocus = false,
//   })  : assert(tristate != null),
//         assert(tristate || value != null),
//         assert(autofocus != null),
//         super(key: key);

//   final bool value;
//   final ValueChanged<bool> onChanged;
//   final MouseCursor mouseCursor;
//   final Color activeColor;
//   final Color checkColor;
//   final bool tristate;
//   final MaterialTapTargetSize materialTapTargetSize;
//   final VisualDensity visualDensity;
//   final Color focusColor;
//   final Color hoverColor;
//   final FocusNode focusNode;
//   final bool autofocus;
//   static const double width = 18.0;

//   @override
//   _BaseCheckBoxState createState() => _BaseCheckBoxState();
// }

// class _BaseCheckBoxState extends State<BaseCheckBox>
//     with TickerProviderStateMixin {
//   bool get enabled => widget.onChanged != null;
//   Map<Type, Action<Intent>> _actionMap;

//   @override
//   void initState() {
//     super.initState();
//     _actionMap = <Type, Action<Intent>>{
//       ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _actionHandler),
//     };
//   }

//   void _actionHandler(ActivateIntent intent) {
//     if (widget.onChanged != null) {
//       switch (widget.value) {
//         case false:
//           widget.onChanged(true);
//           break;
//         case true:
//           widget.onChanged(widget.tristate ? null : false);
//           break;
//         default: // case null:
//           widget.onChanged(false);
//           break;
//       }
//     }
//     final renderObject = context.findRenderObject();
//     renderObject.sendSemanticsEvent(const TapSemanticEvent());
//   }

//   bool _focused = false;
//   void _handleFocusHighlightChanged(bool focused) {
//     if (focused != _focused) {
//       setState(() {
//         _focused = focused;
//       });
//     }
//   }

//   bool _hovering = false;
//   void _handleHoverChanged(bool hovering) {
//     if (hovering != _hovering) {
//       setState(() {
//         _hovering = hovering;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     assert(debugCheckHasMaterial(context));
//     final themeData = Theme.of(context);
//     Size size;
//     switch (widget.materialTapTargetSize ?? themeData.materialTapTargetSize) {
//       case MaterialTapTargetSize.padded:
//         size = const Size(
//             2 * kRadialReactionRadius + 8.0, 2 * kRadialReactionRadius + 8.0);
//         break;
//       case MaterialTapTargetSize.shrinkWrap:
//         size = const Size(2 * kRadialReactionRadius, 2 * kRadialReactionRadius);
//         break;
//     }
//     size +=
//         (widget.visualDensity ?? themeData.visualDensity).baseSizeAdjustment;
//     final additionalConstraints = BoxConstraints.tight(size);
//     final effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
//       widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
//       <MaterialState>{
//         if (!enabled) MaterialState.disabled,
//         if (_hovering) MaterialState.hovered,
//         if (_focused) MaterialState.focused,
//         if (widget.tristate || widget.value) MaterialState.selected,
//       },
//     );

//     return FocusableActionDetector(
//       actions: _actionMap,
//       focusNode: widget.focusNode,
//       autofocus: widget.autofocus,
//       enabled: enabled,
//       onShowFocusHighlight: _handleFocusHighlightChanged,
//       onShowHoverHighlight: _handleHoverChanged,
//       mouseCursor: effectiveMouseCursor,
//       child: Builder(
//         builder: (context) {
//           return _BaseCheckBoxRenderObjectWidget(
//             value: widget.value,
//             tristate: widget.tristate,
//             activeColor: widget.activeColor ?? themeData.toggleableActiveColor,
//             checkColor: widget.checkColor ?? const Color(0xFFFFFFFF),
//             inactiveColor: enabled
//                 ? themeData.unselectedWidgetColor
//                 : themeData.disabledColor,
//             focusColor: widget.focusColor ?? themeData.focusColor,
//             hoverColor: widget.hoverColor ?? themeData.hoverColor,
//             onChanged: widget.onChanged,
//             additionalConstraints: additionalConstraints,
//             vsync: this,
//             hasFocus: _focused,
//             hovering: _hovering,
//           );
//         },
//       ),
//     );
//   }
// }

// class _BaseCheckBoxRenderObjectWidget extends LeafRenderObjectWidget {
//   const _BaseCheckBoxRenderObjectWidget({
//     Key key,
//     @required this.value,
//     @required this.tristate,
//     @required this.activeColor,
//     @required this.checkColor,
//     @required this.inactiveColor,
//     @required this.focusColor,
//     @required this.hoverColor,
//     @required this.onChanged,
//     @required this.vsync,
//     @required this.additionalConstraints,
//     @required this.hasFocus,
//     @required this.hovering,
//   })  : assert(tristate != null),
//         assert(tristate || value != null),
//         assert(activeColor != null),
//         assert(inactiveColor != null),
//         assert(vsync != null),
//         super(key: key);

//   final bool value;
//   final bool tristate;
//   final bool hasFocus;
//   final bool hovering;
//   final Color activeColor;
//   final Color checkColor;
//   final Color inactiveColor;
//   final Color focusColor;
//   final Color hoverColor;
//   final ValueChanged<bool> onChanged;
//   final TickerProvider vsync;
//   final BoxConstraints additionalConstraints;

//   @override
//   _RenderBaseCheckBox createRenderObject(BuildContext context) =>
//       _RenderBaseCheckBox(
//         value: value,
//         tristate: tristate,
//         activeColor: activeColor,
//         checkColor: checkColor,
//         inactiveColor: inactiveColor,
//         focusColor: focusColor,
//         hoverColor: hoverColor,
//         onChanged: onChanged,
//         vsync: vsync,
//         additionalConstraints: additionalConstraints,
//         hasFocus: hasFocus,
//         hovering: hovering,
//       );

//   @override
//   void updateRenderObject(
//       BuildContext context, _RenderBaseCheckBox renderObject) {
//     renderObject
//       ..tristate = tristate
//       ..value = value
//       ..activeColor = activeColor
//       ..checkColor = checkColor
//       ..inactiveColor = inactiveColor
//       ..focusColor = focusColor
//       ..hoverColor = hoverColor
//       ..onChanged = onChanged
//       ..additionalConstraints = additionalConstraints
//       ..vsync = vsync
//       ..hasFocus = hasFocus
//       ..hovering = hovering;
//   }
// }

// const double _kEdgeSize = BaseCheckBox.width;
// const Radius _kEdgeRadius = Radius.circular(5);
// const double _kStrokeWidth = 2.0;

// class _RenderBaseCheckBox extends RenderToggleable {
//   _RenderBaseCheckBox({
//     bool value,
//     bool tristate,
//     Color activeColor,
//     this.checkColor,
//     Color inactiveColor,
//     Color focusColor,
//     Color hoverColor,
//     BoxConstraints additionalConstraints,
//     ValueChanged<bool> onChanged,
//     bool hasFocus,
//     bool hovering,
//     @required TickerProvider vsync,
//   })  : _oldValue = value,
//         super(
//           splashRadius: 20,
//           value: value,
//           tristate: tristate,
//           activeColor: activeColor,
//           inactiveColor: inactiveColor,
//           focusColor: focusColor,
//           hoverColor: hoverColor,
//           onChanged: onChanged,
//           additionalConstraints: additionalConstraints,
//           vsync: vsync,
//           hasFocus: hasFocus,
//           hovering: hovering,
//         );

//   bool _oldValue;
//   Color checkColor;

//   @override
//   set value(bool newValue) {
//     if (newValue == value) return;
//     _oldValue = value;
//     super.value = newValue;
//   }

//   @override
//   void describeSemanticsConfiguration(SemanticsConfiguration config) {
//     super.describeSemanticsConfiguration(config);
//     config.isChecked = value == true;
//   }

//   RRect _outerRectAt(Offset origin, double t) {
//     final inset = 1.0 - (t - 0.5).abs() * 2.0;
//     final size = _kEdgeSize - inset * _kStrokeWidth;
//     final rect =
//         Rect.fromLTWH(origin.dx + inset, origin.dy + inset, size, size);
//     return RRect.fromRectAndRadius(rect, _kEdgeRadius);
//   }

//   Color _colorAt(double t) {
//     return onChanged == null
//         ? inactiveColor
//         : (t >= 0.25
//             ? activeColor
//             : Color.lerp(inactiveColor, activeColor, t * 4.0));
//   }

//   Paint _createStrokePaint() {
//     return Paint()
//       ..color = checkColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = _kStrokeWidth;
//   }

//   void _drawBorder(Canvas canvas, RRect outer, double t, Paint paint) {
//     assert(t >= 0.0 && t <= 0.5);
//     final size = outer.width;
//     final inner = outer.deflate(math.min(size / 2.0, _kStrokeWidth + size * t));
//     canvas.drawDRRect(outer, inner, paint);
//   }

//   void _drawCheck(Canvas canvas, Offset origin, double t, Paint paint) {
//     assert(t >= 0.0 && t <= 1.0);
//     final path = Path();
//     const start = Offset(_kEdgeSize * 0.15, _kEdgeSize * 0.45);
//     const mid = Offset(_kEdgeSize * 0.4, _kEdgeSize * 0.7);
//     const end = Offset(_kEdgeSize * 0.85, _kEdgeSize * 0.25);
//     if (t < 0.5) {
//       final strokeT = t * 2.0;
//       final drawMid = Offset.lerp(start, mid, strokeT);
//       path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
//       path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
//     } else {
//       final strokeT = (t - 0.5) * 2.0;
//       final drawEnd = Offset.lerp(mid, end, strokeT);
//       path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
//       path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
//       path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
//     }
//     canvas.drawPath(path, paint);
//   }

//   void _drawDash(Canvas canvas, Offset origin, double t, Paint paint) {
//     assert(t >= 0.0 && t <= 1.0);
//     const start = Offset(_kEdgeSize * 0.2, _kEdgeSize * 0.5);
//     const mid = Offset(_kEdgeSize * 0.5, _kEdgeSize * 0.5);
//     const end = Offset(_kEdgeSize * 0.8, _kEdgeSize * 0.5);
//     final drawStart = Offset.lerp(start, mid, 1.0 - t);
//     final drawEnd = Offset.lerp(mid, end, t);
//     canvas.drawLine(origin + drawStart, origin + drawEnd, paint);
//   }

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     final canvas = context.canvas;
//     paintRadialReaction(canvas, offset, size.center(Offset.zero));

//     final strokePaint = _createStrokePaint();
//     final origin =
//         offset + (size / 2.0 - const Size.square(_kEdgeSize) / 2.0 as Offset);
//     final status = position.status;
//     final tNormalized =
//         status == AnimationStatus.forward || status == AnimationStatus.completed
//             ? position.value
//             : 1.0 - position.value;

//     if (_oldValue == false || value == false) {
//       final t = value == false ? 1.0 - tNormalized : tNormalized;
//       final outer = _outerRectAt(origin, t);
//       final paint = Paint()..color = _colorAt(t);

//       if (t <= 0.5) {
//         _drawBorder(canvas, outer, t, paint);
//       } else {
//         canvas.drawRRect(outer, paint);

//         final tShrink = (t - 0.5) * 2.0;
//         if (_oldValue == null || value == null) {
//           _drawDash(canvas, origin, tShrink, strokePaint);
//         } else {
//           _drawCheck(canvas, origin, tShrink, strokePaint);
//         }
//       }
//     } else {
//       final outer = _outerRectAt(origin, 1.0);
//       final paint = Paint()..color = _colorAt(1.0);
//       canvas.drawRRect(outer, paint);

//       if (tNormalized <= 0.5) {
//         final tShrink = 1.0 - tNormalized * 2.0;
//         if (_oldValue == true) {
//           _drawCheck(canvas, origin, tShrink, strokePaint);
//         } else {
//           _drawDash(canvas, origin, tShrink, strokePaint);
//         }
//       } else {
//         final tExpand = (tNormalized - 0.5) * 2.0;
//         if (value == true) {
//           _drawCheck(canvas, origin, tExpand, strokePaint);
//         } else {
//           _drawDash(canvas, origin, tExpand, strokePaint);
//         }
//       }
//     }
//   }
// }
