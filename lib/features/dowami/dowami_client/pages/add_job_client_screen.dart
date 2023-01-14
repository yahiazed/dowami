import 'package:dowami/constant/enums/days_enums.dart';
import 'package:dowami/constant/extensions/lat_lng_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/dowami/dowami_client/cubit/dowami_client_cubit.dart';
import 'package:dowami/features/dowami/dowami_client/cubit/dowami_client_state.dart';
import 'package:dowami/features/maps/map_widget/location_dialog.dart';
import 'package:dowami/features/maps/cubit/map_cubit.dart';
import 'package:dowami/features/maps/helper/permission.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddJobClient extends StatelessWidget {
   AddJobClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<DowamiClientCubit,DowamiClientState>(
        listener: (context,state){},
        builder: (context,state) {


          var cubit=DowamiClientCubit.get(context);

          return Scaffold(

            body:preview(context, cubit),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                stopPointsControllers.add(TextEditingController());
                stopPointsLocs.add(LatLng(0, 0));
                cubit.onSelectLocation();

              },
            ),

          );
        }
    );
  }

Widget preview(context,DowamiClientCubit cubit){
    return makeJobPreview(context,cubit);
}

successPreview(){}




  makeJobPreview(context,cubit){
    return
      SingleChildScrollView(
        child: Column(
          children: [


            getLocButton(context: context, controller:fromLocController , hint: 'نقطه الانطلاق',func: (l){startLoc=l;}),
            getLocButton(context: context, controller:toLocController , hint: 'نقطه ألوصول',func: (l){endLoc=l;}),
            Column(
              children:
                stopPointsControllers.map((controller) =>
                    getLocButton(context: context, controller:controller , hint: 'نقطه توقف ${(stopPointsControllers.indexOf(controller)+1)}',func: (l){stopPointsLocs[stopPointsControllers.indexOf(controller)]=l;})

                ).toList()

              ,

            ),

            Row(
              children:
              daysMap.map((e) =>
                  Material(
                    borderRadius: BorderRadius.circular(5),
                    color:e['id']=='0'||e['id']=='6'?Recolor.redColor.withOpacity(.5): Recolor.oGreenColor,
                    child: Text(

                        e['name']!.tr(context),
                      style:
                      bold14Blue().copyWith(color: Recolor.whiteColor),

                    ).paddingA(8),
                  ).paddingA(4)

              ).toList()


              ,
            )
          ],


        ),
      )

      ;
  }

   TextEditingController fromLocController=TextEditingController();
   TextEditingController toLocController=TextEditingController();
   List<TextEditingController> stopPointsControllers=[];
   List<LatLng> stopPointsLocs=[];

   LatLng? startLoc;
   LatLng? endLoc;

  Widget getLocButton({required BuildContext context,required TextEditingController controller,required String hint,required  Function(LatLng l) func }){
    return
      sharedBorderedInput(context,
          controller: controller,
          hintText: hint,
          borderWidth: 2,
          fillColor: Recolor.whiteColor,
          isPassword: false,
          radius: 10,
          suffix:  const Icon(Icons.location_on_outlined),
          keyboardType: TextInputType.none,
          onTap: ()async{





              LatLng?   selectedLatLng=await  openLocationDialog(context);
              if(selectedLatLng==null){return;}

              Placemark myAddress=await selectedLatLng.getPlaceMark();

              var city=myAddress.administrativeArea!;
              var area=myAddress.subAdministrativeArea!;
              var district=myAddress.locality!;
              controller.text= '$city,$area,$district';
              func(selectedLatLng);





            print(startLoc);
            print(endLoc);

          }


      ).paddingA(20)

      ;
  }




}
