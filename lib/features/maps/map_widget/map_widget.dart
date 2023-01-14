import 'dart:async';

import 'package:dowami/features/maps/cubit/map_cubit.dart';
import 'package:dowami/features/maps/cubit/map_state.dart';
import 'package:dowami/features/maps/helper/permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapWidget extends StatelessWidget {
   MapWidget({Key? key}) : super(key: key);

  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit,MapState>(
      listener: (context, state) {
      },
      builder: (context,state) {
        var cubit=MapCubit.get(context);

        return GoogleMap(
          mapType: MapType. satellite,
          initialCameraPosition: CameraPosition(
            target: cubit.myLatLong! ,
            zoom: 18.4746,),
          onMapCreated: (GoogleMapController controller) {

            _controller.complete(controller);

           },
          onTap: (L){cubit.onChangeLocation(value: L);},
          markers: {
            Marker(markerId: const MarkerId('m'), position: cubit.myLatLong!,)},






          circles: {
            Circle(
              circleId: const CircleId('gg'),
              radius: 50,
              fillColor: Colors.amber.withOpacity(.3),
              visible: true,
              center: cubit.myLatLong!,
              strokeColor: Colors.white,
              strokeWidth: 1,
              onTap: (){}
            )},


          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          indoorViewEnabled: false,
          mapToolbarEnabled: false,
          trafficEnabled: false,
          tiltGesturesEnabled: false,
          buildingsEnabled: false,
          compassEnabled: false,
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: true,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: false,




        );

      },


    );
  }
}

