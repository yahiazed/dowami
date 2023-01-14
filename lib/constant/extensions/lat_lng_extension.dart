import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension PointString on LatLng {
  String toStringPoint() {
      return '$latitude,$longitude';
  }


  Future<Placemark> getPlaceMark()async{

    List<Placemark> placeMarks =await  placemarkFromCoordinates(latitude, longitude);
    return  placeMarks.first;
  }





}
extension GetLatLng on String {


  LatLng getLatLng() {



    return LatLng(double.parse(split(',')[0]),double.parse(split(',')[1]));
  }

}









String pointFromLatLng({required LatLng latLng}){
  return '${latLng.latitude},${latLng.longitude}';

}
LatLng getLatLng({required String string}){

  double lat=double.parse(string.split(',')[0]);
  double long=double.parse(string.split(',')[1]);
  return LatLng(lat,long);
}