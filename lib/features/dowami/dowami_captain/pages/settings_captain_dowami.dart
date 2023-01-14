import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/sharedDrawer.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:dowami/features/bottom_bar/cubit/bottom_bar_state.dart';
import 'package:dowami/features/bottom_bar/presentation/dowami_bottom_bar.dart';
import 'package:dowami/features/dowami/dowami_captain/cubit/dowami_captain_cubit.dart';
import 'package:dowami/features/dowami/dowami_captain/cubit/dowami_captain_state.dart';
import 'package:dowami/features/home/presentation/cubit/home_cubit.dart';
import 'package:dowami/features/login/data/cubit/login_cubit.dart';
import 'package:dowami/features/maps/cubit/map_cubit.dart';
import 'package:dowami/features/maps/helper/permission.dart';
import 'package:dowami/features/maps/map_widget/map_widget.dart';
import 'package:dowami/features/register/presentation/cubit/register_cubit.dart';
import 'package:dowami/features/register/presentation/pages/steps/register_send_otp.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SettingCaptainDowamiScreen extends StatelessWidget {
  const SettingCaptainDowamiScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<DowamiCaptainCubit,DowamiCaptainState>(
      listener: (context,state){},
      builder: (context,state) {


        var cubit=DowamiCaptainCubit.get(context);

        return Scaffold(

          body:_previewSteps(context, cubit),

        );
      }
    );
  }


 Widget _welcomePreview(context,DowamiCaptainCubit cubit){
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "welcome to".tr(context), style: eBold30Blue()),
                  TextSpan(text: "Dawami".tr(context), style: eBold30Blue().copyWith(color: Recolor.amberColor)),
                ],
              ),
            ).paddingB(context, 0.04),


            Text('adjust your settings'.tr(context), style: med20Blue(),).paddingB(context, 0.01),

            Text("to get best".tr(context), style: med20Blue()).paddingB(context, 0.08),

            sharedElevatedButton(
                onPressed: () async{
                  bool locationEnable= await checkLocationPermissions();
                  if(locationEnable) {
                    await Geolocator.getCurrentPosition().then((value) =>
                    MapCubit.get(context).myLatLong = LatLng(value.latitude, value.longitude));
                    cubit.onChangeSteps(step:2 );
                  }


                },
                txt: "go".tr(context),
                color: Recolor.mainColor,
                radius: 10,
                textStyle: bold18Blue().copyWith(color: Recolor.amberColor),
                horizontalPadding: .18.widthX(context),
                verticalPadding: .016.heightX(context))
                .paddingB(context, .03),

            Text("dont worry settings".tr(context), style: reg14Blue())

          ]),
    )

      ;

  }

 Widget _selectAddress(context,DowamiCaptainCubit cubit){
    return  Center(
      child: SizedBox(
      //  width: 500,
         // height: 500,


          child: MapWidget()),
    )

      ;

  }
 Widget _selectWorkArea(context,DowamiCaptainCubit cubit){
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          ]),
    )

      ;

  }
 Widget _selectWorkTime(context,DowamiCaptainCubit cubit){
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          ]),
    )

      ;

  }
 Widget _done(context,DowamiCaptainCubit cubit){
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          ]),
    )

      ;

  }

  Widget _previewSteps(context,DowamiCaptainCubit cubit){

    Widget theReturnWidget= _welcomePreview(context, cubit);
    switch(cubit.step){
      case 1:
        theReturnWidget= _welcomePreview(context, cubit);
         break;
      case 2:
        theReturnWidget= _selectAddress(context, cubit);
        break;
      case 3:
        theReturnWidget= _selectWorkArea(context, cubit);
        break;
      case 4:
        theReturnWidget= _selectWorkTime(context, cubit);
        break;
      case 5:
        theReturnWidget= _done(context, cubit);
        break;

    }
    return theReturnWidget;

  }

}
