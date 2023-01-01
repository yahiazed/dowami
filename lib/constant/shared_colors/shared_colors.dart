import 'package:flutter/material.dart';

class Recolor {
  static Color mainColor = const Color(0xff003466);
  static Color amberColor = const Color(0xffFFB808);
  static Color whiteColor = const Color(0xffFFFFFF);
  static Color underLineColor = const Color(0xffD3DFEF);
  static Color redColor = const Color(0xffFF0000);
  static Color oGreenColor = const Color(0xffAEF1BD);
  static Color oPinkColor = const Color(0xffF0ADAD);
  static Color onlineColor = const Color(0xff16EE32);
  static Color hintColor = const Color(0xff797979);
  static Color rowColor = const Color(0xff707070);
  static Color row2Color = const Color(0xff7f7f7f);
  static Color txtColor = const Color(0xff386087);
  static Color txtEffectiveColor = const Color(0xff097F24);
  static Color txtCancelColor = const Color(0xffF35454);
  static Color txtNotifyColor = const Color(0xffFF0303);
  static Color txtRefuseColor = const Color(0xffC80909);
  static Color cardColor = const Color(0xffA5A5A5);
  static Color txtGreyColor = const Color(0xffB2B2B2);
  static Color card2Color = const Color(0xffBDBEBF);
  static Color card3Color = const Color(0xffF8F9FD);

  static const MaterialColor kMain = MaterialColor(
    0xff003466, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color.fromRGBO(0, 52, 102, 0.1), //10%
      100: Color.fromRGBO(0, 52, 102, 0.2), //20%
      200: Color.fromRGBO(0, 52, 102, 0.3), //30%
      300: Color.fromRGBO(0, 52, 102, 0.4), //40%
      400: Color.fromRGBO(0, 52, 102, 0.5), //50%
      500: Color.fromRGBO(0, 52, 102, 0.6), //60%
      600: Color.fromRGBO(0, 52, 102, 0.7), //70%
      700: Color.fromRGBO(0, 52, 102, 0.8), //80%
      800: Color.fromRGBO(0, 52, 102, 0.9), //90%
      900: Color.fromRGBO(0, 52, 102, 1), //100%
    },
  );
}
