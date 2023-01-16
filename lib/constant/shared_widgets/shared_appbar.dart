import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../strings/strings.dart';
import '../text_style/text_style.dart';

AppBar sharedAppBar(context) => AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'back'.tr(context),
                  style: taj14Blue().copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                )
              ],
            ))
      ],
    );
AppBar sharedHomeAppBar(
  context, {
  required String url,
  required String title,
}) =>
    AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(title.tr(context), style: taj16ExtraBoldBlue()),
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(url, fit: BoxFit.cover).circleShape(
                borderColor: Recolor.rowColor,
                borderWidth: 1,
                width: 37,
                height: 37),
          ],
        ),
      ),
      actions: [
        Builder(
          builder: (context) => TextButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: SvgPicture.asset(drawerSvg)),
        )
      ],
    );



class SharedHomeAppBar extends StatelessWidget {
  final String title;
  final String url;
  const SharedHomeAppBar({Key? key, required this.title, required this.url}) : super(key: key);

  @override
  AppBar build(BuildContext context) {
    return  AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(title.tr(context), style: taj16ExtraBoldBlue()),
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(url, fit: BoxFit.cover).circleShape(
                borderColor: Recolor.rowColor,
                borderWidth: 1,
                width: 37,
                height: 37),
          ],
        ),
      ),
      actions: [
        Builder(
          builder: (context) => TextButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: SvgPicture.asset(drawerSvg)),
        )
      ],
    );
  }
}

