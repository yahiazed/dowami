import 'package:equatable/equatable.dart';

class CarDataModel extends Equatable {
  final int? id;
  final String? carId;
  final String? model;
  final String? category;
  final String? year;

  const CarDataModel({
    this.id,
    this.carId,
    this.model,
    this.category,
    this.year,
  });

  factory CarDataModel.fromMap(Map<String, dynamic> map) {
    return CarDataModel(
      id: map['id'],
      carId: map['car_id'],
      model: map['model'],
      category: map['category'],
      year: map['year'],
    );
  }

  toMap(CarDataModel carDataModel) {
    return {
      ['id']: carDataModel.id,
      ['car_id']: carDataModel.carId,
      ['model']: carDataModel.model,
      ['category']: carDataModel.category,
      ['year']: carDataModel.year,
    };
  }

  @override
  List<Object?> get props => [model,category];
}
