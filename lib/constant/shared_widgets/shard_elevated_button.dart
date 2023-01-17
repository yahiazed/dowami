import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:flutter/material.dart';

Widget sharedElevatedButton({
  required void Function()? onPressed,
  required String txt,
  Color? color,
  Color? txtColor,
  double? horizontalPadding,
  double? verticalPadding,
  double? radius,
  TextStyle? textStyle,
  required BuildContext context,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color ?? Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 0))))),
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0.0, vertical: verticalPadding ?? 0),
      child: Text(
        txt,
        style: textStyle,
      ),
    ),
  );
}

Widget sharedElevatedButton2({
  required void Function()? onPressed,
  Color? color,
  double? horizontalPadding,
  double? verticalPadding,
  double? radius,
  required Widget widget,
  required BuildContext context,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color ?? Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 0))))),
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0.0, vertical: verticalPadding ?? 0),
      child: widget,
    ),
  );
}
