import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color_utils.dart';
import '../utils/dimens.dart';

class HutanoTextField extends StatefulWidget {
  final Color suffixIconColor;
  final bool autovalidate;
  final Widget prefix;
  final String headerLabel;
  final String hintText;
  final String prefixIcon;
  final String labelText;
  final Function prefixIconClick;
  final String suffixIcon;
  final Function suffixIconClick;
  final bool isSuffixText;
  final String suffixText;
  bool isSecureField;
  Function passwordTap;
  final double width;
  final bool isNumberField;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType textInputType;
  final int maxLength;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> textInputFormatter;
  final Function validationMethod;
  final Function onFieldSubmitted;
  final Function onFieldTap;
  final Function onValueChanged;
  final bool isFieldEnable;
  final int maxLines;
  final bool isCountryCodeTextField;
  final double prefixwidth;
  final double prefixheight;
  final double suffixwidth;
  final double suffixheight;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color disableBorderColor;
  final FloatingLabelBehavior floatingBehaviour;
  final double textSize;
  final TextStyle labelTextStyle;
  final EdgeInsetsGeometry prefixPadding;
  final bool isPasswordField;
  final InputBorder border;
  final EdgeInsetsGeometry contentPadding;
  final Function onSaved;
  final String errorText;

  HutanoTextField(
      {this.suffixIconColor,
      this.headerLabel = "",
      this.hintText = "",
      this.prefixIcon,
      this.labelText,
      this.prefixIconClick,
      this.suffixIcon,
      this.suffixIconClick,
      this.isSuffixText = false,
      this.suffixText = "",
      this.isSecureField = false,
      this.width,
      this.isNumberField = false,
      this.controller,
      this.focusNode,
      this.textInputType,
      this.maxLength,
      this.textInputAction,
      this.textInputFormatter,
      this.validationMethod,
      this.onFieldSubmitted,
      this.onFieldTap,
      this.onValueChanged,
      this.isFieldEnable = true,
      this.maxLines = 1,
      this.isCountryCodeTextField = false,
      this.prefix,
      this.prefixwidth,
      this.prefixheight,
      this.suffixwidth,
      this.suffixheight,
      this.autovalidate = false,
      this.focusedBorderColor = colorPurple,
      this.floatingBehaviour = FloatingLabelBehavior.auto,
      this.textSize = fontSize14,
      this.labelTextStyle,
      this.enabledBorderColor = colorBlack20,
      this.disableBorderColor = colorBlack20,
      this.prefixPadding,
      this.isPasswordField = false,
      this.border,
      this.contentPadding,
      this.passwordTap,
      this.onSaved,
      this.errorText});

  @override
  _HutanoTextFieldState createState() => _HutanoTextFieldState();
}

class _HutanoTextFieldState extends State<HutanoTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      widget.focusNode.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode != null) {
      widget.focusNode.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: widget.width != null ? widget.width : null,
          child: TextFormField(
            autovalidate: widget.autovalidate,
            style: TextStyle(
              color: textColor,
              fontSize: widget.textSize,
            ),
            controller: widget.controller,
            enableInteractiveSelection: widget.isNumberField ? false : true,
            textInputAction: widget.textInputAction,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            focusNode: widget.focusNode,
            enabled: widget.isFieldEnable,
            decoration: InputDecoration(
              labelText: widget.labelText,
              isDense: true,
              errorText: widget.errorText,
              labelStyle: widget.labelTextStyle != null
                  ? widget.labelTextStyle
                  : _buildLabel(),
              border:
                  widget.border != null ? widget.border : OutlineInputBorder(),
              contentPadding: widget.contentPadding != null
                  ? widget.contentPadding
                  : null, // Added this

              prefix: widget.prefix != null ? widget.prefix : widget.prefix,
              counterText: "",
              hintText: widget.hintText,
              floatingLabelBehavior: widget.floatingBehaviour,
              hintStyle: TextStyle(color: colorBlack60, fontSize: fontSize14),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.focusedBorderColor, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.enabledBorderColor, width: 1)),
              disabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.disableBorderColor, width: 1)),
              prefixIconConstraints: BoxConstraints(),

              prefixIcon: widget.prefixIcon != null
                  ? GestureDetector(
                      onTap: widget.prefixIconClick,
                      child: Padding(
                        padding: widget.prefixPadding == null
                            ? EdgeInsets.all(14.0)
                            : widget.prefixPadding,
                        child: Image.asset(
                          widget.prefixIcon,
                          width: widget.prefixwidth,
                          height: widget.prefixheight,
                        ),
                      ),
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? GestureDetector(
                      onTap: widget.suffixIconClick,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset(
                          widget.suffixIcon,
                          width: widget.suffixwidth,
                          height: widget.suffixheight,
                          color: widget.suffixIconColor,
                        ),
                      ),
                    )
                  : (widget.isPasswordField
                      ? GestureDetector(
                          onTap: () {
                            widget.passwordTap();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(spacing5),
                            child: Icon(
                                widget.isSecureField
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey),
                          ),
                        )
                      : null),
            ),
            obscureText: widget.isSecureField,
            onFieldSubmitted: widget.onFieldSubmitted,
            validator: widget.validationMethod,
            inputFormatters: widget.textInputFormatter,
            keyboardType: widget.textInputType,
            onChanged: widget.onValueChanged,
            onTap: () {
              widget.onFieldTap();
            },
            // onSaved: widget.onSaved,
          ),
        ),
      ],
    );
  }

  _buildLabel() {
    if (widget.floatingBehaviour == FloatingLabelBehavior.always) {
      return TextStyle(fontSize: fontSize14, color: colorGrey60);
    }

    return TextStyle(
        fontSize: fontSize14,
        color: widget.focusNode.hasFocus ? colorPurple : colorBlack85);
  }
}
