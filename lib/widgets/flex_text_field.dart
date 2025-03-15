import 'package:flutter/material.dart';

class FlexTextField extends StatefulWidget {
  final String? hintText;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color color;
  final Color borderColor;
  final double? borderWidth;
  final double? iconSize;
  final double borderRadius;
  final Color fillColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final VoidCallback? onSuffixIconTap;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const FlexTextField({
    super.key,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.color = Colors.black45,
    this.borderColor = Colors.black45,
    this.borderWidth = 1.5,
    this.borderRadius = 10,
    this.fillColor = Colors.transparent,
    this.textStyle,
    this.hintStyle,
    this.onSuffixIconTap,
    this.iconSize,
    this.controller,
    this.validator,
  });

  @override
  State<FlexTextField> createState() => _FlexTextFieldState();
}

class _FlexTextFieldState extends State<FlexTextField> {
  bool obscureText = false;
  @override
  void initState() {
    _onChangeObsecure();
    super.initState();
  }

  void _onChangeObsecure() => setState(() => obscureText = widget.obscureText);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: obscureText,
      style: widget.textStyle ?? TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor,
        prefixIcon:
            widget.prefixIcon != null
                ? Icon(
                  widget.prefixIcon,
                  color: widget.color,
                  size: widget.iconSize,
                )
                : null,
        suffixIcon:
            widget.suffixIcon != null
                ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                      widget.onSuffixIconTap?.call();
                    });
                  },
                  child: Icon(
                    widget.suffixIcon,
                    color: widget.color,
                    size: widget.iconSize,
                  ),
                )
                : null,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ?? TextStyle(color: widget.color),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: widget.borderWidth ?? 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor.withOpacity(0.8),
            width: (widget.borderWidth ?? 1.5) + 0.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor.withOpacity(0.8),
            width: (widget.borderWidth ?? 1.5) + 0.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor.withOpacity(0.8),
            width: (widget.borderWidth ?? 1.5) + 0.5,
          ),
        ),
      ),
    );
  }
}
