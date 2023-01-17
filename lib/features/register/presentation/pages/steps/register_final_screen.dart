import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/features/login/presentation/pages/login_screen1.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';


import '../../../../../constant/text_style/text_style.dart';
import '../../../../home/presentation/pages/home_screen.dart';

class RegisterFinalScreen extends StatelessWidget {
  const RegisterFinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sharedAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTopTextColumn(context),
          Container()
              .roundWidget(
                  width: 0.7.widthX(context), height: 0.4.heightX(context))
              .cardAll(radius: 12, elevation: 7),
          sharedElevatedButton(
              context: context,
                  onPressed: () {

                    navigateRem(context, LogInScreen1());



                  },
                  txt: 'skip'.tr(context),
                  textStyle: taj16BoldWhite(),
                  radius: 9,
                  verticalPadding: 0.025.heightX(context),
                  horizontalPadding: 0.2.widthX(context))
              .paddingT(context, 0.025)
        ],
      ),
    );
  }

  Widget _buildTopTextColumn(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Congratulation".tr(context), style: med12(context)),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: "Welcome".tr(context), style: taj25BoldBlue()),
            TextSpan(text: "Dawami".tr(context), style: taj25BoldAmber()),
          ])).paddingB(context, 0.07),
          Text("showVideo".tr(context),
              textAlign: TextAlign.center, style: taj11MedBlue()),
        ],
      ).paddingS(context, 0.1, 0.06),
    );
  }
}
