import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:flutter/material.dart';

extension WidgetX on Widget {
  Widget expandedWidget({required int flex}) => Expanded(
        flex: flex,
        child: this,
      );
  Widget roundWidget({
    double? radius,
    double? width,
    double? height,
    double? borderWidth,
    Color? color,
    Color? borderColor,
  }) =>
      Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
            color: color ?? Colors.white,
            border: borderWidth != null
                ? Border.all(color: borderColor!, width: borderWidth)
                : null),
        child: Center(child: this),
      );

  Widget circleShape({
    double? width,
    double? borderWidth,
    Color? borderColor,
    double? height,
    Color? color,
  }) =>
      Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
                width: borderWidth ?? 0, color: borderColor ?? Colors.white)),
        child: Center(child: this),
      );

  Widget cardEX({
    double? radius,
    double? elevation,
    double? margin,
    Color? cardColor,
    Color? shadowColor,
  }) =>
      Card(
        color: cardColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: elevation,
        shadowColor: shadowColor,
        margin: EdgeInsets.all(margin ?? 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(radius ?? 0),
                bottomRight: Radius.circular(radius ?? 0))),
        child: this,
      );

  Widget cardUP({
    double? radius,
    double? elevation,
    double? margin,
    Color? cardColor,
    Color? shadowColor,
  }) =>
      Card(
        color: cardColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: elevation,
        shadowColor: shadowColor,
        margin: EdgeInsets.all(margin ?? 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius ?? 0),
                topRight: Radius.circular(radius ?? 0))),
        child: this,
      );
  Widget cardAll({
    double? radius,
    double? elevation,
    double? margin,
    Color? cardColor,
    Color? shadowColor,
  }) =>
      Card(
        color: cardColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: elevation,
        shadowColor: shadowColor,
        margin: EdgeInsets.all(margin ?? 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 0))),
        child: this,
      );
  Widget cardAllSized(
    context, {
    double? radius,
    required double width,
    required double height,
    double? elevation,
    double? margin,
    Color? cardColor,
    Color? shadowColor,
  }) =>
      Container(
        width: width.widthX(context),
        height: height.heightX(context),
        child: Card(
          color: cardColor,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: elevation,
          shadowColor: shadowColor,
          margin: EdgeInsets.all(margin ?? 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 0))),
          child: this,
        ),
      );

  Widget paddingS(context, double horizontal, double vertical) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontal.widthX(context),
            vertical: vertical.heightX(context)),
        child: this,
      );
  Widget paddingSH(context, double horizontal) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal.widthX(context)),
        child: this,
      );
  Widget paddingSV(context, double vertical) => Padding(
        padding: EdgeInsets.symmetric(vertical: vertical.heightX(context)),
        child: this,
      );

  Widget paddingA(double all) => Padding(
        padding: EdgeInsets.all(all),
        child: this,
      );
  Widget paddingT(context, double top) => Padding(
        padding: EdgeInsets.only(top: top.heightX(context)),
        child: this,
      );
  Widget paddingB(context, double bottom) => Padding(
        padding: EdgeInsets.only(bottom: bottom.heightX(context)),
        child: this,
      );
  Widget paddingL(context, double left) => Padding(
        padding: EdgeInsets.only(left: left.widthX(context)),
        child: this,
      );
  Widget paddingR(context, double right) => Padding(
        padding: EdgeInsets.only(right: right.widthX(context)),
        child: this,
      );
  Widget sizeDown(context, double size) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          this,
          SizedBox(
            height: size.heightX(context),
          )
        ],
      );
}
