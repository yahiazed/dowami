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
        hintStyle: hintStyle ?? reg14(context).copyWith(color: Recolor.cardColor),
        filled: true,
        fillColor: fillColor ?? Recolor.whiteColor,
        suffixIcon: suffix,
      ),
      onTap: onTap,
      onChanged: onChanged,
      validator: validator ??
          (value) {
            if (value != null && value.isNotEmpty) {
              return null;
            } else {
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
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2)),
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




Widget sharedBorderedInput(context,
    {required TextEditingController controller,
      TextInputType? keyboardType,
      required String hintText,
      Color? fillColor,
      TextStyle? hintStyle,
      TextStyle? textStyle,
      Widget? suffix,
      bool? isPassword,
      bool? readOnly,
      TextAlign? textAlign,
      double? borderWidth,
      double? radius,
      void Function()? onTap,
      String? Function(String?)? validator}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: isPassword ?? false,
      textAlign: textAlign ?? TextAlign.start,
      style:textStyle ,


      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5,vertical: 1),

        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius??0),
            borderSide: BorderSide(color: Recolor.underLineColor.withOpacity(.5),width:borderWidth??1,)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius??0),
            borderSide: BorderSide(color:Recolor.underLineColor.withOpacity(.5),width:borderWidth??1)),
        errorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius??0),
            borderSide: BorderSide(color: Recolor.redColor,width:borderWidth??1)),

      //  labelStyle: labelStyle ?? reg18Blue().copyWith(color: Recolor.txtGreyColor),

        suffixIcon: suffix,
        hintText: hintText,
        hintStyle: hintStyle,
        errorStyle: reg14(context).copyWith(color: Recolor.redColor),
      ),
      validator: validator ?? (value) {
            if (value != null && value.isNotEmpty) {
              return null;
            } else {
              return 'Invalid'.tr(context);
            }
          },
      onTap: onTap,
      readOnly:readOnly ?? false ,
    );