import 'package:dowami/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';

navigateTo(BuildContext context, Widget widget) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => widget,
  ));
}

navigateRep(BuildContext context, Widget widget) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => widget,
  ));
}

navigateRem(BuildContext context, Widget widget) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
      (route) => route is HomeScreen);
}
