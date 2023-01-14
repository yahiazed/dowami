import 'dart:async';

import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../cubit/register_cubit.dart';



class GetLocationDialog extends StatelessWidget {
  GetLocationDialog({Key? key}) : super(key: key);
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

  RegisterState f=RegisterInitial();

  Widget _buildGoogleMap(){
    return BlocConsumer<RegisterCubit, RegisterState>(
        listener:  (context, state){},
        builder:  (context, state) {
          return StatefulBuilder(
              builder: (context,setState) {
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target:  RegisterCubit.get(context).latLng!,
                    zoom: 18.4746,),
                  onMapCreated: (GoogleMapController controller) {_controller.complete(controller);},
                  onTap: (L){
                    setState(() {RegisterCubit.get(context).latLng=L;});


                  },
                  markers: {Marker(markerId: const MarkerId('m'), position: RegisterCubit.get(context).latLng!,)},

                );
              }
          );
        }
    );
  }




  Widget  saveButton2(context){
      return  sharedElevatedButton(
            onPressed: ()async {
              var cubit=BlocProvider.of<RegisterCubit>(context,listen: false);
              var myLatLng=cubit.latLng!;

              List<Placemark> placeMarks = await placemarkFromCoordinates(myLatLng.latitude,myLatLng. longitude);
              Placemark myAddress=placeMarks.first;

              cubit.city=myAddress.administrativeArea!;
              cubit.area=myAddress.subAdministrativeArea!;
              cubit.district=myAddress.locality!;
              print('city : ${cubit.city}');
              print('area : ${cubit.area}');
              print('district : ${cubit.district}');

              Navigator.pop(context);
            },
            txt: 'Confirm'.tr(context),
            textStyle: taj19BoldWhite(),
            radius: 9,
            color: Recolor.amberColor,
            horizontalPadding: 0.05.widthX(context),
            verticalPadding: 0.01.heightX(context),
  );
}
  Widget  closeButton2(context){
      return  sharedElevatedButton(
            onPressed: ()async {

              Navigator.pop(context);
            },
            txt: 'back'.tr(context),
            textStyle: taj19BoldWhite(),
            radius: 9,
            color: Recolor.amberColor,
            horizontalPadding: 0.05.widthX(context),
            verticalPadding: 0.01.heightX(context),
  );
}


}




