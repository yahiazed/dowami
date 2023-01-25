import 'dart:convert';

import 'package:equatable/equatable.dart';

class CaptainVehicleModel extends Equatable {
  final String? carDataId;
  final String? boardNumber;
  final String? ownershipType;
  final String? captainId;
  final String? carYear;

  const CaptainVehicleModel({
    this.carDataId,
    this.boardNumber,
    this.ownershipType,
    this.captainId,
    this.carYear,
  });

  factory CaptainVehicleModel.fromMap(Map<String,dynamic> map){
    return CaptainVehicleModel(
      carDataId: map['car_data_id'],
      boardNumber: map['board_number'],
      ownershipType: map['ownership_type'],
      captainId: map['captain_id'],
      carYear: map['car_year'],
     );
  }

  Map<String,dynamic> toMap( ){
    return
      {
        'car_data_id':carDataId,
        'board_number':boardNumber,
        'ownership_type':ownershipType,
        'captain_id':captainId,
        'car_year':carYear,
      }
    ;
  }



  String toJson(CaptainVehicleModel captainVehicleModel) => json.encode(toMap());

  factory CaptainVehicleModel.fromJson(String source) => CaptainVehicleModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [carDataId,boardNumber,ownershipType,captainId,carYear];
}
