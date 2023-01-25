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



class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainSettingsCubit, MainSettingsState>(
     /*   listenWhen: (previous, current) =>
    current is EndStartingPageState
        || current is SuccessGetSettingsState
        || current is SuccessLoginState
        || current is EndGetLanguageState
        || current is SuccessSaveDataState
    ,
        buildWhen: (previous, current) =>
        current is EndStartingPageState
            || current is SuccessGetSettingsState
            || current is SuccessLoginState
            || current is EndGetLanguageState
            || current is SuccessSaveDataState

        ,*/
        listener: (context, state) async{
          var logCubit=LoginCubit.get(context);
          var lang=MainSettingsCubit.get(context).languageCode;
          var mainCubit=MainSettingsCubit.get(context);
         // if(state is EndStartingPageState){print('start get language');await MainSettingsCubit.get(context). getLanguageFromPrefs();}

          if(state is EndGetLanguageState){
           await mainCubit.getMainSettings(lang: lang);
          }

          if(state is SuccessGetSettingsState){
            if(!await  logCubit.getDataFromPrefs()){navigateRem(context, SelectLog());}
            else{
              if(logCubit.token==null){
                print('token=null');
                // navigateTo(context, const SelectLog());
              }
              else{

                await  logCubit.login( lang: lang);
              }
            }
           // await Future.delayed(Duration(seconds: 4));


          }


          if(logCubit.state is SuccessLoginState||logCubit.state is SuccessSaveDataState){


            navigateRep(context, const HomeScreen());}
          if(logCubit.state is ErrorLoginState){
            print('error login');
            navigateRep(context, const SelectLog());}
        },
        builder: (context, state) {
          if(state is MainSettingsInitial){
            print('start get language');
              MainSettingsCubit.get(context). getLanguageFromPrefs();
          }
          print(state);
          var cubit = MainSettingsCubit.get(context);

          return FutureBuilder<void>(
            future: cubit.onStartPage(state is MainSettingsInitial),
            builder: (context, snapshot) {
              print(state);
              return Scaffold(
                body: //state is SuccessGetSettingsState ?
                _splash(context)
                    //: _loading(context),

              );
            },

          );
        }
    );
  }

  Widget preview(context) => _splash(context);

  Widget _splash(context) {
    return Container(
      width: 1.0.widthX(context),
      height: 1.0.heightX(context),

      color: Theme.of(context).primaryColor,
      child: Center(
        child:// MainSettingsCubit.get(context).mainSettingsModel == null || MainSettingsCubit.get(context).mainSettingsModel!.splashScreen != null ? Text('', style: eBold30(context),) :
        SvgPicture.asset('assets/svg/Group9786.svg',),
      )
      // Image(image: NetworkImage(MainSettingsCubit.get(context).mainSettingsModel!.logo!))
      ,
    );
  }

  Widget _loading(context) {
    return Container(
      width: 1.0.widthX(context),
      height: 1.0.heightX(context),

      color: Theme
          .of(context)
          .primaryColor,


    );
  }


}

/*
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  getSettings()async{
    await MainSettingsCubit.get(context).getLanguageFromPrefs();
    if(!mounted)return;
await MainSettingsCubit.get(context).getMainSettings(lang:MainSettingsCubit.get(context).languageCode );
if(!mounted)return;
await LoginCubit.get(context).getDataFromPrefs();



Timer(const Duration(seconds: 5), () {

        if(LoginCubit.get(context).token==null){navigateTo(context, const SelectLog());}
        else{navigateTo(context, const HomeScreen()
        );}});

  }
  @override
  void initState() {
    super.initState();
    getSettings();

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

            color: Theme.of(context).primaryColor,
            child: Center(
              child: MainSettingsCubit.get(context).mainSettingsModel==null
                  ||MainSettingsCubit.get(context).mainSettingsModel!.splashScreen!=null
                  ? Text('',style: eBold30(context),)
                  :SvgPicture.asset('assets/svg/Group9786.svg',),
            )
            // Image(image: NetworkImage(MainSettingsCubit.get(context).mainSettingsModel!.logo!))
            ,
          );
        }
    );

  }





}
*/