
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/forget_password/presentation/forget_pass_sent_otp.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/login/presentation/pages/login_screen2.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/register/presentation/pages/select_register_screen.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../constant/shared_widgets/shard_elevated_button.dart';
import '../../../../constant/shared_widgets/shared_card_input.dart';
import '../../../../constant/shared_widgets/shared_flag_item.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../register/presentation/pages/select_user_kind.dart';

class LogInScreen1 extends StatelessWidget {
  LogInScreen1({super.key});

  var loginFormKey = GlobalKey<FormState>();
  String phoneCode = '+966';

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is SuccessLoginState) {
            print('saving');
            LoginCubit.get(context).saveDataToPrefs();        }

          if (state is SuccessSaveDataState) {
            navigateTo(context, const HomeScreen());
          }
          if (state is ErrorSaveDataState) {
            showErrorToast(message:'error connection');
          }
          if (state is ErrorLoginState) {
            showErrorToast(message:state.errorMsg);
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
        return Scaffold(
          backgroundColor: Recolor.whiteColor,
          appBar: sharedAppBar(context: context,onTap: (){Navigator.pop(context);}),
          body: Center(
            child: Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'welcome back'.tr(context),
                    style: reg25(context),
                  ).paddingB(context, 0.03),
                  _buildPhoneInput(context),
                  _buildPassInput( context),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {
                          navigateTo(context, ForgetPassSendOtp());
                        },
                        child: Text(
                          'forgetPass'.tr(context),

                          style: reg12(context).copyWith( decoration: TextDecoration.underline,color: Colors.blue),
                        )),
                  ),
                  _buildButton( context),


                  TextButton(
                      onPressed: () {
                        navigateTo(context, SelectLog());
                      },
                      child: Text(
                        'OrCreateNew'.tr(context),
                        style:reg12(context).copyWith(decoration: TextDecoration.underline,color: Colors.blue),
                      )),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  Widget _buildPhoneInput(BuildContext context) {
    return sharedCardInput(context,
        controller:LoginCubit.get(context). phoneController,
        hintText: 'enterPhone'.tr(context),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
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
  Widget _buildPassInput(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {

        },
        builder: (context, state) {
        return sharedCardInput(context,
            controller:LoginCubit.get(context). passController,
            hintText: 'enterPass'.tr(context),
            isPassword: LoginCubit.get(context).showPass,
          keyboardType: TextInputType.text,
          /*  inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],*/
            suffix:
                IconButton(
                    onPressed: () {
                      print('lol');
                      LoginCubit.get(context).onShowPass();
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Recolor.rowColor,
                    )

            )

        )
            .roundWidget(width: .9.widthX(context), height: 0.070.heightX(context))
            .cardAll(elevation: 12, radius: 7, shadowColor: const Color(0xffF6F6F6))
        // .paddingSH(context, 0.05)
            .paddingB(context, 0.04);
      }
    );
  }
  Widget _buildButton(BuildContext context) {
    return sharedElevatedButton(
      context: context,

      onPressed: () {
        if (!loginFormKey.currentState!.validate()) {showErrorToast(message: 'enterPhone'.tr(context));}

        LoginCubit.get(context).phoneCode = phoneCode;
        LoginCubit.get(context).phoneNumber = LoginCubit.get(context).phoneController.text;
        LoginCubit.get(context).password = LoginCubit.get(context).passController.text;
        LoginCubit.get(context).login(

            lang: MainSettingsCubit.get(context).languageCode,

        );

      },
        txt: "goon".tr(context),
        color: Theme.of(context).primaryColor,
        radius: 6,
        textStyle: eBold19(context).copyWith(color: Recolor.whiteColor),
        horizontalPadding: .2.widthX(context),
        verticalPadding: .02.heightX(context))
        .paddingT(context, 0.025)
        .sizeDown(context, 0.01)
    ;
  }



}
