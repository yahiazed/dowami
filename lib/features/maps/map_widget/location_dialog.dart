import 'dart:async';

import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/maps/cubit/map_cubit.dart';
import 'package:dowami/features/maps/cubit/map_state.dart';
import 'package:dowami/features/maps/helper/permission.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';




class OpenLocationDialog extends StatelessWidget {
  OpenLocationDialog({Key? key}) : super(key: key);
  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sharedAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex:7,
              child: _buildGoogleMap(),),

            Expanded(
              flex: 1,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  saveButton2(context),
                  closeButton2(context)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildGoogleMap(){
    return BlocConsumer<MapCubit, MapState>(
        listener:  (context, state){},
        builder:  (context, state) {
          return StatefulBuilder(
              builder: (context,setState) {
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target:  MapCubit.get(context).myLatLong!,
                    zoom: 18.4746,),
                  onMapCreated: (GoogleMapController controller) {_controller.complete(controller);},
                  onTap: (L){
                    setState(() {MapCubit.get(context).myLatLong=L;});


                  },
                  markers: {Marker(markerId: const MarkerId('m'), position: MapCubit.get(context).myLatLong!,)},


                );
              }
          );
        }
    );
  }




  Widget  saveButton2(context){
    return  sharedElevatedButton(
      context: context,
      onPressed: ()async {
        var cubit=BlocProvider.of<MapCubit>(context,listen: false);
        var myLatLng=cubit.myLatLong!;

        List<Placemark> placeMarks = await placemarkFromCoordinates(myLatLng.latitude,myLatLng. longitude);
        Placemark myAddress=placeMarks.first;

        cubit.city=myAddress.administrativeArea!;
        cubit.area=myAddress.subAdministrativeArea!;
        cubit.district=myAddress.locality!;
        print('city : ${cubit.city}');
        print('area : ${cubit.area}');
        print('district : ${cubit.district}');

        Navigator.pop(context,myLatLng);
      },
      txt: 'Confirm'.tr(context),
      textStyle: eBold19(context).copyWith(color: Recolor.whiteColor),
      radius: 9,
      color: Theme.of(context).primaryColor,
      horizontalPadding: 0.05.widthX(context),
      verticalPadding: 0.01.heightX(context),
    );
  }
  Widget  closeButton2(context){
    return  sharedElevatedButton(
      context: context,
      onPressed: ()async {

        Navigator.pop(context,null);
      },
      txt: 'back'.tr(context),
      textStyle: eBold19(context).copyWith(color: Recolor.whiteColor),
      radius: 9,
      color: Theme.of(context).primaryColor,
      horizontalPadding: 0.05.widthX(context),
      verticalPadding: 0.01.heightX(context),
    );
  }


}


Future<LatLng?> openLocationDialog(context)async{
  bool locationEnable= await checkLocationPermissions();
  if(!locationEnable){return null;}
  await Geolocator.getCurrentPosition().then((value) =>
  MapCubit.get(context).myLatLong=
      const LatLng(30.592153682326554, 31.52264703065157)
     // LatLng(value.latitude,value.longitude)

  );


  return await  showDialog<LatLng>(context: context, builder: (context) =>Dialog(child: OpenLocationDialog(),));






}

