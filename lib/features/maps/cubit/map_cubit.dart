import 'package:dowami/features/maps/cubit/map_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCubit extends Cubit<MapState>{

  MapCubit():super(MapInitial());
  static MapCubit get(context) => BlocProvider.of(context);


 LatLng? myLatLong;
 String city='';
 String area='';
 String district='';


 // LatLng? startLatLng;
 // LatLng? endLatLng;
  //List<LatLng>? stopPoints;




   onChangeLocation({required LatLng value}){

     emit(StartChange());
     myLatLong=value;
     emit(EndChange());

   }

   @override
  void onChange(Change<MapState> change) {
   print('onchange');
    super.onChange(change);
  }



/*  List<Placemark> placeMarks = await placemarkFromCoordinates(myLatLng.latitude,myLatLng. longitude);
  Placemark myAddress=placeMarks.first;

  cubit.city=myAddress.administrativeArea!;
  cubit.area=myAddress.subAdministrativeArea!;
  cubit.district=myAddress.locality!;*/

}