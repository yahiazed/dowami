import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:dowami/features/terms/presentation/pages/privacy_policy_screen.dart';
import 'package:dowami/features/terms/presentation/pages/terms_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constant/text_style/text_style.dart';
import 'steps/register_send_otp.dart';

class SelectAccountKind extends StatelessWidget {
  const SelectAccountKind({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              TextButton(
                  onPressed: () {Navigator.pop(context);},
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
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                        children: [
                    TextSpan(text: "WeToDawmi".tr(context), style: taj15Blue()),
                    TextSpan(text: "Dawami".tr(context), style: taj15Blue().copyWith(color: Recolor.amberColor)),
                        ],
                      ),
                  ).paddingB(context, 0.02),

                  RichText(
                      text: TextSpan(
                          children: [
                    TextSpan(text: "Happy".tr(context), style: taj25BoldBlue2()),
                    TextSpan(text: '${"join".tr(context)}\t', style: taj25BoldBlue2().copyWith(color: Recolor.amberColor),),
                    TextSpan(text: "us".tr(context), style: taj25BoldBlue2()),

                          ],
                      ),
                  ).paddingB(context, 0.02),
                  Text(
                    'chooseAccount'.tr(context), style: taj16BoldBlue(),).paddingB(context, 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      sharedElevatedButton2(
                          onPressed: () {
                            RegisterCubit.get(context).userType = 'client';
                            navigateTo(context, RegisterSendOtpScreen());
                          },
                          radius: 15,
                          color: Recolor.amberColor,
                          horizontalPadding: 0.09.widthX(context),
                          verticalPadding: 0.03.heightX(context),
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                userSvg,
                                color: Recolor.whiteColor,
                              ).paddingB(context, 0.01),
                              Text(
                                "customer account".tr(context),
                                style: taj12BoldWhite(),
                              )
                            ],
                          )),
                      sharedElevatedButton2(
                          onPressed: () {
                            RegisterCubit.get(context).userType = 'captain';
                            navigateTo(context, RegisterSendOtpScreen());
                          },
                          radius: 15,
                          horizontalPadding: 0.09.widthX(context),
                          verticalPadding: 0.03.heightX(context),
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                captainSvg,
                                color: Recolor.whiteColor,
                              ).paddingB(context, 0.01),
                              Text(
                                "captain account".tr(context),
                                style: taj12BoldWhite(),
                              )
                            ],
                          )),
                    ],
                  ).paddingB(context, 0.093),
                  Text("By creating".tr(context),
                      style: taj12BoldWhite().copyWith(
                        color: Recolor.mainColor,
                      )).paddingB(context, 0.02),
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Privacy Policy".tr(context),
                          style: taj16BoldBlue().copyWith(
                            fontSize: 12,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navigateRep(context, const PrivacyPolicyScreen());
                            }),
                      TextSpan(
                        text: "and".tr(context),
                        style: taj14Blue().copyWith(fontSize: 12),
                      ),
                      TextSpan(
                          text: "Terms of Service".tr(context),
                          style: taj16BoldBlue().copyWith(fontSize: 12),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navigateTo(context, const ServiceTerms());
                            }),
                    ],
                  )),
                ]),
          ),
        );
      },
    );
  }
}
