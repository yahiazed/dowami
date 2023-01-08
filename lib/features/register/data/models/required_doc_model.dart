import 'dart:convert';

import 'package:equatable/equatable.dart';

class RequiredDocModel extends Equatable {
  final int? id;
  final String? hasExpiredDate;
  final String? hasIdNumber;
  final String? name;

  const RequiredDocModel({
    this.id,
    this.hasExpiredDate,
    this.hasIdNumber,
    this.name,
  });

  factory RequiredDocModel.fromMap(Map<String,dynamic> map){
    return RequiredDocModel(
      id: map['id'],
      hasExpiredDate: map['has_expire_date'],
      hasIdNumber: map['has_id_number'],
      name: map['name'],
    );
  }

  Map<String,dynamic> toMap(RequiredDocModel requiredDocModel){
    return
      {
        'id':requiredDocModel.id,
        'has_expire_date':requiredDocModel.hasExpiredDate,
        'has_id_number':requiredDocModel.hasIdNumber,
        'name':requiredDocModel.name,
      }
    ;
  }



  String toJson(RequiredDocModel requiredDocModel) => json.encode(toMap(requiredDocModel));

  factory RequiredDocModel.fromJson(String source) => RequiredDocModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [name,id];
}
