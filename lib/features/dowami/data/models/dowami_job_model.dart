import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DowamiJobModel extends Equatable {
  final String? name;
  final String? fromLoc;
  final String? toLoc;
  final List<String>? stopPoints;
  final List<String>? days;
  final String? requestType;
  final String? goingTime;
  final String? comingTime;
  final String? passengersCount;
  final String? carType;
  final String? priceOffer;

  const DowamiJobModel({
    this.name,
    this.fromLoc,
    this.toLoc,
    this.stopPoints,
    this.days,
    this.requestType,
    this.goingTime,
    this.comingTime,
    this.passengersCount,
    this.carType,
    this.priceOffer,
  });


  factory DowamiJobModel.fromMap({required Map<String,dynamic>map}){
    return DowamiJobModel(
      name:map['name'],
      fromLoc:map['from_location'],
      toLoc:map['to_location'],
      stopPoints:map['stop_points'],
      days:map['days'],
      requestType:map['request_type'],
      goingTime:map['going_time'],
      comingTime:map['coming_time'],
      passengersCount:map['passengers_count'],
      carType:map['car_type'],
      priceOffer:map['price_offer'],


    );
  }

  Map<String,dynamic>toMap(){

    return {
      'name':name,
      'from_location':fromLoc,
      'to_location':toLoc,
      'stop_points':stopPoints,
      'days':days,
      'request_type':requestType,
      'going_time':goingTime,
      'coming_time':comingTime,
      'passengers_count':passengersCount,
      'car_type':carType,
      'price_offer':priceOffer,

    };
  }

  String toJson(DowamiJobModel dowamiJobModel) => json.encode(toMap());

  factory DowamiJobModel.fromJson(String source) => DowamiJobModel.fromMap(map: json.decode(source));


  @override
  List<Object?> get props => [name];
}
