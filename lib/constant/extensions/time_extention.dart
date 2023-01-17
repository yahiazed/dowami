import 'package:flutter/material.dart';

extension Timex on TimeOfDay {

  String getStringFormat({required BuildContext context,required TimeOfDay time}) {
    final localizations = MaterialLocalizations.of(context);
    String formattedTimeOfDay = localizations.formatTimeOfDay(time,alwaysUse24HourFormat: true);
    return formattedTimeOfDay;
      }



}
 String getStringFormat({required BuildContext context,required TimeOfDay time}) {
  final localizations = MaterialLocalizations.of(context);
  String formattedTimeOfDay = localizations.formatTimeOfDay(time,alwaysUse24HourFormat: true);
  return formattedTimeOfDay;
}

