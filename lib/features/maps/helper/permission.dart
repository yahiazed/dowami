import 'package:geolocator/geolocator.dart';



 Future<bool>  checkLocationPermissions()async{


  bool serviceEnabled;
  LocationPermission permission;
 // serviceEnabled = await Geolocator.isLocationServiceEnabled();


  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
                                               if (permission == LocationPermission.denied) {
                                                 permission = await Geolocator.requestPermission();
                                                                   if (permission == LocationPermission.denied) { return false;}
                                                                   else{return true;}
                                               }
                                               else{return true;}
  }



  if (permission == LocationPermission.deniedForever||permission == LocationPermission.denied) {return false;}
  else{return true;}







}