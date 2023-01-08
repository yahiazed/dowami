import 'dart:convert';

import 'package:equatable/equatable.dart';

class CaptainVehicleModel extends Equatable {
  final String? carDataId;
  final String? boardNumber;
  final String? ownershipType;
  final String? captainId;

  const CaptainVehicleModel({
    this.carDataId,
    this.boardNumber,
    this.ownershipType,
    this.captainId,
  });

  factory CaptainVehicleModel.fromMap(Map<String,dynamic> map){
    return CaptainVehicleModel(
      carDataId: map['car_data_id'],
      boardNumber: map['board_number'],
      ownershipType: map['ownership_type'],
      captainId: map['captain_id'],
     );
  }

  Map<String,dynamic> toMap(CaptainVehicleModel captainVehicleModel){
    return
      {
        'car_data_id':captainVehicleModel.carDataId,
        'board_number':captainVehicleModel.boardNumber,
        'ownership_type':captainVehicleModel.ownershipType,
        'captain_id':captainVehicleModel.captainId,
      }
    ;
  }



  String toJson(CaptainVehicleModel captainVehicleModel) => json.encode(toMap(captainVehicleModel));

  factory CaptainVehicleModel.fromJson(String source) => CaptainVehicleModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [carDataId];
}
