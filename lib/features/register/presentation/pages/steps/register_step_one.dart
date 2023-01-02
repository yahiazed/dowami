import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/features/register/presentation/cubit/register_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:dowami/features/register/presentation/pages/steps/register_step_two.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constant/shared_colors/shared_colors.dart';
import '../../../../../constant/shared_function/navigator.dart';
import '../../../../../constant/shared_widgets/shared_appbar.dart';
import '../../../../../constant/shared_widgets/shared_card_input.dart';
import '../../../../../constant/shared_widgets/shared_flag_item.dart';
import '../../../../../constant/text_style/text_style.dart';
import '../../../../terms/presentation/pages/privacy_policy_screen.dart';
import '../../../../terms/presentation/pages/terms_screen.dart';

class RegisterStepOneScreen extends StatelessWidget {
  // bool isCaptain;
  String phoneCode = '+966';
  var phoneController = TextEditingController();
  RegisterStepOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is ErrorSendOtpState) {
          showErrorToast(message: state.errorMsg);
        }
        if (state is SuccessSendOtpState) {
          RegisterCubit.get(context).smsCode = state.smsCode;
          print('smscode======================${state.smsCode}');
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return Scaffold(
          appBar: sharedAppBar(context),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildWelcomeText(context),
                _buildHappyText(context),
                _buildPhoneInput(context),
                Text("By creating".tr(context),
                    style: taj12BoldWhite().copyWith(
                      color: Recolor.mainColor,
                    )).paddingB(context, 0.02),
                _buildPrivacyText(context),
                _buildButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    return sharedElevatedButton(
      txt: 'next'.tr(context),
      radius: 9,
      verticalPadding: 0.023.heightX(context),
      horizontalPadding: 0.2.widthX(context),
      textStyle: taj16BoldBlue().copyWith(color: Recolor.amberColor),
      onPressed: () {
        RegisterCubit.get(context).phoneCode = phoneCode;
        RegisterCubit.get(context).phoneNumber = phoneController.text;
        navigateTo(
            context,
            RegisterStepTwoScreen(
                phoneNumber: phoneCode + phoneController.text));
        RegisterCubit.get(context)
            .sendOtp(phoneNum: phoneCode + phoneController.text);
      },
    );
  }

  Widget _buildPrivacyText(BuildContext context) {
    return RichText(
        text: TextSpan(
      children: [
        TextSpan(
            text: "Privacy Policy".tr(context),
            style: taj16BoldBlue()
                .copyWith(fontSize: 12, color: Recolor.amberColor),
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
            style: taj16BoldBlue()
                .copyWith(fontSize: 12, color: Recolor.amberColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                navigateTo(context, const ServiceTerms());
              }),
      ],
    )).paddingB(context, 0.02);
  }

  Widget _buildPhoneInput(BuildContext context) {
    return sharedCardInput(context,
            controller: phoneController,
            hintText: 'enterPhone'.tr(context),
            suffix: buildFlag(
              cCode: phoneCode,
              onTap: (p0) {
                phoneCode = p0.phoneCode;
              },
            ))
        .roundWidget(width: .9.widthX(context), height: 0.070.heightX(context))
        .cardAll(elevation: 12, radius: 7, shadowColor: const Color(0xffF6F6F6))
        // .paddingSH(context, 0.05)
        .paddingB(context, 0.04);
  }

  Widget _buildHappyText(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(text: "Happy".tr(context), style: taj25BoldBlue2()),
      TextSpan(
          text: '${"join".tr(context)}\t',
          style: taj25BoldBlue2().copyWith(color: Recolor.amberColor)),
      TextSpan(text: "us".tr(context), style: taj25BoldBlue2()),
    ])).paddingB(context, 0.02);
  }

  Widget _buildWelcomeText(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(text: "WeToDawmi".tr(context), style: taj15Blue()),
      TextSpan(
          text: "Dawami".tr(context),
          style: taj15Blue().copyWith(color: Recolor.amberColor)),
    ])).paddingB(context, 0.02);
  }
}
