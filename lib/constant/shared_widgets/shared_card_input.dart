import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../text_style/text_style.dart';

Widget sharedCardInput(context,
        {required TextEditingController controller,
        TextInputType? keyboardType,
        required String hintText,
        Color? fillColor,
        TextStyle? hintStyle,
        TextStyle? txtStyle,
        Widget? suffix,
        bool? isPassword,
        FocusNode? focusNode,
        TextAlign? textAlign,
        TextInputAction? textInputAction,
        List<TextInputFormatter>? inputFormatters,
        void Function()? onTap,
        void Function(String)? onChanged,
        String? Function(String?)? validator}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.number,
      obscureText: isPassword ?? false,
      style: txtStyle ?? pop18BoldGree(),
      textAlign: textAlign ?? TextAlign.start,
      textInputAction: textInputAction,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: hintStyle ?? taj14Blue().copyWith(color: Recolor.cardColor),
        filled: true,
        fillColor: fillColor ?? Recolor.whiteColor,
        suffixIcon: suffix,
      ),
      onTap: onTap,
      onChanged: onChanged,
      validator: validator ??
          (value) {
            if (value != null && value.isNotEmpty)
              return null;
            else {
              return 'Invalid'.tr(context);
            }
          },
    );
Widget sharedUnderLineInput(context,
        {required TextEditingController controller,
        TextInputType? keyboardType,
        required String labelText,
        Color? fillColor,
        TextStyle? labelStyle,
        Widget? suffix,
        bool? isPassword,
        TextAlign? textAlign,
        String? Function(String?)? validator}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: isPassword ?? false,
      textAlign: textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Recolor.underLineColor)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Recolor.underLineColor)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Recolor.amberColor, width: 2)),
        labelStyle: labelStyle ?? taj12RegGreeHint(),
        labelText: labelText,
        suffixIcon: suffix,
      ),
      validator: validator ??
          (value) {
            if (value != null && value.isNotEmpty)
              return null;
            else {
              return 'Invalid'.tr(context);
            }
          },
    );
