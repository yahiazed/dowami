import 'dart:async';

import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/home/presentation/pages/home_screen.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_state.dart';
import 'package:dowami/features/register/presentation/pages/select_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  getSettings()async{
await MainSettingsCubit.get(context).getMainSettings();
if(!mounted)return;
await LoginCubit.get(context).getDataFromPrefs();

Timer(const Duration(seconds: 5), () {

  if(LoginCubit.get(context).token==null){navigateTo(context, SelectLog());}
  else{navigateTo(context, HomeScreen());}



});
  }
  @override
  void initState() {
    super.initState();
    getSettings();
   // Timer(Duration(seconds: 5), () {navigateTo(context, SelectLog());});
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

       body: Row(
         children: [

           splash(),
         ],
       )
    );
  }
  Widget splash(){
    print('splash');
    return  BlocConsumer<MainSettingsCubit,MainSettingsState>(
        listenWhen: (previous, current) => current is SuccessGetSettingsState||current is ErrorGetSettingsState,
        buildWhen: (previous, current) =>current is SuccessGetSettingsState||current is ErrorGetSettingsState ,
        listener: (context, state) {

        },
        builder: (context,state)  {
          print(MainSettingsCubit.get(context).mainSettingsModel);
          return Container(
            width: 1.0.widthX(context),
            height: 1.0.heightX(context),

            color: Recolor.amberColor,
            child: Center(
              child: MainSettingsCubit.get(context).mainSettingsModel==null
                  ||MainSettingsCubit.get(context).mainSettingsModel!.splashScreen!=null
                  ? Text('',style: eBold30Blue(),)
                  :SvgPicture.asset('assets/svg/Group9786.svg',),
            )
            // Image(image: NetworkImage(MainSettingsCubit.get(context).mainSettingsModel!.logo!))
            ,
          );
        }
    );

  }





}










