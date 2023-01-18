import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';

import '../shared_colors/shared_colors.dart';

Drawer sharedDrawer(BuildContext context,
        {required String url, required String userName}) =>
    Drawer(
      elevation: 9,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(30), topEnd: Radius.circular(30))),
     // shadowColor: Recolor.rowColor,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(20), topEnd: Radius.circular(20))),
        width: .60.widthX(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(url, fit: BoxFit.cover)
                      .circleShape(
                          borderColor: Recolor.rowColor,
                          borderWidth: 1,
                          width: 74,
                          height: 74)
                      .paddingB(context, .025),
                  Text(userName, style: eBold22(context))
                      .paddingB(context, .025),
                  Text("editProfile".tr(context), style: med14(context).copyWith(color:Theme.of(context).primaryColor)),
                ],
              ).paddingSV(context, 0.1),
              TextButton(
                  onPressed: () {},
                  child: Text('SETTINGD'.tr(context),
                      style: eBold20(context))),
              TextButton(
                  onPressed: () {},
                  child:
                      Text('WALLET'.tr(context), style: eBold20(context))),
              TextButton(
                  onPressed: () {},
                  child: Text('NOTIFICATION'.tr(context),
                      style: eBold20(context))),
              TextButton(
                  onPressed: () {},
                  child: Text('promotion'.tr(context),
                      style: eBold20(context))),
              TextButton(
                  onPressed: () {},
                  child: Text('Help Center'.tr(context),
                      style: eBold20(context))),
              TextButton(
                  onPressed: () {},
                  child:
                      Text('SETTING'.tr(context), style: eBold20(context))),
              Spacer(),
              TextButton(
                      onPressed: () {},
                      child: Text("Log out".tr(context),
                          style: eBold20(context)))
                  .paddingB(context, 0.03),
            ],
          ),
        ),
      ),
    );
