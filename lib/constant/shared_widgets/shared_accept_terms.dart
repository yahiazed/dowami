import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../features/register/cubit/register_cubit.dart';
import '../../features/terms/presentation/pages/privacy_policy_screen.dart';
import '../../features/terms/presentation/pages/terms_screen.dart';
import '../shared_colors/shared_colors.dart';
import '../shared_function/navigator.dart';
import '../text_style/text_style.dart';

Widget buildAcceptsTermsRow(bool isAcceptTerms, BuildContext context) {
  return Row(
    // crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Checkbox(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Recolor.mainColor, width: 1),
            borderRadius: BorderRadius.circular(5)),
        value: isAcceptTerms,
        onChanged: (value) {
          RegisterCubit.get(context).onChangedAcceptTerms(value);
        },
      ),
      RichText(
          text: TextSpan(children: [
        TextSpan(text: "I Accept".tr(context), style: taj12RegBlue()),
        TextSpan(
            text: "Privacy Policy".tr(context),
            style: taj12MedBlue(),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                navigateTo(context, const PrivacyPolicyScreen());
              }),
        TextSpan(text: "and".tr(context), style: taj11MedBlue()),
        TextSpan(
            text: "Terms of Service".tr(context),
            style: taj12MedBlue(),
            recognizer: TapGestureRecognizer()
              ..onTap = () => navigateTo(context, const ServiceTerms())),
      ]))
    ],
  ).paddingSV(context, 0.02);
}
