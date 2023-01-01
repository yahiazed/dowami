import 'package:flutter/material.dart';

extension SizeX on double {
  double widthX(BuildContext context) =>
      this * MediaQuery.of(context).size.width;
  double heightX(BuildContext context) =>
      this * MediaQuery.of(context).size.height;
}

// extension WidgetX on Widget{
//   Widget raduisAll()=>RoundedRectangleBorder()
// }