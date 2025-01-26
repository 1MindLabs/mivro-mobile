import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final Color? labelColor;
  final String? hintText;
  final IconData? icon;
  final Color? iconColor;
  final Color? focusBorderSideColor;
  final Color? enabledBorderSideColor;
  final TextInputType? keyboardTypel;
  final TextEditingController? controller;
  const CustomTextFormField({
    super.key,
    this.labelText,
    this.labelColor,
    this.hintText,
    this.icon,
    this.iconColor,
    this.focusBorderSideColor,
    this.enabledBorderSideColor,
    this.keyboardTypel,
    this.controller,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: widget.labelColor ?? Colors.black),
        hintText: widget.hintText,
        prefixIcon: Icon(widget.icon,
            color: widget.iconColor ?? const Color(0xFF001F3F)),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: widget.focusBorderSideColor ?? Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: widget.enabledBorderSideColor ?? Colors.black),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: widget.controller,
    );
  }
}
