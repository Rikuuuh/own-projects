import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  InputBorder? enabledBorder,
  InputBorder? border,
  Color? fillColor,
  bool? filled,
  Widget? prefixIcon,
  String? hintText,
  String? labelText,
}) =>
    InputDecoration(
        enabledBorder: enabledBorder ??
            const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
        border: border ?? const OutlineInputBorder(borderSide: BorderSide()),
        fillColor: fillColor ?? Colors.white,
        filled: filled ?? true,
        prefixIcon: prefixIcon,
        hintText: hintText,
        labelText: labelText);
