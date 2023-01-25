import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/shared_widgets/shared_flag_item.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/forget_password/cubit/forget_pass_cubit.dart';
import 'package:dowami/features/forget_password/cubit/forget_pass_state.dart';
import 'package:dowami/features/forget_password/presentation/forget_pass_verify_code.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/terms/presentation/pages/privacy_policy_screen.dart';
import 'package:dowami/features/terms/presentation/pages/terms_screen.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPassSendOtp extends StatelessWidget {


  const ForgetPassSendOtp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ResetPassCubit, ResetPassState>(
        listener: (context, state) {
          if (state is ErrorSendOtpResetPassState) {
            showErrorToast(message: state.errorMsg);

          }
          if (state is SuccessSendOtpResetPassState) {
            ResetPassCubit.get(context).smsCode = state.smsCode;
            print('smscode======================${state.smsCode}');
            navigateTo(context,  ForgetPassVerifyCode());
          }
        },
        builder: (context, state) {
          var cubit = ResetPassCubit.get(context);
          return Scaffold(
            appBar: sharedAppBar(context: context,onTap: (){Navigator.pop(context);}),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 // _buildWelcomeText(context),
                  _buildHappyText(context),
                  _buildPhoneInput(context),
                //  Text("By creating".tr(context), style: bold12(context).copyWith(color: Theme.of(context).canvasColor,)).paddingB(context, 0.02),
                 // _buildPrivacyText(context),
                  _buildButton(context),
                ],
              ),
            ),
          );
      }
    );
  }













  Widget _buildButton(BuildContext context) {
    return sharedElevatedButton(
      context: context,
      txt: 'next'.tr(context),
      radius: 9,
      verticalPadding: 0.023.heightX(context),
      horizontalPadding: 0.2.widthX(context),
      textStyle:bold16(context).copyWith(color: Theme.of(context).primaryColor),
      onPressed: ()async {
        var cubit=ResetPassCubit.get(context);

        cubit.phoneNumber = cubit. phoneController.text;

        if(cubit.second!=0){navigateTo(context, ForgetPassVerifyCode());}
        else{
          await  cubit.sendOtp( lang: MainSettingsCubit.get(context).languageCode);
        }


      },
    );
  }

  Widget _buildPrivacyText(BuildContext context) {
    return RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "Privacy Policy".tr(context),
                style:bold16(context)
                    .copyWith(fontSize: 12, color: Theme.of(context).primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    navigateRep(context, const PrivacyPolicyScreen());
                  }),
            TextSpan(
              text: "and".tr(context),
              style: reg14(context).copyWith(fontSize: 12),
            ),
            TextSpan(
                text: "Terms of Service".tr(context),
                style: bold16(context)
                    .copyWith(fontSize: 12, color: Theme.of(context).primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    navigateTo(context, const ServiceTerms());
                  }),
          ],
        )).paddingB(context, 0.02);
  }

  Widget _buildPhoneInput(BuildContext context) {
    return sharedCardInput(context,
        controller:ResetPassCubit.get(context). phoneController,
        hintText: 'enterPhone'.tr(context),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        suffix: buildFlag(
          cCode: ResetPassCubit.get(context).phoneCode,
          onTap: (p0) {
            ResetPassCubit.get(context).phoneCode = p0.phoneCode;
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
          TextSpan(text: "reset".tr(context), style: eBold25(context)),
          TextSpan(
              text: ' ${"password".tr(context)}\t',
              style:eBold25(context).copyWith(color: Theme.of(context).primaryColor)),
        //  TextSpan(text: "us".tr(context), style: eBold25(context)),
        ])).paddingB(context, 0.08);
  }

  Widget _buildWelcomeText(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
         // TextSpan(text: "WeToDawmi".tr(context), style: reg16(context) ),
          TextSpan(
              text: "Dawami".tr(context),
              style:eBold26(context).copyWith(color: Theme.of(context).primaryColor)),
        ])).paddingB(context, 0.1);
  }
}
