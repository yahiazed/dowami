import 'dart:convert';

import 'package:equatable/equatable.dart';

class CarModel extends Equatable {
  final int? id;
  final String? name;
  final String? carLogo;

  const CarModel({
    this.id,
    this.name,
    this.carLogo,
  });

  factory CarModel.fromMap(Map<String,dynamic> map){
    return CarModel(
      id: map['id'],
      name: map['name'],
      carLogo: map['car_logo'],
    );
  }

  toMap(CarModel carModel){
    return
      {
        ['id']:carModel.id,
        ['name']:carModel.name,
        ['car_logo']:carModel.carLogo,
      }
      ;
  }



  String toJson(CarModel carModel) => json.encode(toMap(carModel));

  factory CarModel.fromJson(String source) => CarModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [name];
}
