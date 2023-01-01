import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

showSuccessToast({required String message}) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Recolor.oGreenColor,
    textColor: Recolor.row2Color,
    fontSize: 16.0);
showErrorToast({required String message}) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Recolor.redColor,
    textColor: Recolor.whiteColor,
    fontSize: 16.0);
