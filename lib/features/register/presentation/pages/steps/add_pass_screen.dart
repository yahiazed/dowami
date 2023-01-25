import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constant/shared_function/navigator.dart';
import '../../../../../constant/shared_widgets/shard_elevated_button.dart';
import '../../../../../constant/shared_widgets/toast.dart';
import 'fill_data_screen.dart';

class AddPasswordScreen extends StatelessWidget {


  AddPasswordScreen({super.key,});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=RegisterCubit.get(context);
        return Scaffold(
          appBar: sharedAppBar(context: context,onTap: (){Navigator.pop(context);}),
          body: Center(
            child: Column(
              children: [
                _buildTopTexts(context),
                _buildInputPassField(context,cubit),
                _buildButton(context,cubit: cubit)
              ],
            ),
          ),
        );
      }
    );




  }

  Widget _buildInputPassField(
      BuildContext context,
      RegisterCubit cubit) {

    return StatefulBuilder(
      builder: (context, setState)  {

        return
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              sharedCardInput(context,
                  controller:cubit. passController,
                  isPassword: cubit.showPass,
                  hintText: "enterPass".tr(context),
                  hintStyle: med14(context).copyWith(color: Recolor.hintColor),
                  keyboardType: TextInputType.visiblePassword,
                  suffix: IconButton(
                      onPressed: () {
                        cubit.onChangeShowPass(!cubit.showPass);


                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Recolor.rowColor,
                      )))
                  .roundWidget(
                  width: .9.widthX(context), height: 0.070.heightX(context))
                  .cardAll(
                  elevation: 12, radius: 7, shadowColor: const Color(0xffF6F6F6))
                  .paddingB(context, 0.02),
              sharedCardInput(context,
                  controller:cubit. rePassController,
                  isPassword: cubit.showPass,
                  hintText: "erEnterPass".tr(context),
                  hintStyle: med14(context).copyWith(color: Recolor.hintColor),
                  keyboardType:  TextInputType.visiblePassword,
                  suffix: IconButton(
                      onPressed: () {
                        cubit.onChangeShowPass(!cubit.showPass);
                        },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Recolor.rowColor,
                      ))
              )
                  .roundWidget(
                  width: .9.widthX(context), height: 0.070.heightX(context))
                  .cardAll(
                  elevation: 12, radius: 7, shadowColor: const Color(0xffF6F6F6))
                  .paddingB(context, 0.04),
            ],
          );},

    );
  }

  Widget _buildTopTexts(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("add password".tr(context), style: med12(context)),
        Text("our end! Verified".tr(context), style: eBold25(context)),
        Text("Now enter and confirm the password".tr(context),
            style: med14(context)),
      ],
    ).paddingSV(context, 0.08);
  }

  Widget _buildButton(BuildContext context,{required RegisterCubit cubit}) {
    return sharedElevatedButton(
      context: context,
      txt: 'next'.tr(context),
      radius: 9,
      verticalPadding: 0.023.heightX(context),
      horizontalPadding: 0.15.widthX(context),
      textStyle: bold16(context).copyWith(color: Theme.of(context).primaryColor),
      onPressed: ()async {

        if(cubit. passController.text==cubit.rePassController.text){

          if(cubit. passController.text.isEmpty||cubit.rePassController.text.isEmpty){ showErrorToast(message:'enterPasswords'.tr(context));return;}
          if(cubit. passController.text.length<7){ showErrorToast(message:'weakPassword'.tr(context));return;}

          cubit.userPassword=cubit.passController.text;
       // await  cubit.getCities(lang: MainSettingsCubit.get(context).languageCode);
               navigateTo(context, FillUserRegisterDataScreen( ));





        }


        else {
          showErrorToast(message:'passNotIdentical'.tr(context));return;

        }

      },
    );
  }
}
